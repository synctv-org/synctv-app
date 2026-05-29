import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class RoomRealtimeConnection {
  RoomRealtimeConnection._({
    required StreamController<List<int>> outgoing,
    required Future<WebSocket> socket,
    required Stream<Uint8List> incoming,
  })  : _outgoing = outgoing,
        _socket = socket,
        stream = incoming;

  final StreamController<List<int>> _outgoing;
  final Future<WebSocket> _socket;
  final Stream<Uint8List> stream;

  StreamSink<List<int>> get sink => _outgoing.sink;

  Future<void> close([int? closeCode, String? closeReason]) async {
    await _outgoing.close();
    final socket = await _socket;
    await socket.close(closeCode, closeReason);
  }

  static RoomRealtimeConnection connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    late final WebSocket socket;
    StreamSubscription<List<int>>? outgoingSubscription;
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
        onOutgoing?.call(bytes);
        final message = client.ClientMessage.fromBuffer(bytes);
        socket.add(WatchTogetherService.encodeRealtimeMessageJson(message));
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
      await outgoing.close();
      await outgoingSubscription?.cancel();
      await socketFuture.then((_) => socket.close()).catchError((_) {});
    };

    return RoomRealtimeConnection._(
      outgoing: outgoing,
      socket: socketFuture,
      incoming: incoming.stream,
    );
  }
}
