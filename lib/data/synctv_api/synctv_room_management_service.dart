import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

class SyncTvRoomManagementDomainService {
  SyncTvRoomManagementDomainService(
    this._api, {
    SyncTvMemoryCache? cache,
    opaque.SyncTvOpaqueClient? opaqueClient,
  }) : _cache = cache ?? SyncTvMemoryCache(),
       _opaqueClient = opaqueClient ?? opaque.SyncTvOpaqueClient();

  final SyncTvApiClient _api;
  final SyncTvMemoryCache _cache;
  final opaque.SyncTvOpaqueClient _opaqueClient;

  Future<List<SyncTvUser>> getRoomMembers(String roomId) async {
    final response = await _api.room.getRoomMembers(
      roomId,
      client.GetRoomMembersRequest(),
    );
    return response.members.map(_api.mapMember).toList(growable: false);
  }

  Future<RoomMembersPage> getRoomMemberDetailsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    common_enum.RoomMemberRole? role,
    client_enum.RoomMemberListSortBy sortBy =
        client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.room.getRoomMembers(
      roomId,
      client.GetRoomMembersRequest(
        page: page,
        pageSize: pageSize,
        search: search,
        role: role,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return RoomMembersPage(
      members: response.members
          .map(roomMemberFromProto)
          .toList(growable: false),
      total: response.total,
      onlineMemberCount: response.hasPresence()
          ? response.presence.onlineMemberCount
          : 0,
      connectionCount: response.hasPresence()
          ? response.presence.connectionCount
          : 0,
      page: page,
      pageSize: pageSize,
      version: response.version,
    );
  }

  Stream<RoomResourceWatchEvent<SyncTvRoomSettings>> watchRoomSettings(
    String roomId, {
    String version = '',
  }) {
    return _api.room
        .watchRoomSettings(
          roomId,
          client.WatchRoomSettingsRequest(
            deliveryMode: client_enum
                .ResourceDeliveryMode
                .RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
            roomSettings: client.ObserveRoomSettings(
              afterEventSequence: _watchSequence(version),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<SyncTvRoomSettings>.observed(
              version: _cursorVersion(event.observed.eventCursor),
              changed: event.observed.changed,
            );
          }
          if (event.hasError()) {
            return RoomResourceWatchEvent<SyncTvRoomSettings>.error(
              message: event.error.hasError() ? event.error.error.message : '',
              code: event.error.hasError() ? event.error.error.code : 0,
            );
          }
          return RoomResourceWatchEvent<SyncTvRoomSettings>.changed(
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: SyncTvRoomSettings.fromJson(
              roomSettingsToJson(event.resourceEvent.roomSettings.settings),
            ),
          );
        });
  }

  Stream<RoomResourceWatchEvent<List<AdminRoomMember>>> watchRoomMembers(
    String roomId, {
    String version = '',
  }) {
    return _api.room
        .watchRoomMemberEvents(
          roomId,
          client.WatchRoomMemberEventsRequest(
            deliveryMode: client_enum
                .ResourceDeliveryMode
                .RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
            roomMemberEvents: client.ObserveRoomMemberEvents(
              afterEventSequence: _watchSequence(version),
            ),
          ),
        )
        .map((event) {
          if (event.hasObserved()) {
            return RoomResourceWatchEvent<List<AdminRoomMember>>.observed(
              version: _cursorVersion(event.observed.eventCursor),
              changed: event.observed.changed,
            );
          }
          if (event.hasError()) {
            return RoomResourceWatchEvent<List<AdminRoomMember>>.error(
              message: event.error.hasError() ? event.error.error.message : '',
              code: event.error.hasError() ? event.error.error.code : 0,
            );
          }
          return RoomResourceWatchEvent<List<AdminRoomMember>>.changed(
            version: _cursorVersion(event.resourceEvent.eventCursor),
            snapshot: const <AdminRoomMember>[],
          );
        });
  }

  Future<List<IceServerInfo>> getIceServers(String roomId) async {
    final response = await _api.room.getIceServers(
      roomId,
      client.GetIceServersRequest(),
    );
    return response.servers.map(iceServerFromProto).toList(growable: false);
  }

  Future<void> updateRoomPassword(String roomId, String? password) async {
    final newPassword = password ?? '';
    if (newPassword.isEmpty) {
      await _api.room.clearRoomPassword(
        roomId,
        client.ClearRoomPasswordRequest(),
      );
      return;
    }

    final start = await _opaqueClient.startRegistration(newPassword);
    final challenge = await _api.room.startRoomPasswordRegistration(
      roomId,
      client.StartRoomPasswordRegistrationRequest(
        registrationRequest: start.registrationRequest,
      ),
    );
    final finish = await _opaqueClient.finishRegistration(
      password: newPassword,
      state: start.state,
      registrationResponse: Uint8List.fromList(challenge.registrationResponse),
    );
    await _api.room.finishRoomPasswordRegistration(
      roomId,
      client.FinishRoomPasswordRegistrationRequest(
        sessionId: challenge.sessionId,
        registrationUpload: finish.registrationUpload,
      ),
    );
  }

  Int64? _watchSequence(String version) {
    if (version.isEmpty) return null;
    final parsed = int.tryParse(version);
    return parsed == null ? null : Int64(parsed);
  }

  String _cursorVersion(client.EventCursor cursor) {
    final sequence = cursor.sequence.toInt();
    return sequence == 0 ? cursor.eventId : sequence.toString();
  }

  Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  }) async {
    return _cache.get<SyncTvRoomSettings>(
      'room:$roomId:settings',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: () => _fetchRoomSettings(roomId),
    );
  }

  Future<SyncTvRoomSettings> _fetchRoomSettings(String roomId) async {
    final response = await _api.room.getRoomSettings(
      roomId,
      client.GetRoomSettingsRequest(),
    );
    return SyncTvRoomSettings.fromJson(roomSettingsToJson(response.settings));
  }

  Future<void> updateRoomSettings(
    String roomId,
    SyncTvRoomSettings settings,
  ) async {
    await _api.room.updateRoomSettings(
      roomId,
      roomSettingsUpdateRequestFromJson(settings.toJson()),
    );
    _cache.put(
      'room:$roomId:settings',
      settings,
      ttl: const Duration(minutes: 2),
    );
  }

  Future<SyncTvRoom> updateRoomVisibility(String roomId, bool isPublic) async {
    final room = await _api.room.updateRoomVisibility(
      roomId,
      client.UpdateRoomVisibilityRequest(isPublic: isPublic),
    );
    return _api.mapRoom(room);
  }

  Future<void> updateRoomAutoPlay(
    String roomId, {
    required bool enabled,
    required client_enum.PlayMode mode,
  }) async {
    await _api.room.updateRoomSettings(
      roomId,
      roomSettingsUpdateRequestFromJson({
        'autoPlay': {'enabled': enabled, 'mode': mode.value},
      }),
    );
    _cache.invalidate('room:$roomId:settings');
  }

  Future<void> kickMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  }) async {
    await _api.room.kickMember(
      roomId,
      client.KickMemberRequest(
        userId: userId,
        kickCooldownSeconds: Int64(kickCooldownSeconds),
      ),
    );
  }

  Future<RoomStreamsPage> listRoomStreamsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    client_enum.RoomStreamListSortBy sortBy =
        client_enum.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
  }) async {
    final response = await _api.room.listRoomStreams(
      roomId,
      client.ListRoomStreamsRequest(
        page: page,
        pageSize: pageSize,
        search: search,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    final streams = <RoomStreamEntryInfo>[];
    for (final stream in response.streams) {
      if (!stream.active) {
        streams.add(roomStreamEntryFromProto(stream));
        continue;
      }
      try {
        final info = await _api.room.getRoomStreamInfo(
          roomId,
          client.GetRoomStreamInfoRequest(mediaId: stream.mediaId),
        );
        streams.add(roomStreamEntryFromProto(stream, info: info));
      } catch (_) {
        streams.add(roomStreamEntryFromProto(stream));
      }
    }
    return RoomStreamsPage(
      streams: streams,
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<RoomStreamEntryInfo> getRoomStreamInfo(
    String roomId,
    String mediaId,
  ) async {
    final response = await _api.room.getRoomStreamInfo(
      roomId,
      client.GetRoomStreamInfoRequest(mediaId: mediaId),
    );
    return RoomStreamEntryInfo(
      mediaId: mediaId,
      active: response.active,
      publisherUserId: response.hasPublisher() ? response.publisher.userId : '',
      startedAt: response.hasPublisher()
          ? response.publisher.startedAt.toInt()
          : 0,
    );
  }

  Future<void> kickRoomStream(
    String roomId,
    String mediaId, {
    String reason = '',
  }) async {
    await _api.room.kickRoomStream(
      roomId,
      client.KickRoomStreamRequest(mediaId: mediaId, reason: reason),
    );
  }

  Future<RoomJoinReviewsPage> listRoomJoinReviewsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    common_enum.ReviewStatus status =
        common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
    String userId = '',
  }) async {
    final response = await _api.room.listRoomJoinReviews(
      roomId,
      client.ListRoomJoinReviewsRequest(
        page: page,
        pageSize: pageSize,
        status: status,
        userId: userId,
      ),
    );
    return RoomJoinReviewsPage(
      reviews: response.reviews
          .map(roomJoinReviewFromProto)
          .toList(growable: false),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<void> approveRoomJoinReview(String roomId, String requestId) async {
    await _api.room.approveRoomJoinReview(
      roomId,
      client.ApproveRoomJoinReviewRequest(requestId: requestId),
    );
  }

  Future<void> rejectRoomJoinReview(
    String roomId,
    String requestId, {
    String reason = '',
  }) async {
    await _api.room.rejectRoomJoinReview(
      roomId,
      client.RejectRoomJoinReviewRequest(requestId: requestId, reason: reason),
    );
  }

  Future<void> addRoomMember(
    String roomId,
    String userId, {
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
    bool notify = true,
  }) async {
    await _api.room.addMember(
      roomId,
      client.AddMemberRequest(userId: userId, role: role, notify: notify),
    );
  }

  Future<void> updateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  ) async {
    await _api.room.updateMemberRemarkName(
      roomId,
      client.UpdateMemberRemarkNameRequest(
        userId: userId,
        remarkName: remarkName,
      ),
    );
  }

  Future<void> updateRoomMemberDisplayTag(
    String roomId,
    String userId,
    String displayTag,
  ) async {
    await _api.room.updateMemberDisplayTag(
      roomId,
      client.UpdateMemberDisplayTagRequest(
        userId: userId,
        displayTag: displayTag,
      ),
    );
  }

  Future<AdminRoomMember> setRoomMemberRole(
    String roomId,
    String userId,
    common_enum.RoomMemberRole role,
  ) async {
    final member = await _api.room.updateMemberPermissions(
      roomId,
      client.UpdateMemberPermissionsRequest(userId: userId, role: role),
    );
    return roomMemberFromProto(member);
  }

  Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) async {
    await _api.room.updateMemberPermissions(
      roomId,
      client.UpdateMemberPermissionsRequest(
        userId: userId,
        addedPermissions: Int64(addedPermissions),
        removedPermissions: Int64(removedPermissions),
        adminAddedPermissions: Int64(adminAddedPermissions),
        adminRemovedPermissions: Int64(adminRemovedPermissions),
      ),
    );
  }

  Future<void> transferRoomOwnership(String roomId, String newOwnerId) async {
    await _api.room.transferRoomOwnership(
      roomId,
      client.TransferRoomOwnershipRequest(newOwnerUserId: newOwnerId),
    );
  }

  Future<void> leaveRoom(String roomId) async {
    await _api.room.leaveRoom(roomId, client.LeaveRoomRequest());
  }

  Future<void> resetRoomSettings(String roomId) async {
    await _api.room.resetRoomSettings(
      roomId,
      client.ResetRoomSettingsRequest(),
    );
    _cache.invalidate('room:$roomId:settings');
  }

  Future<void> setRoomAdmin(String roomId, String userId) async {
    await _api.room.updateMemberPermissions(
      roomId,
      client.UpdateMemberPermissionsRequest(
        userId: userId,
        role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
      ),
    );
  }

  Future<void> removeRoomAdmin(String roomId, String userId) async {
    await _api.room.updateMemberPermissions(
      roomId,
      client.UpdateMemberPermissionsRequest(
        userId: userId,
        role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
      ),
    );
  }
}

AdminRoomMember roomMemberFromProto(common.RoomMember member) {
  return AdminRoomMember(
    roomId: member.roomId,
    userId: member.userId,
    username: member.username,
    remarkName: member.remarkName,
    displayTag: member.displayTag,
    role: member.role,
    permissions: member.permissions.toInt(),
    addedPermissions: member.addedPermissions.toInt(),
    removedPermissions: member.removedPermissions.toInt(),
    adminAddedPermissions: member.adminAddedPermissions.toInt(),
    adminRemovedPermissions: member.adminRemovedPermissions.toInt(),
    joinedAt: member.joinedAt.toInt(),
    isOnline: member.isOnline,
    connectionCount: member.connectionCount,
  );
}

RoomStreamEntryInfo roomStreamEntryFromProto(
  client.StreamEntry stream, {
  client.GetRoomStreamInfoResponse? info,
}) {
  return RoomStreamEntryInfo(
    mediaId: stream.mediaId,
    active: stream.active || (info?.active ?? false),
    publisherUserId: info?.publisher.userId ?? '',
    startedAt: info?.publisher.startedAt.toInt() ?? 0,
  );
}

RoomJoinReviewInfo roomJoinReviewFromProto(client.RoomJoinReview review) {
  return RoomJoinReviewInfo(
    id: review.id,
    roomId: review.roomId,
    userId: review.userId,
    username: review.username,
    requestedRole: review.requestedRole,
    status: review.status,
    requestedAt: review.requestedAt.toInt(),
    reviewedAt: review.reviewedAt.toInt(),
    reviewedBy: review.reviewedBy,
    rejectionReason: review.rejectionReason,
  );
}

IceServerInfo iceServerFromProto(client.IceServer server) {
  return IceServerInfo(
    urls: server.urls.toList(),
    username: server.username,
    credential: server.credential,
  );
}
