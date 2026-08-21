import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/application/playback_history_controller.dart';
import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  group('PlaybackHistoryController', () {
    late _FakeRoomPlaybackGateway gateway;
    late PlaybackHistoryController controller;

    setUp(() {
      gateway = _FakeRoomPlaybackGateway();
      controller = PlaybackHistoryController(
        gateway: gateway,
        roomId: 'room_1',
      );
    });

    tearDown(() => controller.dispose());

    test('loads additional cursor pages in the selected order', () async {
      gateway.pages.addAll([
        client.ListPlaybackHistoryResponse(
          entries: [_entry('ph_3'), _entry('ph_2')],
          nextCursorEntryId: 'ph_2',
        ),
        client.ListPlaybackHistoryResponse(entries: [_entry('ph_1')]),
      ]);

      await controller.refresh();
      await controller.loadMore();

      expect(controller.state.entries.map((entry) => entry.id), [
        'ph_3',
        'ph_2',
        'ph_1',
      ]);
      expect(controller.state.hasMore, isFalse);
      expect(gateway.listCalls, [
        const _ListCall('', client_enum.SortDirection.SORT_DIRECTION_DESC),
        const _ListCall('ph_2', client_enum.SortDirection.SORT_DIRECTION_DESC),
      ]);
    });

    test('switches to oldest-first and uses that order for refresh', () async {
      gateway.pages.add(
        client.ListPlaybackHistoryResponse(entries: [_entry('ph_1')]),
      );

      await controller.setSortDirection(
        client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(
        controller.state.sortDirection,
        client_enum.SortDirection.SORT_DIRECTION_ASC,
      );
      expect(controller.state.entries.single.id, 'ph_1');
      expect(
        gateway.listCalls.single,
        const _ListCall('', client_enum.SortDirection.SORT_DIRECTION_ASC),
      );
    });

    test(
      'deletes the current entry and clears all remaining history',
      () async {
        controller.applyRealtimeHistory(
          client.ListPlaybackHistoryResponse(
            entries: [_entry('ph_current'), _entry('ph_old')],
            historyCursorId: 'ph_current',
          ),
          '1',
        );
        gateway.pages.addAll([
          client.ListPlaybackHistoryResponse(entries: [_entry('ph_old')]),
          client.ListPlaybackHistoryResponse(),
        ]);
        gateway.clearResult = 1;

        expect(await controller.deleteEntry('ph_current'), isTrue);
        expect(controller.state.cursorId, isEmpty);
        expect(controller.state.entries.single.id, 'ph_old');
        expect(gateway.deletedEntryIds, ['ph_current']);

        expect(await controller.clear(), 1);
        expect(controller.state.entries, isEmpty);
        expect(controller.state.clearing, isFalse);
        expect(gateway.clearCalls, 1);
      },
    );

    test('reconciles stale state after idempotent delete and clear', () async {
      controller.applyRealtimeHistory(
        client.ListPlaybackHistoryResponse(
          entries: [_entry('ph_stale')],
          historyCursorId: 'ph_stale',
        ),
        '1',
      );
      gateway.deleteResult = false;
      gateway.pages.add(client.ListPlaybackHistoryResponse());

      expect(await controller.deleteEntry('ph_stale'), isFalse);
      expect(controller.state.entries, isEmpty);
      expect(controller.state.cursorId, isEmpty);

      controller.applyRealtimeHistory(
        client.ListPlaybackHistoryResponse(entries: [_entry('ph_stale')]),
        '2',
      );
      gateway.clearResult = 0;
      gateway.pages.add(client.ListPlaybackHistoryResponse());

      expect(await controller.clear(), 0);
      expect(controller.state.entries, isEmpty);
      expect(gateway.clearCalls, 1);
    });
  });
}

client.PlaybackHistoryEntry _entry(String id) =>
    client.PlaybackHistoryEntry(id: id, createdAt: Int64.ONE);

final class _ListCall {
  const _ListCall(this.cursorEntryId, this.sortDirection);

  final String cursorEntryId;
  final client_enum.SortDirection sortDirection;

  @override
  bool operator ==(Object other) =>
      other is _ListCall &&
      other.cursorEntryId == cursorEntryId &&
      other.sortDirection == sortDirection;

  @override
  int get hashCode => Object.hash(cursorEntryId, sortDirection);
}

final class _FakeRoomPlaybackGateway implements RoomPlaybackGateway {
  final List<client.ListPlaybackHistoryResponse> pages = [];
  final List<_ListCall> listCalls = [];
  final List<String> deletedEntryIds = [];
  bool deleteResult = true;
  int clearResult = 0;
  int clearCalls = 0;

  @override
  Future<client.ListPlaybackHistoryResponse> listHistory(
    String roomId, {
    String cursorEntryId = '',
    int limit = 50,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    listCalls.add(_ListCall(cursorEntryId, sortDirection));
    return pages.removeAt(0);
  }

  @override
  Future<bool> deleteHistoryEntry(String roomId, String entryId) async {
    deletedEntryIds.add(entryId);
    return deleteResult;
  }

  @override
  Future<int> clearHistory(String roomId) async {
    clearCalls++;
    return clearResult;
  }

  @override
  Future<SyncTvPlaybackStatus> playHistoryEntry(
    String roomId,
    String entryId,
  ) => throw UnimplementedError();

  @override
  Future<SyncTvPlaybackStatus> playNext(String roomId) =>
      throw UnimplementedError();

  @override
  Future<SyncTvPlaybackStatus> playPrevious(String roomId) =>
      throw UnimplementedError();

  @override
  Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  }) => throw UnimplementedError();
}
