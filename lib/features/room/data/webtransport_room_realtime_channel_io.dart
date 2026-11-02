import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_webtransport/synctv_webtransport.dart';

/// Native WebTransport support via the platform Rust bridge
/// (`package:synctv_webtransport`); true wherever the bridge is bundled.
bool isWebTransportSupported() => true;

/// Factory over the native bridge.
RoomRealtimeChannelFactory? webTransportChannelFactory({
  required Future<Uri> Function(String roomId) createUri,
  String? certificateHashBase64,
}) {
  return NativeWebTransportChannelFactory(
    createUri: createUri,
    certificateHashBase64: certificateHashBase64,
  );
}

/// [RoomRealtimeChannelFactory] over the native WebTransport bridge. The
/// wire format matches the server's WebTransport transport: a bidirectional
/// control stream carrying length-prefixed protobuf frames, plus the
/// per-observation unidirectional push streams the native bridge multiplexes
/// into the same frame stream.
class NativeWebTransportChannelFactory implements RoomRealtimeChannelFactory {
  NativeWebTransportChannelFactory({
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
    return _PendingNativeWebTransportChannel(
      createUri: () => createUri(roomId),
      certificateHash: _decodeHash(certificateHashBase64),
      initialMessages: initialMessages,
      onOutgoing: onOutgoing,
      onIncoming: onIncoming,
    );
  }

  static Uint8List? _decodeHash(String? base64Source) {
    final trimmed = base64Source?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return Uint8List.fromList(base64Decode(trimmed));
  }
}

/// Connects asynchronously while satisfying the synchronous `connect`
/// contract; buffers outgoing messages until the session is open.
class _PendingNativeWebTransportChannel implements RoomRealtimeChannel {
  _PendingNativeWebTransportChannel({
    required Future<Uri> Function() createUri,
    required this.certificateHash,
    required this.initialMessages,
    this.onOutgoing,
    this.onIncoming,
  }) // Public parameter name, private storage.
    // ignore: prefer_initializing_formals
    : _createUri = createUri;

  final Future<Uri> Function() _createUri;
  final Uint8List? certificateHash;
  final Iterable<List<int>> initialMessages;
  final void Function(List<int> bytes)? onOutgoing;
  final void Function(Uint8List bytes)? onIncoming;

  final StreamController<Uint8List> _incoming = StreamController<Uint8List>();
  final _pending = <List<int>>[];
  NativeWebTransportSession? _session;
  StreamSubscription<Uint8List>? _subscription;
  bool _closed = false;

  late final Future<void> _ready = _open();

  Future<void> _open() async {
    final uri = await _createUri();
    if (_closed) return;
    final session = await NativeWebTransportSession.connect(
      uri,
      certificateHash: certificateHash,
    );
    if (_closed) {
      unawaited(session.close());
      return;
    }
    _session = session;
    _subscription = session.frames.listen(
      (bytes) {
        onIncoming?.call(bytes);
        if (!_incoming.isClosed) _incoming.add(bytes);
      },
      onError: (Object error, StackTrace stackTrace) {
        _fail(error, stackTrace);
      },
      onDone: () =>
          _fail(StateError('WebTransport session closed'), StackTrace.current),
    );
    for (final message in initialMessages) {
      if (message.isEmpty) continue;
      onOutgoing?.call(message);
      session.send(Uint8List.fromList(message));
    }
    final buffered = List<List<int>>.of(_pending);
    _pending.clear();
    for (final message in buffered) {
      session.send(Uint8List.fromList(message));
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
    final session = _session;
    if (session == null) {
      if (_pending.length < 128) _pending.add(bytes);
      return;
    }
    onOutgoing?.call(bytes);
    try {
      session.send(Uint8List.fromList(bytes));
    } catch (error, stackTrace) {
      _fail(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    _closed = true;
    final subscription = _subscription;
    _subscription = null;
    await subscription?.cancel();
    final session = _session;
    _session = null;
    await session?.close();
    unawaited(_incoming.close());
    try {
      await _ready;
    } catch (_) {
      // A failed open is closed by construction.
    }
  }
}
