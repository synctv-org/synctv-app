import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/features/room/data/http_session_room_realtime_channel.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class _FakeGateway implements RoomSessionGateway {
  @override
  Future<client.CreateRealtimeSessionResponse> createRealtimeSession(
    String roomId,
    List<client.ObserveResource> initialObservations,
  ) async {
    creations.add((roomId, initialObservations));
    if (failCreate) {
      throw StateError('session create failed');
    }
    return client.CreateRealtimeSessionResponse(
      sessionId: 'sess-1',
      leaseTtlMs: Int64(30_000),
    );
  }

  @override
  Stream<Uint8List> openRealtimeSessionEvents(String roomId, String sessionId) {
    attaches.add((roomId, sessionId));
    return events.stream;
  }

  @override
  Future<void> sendRealtimeSessionMessage(
    String roomId,
    String sessionId,
    client.ClientMessage message,
  ) async {
    posts.add((sessionId, message));
    if (failPosts) {
      throw StateError('post failed');
    }
  }

  @override
  Future<void> endRealtimeSession(String roomId, String sessionId) async {
    deletes.add(sessionId);
  }

  final creations = <(String, List<client.ObserveResource>)>[];
  final attaches = <(String, String)>[];
  final posts = <(String, client.ClientMessage)>[];
  final deletes = <String>[];
  final events = StreamController<Uint8List>();
  var failCreate = false;
  var failPosts = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'creates the session with initial observations and attaches events',
    () async {
      final gateway = _FakeGateway();
      final channel = HttpSessionRoomRealtimeChannel.connect(
        gateway,
        'room-1',
        initialMessages: [
          client.ClientMessage(
            observeResource: client.ObserveResource(observeId: 'obs-1'),
          ).writeToBuffer(),
          // Non-observe messages are skipped for the initial set.
          client.ClientMessage(heartbeat: client.HeartbeatMessage())
              .writeToBuffer(),
        ],
      );

      await channel.ready;
      expect(gateway.creations.single.$1, 'room-1');
      expect(gateway.creations.single.$2.map((observe) => observe.observeId), [
        'obs-1',
      ]);
      expect(gateway.attaches.single, ('room-1', 'sess-1'));
      await channel.close();
    },
  );

  test(
    'downlink frames flow to the stream; sends post to the session',
    () async {
      final gateway = _FakeGateway();
      final channel = HttpSessionRoomRealtimeChannel.connect(gateway, 'room-1');
      final received = <Uint8List>[];
      final subscription = channel.stream.listen(received.add);
      await channel.ready;

      final frame = Uint8List.fromList(
        client.ServerMessage(heartbeatAck: client.HeartbeatAck())
            .writeToBuffer(),
      );
      gateway.events.add(frame);
      await pumpEventQueue();
      expect(received, [frame]);

      channel.send(
        client.ClientMessage(chat: client.ChatMessageSend(content: 'hi'))
            .writeToBuffer(),
      );
      await pumpEventQueue();
      expect(gateway.posts.single.$1, 'sess-1');
      expect(gateway.posts.single.$2.chat.content, 'hi');

      await subscription.cancel();
      await channel.close();
    },
  );

  test('sends before the session exists are buffered, then flushed', () async {
    final gateway = _FakeGateway();
    final channel = HttpSessionRoomRealtimeChannel.connect(gateway, 'room-1');
    channel.send(
      client.ClientMessage(heartbeat: client.HeartbeatMessage())
          .writeToBuffer(),
    );
    expect(gateway.posts, isEmpty);

    await channel.ready;
    await pumpEventQueue();
    expect(gateway.posts, hasLength(1));
    await channel.close();
  });

  test('create failure fails ready and the stream', () async {
    final gateway = _FakeGateway()..failCreate = true;
    final channel = HttpSessionRoomRealtimeChannel.connect(gateway, 'room-1');
    final errors = <Object>[];
    final subscription = channel.stream.listen((_) {}, onError: errors.add);

    await expectLater(channel.ready, throwsStateError);
    await pumpEventQueue();
    expect(errors, hasLength(1));
    await subscription.cancel();
    await channel.close();
  });

  test('post failure fails the channel (engine reconnects)', () async {
    final gateway = _FakeGateway()..failPosts = true;
    final channel = HttpSessionRoomRealtimeChannel.connect(gateway, 'room-1');
    final errors = <Object>[];
    final subscription = channel.stream.listen((_) {}, onError: errors.add);
    await channel.ready;

    channel.send(
      client.ClientMessage(heartbeat: client.HeartbeatMessage())
          .writeToBuffer(),
    );
    await pumpEventQueue();
    expect(errors, hasLength(1));
    expect(gateway.deletes, ['sess-1']);
    await subscription.cancel();
  });

  test('close deletes the session exactly once', () async {
    final gateway = _FakeGateway();
    final channel = HttpSessionRoomRealtimeChannel.connect(gateway, 'room-1');
    await channel.ready;
    await Future.wait([channel.close(), channel.close()]);
    expect(gateway.deletes, ['sess-1']);
  });
}
