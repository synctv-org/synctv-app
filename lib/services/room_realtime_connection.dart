import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class RoomRealtimeConnection {
  RoomRealtimeConnection._({
    required StreamController<List<int>> outgoing,
    required Future<WebSocket> socket,
    required Stream<Uint8List> incoming,
    required this.onOutgoing,
  })  : _outgoing = outgoing,
        _socket = socket,
        stream = incoming;

  final StreamController<List<int>> _outgoing;
  final Future<WebSocket> _socket;
  final Stream<Uint8List> stream;
  final void Function(List<int> bytes, [client.ClientMessage? message])?
      onOutgoing;

  StreamSink<List<int>> get sink => _outgoing.sink;

  void sendMessage(client.ClientMessage message) {
    unawaited(_sendMessage(message));
  }

  Future<void> _sendMessage(client.ClientMessage message) async {
    final socket = await _socket;
    final bytes = message.writeToBuffer();
    onOutgoing?.call(bytes, message);
    socket.add(WatchTogetherService.encodeRealtimeMessageJson(message));
  }

  Future<void> close([int? closeCode, String? closeReason]) async {
    await _outgoing.close();
    final socket = await _socket;
    await socket.close(closeCode, closeReason);
  }

  static RoomRealtimeConnection connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes, [client.ClientMessage? message])? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    late final WebSocket socket;
    StreamSubscription<List<int>>? outgoingSubscription;
    Timer? heartbeatTimer;
    final incoming = StreamController<Uint8List>();
    final outgoing = StreamController<List<int>>();

    final socketFuture = WatchTogetherService.createRoomWebSocketUri(roomId)
        .then((uri) => WebSocket.connect(uri.toString()))
        .then((connected) {
      socket = connected;
      socket.listen(
        (frame) {
          try {
            if (frame is! String) return;
            final message = WatchTogetherService.decodeRealtimeMessageJson(
              frame,
            );
            final bytes = Uint8List.fromList(message.writeToBuffer());
            onIncoming?.call(bytes);
            incoming.add(bytes);
          } catch (error, stackTrace) {
            incoming.addError(error, stackTrace);
          }
        },
        onError: incoming.addError,
        onDone: incoming.close,
      );
      outgoingSubscription =
          outgoing.stream.where((bytes) => bytes.isNotEmpty).listen((bytes) {
        final message = client.ClientMessage.fromBuffer(bytes);
        onOutgoing?.call(bytes, message);
        socket.add(WatchTogetherService.encodeRealtimeMessageJson(message));
      });
      heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (_) {
        if (!outgoing.isClosed) {
          outgoing.add(RoomRealtimeCodec.encodeSync());
        }
      });
      for (final message in initialMessages) {
        if (message.isNotEmpty) outgoing.add(message);
      }
      return connected;
    });

    socketFuture.catchError((Object error, StackTrace stackTrace) {
      incoming.addError(error, stackTrace);
      unawaited(incoming.close());
      throw error;
    });
    incoming.onCancel = () async {
      heartbeatTimer?.cancel();
      await outgoing.close();
      await outgoingSubscription?.cancel();
      await socketFuture.then((_) => socket.close()).catchError((_) {});
    };

    return RoomRealtimeConnection._(
      outgoing: outgoing,
      socket: socketFuture,
      incoming: incoming.stream,
      onOutgoing: onOutgoing,
    );
  }
}
