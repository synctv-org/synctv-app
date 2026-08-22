import 'dart:async';
import 'dart:io';

import 'package:synctv_app/core/network/server_http_client.dart';
import 'package:synctv_app/features/room/data/room_realtime_socket_contract.dart';

Future<RoomRealtimeSocket> connectRoomRealtimeSocket(
  Uri uri, {
  required bool allowInsecureTls,
}) async {
  if (!allowInsecureTls || uri.scheme.toLowerCase() != 'wss') {
    return _IoRoomRealtimeSocket(await WebSocket.connect(uri.toString()));
  }
  final client = createServerIoHttpClient(
    uri.replace(scheme: 'https'),
    allowInsecureTls: true,
  );
  try {
    return _IoRoomRealtimeSocket(
      await WebSocket.connect(uri.toString(), customClient: client),
    );
  } finally {
    client.close(force: false);
  }
}

final class _IoRoomRealtimeSocket implements RoomRealtimeSocket {
  _IoRoomRealtimeSocket(this._socket) {
    _socket.pingInterval = const Duration(seconds: 10);
    _messages = StreamController<String>();
    _subscription = _socket.listen(
      (frame) {
        if (frame is String && !_messages.isClosed) {
          _messages.add(frame);
        }
      },
      onError: _messages.addError,
      onDone: _messages.close,
    );
  }

  final WebSocket _socket;
  late final StreamController<String> _messages;
  late final StreamSubscription<dynamic> _subscription;
  var _closed = false;

  @override
  Stream<String> get messages => _messages.stream;

  @override
  void send(String message) => _socket.add(message);

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    try {
      await _subscription.cancel();
      await _socket.close();
    } finally {
      unawaited(_messages.close());
    }
  }
}
