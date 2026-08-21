import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

abstract interface class RoomPlaybackGateway {
  Future<SyncTvPlaybackStatus> playPrevious(String roomId);

  Future<SyncTvPlaybackStatus> playNext(String roomId);

  Future<client.ListPlaybackHistoryResponse> listHistory(
    String roomId, {
    String cursorEntryId = '',
    int limit = 50,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  });

  Future<SyncTvPlaybackStatus> playHistoryEntry(String roomId, String entryId);

  Future<bool> deleteHistoryEntry(String roomId, String entryId);

  Future<int> clearHistory(String roomId);

  Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  });
}
