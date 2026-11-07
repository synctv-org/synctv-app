import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/realtime_reconnect_policy.dart';
import 'package:synctv_app/features/room/application/realtime_transport_selector.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_realtime_engine.dart';
import 'package:synctv_app/features/room/data/room_realtime_engine.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

/// Scriptable channel: connects after optional failures, then ends on cue.
class _FakeChannel implements RoomRealtimeChannel {
  _FakeChannel(this.script);

  final _FakeFactory script;
  final incoming = StreamController<Uint8List>();
  final sent = <List<int>>[];
  var closed = false;
  Completer<void>? closedCompleter;

  @override
  Stream<Uint8List> get stream => incoming.stream;

  @override
  Future<void> get ready {
    if (script.failNextReady) {
      script.failNextReady = false;
      return Future.error(StateError('connect failed'));
    }
    return Future.value();
  }

  @override
  void send(List<int> bytes) {
    if (bytes.isNotEmpty) sent.add(bytes);
  }

  @override
  Future<void> close() async {
    closed = true;
    closedCompleter?.complete();
    await incoming.close();
  }
}

class _FakeFactory implements RoomRealtimeChannelFactory {
  _FakeFactory();

  final channels = <_FakeChannel>[];
  Object? connectError;
  var failNextReady = false;

  /// Ends the most recent channel's stream (simulates transport drop).
  void dropLast() {
    final channel = channels.lastWhere((channel) => !channel.closed);
    scheduleMicrotask(() => channel.incoming.close());
  }

  @override
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    if (connectError != null) {
      throw connectError!;
    }
    final channel = _FakeChannel(this)
      ..sent.addAll(initialMessages.map((bytes) => List<int>.of(bytes)));
    channels.add(channel);
    return channel;
  }
}

client.ClientMessage _observe(String id, {int? sequence}) {
  return client.ClientMessage(
    observeResource: client.ObserveResource(
      observeId: id,
      roomSettings: client.ObserveRoomSettings(
        afterEventSequence: sequence == null ? null : Int64(sequence),
      ),
    ),
  );
}

Uint8List _serverFrame(client.ServerMessage message) =>
    Uint8List.fromList(message.writeToBuffer());

ReconnectingRoomRealtimeEngine _buildEngine(
  _FakeFactory factory, {
  RealtimeReconnectPolicy? policy,
}) {
  return ReconnectingRoomRealtimeEngine(
    roomId: 'room-1',
    planner: FixedTransportPlanner(
      RealtimeTransportOption(
        transport: RealtimeTransport.webSocket,
        factory: factory,
      ),
    ),
    reconnectPolicy:
        policy ??
        RealtimeReconnectPolicy(
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 5),
        ),
    nowMillis: () => 42,
    heartbeatInterval: const Duration(hours: 1),
  );
}

void main() {
  test('connects, emits lifecycle, replays recorded observations', () async {
    final factory = _FakeFactory();
    final engine = _buildEngine(factory);
    final lifecycle = <RoomRealtimeLifecycle>[];
    final subscription = engine.lifecycle.listen(lifecycle.add);

    // Observations sent before start are recorded, then replayed by the
    // channel's initial messages.
    engine.send(_observe('room_settings').writeToBuffer());
    engine.start();
    await pumpEventQueue();

    expect(factory.channels, hasLength(1));
    final initial = factory.channels.single.sent
        .map(client.ClientMessage.fromBuffer)
        .toList();
    expect(initial, hasLength(1));
    expect(initial.single.observeResource.observeId, 'room_settings');

    await engine.close();
    await subscription.cancel();
    expect(lifecycle.whereType<RoomRealtimeConnected>(), isNotEmpty);
    expect(lifecycle.whereType<RoomRealtimeClosed>(), isNotEmpty);
  });

  test('reconnects after a drop and replays with the latest cursor', () async {
    final factory = _FakeFactory();
    final engine = _buildEngine(factory);

    engine
      ..send(_observe('room_settings').writeToBuffer())
      ..start();
    await pumpEventQueue();

    // Server pushes an event cursor, then the transport drops.
    factory.channels.single.incoming.add(
      _serverFrame(
        client.ServerMessage(
          resourceEvent: client.ResourceEvent(
            observeId: 'room_settings',
            eventCursor: client.EventCursor(sequence: Int64(17)),
          ),
        ),
      ),
    );
    await pumpEventQueue();
    factory.dropLast();
    await pumpEventQueue();

    expect(factory.channels, hasLength(2));
    final replay = factory.channels[1].sent
        .map(client.ClientMessage.fromBuffer)
        .toList();
    expect(
      replay.single.observeResource.roomSettings.afterEventSequence,
      Int64(17),
    );
    await engine.close();
  });

  test(
    'server termination stops reconnection and surfaces the reason',
    () async {
      final factory = _FakeFactory();
      final engine = _buildEngine(factory);
      final events = <RoomRealtimeLifecycle>[];
      final subscription = engine.lifecycle.listen(events.add);
      final messages = <RoomRealtimeMessage>[];
      final messageSubscription = engine.messages.listen(messages.add);

      engine.start();
      await pumpEventQueue();

      factory.channels.single.incoming.add(
        _serverFrame(
          client.ServerMessage(
            termination: client.RealtimeTermination(
              message: 'membership revoked',
              code: client
                  .RealtimeTerminationCode
                  .REALTIME_TERMINATION_CODE_ROOM_MEMBERSHIP_REVOKED,
            ),
          ),
        ),
      );
      await pumpEventQueue();

      expect(
        messages.map((message) => message.kind),
        contains(RoomRealtimeMessageKind.terminated),
      );
      final termination = messages
          .firstWhere(
            (message) => message.kind == RoomRealtimeMessageKind.terminated,
          )
          .termination;
      expect(
        termination!.code,
        RoomRealtimeTerminationCode.roomMembershipRevoked,
      );
      expect(termination.displayMessage, 'membership revoked');

      await pumpEventQueue();
      // No reconnect happened after termination.
      expect(factory.channels, hasLength(1));
      expect(events.whereType<RoomRealtimeTerminatedEvent>(), hasLength(1));

      await messageSubscription.cancel();
      await subscription.cancel();
      await engine.close();
    },
  );

  test(
    'failed candidates rotate within one cycle and successes go sticky',
    () async {
      final failing = _FakeFactory()..failNextReady = true;
      final working = _FakeFactory();
      final selector = RealtimeTransportSelector(
        webTransportFactory: () => failing,
        webSocketFactory: working,
        failureThreshold: 1,
        demotionCooldown: const Duration(minutes: 1),
      );
      // Prefer the (failing) WebTransport candidate.
      selector.preferred = RealtimeTransport.webTransport;

      final engine = ReconnectingRoomRealtimeEngine(
        roomId: 'room-1',
        planner: SelectorRealtimeTransportPlanner(
          selector: selector,
          advertisedTransports: () => const [
            client.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_WEB_SOCKET,
            client.RealtimeTransportKind.REALTIME_TRANSPORT_KIND_WEB_TRANSPORT,
          ],
        ),
        reconnectPolicy: RealtimeReconnectPolicy(
          baseDelay: const Duration(milliseconds: 1),
          maxDelay: const Duration(milliseconds: 5),
        ),
        nowMillis: () => 0,
        heartbeatInterval: const Duration(hours: 1),
      );

      engine.start();
      await pumpEventQueue();

      // WebTransport failed once (threshold 1) and got demoted; WebSocket
      // connected in the same cycle.
      expect(failing.channels, hasLength(1));
      expect(working.channels, hasLength(1));
      expect(selector.preferred, RealtimeTransport.webSocket);
      await engine.close();
    },
  );

  test('heartbeat sends while connected', () async {
    final factory = _FakeFactory();
    final engine = ReconnectingRoomRealtimeEngine(
      roomId: 'room-1',
      planner: FixedTransportPlanner(
        RealtimeTransportOption(
          transport: RealtimeTransport.webSocket,
          factory: factory,
        ),
      ),
      reconnectPolicy: RealtimeReconnectPolicy(
        baseDelay: const Duration(milliseconds: 1),
        maxDelay: const Duration(milliseconds: 5),
      ),
      nowMillis: () => 1234,
      heartbeatInterval: Duration.zero,
    );
    engine.start();
    await pumpEventQueue();

    final heartbeats = factory.channels.single.sent
        .map(client.ClientMessage.fromBuffer)
        .where((message) => message.hasHeartbeat())
        .toList();
    expect(heartbeats, isNotEmpty);
    expect(heartbeats.first.heartbeat.timestamp.toInt(), 1234);
    await engine.close();
  });

  test('close is idempotent and stops reconnection', () async {
    final factory = _FakeFactory();
    final engine = _buildEngine(factory);
    engine.start();
    await pumpEventQueue();

    await Future.wait([engine.close(), engine.close()]);
    expect(factory.channels.single.closed, isTrue);
    final countAfterClose = factory.channels.length;
    await pumpEventQueue();
    expect(factory.channels, hasLength(countAfterClose));
  });

  test('decode failures are ignored without ending the session', () async {
    final factory = _FakeFactory();
    final engine = _buildEngine(factory);
    engine.start();
    await pumpEventQueue();

    factory.channels.single.incoming.add(Uint8List.fromList([1, 2, 3]));
    factory.channels.single.incoming.add(
      _serverFrame(
        client.ServerMessage(
          notification: client.UserNotification(
            notificationId: 'n-1',
            title: 'hello',
            content: 'world',
          ),
        ),
      ),
    );
    final messages = <RoomRealtimeMessage>[];
    final subscription = engine.messages.listen(messages.add);
    await pumpEventQueue();

    expect(
      messages.map((message) => message.kind),
      contains(RoomRealtimeMessageKind.notification),
    );
    // Bad frame did not drop the channel.
    expect(factory.channels.single.closed, isFalse);
    await subscription.cancel();
    await engine.close();
  });

  test(
    'cursor-expired observe errors restart the observation from now',
    () async {
      // Regression (stale-cursor-observation-never-recovers): an expired
      // cursor used to kill the observation for good — every reconnect
      // replayed the same stale cursor and failed again.
      final factory = _FakeFactory();
      final engine = _buildEngine(factory);
      engine.start();
      await pumpEventQueue();

      engine.send(_observe('room_settings').writeToBuffer());
      final channel = factory.channels.single;
      channel.incoming.add(
        _serverFrame(
          client.ServerMessage(
            resourceEvent: client.ResourceEvent(
              observeId: 'room_settings',
              eventCursor: client.EventCursor(sequence: Int64(21)),
            ),
          ),
        ),
      );
      await pumpEventQueue();
      expect(
        channel.sent,
        hasLength(1),
        reason: 'only the initial observe so far',
      );

      channel.incoming.add(
        _serverFrame(
          client.ServerMessage(
            resourceObserveError: client.ResourceObserveError(
              observeId: 'room_settings',
              error: client.ErrorMessage(
                message:
                    'Room resource event cursor expired; fetch the resource '
                    'snapshot again and restart observe',
              ),
            ),
          ),
        ),
      );
      await pumpEventQueue();

      // The engine re-sent the observation with the cursor cleared.
      final resent = channel.sent
          .skip(1)
          .map(client.ClientMessage.fromBuffer)
          .single;
      expect(resent.observeResource.observeId, 'room_settings');
      expect(
        resent.observeResource.roomSettings.afterEventSequence,
        Int64.ZERO,
        reason: 'the replay cursor must restart from now',
      );

      // A later reconnect also replays without the stale cursor.
      factory.dropLast();
      await pumpEventQueue();
      final reconnect = factory.channels.last.sent
          .map(client.ClientMessage.fromBuffer)
          .single;
      expect(
        reconnect.observeResource.roomSettings.afterEventSequence,
        Int64.ZERO,
      );
      await engine.close();
    },
  );

  test('a mid-session drop reports the transport as failed', () async {
    // Regression (sse-sticky-forever): a transport whose sessions keep
    // dying after a successful connect was never reported to the planner,
    // so failover never moved past it.
    final factory = _FakeFactory();
    final planner = _RecordingPlanner(
      RealtimeTransportOption(
        transport: RealtimeTransport.webSocket,
        factory: factory,
      ),
    );
    final engine = ReconnectingRoomRealtimeEngine(
      roomId: 'room-1',
      planner: planner,
      reconnectPolicy: RealtimeReconnectPolicy(
        baseDelay: const Duration(milliseconds: 1),
        maxDelay: const Duration(milliseconds: 5),
      ),
      nowMillis: () => 42,
      heartbeatInterval: const Duration(hours: 1),
    );
    engine.start();
    await pumpEventQueue();
    expect(planner.successes, [RealtimeTransport.webSocket]);

    factory.dropLast();
    await pumpEventQueue();

    expect(planner.failures, contains(RealtimeTransport.webSocket));
    await engine.close();
  });
}

/// Fixed planner that records success/failure reports for assertions.
class _RecordingPlanner extends FixedTransportPlanner {
  _RecordingPlanner(super.option);

  final successes = <RealtimeTransport>[];
  final failures = <RealtimeTransport>[];

  @override
  void reportSuccess(RealtimeTransport transport) => successes.add(transport);

  @override
  void reportFailure(RealtimeTransport transport) => failures.add(transport);
}
