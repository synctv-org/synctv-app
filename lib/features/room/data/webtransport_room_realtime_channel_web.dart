import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/data/realtime_frame_codec.dart';
import 'package:web/web.dart' as web;

/// Whether the browser exposes WebTransport and the context is secure
/// (WebTransport requires a secure context).
bool isWebTransportSupported() {
  return globalContext.has('WebTransport') && web.window.isSecureContext;
}

/// WebTransport channel over the browser's `WebTransport` API.
///
/// The wire format matches the server's WebTransport transport: one
/// bidirectional control stream carrying length-prefixed protobuf frames,
/// plus — when the server honors the multi-stream revision requested on the
/// connect URI — per-observation frames arriving on server-initiated
/// unidirectional streams. Both sources feed the same frame stream; the
/// protocol guarantees ordering only within one observation, which each
/// server-side stream preserves.
class WebTransportRoomRealtimeChannel implements RoomRealtimeChannel {
  WebTransportRoomRealtimeChannel._(this._session, this._writer, this._reader) {
    // Start reading eagerly: without a consumer the stream's flow control
    // blocks the server's writes, so a lazily-started pump would starve the
    // channel even though the session itself is healthy.
    _handshake = _startReadLoop();
  }

  /// Connects a WebTransport session to [uri] and opens the frame stream.
  static Future<WebTransportRoomRealtimeChannel> connect(
    Uri uri, {
    String? certificateHashBase64,
    Duration connectTimeout = const Duration(seconds: 10),
  }) async {
    final options =
        certificateHashBase64 == null || certificateHashBase64.isEmpty
        ? web.WebTransportOptions()
        : web.WebTransportOptions(
            serverCertificateHashes: _certificateHashes(certificateHashBase64),
          );
    final session = web.WebTransport(uri.toString(), options);
    try {
      await session.ready.toDart.timeout(connectTimeout);
    } on TimeoutException {
      session.close();
      throw TimeoutException('WebTransport handshake timed out');
    }
    try {
      final stream = await session.createBidirectionalStream().toDart.timeout(
        connectTimeout,
      );
      final writer = (stream.writable as web.WritableStream).getWriter();
      final reader =
          (stream.readable as web.ReadableStream).getReader()
              as web.ReadableStreamDefaultReader;
      return WebTransportRoomRealtimeChannel._(session, writer, reader);
    } on TimeoutException {
      session.close();
      throw TimeoutException('WebTransport stream setup timed out');
    } catch (error) {
      session.close();
      rethrow;
    }
  }

  final web.WebTransport _session;
  final web.WritableStreamDefaultWriter _writer;
  final web.ReadableStreamDefaultReader _reader;

  final StreamController<Uint8List> _incoming = StreamController<Uint8List>();
  Future<void>? _readLoop;
  Future<void>? _closeFuture;
  bool _writerLocked = true;

  @override
  Stream<Uint8List> get stream => _incoming.stream;

  @override
  Future<void> get ready => _handshake;

  // Started eagerly in the constructor: without a consumer the stream's flow
  // control blocks the server's writes, so a lazily-started pump would starve
  // the channel even though the session itself is healthy.
  late final Future<void> _handshake;

  Future<void> _startReadLoop() async {
    _readLoop = _pumpStream(_reader, 'control');
    unawaited(_pumpIncomingStreams());
    await _readLoop;
  }

  /// Accepts server-initiated unidirectional streams (per-observation push
  /// lanes) and pumps their frames into the shared incoming stream.
  Future<void> _pumpIncomingStreams() async {
    try {
      final acceptReader =
          _session.incomingUnidirectionalStreams.getReader()
              as web.ReadableStreamDefaultReader;
      while (true) {
        final result = await acceptReader.read().toDart;
        if (result.done) return;
        final stream = result.value;
        if (stream == null) continue;
        unawaited(
          _pumpStream(
            (stream as web.ReadableStream).getReader()
                as web.ReadableStreamDefaultReader,
            'push stream',
          ),
        );
      }
    } catch (error) {
      _failChannel('WebTransport stream accept failed: $error');
    }
  }

  /// Pumps length-prefixed frames from one stream. Each stream keeps its own
  /// incremental frame reader — streams interleave at frame boundaries only.
  Future<void> _pumpStream(
    web.ReadableStreamDefaultReader reader,
    String source,
  ) async {
    final frameReader = RealtimeFrameReader();
    try {
      while (true) {
        final result = await reader.read().toDart;
        if (result.done) break;
        final chunk = result.value;
        if (chunk == null) continue;
        for (final frame in frameReader.addChunk(
          (chunk as JSUint8Array).toDart,
        )) {
          if (_incoming.isClosed) return;
          _incoming.add(frame);
        }
      }
      if (source == 'control') {
        // The server closed the control stream: the session is over. Push
        // lanes end with it, so closing here covers the whole channel.
        unawaited(close());
      }
    } catch (error) {
      if (source == 'control') {
        _failChannel('WebTransport read failed: $error');
      } else {
        // Push lanes exist only inside a live session; an error on one means
        // the session is unhealthy. Failing the channel makes the engine
        // reconnect and resynchronize from its observation cursors.
        _failChannel('WebTransport $source failed: $error');
      }
    }
  }

  void _failChannel(String message) {
    if (_incoming.isClosed) return;
    _incoming.addError(StateError(message));
    unawaited(close());
  }

  @override
  void send(List<int> bytes) {
    if (bytes.isEmpty || _closeFuture != null) return;
    final frame = encodeRealtimeFrame(bytes);
    unawaited(
      _writer
          .write(frame.toJS)
          .toDart
          .then((_) {}, onError: (Object error) => unawaited(close())),
    );
  }

  @override
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    if (!_incoming.isClosed) {
      unawaited(_incoming.close());
    }
    try {
      if (_writerLocked) {
        _writerLocked = false;
        await _writer.close().toDart;
      }
    } catch (_) {
      // The stream may already be gone; closing the session cleans up.
    }
    _session.close();
  }
}

JSArray<web.WebTransportHash> _certificateHashes(String base64) {
  final bytes = base64Decode(base64.replaceAll(RegExp(r'\s'), ''));
  return [web.WebTransportHash(algorithm: 'sha-256', value: bytes.toJS)].toJS;
}

/// Factory over the browser WebTransport API; null when unsupported or
/// when no URI builder is provided.
RoomRealtimeChannelFactory? webTransportChannelFactory({
  required Future<Uri> Function(String roomId) createUri,
  String? certificateHashBase64,
}) {
  if (!isWebTransportSupported()) return null;
  return WebTransportRoomRealtimeChannelFactory(
    createUri: createUri,
    certificateHashBase64: certificateHashBase64,
  );
}

/// Factory over the browser WebTransport API.
class WebTransportRoomRealtimeChannelFactory
    implements RoomRealtimeChannelFactory {
  WebTransportRoomRealtimeChannelFactory({
    required this.createUri,
    this.certificateHashBase64,
  });

  /// Builds the per-room WebTransport URI (with a one-time ticket).
  final Future<Uri> Function(String roomId) createUri;

  /// Optional base64 SHA-256 of the server certificate's DER for
  /// self-signed deployments; omitted for publicly trusted certificates.
  final String? certificateHashBase64;

  @override
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    return _PendingWebTransportChannel(
      createUri: () => createUri(roomId),
      certificateHashBase64: certificateHashBase64,
      initialMessages: initialMessages,
      onOutgoing: onOutgoing,
      onIncoming: onIncoming,
    );
  }
}

/// Connects asynchronously while satisfying the synchronous `connect`
/// contract; buffers outgoing messages until the session's stream is open.
class _PendingWebTransportChannel implements RoomRealtimeChannel {
  _PendingWebTransportChannel({
    required Future<Uri> Function() createUri,
    required this.certificateHashBase64,
    required this.initialMessages,
    this.onOutgoing,
    this.onIncoming,
  }) // Public parameter name, private storage.
    // ignore: prefer_initializing_formals
    : _createUri = createUri;

  /// URI builder invoked once per connection attempt.
  final Future<Uri> Function() _createUri;
  final String? certificateHashBase64;
  final Iterable<List<int>> initialMessages;
  final void Function(List<int> bytes)? onOutgoing;
  final void Function(Uint8List bytes)? onIncoming;

  final StreamController<Uint8List> _incoming = StreamController<Uint8List>();
  final _pending = <List<int>>[];
  WebTransportRoomRealtimeChannel? _channel;
  StreamSubscription<Uint8List>? _subscription;
  bool _closed = false;

  late final Future<void> _ready = _open();

  Future<void> _open() async {
    final uri = await _createUri();
    if (_closed) return;
    final channel = await WebTransportRoomRealtimeChannel.connect(
      uri,
      certificateHashBase64: certificateHashBase64,
    );
    if (_closed) {
      unawaited(channel.close());
      return;
    }
    _channel = channel;
    _subscription = channel.stream.listen(
      (bytes) {
        onIncoming?.call(bytes);
        if (!_incoming.isClosed) _incoming.add(bytes);
      },
      onError: (Object error, StackTrace stackTrace) {
        _fail(error, stackTrace);
      },
      onDone: () =>
          _fail(StateError('WebTransport stream closed'), StackTrace.current),
    );
    for (final message in initialMessages) {
      if (message.isEmpty) continue;
      onOutgoing?.call(message);
      channel.send(message);
    }
    final buffered = List<List<int>>.of(_pending);
    _pending.clear();
    for (final message in buffered) {
      channel.send(message);
    }
  }

  void _fail(Object error, StackTrace stackTrace) {
    if (_incoming.isClosed) return;
    _incoming.addError(error, stackTrace);
    unawaited(close());
  }

  @override
  Stream<Uint8List> get stream => _incoming.stream;

  @override
  Future<void> get ready => _ready;

  @override
  void send(List<int> bytes) {
    if (bytes.isEmpty || _closed) return;
    final channel = _channel;
    if (channel != null) {
      onOutgoing?.call(bytes);
      channel.send(bytes);
      return;
    }
    if (_pending.length < 128) _pending.add(bytes);
  }

  @override
  Future<void> close() async {
    _closed = true;
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
    final channel = _channel;
    _channel = null;
    await channel?.close();
    unawaited(_incoming.close());
    try {
      await _ready;
    } catch (_) {
      // A failed open is closed by construction.
    }
  }
}
