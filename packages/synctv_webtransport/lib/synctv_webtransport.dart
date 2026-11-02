import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'src/synctv_webtransport_native.dart' as native;

/// A native WebTransport session carrying length-prefixed frames: the
/// bidirectional control stream plus any per-observation unidirectional
/// push streams the server opens, multiplexed into one frame stream.
///
/// Connecting, receiving, and sending all run off the main isolate: the
/// native receive call blocks until a whole frame arrives from any stream,
/// and the native send call can block on the QUIC writer when the peer
/// stops reading. Sends are handed to a sender isolate in order through a
/// bounded queue (oldest frames are dropped when the peer stalls — newer
/// state supersedes, and the client resyncs from cursors).
class NativeWebTransportSession {
  NativeWebTransportSession._(this._handle);

  /// Opens a session to [uri] (`https://…`). [certificateHash] is the
  /// SHA-256 of the server certificate's DER for self-signed deployments;
  /// null uses the platform trust store.
  ///
  /// [connectTimeout] must stay above the native bound (9.5 s): the native
  /// call cannot be cancelled, so on timeout the connecting isolate keeps
  /// running and a session that lands after the caller gave up is reclaimed
  /// by the late-arrival handler below instead of leaking.
  static Future<NativeWebTransportSession> connect(
    Uri uri, {
    Uint8List? certificateHash,
    Duration connectTimeout = const Duration(seconds: 10),
  }) async {
    final url = uri.toString();
    final hash = certificateHash == null
        ? null
        : Uint8List.fromList(certificateHash);
    final handle = await guardConnectTimeout(
      Isolate.run(() => native.nativeWebTransportConnect(url, hash)),
      connectTimeout,
      native.nativeWebTransportClose,
    );
    final session = NativeWebTransportSession._(handle);
    await session._startReader();
    await session._startSender();
    return session;
  }

  /// Times out [connecting]; a handle that lands after the deadline is
  /// passed to [reclaim] so the underlying session cannot leak. The native
  /// call cannot be cancelled, and its bound sits below the Dart deadline,
  /// so the only way a handle arrives late is a genuinely slow endpoint —
  /// and that session must still be closed.
  @visibleForTesting
  static Future<int> guardConnectTimeout(
    Future<int> connecting,
    Duration connectTimeout,
    void Function(int handle) reclaim,
  ) async {
    try {
      return await connecting.timeout(connectTimeout);
    } on TimeoutException {
      unawaited(
        connecting
            .then((lateHandle) {
              if (lateHandle > 0) {
                reclaim(lateHandle);
              }
            })
            .catchError((Object _) {
              // The native call failed on its own; nothing to reclaim.
            }),
      );
      rethrow;
    }
  }

  final int _handle;
  final StreamController<Uint8List> _frames = StreamController<Uint8List>();
  Isolate? _reader;
  ReceivePort? _readerPort;
  bool _closed = false;

  // Sender isolate: keeps the (potentially blocking) native send call off
  // the UI isolate and preserves send order.
  Isolate? _sender;
  ReceivePort? _senderEvents;
  SendPort? _senderInbox;
  final ListQueue<Uint8List> _sendQueue = ListQueue<Uint8List>();
  int _sendsInFlight = 0;

  /// Upper bound on frames waiting for the sender isolate. Beyond it the
  /// oldest queued frame is dropped: a peer this far behind is stalling,
  /// newer state supersedes older frames, and the client resyncs from
  /// cursors across any gap.
  static const _maxQueuedSends = 64;

  /// How many frames may be handed to the sender isolate before a
  /// completion credit is required; keeps the isolate's own inbox bounded.
  static const _maxSendsInFlight = 8;

  /// Incoming frame payloads. Ends when the session closes; errors when the
  /// transport fails.
  Stream<Uint8List> get frames => _frames.stream;

  Future<void> _startReader() async {
    final port = ReceivePort();
    _readerPort = port;
    port.listen((message) {
      if (_frames.isClosed) return;
      switch (message) {
        case Uint8List bytes:
          _frames.add(bytes);
        case String error:
          _frames.addError(StateError(error));
          unawaited(close());
        case null:
          unawaited(close());
      }
    });
    _reader = await Isolate.spawn(
      _readerMain,
      _ReaderArgs(handle: _handle, port: port.sendPort),
      debugName: 'synctv-webtransport-reader',
    );
  }

  Future<void> _startSender() async {
    final events = ReceivePort();
    _senderEvents = events;
    events.listen((message) {
      if (_closed) return;
      if (message is SendPort) {
        _senderInbox = message;
        _pumpSendQueue();
        return;
      }
      if (message is int) {
        // Completion credit for one send.
        if (_sendsInFlight > 0) _sendsInFlight--;
        _pumpSendQueue();
        return;
      }
      if (message is String) {
        if (!_frames.isClosed) {
          _frames.addError(StateError(message));
        }
        unawaited(close());
      }
    });
    _sender = await Isolate.spawn(
      _senderMain,
      _SenderArgs(handle: _handle, events: events.sendPort),
      debugName: 'synctv-webtransport-sender',
    );
  }

  /// Sends one frame payload without blocking the caller: the frame is
  /// queued and delivered to the sender isolate in order. Throws when the
  /// session is closed.
  void send(Uint8List payload) {
    if (_closed) {
      throw StateError('WebTransport session is closed');
    }
    if (_sendQueue.length >= _maxQueuedSends) {
      // Drop the oldest queued frame; see [_maxQueuedSends].
      _sendQueue.removeFirst();
    }
    _sendQueue.add(payload);
    _pumpSendQueue();
  }

  void _pumpSendQueue() {
    final inbox = _senderInbox;
    if (inbox == null) return;
    while (_sendQueue.isNotEmpty && _sendsInFlight < _maxSendsInFlight) {
      inbox.send(_sendQueue.removeFirst());
      _sendsInFlight++;
    }
  }

  /// Closes the session; the reader and sender isolates are torn down with
  /// it.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    native.nativeWebTransportClose(_handle);
    _reader?.kill(priority: Isolate.immediate);
    _reader = null;
    _readerPort?.close();
    _readerPort = null;
    _sender?.kill(priority: Isolate.immediate);
    _sender = null;
    _senderEvents?.close();
    _senderEvents = null;
    _senderInbox = null;
    _sendQueue.clear();
    if (!_frames.isClosed) {
      await _frames.close();
    }
  }
}

class _ReaderArgs {
  const _ReaderArgs({required this.handle, required this.port});

  final int handle;
  final SendPort port;
}

void _readerMain(_ReaderArgs args) {
  while (true) {
    final Uint8List? frame;
    try {
      frame = native.nativeWebTransportRecv(args.handle);
    } catch (error) {
      args.port.send(error.toString());
      return;
    }
    if (frame == null) {
      args.port.send(null);
      return;
    }
    args.port.send(frame);
  }
}

class _SenderArgs {
  const _SenderArgs({required this.handle, required this.events});

  final int handle;
  final SendPort events;
}

void _senderMain(_SenderArgs args) {
  final inbox = ReceivePort();
  args.events.send(inbox.sendPort);
  inbox.listen((message) {
    if (message is! Uint8List) return;
    try {
      native.nativeWebTransportSend(args.handle, message);
      args.events.send(1);
    } catch (error) {
      args.events.send(error.toString());
    }
  });
}
