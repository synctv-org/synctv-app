import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

final class SyncTvRoomManagementGateway implements RoomManagementGateway {
  const SyncTvRoomManagementGateway();

  @override
  Future<SyncTvUser> getMe({bool refresh = false}) =>
      SyncTvService.getMe(refresh: refresh);
  @override
  Future<SyncTvRoom> getRoomInfo(String roomId) =>
      SyncTvService.getRoomInfo(roomId);
  @override
  Future<void> deleteRoom(String roomId) => SyncTvService.deleteRoom(roomId);
  @override
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
  }) => SyncTvService.getRoomMemberDetailsPage(
    roomId,
    page: page,
    pageSize: pageSize,
    search: search,
    role: role,
    sortBy: sortBy,
    sortDirection: sortDirection,
  );
  @override
  Future<List<IceServerInfo>> getIceServers(String roomId) =>
      SyncTvService.getIceServers(roomId);
  @override
  Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  }) => SyncTvService.getRoomSettings(roomId, refresh: refresh);
  @override
  Future<void> updateRoomPassword(String roomId, String? password) =>
      SyncTvService.updateRoomPassword(roomId, password);
  @override
  Future<void> updateRoomSettings(String roomId, SyncTvRoomSettings settings) =>
      SyncTvService.updateRoomSettings(roomId, settings);
  @override
  Future<void> updateRoomAutoPlay(
    String roomId, {
    required bool enabled,
    required client.PlayMode mode,
  }) => SyncTvService.updateRoomAutoPlay(roomId, enabled: enabled, mode: mode);
  @override
  Future<void> kickMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  }) => SyncTvService.kickMember(
    roomId,
    userId,
    kickCooldownSeconds: kickCooldownSeconds,
  );
  @override
  Future<RoomStreamsPage> listRoomStreamsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    client.RoomStreamListSortBy sortBy =
        client.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_ASC,
  }) => SyncTvService.listRoomStreamsPage(
    roomId,
    page: page,
    pageSize: pageSize,
    search: search,
    sortBy: sortBy,
    sortDirection: sortDirection,
  );
  @override
  Future<RoomStreamEntryInfo> getRoomStreamInfo(
    String roomId,
    String mediaId,
  ) => SyncTvService.getRoomStreamInfo(roomId, mediaId);
  @override
  Future<void> kickRoomStream(
    String roomId,
    String mediaId, {
    String reason = '',
  }) => SyncTvService.kickRoomStream(roomId, mediaId, reason: reason);
  @override
  Future<RoomJoinReviewsPage> listRoomJoinReviewsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    common.ReviewStatus status = common.ReviewStatus.REVIEW_STATUS_PENDING,
    String userId = '',
  }) => SyncTvService.listRoomJoinReviewsPage(
    roomId,
    page: page,
    pageSize: pageSize,
    status: status,
    userId: userId,
  );
  @override
  Future<void> approveRoomJoinReview(String roomId, String requestId) =>
      SyncTvService.approveRoomJoinReview(roomId, requestId);
  @override
  Future<void> rejectRoomJoinReview(
    String roomId,
    String requestId, {
    String reason = '',
  }) => SyncTvService.rejectRoomJoinReview(roomId, requestId, reason: reason);
  @override
  Future<void> addRoomMember(
    String roomId,
    String userId, {
    int role = 3,
    bool notify = true,
  }) => SyncTvService.addRoomMember(roomId, userId, role: role, notify: notify);
  @override
  Future<void> updateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  ) => SyncTvService.updateRoomMemberRemarkName(roomId, userId, remarkName);
  @override
  Future<void> updateRoomMemberDisplayTag(
    String roomId,
    String userId,
    String displayTag,
  ) => SyncTvService.updateRoomMemberDisplayTag(roomId, userId, displayTag);
  @override
  Future<AdminRoomMember> setRoomMemberRole(
    String roomId,
    String userId,
    int role,
  ) => SyncTvService.setRoomMemberRole(roomId, userId, role);
  @override
  Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) => SyncTvService.updateRoomMemberPermissionOverrides(
    roomId,
    userId,
    addedPermissions: addedPermissions,
    removedPermissions: removedPermissions,
    adminAddedPermissions: adminAddedPermissions,
    adminRemovedPermissions: adminRemovedPermissions,
  );
  @override
  Future<void> transferRoomOwnership(String roomId, String newOwnerId) =>
      SyncTvService.transferRoomOwnership(roomId, newOwnerId);
  @override
  Future<void> leaveRoom(String roomId) => SyncTvService.leaveRoom(roomId);
  @override
  Future<void> resetRoomSettings(String roomId) =>
      SyncTvService.resetRoomSettings(roomId);
  @override
  Future<void> setRoomAdmin(String roomId, String userId) =>
      SyncTvService.setRoomAdmin(roomId, userId);
  @override
  Future<void> removeRoomAdmin(String roomId, String userId) =>
      SyncTvService.removeRoomAdmin(roomId, userId);
  @override
  Future<SyncTvRoom> updateRoomCover(String roomId, LocalImageUpload upload) =>
      SyncTvService.updateRoomCover(roomId, upload);
  @override
  Future<SyncTvRoom> clearRoomCover(String roomId) =>
      SyncTvService.clearRoomCover(roomId);
}
