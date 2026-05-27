import 'dart:async';
import 'dart:typed_data';

import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class RoomRealtimeConnection {
  RoomRealtimeConnection._({
    required StreamController<List<int>> outgoing,
    required Stream<Uint8List> incoming,
  })  : _outgoing = outgoing,
        stream = incoming;

  final StreamController<List<int>> _outgoing;
  final Stream<Uint8List> stream;

  StreamSink<List<int>> get sink => _outgoing.sink;

  static RoomRealtimeConnection connect(String roomId) {
    final outgoing = StreamController<List<int>>();
    final messages = outgoing.stream
        .where((bytes) => bytes.isNotEmpty)
        .map(client.ClientMessage.fromBuffer);
    final incoming = WatchTogetherService.connectRoomMessageStream(
      roomId,
      messages,
    ).map((message) => Uint8List.fromList(message.writeToBuffer()));

    return RoomRealtimeConnection._(
      outgoing: outgoing,
      incoming: incoming,
    );
  }
}
