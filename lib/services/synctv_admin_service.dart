import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/admin_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/synctv_account_service.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_room_management_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;

class SyncTvAdminDomainService {
  SyncTvAdminDomainService(this._api);

  final SyncTvApiClient _api;
  final Map<String, Map<String, dynamic>> _settingsCache = {};

  Future<AdminUsersPage> listUsersPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    common_enum.UserStatus status =
        common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
    common_enum.UserRole role = common_enum.UserRole.USER_ROLE_UNSPECIFIED,
    bool? isBanned,
    admin_enum.UserListSortBy sortBy =
        admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.listUsers(
      admin.ListUsersRequest(
        page: page,
        pageSize: pageSize,
        search: search,
        status: status,
        role: role,
        isBanned: isBanned,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminUsersPage(
      users: response.users.map(_api.mapAdminUser).toList(),
      total: response.total,
    );
  }

  Future<void> addUser(
    String username,
    String password,
    int role, {
    String email = '',
    common_enum.UserStatus status = common_enum.UserStatus.USER_STATUS_ACTIVE,
  }) async {
    await _api.adminService.createUser(
      admin.CreateUserRequest(
        username: username,
        password: password,
        email: email,
        role: common_enum.UserRole.valueOf(role) ??
            common_enum.UserRole.USER_ROLE_USER,
        status: status,
      ),
    );
  }

  Future<void> deleteUser(String userId) async {
    await _api.adminService.deleteUser(admin.DeleteUserRequest(userId: userId));
  }

  Future<WUser> getUser(String userId) async {
    final response = await _api.adminService.getUser(
      admin.GetUserRequest(userId: userId),
    );
    return _api.mapAdminUser(response.user);
  }

  Future<AdminRoomsPage> listUserRoomsPage(
    String userId, {
    int page = 1,
    int pageSize = 20,
    String search = '',
    common_enum.RoomStatus status =
        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
    bool? isBanned,
    admin_enum.RoomListSortBy sortBy =
        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.getUserRooms(
      admin.GetUserRoomsRequest(
        userId: userId,
        page: page,
        pageSize: pageSize,
        search: search,
        status: status,
        isBanned: isBanned,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminRoomsPage(
      rooms: response.rooms.map(_api.mapAdminRoom).toList(),
      total: response.total,
    );
  }

  Future<AccountPreferences> getUserPreferences(String userId) async {
    final response = await _api.adminService.getUserPreferences(
      admin.GetUserPreferencesRequest(userId: userId),
    );
    return accountPreferencesFromProto(
      response.preferences,
      response.authFactors,
    );
  }

  Future<AccountPreferences> updateUserPreferences(
    String userId, {
    bool? twoFactorEnabled,
    NotificationPreferences? notifications,
  }) async {
    final response = await _api.adminService.updateUserPreferences(
      admin.UpdateUserPreferencesRequest(
        userId: userId,
        twoFactorEnabled: twoFactorEnabled,
        notifications: notifications?.toProto(),
      ),
    );
    return accountPreferencesFromProto(
      response.preferences,
      response.authFactors,
    );
  }

  Future<void> updateUsername(String userId, String username) async {
    await _api.adminService.updateUserUsername(
      admin.UpdateUserUsernameRequest(userId: userId, newUsername: username),
    );
  }

  Future<void> updatePassword(
    String userId,
    String password, {
    String reason = '',
  }) async {
    await _api.adminService.updateUserPassword(
      admin.UpdateUserPasswordRequest(
        userId: userId,
        newPassword: password,
        reason: reason,
      ),
    );
  }

  Future<void> setAdmin(String userId, bool isAdmin) async {
    await _api.adminService.updateUserRole(
      admin.UpdateUserRoleRequest(
        userId: userId,
        role: isAdmin
            ? common_enum.UserRole.USER_ROLE_ADMIN
            : common_enum.UserRole.USER_ROLE_USER,
      ),
    );
  }

  Future<List<AdminSettingsGroup>> getAllSettings() async {
    final response = await _api.adminService.getSettings(
      admin.GetSettingsRequest(),
    );
    final groups = response.groups.map(_settingsGroupFromProto).toList();
    for (final group in groups) {
      _settingsCache[group.name] = Map<String, dynamic>.from(group.settings);
    }
    return groups;
  }

  Future<AdminSettingsGroup> getSettingsGroup(String group) async {
    final response = await _api.adminService.getSettingsGroup(
      admin.GetSettingsGroupRequest(group: group),
    );
    final settingsGroup = _settingsGroupFromProto(response.group);
    _settingsCache[settingsGroup.name] = Map<String, dynamic>.from(
      settingsGroup.settings,
    );
    return settingsGroup;
  }

  Future<void> banUser(
    String userId,
    bool ban, {
    String reason = '',
  }) async {
    if (ban) {
      await _api.adminService.banUser(
        admin.BanUserRequest(userId: userId, reason: reason),
      );
    } else {
      await _api.adminService.unbanUser(
        admin.UnbanUserRequest(userId: userId),
      );
    }
  }

  Future<AdminBatchOperationResult> batchBanUsers(
    List<String> userIds, {
    String reason = '',
  }) async {
    final response = await _api.adminService.batchBanUsers(
      admin.BatchBanUsersRequest(userIds: userIds, reason: reason),
    );
    return _batchOperationResult(
        response.results, response.succeeded, response.failed);
  }

  Future<AdminBatchOperationResult> batchDeleteUsers(
    List<String> userIds,
  ) async {
    final response = await _api.adminService.batchDeleteUsers(
      admin.BatchDeleteUsersRequest(userIds: userIds),
    );
    return _batchOperationResult(
        response.results, response.succeeded, response.failed);
  }

  Future<AdminRoomsPage> listRoomsPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    common_enum.RoomStatus status =
        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
    bool? isBanned,
    admin_enum.RoomListSortBy sortBy =
        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.listRooms(
      admin.ListRoomsRequest(
        page: page,
        pageSize: pageSize,
        search: search,
        status: status,
        isBanned: isBanned,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminRoomsPage(
      rooms: response.rooms.map(_api.mapAdminRoom).toList(),
      total: response.total,
    );
  }

  Future<void> banRoom(
    String roomId,
    bool ban, {
    String reason = '',
  }) async {
    if (ban) {
      await _api.adminService.banRoom(
        admin.BanRoomRequest(roomId: roomId, reason: reason),
      );
    } else {
      await _api.adminService.unbanRoom(
        admin.UnbanRoomRequest(roomId: roomId),
      );
    }
  }

  Future<AdminBatchOperationResult> batchBanRooms(
    List<String> roomIds, {
    String reason = '',
  }) async {
    final response = await _api.adminService.batchBanRooms(
      admin.BatchBanRoomsRequest(roomIds: roomIds, reason: reason),
    );
    return _batchOperationResult(
        response.results, response.succeeded, response.failed);
  }

  Future<AdminBatchOperationResult> batchDeleteRooms(
    List<String> roomIds,
  ) async {
    final response = await _api.adminService.batchDeleteRooms(
      admin.BatchDeleteRoomsRequest(roomIds: roomIds),
    );
    return _batchOperationResult(
        response.results, response.succeeded, response.failed);
  }

  Future<void> deleteRoom(String roomId) async {
    await _api.adminService.deleteRoom(admin.DeleteRoomRequest(roomId: roomId));
  }

  Future<WRoom> getRoom(String roomId) async {
    final response = await _api.adminService.getRoom(
      admin.GetRoomRequest(roomId: roomId),
    );
    return _api.mapAdminRoom(response.room);
  }

  Future<WRoomSettings> getRoomSettings(String roomId) async {
    final response = await _api.adminService.getRoomSettings(
      admin.GetRoomSettingsRequest(roomId: roomId),
    );
    return WRoomSettings.fromJson(decodeJsonBytes(response.settings));
  }

  Future<void> updateRoomSettings(
    String roomId,
    WRoomSettings settings,
  ) async {
    await _api.adminService.updateRoomSettings(
      admin.UpdateRoomSettingsRequest(
        roomId: roomId,
        settings: _api.encodeJsonBytes(settings.toJson()),
      ),
    );
  }

  Future<void> resetRoomSettings(String roomId) async {
    await _api.adminService.resetRoomSettings(
      admin.ResetRoomSettingsRequest(roomId: roomId),
    );
  }

  Future<void> updateRoomPassword(String roomId, String password) async {
    await _api.adminService.updateRoomPassword(
      admin.UpdateRoomPasswordRequest(roomId: roomId, newPassword: password),
    );
  }

  Future<AdminSettingsGroup> updateSettingInGroup(
    String group,
    String key,
    dynamic value,
  ) async {
    final response = await _api.adminService.updateSettings(
      admin.UpdateSettingsRequest(
        group: group,
        settings: {key: _settingValueToString(value)}.entries,
      ),
    );
    final updated = _settingsGroupFromProto(response.group);
    _settingsCache[updated.name] = Map<String, dynamic>.from(updated.settings);
    return updated;
  }

  Future<String> sendTestEmail(String to) async {
    final response = await _api.adminService.sendTestEmail(
      admin.SendTestEmailRequest(to: to),
    );
    if (!response.success) {
      throw StateError(
          response.message.isEmpty ? '测试邮件发送失败' : response.message);
    }
    return response.message;
  }

  Future<AdminSystemStats> getSystemStats() async {
    final response = await _api.adminService.getSystemStats(
      admin.GetSystemStatsRequest(),
    );
    return AdminSystemStats(
      totalUsers: response.totalUsers,
      activeUsers: response.activeUsers,
      bannedUsers: response.bannedUsers,
      totalRooms: response.totalRooms,
      activeRooms: response.activeRooms,
      bannedRooms: response.bannedRooms,
      totalMedia: response.totalMedia,
      providerInstances: response.providerInstances,
      additionalStats: decodeJsonBytes(response.additionalStats),
    );
  }

  Future<AdminsPage> listAdminsPage({
    int page = 1,
    int pageSize = 20,
    String search = '',
    admin_enum.UserListSortBy sortBy =
        admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.listAdmins(
      admin.ListAdminsRequest(
        page: page,
        pageSize: pageSize,
        search: search,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminsPage(
      admins: response.admins.map(_api.mapAdminUser).toList(),
      total: response.total,
    );
  }

  Future<List<WUser>> listAdmins({String search = ''}) async {
    final page = await listAdminsPage(
      page: 1,
      pageSize: 100,
      search: search,
    );
    return page.admins;
  }

  Future<void> addAdmin(String userId) async {
    await _api.adminService.addAdmin(admin.AddAdminRequest(userId: userId));
  }

  Future<void> removeAdmin(String userId) async {
    await _api.adminService.removeAdmin(
      admin.RemoveAdminRequest(userId: userId),
    );
  }

  Future<AdminRoomMembersPage> listRoomMembersPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String search = '',
    common_enum.RoomMemberRole? role,
    admin_enum.RoomMemberListSortBy sortBy =
        admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.getRoomMembers(
      admin.GetRoomMembersRequest(
        roomId: roomId,
        page: page,
        pageSize: pageSize,
        search: search,
        role: role,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminRoomMembersPage(
      members: response.members.map(roomMemberFromProto).toList(),
      total: response.total,
    );
  }

  Future<void> addRoomMember(
    String roomId,
    String userId, {
    int role = 2,
    bool notify = true,
  }) async {
    await _api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: roomId,
        userId: userId,
        role: roomMemberRoleFromValue(role),
        notify: notify,
      ),
    );
  }

  Future<void> setRoomMemberRole(
    String roomId,
    String userId,
    int role,
  ) async {
    await _api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: roomId,
        userId: userId,
        role: roomMemberRoleFromValue(role),
      ),
    );
  }

  Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int role = 3,
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) async {
    await _api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: roomId,
        userId: userId,
        role: roomMemberRoleFromValue(role),
        addedPermissions: Int64(addedPermissions),
        removedPermissions: Int64(removedPermissions),
        adminAddedPermissions: Int64(adminAddedPermissions),
        adminRemovedPermissions: Int64(adminRemovedPermissions),
      ),
    );
  }

  Future<void> kickRoomMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  }) async {
    await _api.adminService.kickMember(
      admin.KickMemberRequest(
        roomId: roomId,
        userId: userId,
        kickCooldownSeconds: Int64(kickCooldownSeconds),
      ),
    );
  }

  Future<AdminProviderInstancesPage> listProviderInstancesPage({
    int page = 1,
    int pageSize = 50,
    String providerType = '',
    String search = '',
    bool? enabled,
    bool? tls,
    provider_common_enum.ProviderInstanceListSortBy sortBy =
        provider_common_enum
            .ProviderInstanceListSortBy.PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
    provider_common_enum.SortDirection sortDirection =
        provider_common_enum.SortDirection.SORT_DIRECTION_ASC,
  }) async {
    final response = await _api.providerCommon.listProviderInstances(
      provider_common.ListProviderInstancesRequest(
        page: page,
        pageSize: pageSize,
        providerType: providerType,
        search: search,
        enabled: enabled,
        tls: tls,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminProviderInstancesPage(
      instances: response.instances.map(_providerInstanceFromProto).toList(),
      total: response.total,
    );
  }

  Future<List<AdminProviderInstance>> listProviderInstances({
    String providerType = '',
    String search = '',
    bool? enabled,
    bool? tls,
    provider_common_enum.ProviderInstanceListSortBy sortBy =
        provider_common_enum
            .ProviderInstanceListSortBy.PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
    provider_common_enum.SortDirection sortDirection =
        provider_common_enum.SortDirection.SORT_DIRECTION_ASC,
  }) async {
    final page = await listProviderInstancesPage(
      page: 1,
      pageSize: 100,
      providerType: providerType,
      search: search,
      enabled: enabled,
      tls: tls,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
    return page.instances;
  }

  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async {
    final response = await _api.providerCommon.listAvailableProviderInstances(
      provider_common.ListAvailableProviderInstancesRequest(
        providerType: providerType,
      ),
    );
    return response.instances.toList();
  }

  Future<List<String>> listProviderBackends(String providerType) async {
    final response = await _api.providerCommon.listProviderBackends(
      provider_common.ListProviderBackendsRequest(providerType: providerType),
    );
    return response.backends.toList();
  }

  Future<AdminProviderInstance> addProviderInstance({
    required String name,
    required String endpoint,
    required List<String> providers,
    String comment = '',
    int timeoutSeconds = 30,
    bool tls = true,
    bool insecureTls = false,
    String? jwtSecret,
    String? customCa,
  }) async {
    final response = await _api.providerCommon.addProviderInstance(
      provider_common.AddProviderInstanceRequest(
        name: name,
        endpoint: endpoint,
        providers: providers,
        comment: comment,
        timeoutSeconds: timeoutSeconds,
        tls: tls,
        insecureTls: insecureTls,
        jwtSecret: jwtSecret,
        customCa: customCa,
      ),
    );
    return _providerInstanceFromProto(response.instance);
  }

  Future<AdminProviderInstance> updateProviderInstance({
    required String name,
    String? endpoint,
    String? comment,
    int? timeoutSeconds,
    bool? tls,
    bool? insecureTls,
    List<String> providers = const [],
    String? jwtSecret,
    String? customCa,
    bool? clearComment,
    bool? clearJwtSecret,
    bool? clearCustomCa,
  }) async {
    final response = await _api.providerCommon.updateProviderInstance(
      provider_common.UpdateProviderInstanceRequest(
        name: name,
        endpoint: endpoint,
        comment: comment,
        timeoutSeconds: timeoutSeconds,
        tls: tls,
        insecureTls: insecureTls,
        providers: providers,
        jwtSecret: jwtSecret,
        customCa: customCa,
        clearComment_10: clearComment,
        clearJwtSecret_11: clearJwtSecret,
        clearCustomCa_12: clearCustomCa,
      ),
    );
    return _providerInstanceFromProto(response.instance);
  }

  Future<void> deleteProviderInstance(String name) async {
    await _api.providerCommon.deleteProviderInstance(
      provider_common.DeleteProviderInstanceRequest(name: name),
    );
  }

  Future<void> reconnectProviderInstance(String name) async {
    await _api.providerCommon.reconnectProviderInstance(
      provider_common.ReconnectProviderInstanceRequest(name: name),
    );
  }

  Future<void> setProviderInstanceEnabled(String name, bool enabled) async {
    if (enabled) {
      await _api.providerCommon.enableProviderInstance(
        provider_common.EnableProviderInstanceRequest(name: name),
      );
    } else {
      await _api.providerCommon.disableProviderInstance(
        provider_common.DisableProviderInstanceRequest(name: name),
      );
    }
  }

  Future<AdminActiveStreamsPage> listActiveStreamsPage({
    int page = 1,
    int pageSize = 50,
    String roomId = '',
    String userId = '',
    String nodeId = '',
    String search = '',
    admin_enum.ActiveStreamListSortBy sortBy =
        admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.adminService.listActiveStreams(
      admin.ListActiveStreamsRequest(
        page: page,
        pageSize: pageSize,
        roomId: roomId,
        userId: userId,
        nodeId: nodeId,
        search: search,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return AdminActiveStreamsPage(
      streams: response.streams.map(_activeStreamFromProto).toList(),
      total: response.total,
    );
  }

  Future<List<AdminActiveStream>> listActiveStreams({
    int page = 1,
    int pageSize = 50,
    String roomId = '',
    String userId = '',
    String nodeId = '',
    String search = '',
    admin_enum.ActiveStreamListSortBy sortBy =
        admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final pageResult = await listActiveStreamsPage(
      page: page,
      pageSize: pageSize,
      roomId: roomId,
      userId: userId,
      nodeId: nodeId,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
    return pageResult.streams;
  }

  Future<void> kickStream(AdminActiveStream stream) async {
    await _api.adminService.kickStream(
      admin.KickStreamRequest(
        roomId: stream.roomId,
        mediaId: stream.mediaId,
        reason: 'Kicked from Flutter admin',
      ),
    );
  }

  Future<AdminBanRecordsPage> listBanRecordsPage({
    int page = 1,
    int pageSize = 50,
    int targetType = 0,
    bool? active,
    String userId = '',
    String roomId = '',
  }) async {
    final response = await _api.adminService.listBanRecords(
      admin.ListBanRecordsRequest(
        page: page,
        pageSize: pageSize,
        targetType: _banTargetTypeFromValue(targetType),
        active: active,
        userId: userId,
        roomId: roomId,
      ),
    );
    return AdminBanRecordsPage(
      records: response.bans.map(_banRecordFromProto).toList(),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<AdminReviewsPage> listReviewsPage({
    required String kind,
    int page = 1,
    int pageSize = 50,
    int status = 1,
    String search = '',
    String requestedBy = '',
    String roomId = '',
    String userId = '',
  }) async {
    final reviewStatus = _reviewStatusFromValue(status);
    switch (kind) {
      case 'user':
        final response = await _api.adminService.listUserRegistrationReviews(
          admin.ListUserRegistrationReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: reviewStatus,
            search: search,
          ),
        );
        return AdminReviewsPage(
          reviews: response.reviews.map(_userReviewFromProto).toList(),
          total: response.total,
          page: page,
          pageSize: pageSize,
        );
      case 'room':
        final response = await _api.adminService.listRoomCreationReviews(
          admin.ListRoomCreationReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: reviewStatus,
            requestedBy: requestedBy,
            search: search,
          ),
        );
        return AdminReviewsPage(
          reviews: response.reviews.map(_roomCreationReviewFromProto).toList(),
          total: response.total,
          page: page,
          pageSize: pageSize,
        );
      case 'join':
        final response = await _api.adminService.listRoomJoinReviews(
          admin.ListRoomJoinReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: reviewStatus,
            roomId: roomId.isNotEmpty
                ? roomId
                : search.startsWith('room_')
                    ? search
                    : '',
            userId: userId.isNotEmpty
                ? userId
                : search.startsWith('usr_')
                    ? search
                    : '',
          ),
        );
        return AdminReviewsPage(
          reviews: response.reviews.map(_adminRoomJoinReviewFromProto).toList(),
          total: response.total,
          page: page,
          pageSize: pageSize,
        );
      default:
        throw ArgumentError.value(kind, 'kind', '未知审核类型');
    }
  }

  Future<void> approveReview(String kind, String requestId) async {
    switch (kind) {
      case 'user':
        await _api.adminService.approveUserRegistrationReview(
          admin.ApproveUserRegistrationReviewRequest(requestId: requestId),
        );
        return;
      case 'room':
        await _api.adminService.approveRoomCreationReview(
          admin.ApproveRoomCreationReviewRequest(requestId: requestId),
        );
        return;
      case 'join':
        await _api.adminService.approveRoomJoinReview(
          admin.ApproveRoomJoinReviewRequest(requestId: requestId),
        );
        return;
      default:
        throw ArgumentError.value(kind, 'kind', '未知审核类型');
    }
  }

  Future<void> rejectReview(
    String kind,
    String requestId, {
    String reason = '',
  }) async {
    switch (kind) {
      case 'user':
        await _api.adminService.rejectUserRegistrationReview(
          admin.RejectUserRegistrationReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
      case 'room':
        await _api.adminService.rejectRoomCreationReview(
          admin.RejectRoomCreationReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
      case 'join':
        await _api.adminService.rejectRoomJoinReview(
          admin.RejectRoomJoinReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
      default:
        throw ArgumentError.value(kind, 'kind', '未知审核类型');
    }
  }

  AdminBatchOperationResult _batchOperationResult(
    Iterable<admin.BatchResultItem> results,
    int succeeded,
    int failed,
  ) {
    return AdminBatchOperationResult(
      results: results.map(_batchResultFromProto).toList(),
      succeeded: succeeded,
      failed: failed,
    );
  }

  common_enum.ReviewStatus _reviewStatusFromValue(int value) {
    return common_enum.ReviewStatus.valueOf(value) ??
        common_enum.ReviewStatus.REVIEW_STATUS_PENDING;
  }

  admin.BanTargetType _banTargetTypeFromValue(int value) {
    return admin.BanTargetType.valueOf(value) ??
        admin.BanTargetType.BAN_TARGET_TYPE_UNSPECIFIED;
  }

  String _settingValueToString(dynamic value) {
    if (value is bool || value is num || value is String) {
      return value.toString();
    }
    return jsonEncode(value);
  }

  AdminSettingsGroup _settingsGroupFromProto(admin.SettingsGroup group) {
    return AdminSettingsGroup(
      name: group.name,
      settings: decodeJsonBytes(group.settings),
    );
  }

  AdminProviderInstance _providerInstanceFromProto(
    provider_common.ProviderInstance instance,
  ) {
    return AdminProviderInstance(
      name: instance.name,
      endpoint: instance.endpoint,
      comment: instance.comment,
      timeoutSeconds: instance.timeoutSeconds,
      tls: instance.tls,
      insecureTls: instance.insecureTls,
      providers: instance.providers.toList(),
      enabled: instance.enabled,
      status: instance.status.value,
      createdAt: instance.createdAt.toInt(),
      updatedAt: instance.updatedAt.toInt(),
    );
  }

  AdminActiveStream _activeStreamFromProto(admin.ActiveStreamInfo stream) {
    return AdminActiveStream(
      roomId: stream.roomId,
      mediaId: stream.mediaId,
      userId: stream.userId,
      nodeId: stream.nodeId,
      startedAt: stream.startedAt.toInt(),
    );
  }

  AdminBanRecord _banRecordFromProto(admin.BanRecord record) {
    return AdminBanRecord(
      id: record.id,
      targetType: record.targetType.value,
      userId: record.userId,
      username: record.username,
      roomId: record.roomId,
      roomName: record.roomName,
      bannedBy: record.bannedBy,
      bannedByUsername: record.bannedByUsername,
      reason: record.reason,
      startsAt: record.startsAt.toInt(),
      endsAt: record.endsAt.toInt(),
      revokedAt: record.revokedAt.toInt(),
      revokedBy: record.revokedBy,
      isActive: record.isActive,
    );
  }

  AdminBatchResult _batchResultFromProto(admin.BatchResultItem item) {
    return AdminBatchResult(
      id: item.id,
      success: item.success,
      error: item.error,
    );
  }

  AdminReviewItem _userReviewFromProto(admin.UserRegistrationReview review) {
    final details = <String>[
      '注册方式 ${_signupMethodLabel(review.signupMethod)}',
      if (review.email.isNotEmpty) '邮箱 ${review.email}',
      if (review.oauth2Provider.isNotEmpty) 'OAuth2 ${review.oauth2Provider}',
      if (review.oauth2ProviderInstanceName.isNotEmpty)
        '实例 ${review.oauth2ProviderInstanceName}',
      if (review.oauth2ProviderUsername.isNotEmpty)
        'Provider 用户 ${review.oauth2ProviderUsername}',
      if (review.oauth2ProviderUserId.isNotEmpty)
        'Provider ID ${review.oauth2ProviderUserId}',
      if (review.oauth2ProviderIssuer.isNotEmpty)
        'Issuer ${review.oauth2ProviderIssuer}',
      if (review.oauth2AvatarUrl.isNotEmpty) '头像 ${review.oauth2AvatarUrl}',
      if (review.oauth2Provider.isNotEmpty)
        'OAuth2 邮箱${review.oauth2EmailVerified ? '已验证' : '未验证'}',
      if (review.webauthnCredentialName.isNotEmpty)
        'Passkey ${review.webauthnCredentialName}',
      if (review.webauthnCredentialId.isNotEmpty)
        'Credential ${review.webauthnCredentialId}',
    ];
    return AdminReviewItem(
      kind: 'user',
      id: review.id,
      title: review.username,
      subtitle: review.email,
      status: review.status.value,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: review.reviewedAt.toInt(),
      reviewedBy: review.reviewedBy,
      rejectionReason: review.rejectionReason,
      detail: details.join(' · '),
      details: details,
      signupMethod: review.signupMethod,
      oauth2Provider: review.oauth2Provider,
      oauth2ProviderInstanceName: review.oauth2ProviderInstanceName,
      oauth2ProviderIssuer: review.oauth2ProviderIssuer,
      oauth2ProviderUserId: review.oauth2ProviderUserId,
      oauth2ProviderUsername: review.oauth2ProviderUsername,
      oauth2AvatarUrl: review.oauth2AvatarUrl,
      oauth2EmailVerified: review.oauth2EmailVerified,
      webauthnCredentialId: review.webauthnCredentialId,
      webauthnCredentialName: review.webauthnCredentialName,
    );
  }

  AdminReviewItem _roomCreationReviewFromProto(
    admin.RoomCreationReview review,
  ) {
    return AdminReviewItem(
      kind: 'room',
      id: review.id,
      title: review.name,
      subtitle: review.requestedByUsername,
      status: review.status.value,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: review.reviewedAt.toInt(),
      reviewedBy: review.reviewedBy,
      rejectionReason: review.rejectionReason,
      detail: review.description,
      details: [
        if (review.description.isNotEmpty) review.description,
        if (review.requestedBy.isNotEmpty) '申请人 ${review.requestedBy}',
      ],
    );
  }

  AdminReviewItem _adminRoomJoinReviewFromProto(
    admin.RoomJoinReview review,
  ) {
    return AdminReviewItem(
      kind: 'join',
      id: review.id,
      title: review.roomName,
      subtitle: review.username,
      status: review.status.value,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: review.reviewedAt.toInt(),
      reviewedBy: review.reviewedBy,
      rejectionReason: review.rejectionReason,
      detail: '${review.roomId} · ${review.userId}',
      details: [
        '房间 ${review.roomId}',
        '用户 ${review.userId}',
        '申请角色 ${review.requestedRole.value}',
      ],
    );
  }

  String _signupMethodLabel(int method) {
    return switch (method) {
      1 => '邮箱',
      2 => '密码',
      3 => 'OAuth2',
      4 => '管理员创建',
      5 => 'Passkey',
      _ => '未知',
    };
  }
}
