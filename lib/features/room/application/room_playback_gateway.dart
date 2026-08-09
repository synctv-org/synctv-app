import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

abstract interface class RoomPlaybackGateway {
  Future<SyncTvPlaybackStatus> playPrevious(String roomId);

  Future<SyncTvPlaybackStatus> playNext(String roomId);

  Future<client.ListPlaybackHistoryResponse> listHistory(
    String roomId, {
    String beforeEntryId = '',
    int limit = 50,
  });

  Future<SyncTvPlaybackStatus> playHistoryEntry(String roomId, String entryId);

  Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  });
}
