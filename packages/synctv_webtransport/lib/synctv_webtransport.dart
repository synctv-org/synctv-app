import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'src/synctv_webtransport_native.dart' as native;

/// A native WebTransport session carrying length-prefixed frames: the
/// bidirectional control stream plus any per-observation unidirectional
/// push streams the server opens, multiplexed into one frame stream.
///
/// Connecting and receiving run off the main isolate (the native receive
/// call blocks until a whole frame arrives from any stream); sending is a
/// short native call that hands the frame to the QUIC stack.
class NativeWebTransportSession {
  NativeWebTransportSession._(this._handle);

  /// Opens a session to [uri] (`https://…`). [certificateHash] is the
  /// SHA-256 of the server certificate's DER for self-signed deployments;
  /// null uses the platform trust store.
  static Future<NativeWebTransportSession> connect(
    Uri uri, {
    Uint8List? certificateHash,
    Duration connectTimeout = const Duration(seconds: 10),
  }) async {
    final url = uri.toString();
    final hash = certificateHash == null
        ? null
        : Uint8List.fromList(certificateHash);
    final handle = await Isolate.run(
      () => native.nativeWebTransportConnect(url, hash),
    ).timeout(connectTimeout);
    final session = NativeWebTransportSession._(handle);
    await session._startReader();
    return session;
  }

  final int _handle;
  final StreamController<Uint8List> _frames = StreamController<Uint8List>();
  Isolate? _reader;
  ReceivePort? _readerPort;
  bool _closed = false;

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

  /// Sends one frame payload. Throws when the session is closed or the
  /// native stack rejects the write.
  void send(Uint8List payload) {
    if (_closed) {
      throw StateError('WebTransport session is closed');
    }
    native.nativeWebTransportSend(_handle, payload);
  }

  /// Closes the session; the reader isolate observes the closed handle and
  /// exits.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    native.nativeWebTransportClose(_handle);
    _reader?.kill(priority: Isolate.immediate);
    _reader = null;
    _readerPort?.close();
    _readerPort = null;
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
