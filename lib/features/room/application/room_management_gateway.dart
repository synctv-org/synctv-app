import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

abstract interface class RoomManagementGateway {
  Future<SyncTvUser> getMe({bool refresh = false});
  Future<SyncTvRoom> getRoomInfo(String roomId);
  Future<void> deleteRoom(String roomId);
  Future<RoomMembersPage> getRoomMemberDetailsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    common.RoomMemberRole? role,
    client.RoomMemberListSortBy sortBy =
        client.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_DESC,
  });
  Future<List<IceServerInfo>> getIceServers(String roomId);
  Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  });
  Future<void> updateRoomPassword(String roomId, String? password);
  Future<void> updateRoomSettings(String roomId, SyncTvRoomSettings settings);
  Future<void> updateRoomAutoPlay(
    String roomId, {
    required bool enabled,
    required client.PlayMode mode,
  });
  Future<void> kickMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  });
  Future<RoomStreamsPage> listRoomStreamsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    client.RoomStreamListSortBy sortBy =
        client.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_ASC,
  });
  Future<RoomStreamEntryInfo> getRoomStreamInfo(String roomId, String mediaId);
  Future<void> kickRoomStream(
    String roomId,
    String mediaId, {
    String reason = '',
  });
  Future<RoomJoinReviewsPage> listRoomJoinReviewsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    common.ReviewStatus status = common.ReviewStatus.REVIEW_STATUS_PENDING,
    String userId = '',
  });
  Future<void> approveRoomJoinReview(String roomId, String requestId);
  Future<void> rejectRoomJoinReview(
    String roomId,
    String requestId, {
    String reason = '',
  });
  Future<void> addRoomMember(
    String roomId,
    String userId, {
    int role = 3,
    bool notify = true,
  });
  Future<void> updateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  );
  Future<void> updateRoomMemberDisplayTag(
    String roomId,
    String userId,
    String displayTag,
  );
  Future<AdminRoomMember> setRoomMemberRole(
    String roomId,
    String userId,
    int role,
  );
  Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  });
  Future<void> transferRoomOwnership(String roomId, String newOwnerId);
  Future<void> leaveRoom(String roomId);
  Future<void> resetRoomSettings(String roomId);
  Future<void> setRoomAdmin(String roomId, String userId);
  Future<void> removeRoomAdmin(String roomId, String userId);
  Future<SyncTvRoom> updateRoomCover(String roomId, LocalImageUpload upload);
  Future<SyncTvRoom> clearRoomCover(String roomId);
}
