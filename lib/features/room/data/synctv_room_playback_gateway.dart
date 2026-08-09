import 'package:synctv_app/features/room/application/room_playback_gateway.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

final class SyncTvRoomPlaybackGateway implements RoomPlaybackGateway {
  const SyncTvRoomPlaybackGateway();

  @override
  Future<SyncTvPlaybackStatus> playPrevious(String roomId) =>
      SyncTvService.playPrevious(roomId);

  @override
  Future<SyncTvPlaybackStatus> playNext(String roomId) =>
      SyncTvService.playNext(roomId);

  @override
  Future<client.ListPlaybackHistoryResponse> listHistory(
    String roomId, {
    String beforeEntryId = '',
    int limit = 50,
  }) => SyncTvService.listPlaybackHistory(
    roomId,
    beforeEntryId: beforeEntryId,
    limit: limit,
  );

  @override
  Future<SyncTvPlaybackStatus> playHistoryEntry(
    String roomId,
    String entryId,
  ) => SyncTvService.playHistoryEntry(roomId, entryId);

  @override
  Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  }) => SyncTvService.switchMedia(
    roomId,
    entryId,
    subPath: subPath,
    playlistId: playlistId,
  );
}
