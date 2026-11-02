import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/realtime_observation_registry.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

client.ObserveResource _chatEvents({Int64? after}) {
  return client.ObserveResource(
    observeId: 'chat_events',
    deliveryMode:
        client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
    chatEvents: client.ObserveChatEvents(
      afterEventSequence: after,
      includeMessageTypes: [client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER],
    ),
  );
}

void main() {
  group('RealtimeObservationRegistry', () {
    test('replays observations with the last event cursor', () {
      final registry = RealtimeObservationRegistry();
      registry.record(_chatEvents());
      registry.advanceCursor(
        'chat_events',
        client.EventCursor(eventId: 'evt-1', sequence: Int64(41)),
      );

      final replay = registry.replayMessages();
      expect(replay, hasLength(1));
      final message = client.ClientMessage.fromBuffer(replay.single);
      expect(message.observeResource.chatEvents.afterEventSequence, Int64(41));
      expect(
        message.observeResource.deliveryMode,
        client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      );
    });

    test('re-requesting an observation keeps the cursor', () {
      final registry = RealtimeObservationRegistry();
      registry.record(_chatEvents());
      registry.advanceCursor(
        'chat_events',
        client.EventCursor(sequence: Int64(7)),
      );
      // Pagination/search re-request without a cursor.
      registry.record(_chatEvents());

      final replay = client.ClientMessage.fromBuffer(
        registry.replayMessages().single,
      );
      expect(replay.observeResource.chatEvents.afterEventSequence, Int64(7));
    });

    test('cursor never rewinds', () {
      final registry = RealtimeObservationRegistry();
      registry.record(_chatEvents());
      registry.advanceCursor(
        'chat_events',
        client.EventCursor(sequence: Int64(12)),
      );
      registry.advanceCursor(
        'chat_events',
        client.EventCursor(sequence: Int64(5)),
      );

      final replay = client.ClientMessage.fromBuffer(
        registry.replayMessages().single,
      );
      expect(replay.observeResource.chatEvents.afterEventSequence, Int64(12));
    });

    test('cursor patches only resources that carry one', () {
      final registry = RealtimeObservationRegistry();
      registry
        ..record(
          client.ObserveResource(
            observeId: 'online_count',
            onlineCount: client.ObserveOnlineCount(),
          ),
        )
        ..record(
          client.ObserveResource(
            observeId: 'room_settings',
            roomSettings: client.ObserveRoomSettings(),
          ),
        )
        ..advanceCursor('online_count', client.EventCursor(sequence: Int64(99)))
        ..advanceCursor(
          'room_settings',
          client.EventCursor(sequence: Int64(5)),
        );

      final replays = registry
          .replayMessages()
          .map(client.ClientMessage.fromBuffer)
          .toList();
      final online = replays.firstWhere(
        (message) => message.observeResource.observeId == 'online_count',
      );
      final settings = replays.firstWhere(
        (message) => message.observeResource.observeId == 'room_settings',
      );
      expect(online.observeResource.hasOnlineCount(), isTrue);
      expect(
        settings.observeResource.roomSettings.afterEventSequence,
        Int64(5),
      );
    });

    test('removing and clearing observations', () {
      final registry = RealtimeObservationRegistry()
        ..record(_chatEvents())
        ..record(
          client.ObserveResource(
            observeId: 'room_settings',
            roomSettings: client.ObserveRoomSettings(),
          ),
        );
      registry.remove('chat_events');
      expect(registry.observeIds, ['room_settings']);

      registry.clear();
      expect(registry.isEmpty, isTrue);
      expect(registry.replayMessages(), isEmpty);
    });

    test('exposes playlist context for the codec', () {
      final registry = RealtimeObservationRegistry()
        ..record(
          client.ObserveResource(
            observeId: 'playlist_items',
            playlistItems: client.ObservePlaylistItems(
              request: client.ListPlaylistItemsRequest(
                playlistId: 'pl-1',
                page: client.PagePagination(page: 3),
              ),
            ),
          ),
        );

      expect(registry.playlistContext('playlist_items'), (
        parentId: 'pl-1',
        page: 3,
      ));
      expect(registry.playlistContext('missing'), isNull);
      // Delivery mode falls back to the proto default when unset.
      expect(
        registry.deliveryMode('playlist_items'),
        client_enum.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_UNSPECIFIED,
      );
      expect(registry.deliveryMode('missing'), isNull);
    });
  });
}
