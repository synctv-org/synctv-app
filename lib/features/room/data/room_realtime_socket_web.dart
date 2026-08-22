import 'dart:async';

import 'package:synctv_app/features/room/data/room_realtime_socket_contract.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<RoomRealtimeSocket> connectRoomRealtimeSocket(
  Uri uri, {
  required bool allowInsecureTls,
}) async {
  final channel = WebSocketChannel.connect(uri);
  try {
    await channel.ready.timeout(const Duration(seconds: 10));
  } catch (_) {
    unawaited(channel.sink.close().catchError((_) {}));
    rethrow;
  }
  return _WebRoomRealtimeSocket(channel);
}

final class _WebRoomRealtimeSocket implements RoomRealtimeSocket {
  _WebRoomRealtimeSocket(this._channel) {
    _messages = StreamController<String>();
    _subscription = _channel.stream.listen(
      (frame) {
        if (frame is String && !_messages.isClosed) {
          _messages.add(frame);
        }
      },
      onError: _messages.addError,
      onDone: _messages.close,
    );
  }

  final WebSocketChannel _channel;
  late final StreamController<String> _messages;
  late final StreamSubscription<dynamic> _subscription;
  var _closed = false;

  @override
  Stream<String> get messages => _messages.stream;

  @override
  void send(String message) => _channel.sink.add(message);

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    try {
      await _subscription.cancel();
      await _channel.sink.close();
    } finally {
      unawaited(_messages.close());
    }
  }
}
