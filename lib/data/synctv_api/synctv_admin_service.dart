import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart'
    as field_mask;
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_account_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_management_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;

class SyncTvAdminDomainService {
  SyncTvAdminDomainService(this._api, {SyncTvMemoryCache? cache})
    : _cache = cache ?? SyncTvMemoryCache();

  final SyncTvApiClient _api;
  final SyncTvMemoryCache _cache;

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
    common_enum.UserRole role, {
    String email = '',
    common_enum.UserStatus status = common_enum.UserStatus.USER_STATUS_ACTIVE,
  }) async {
    await _api.adminService.createUser(
      admin.CreateUserRequest(
        username: username,
        password: password,
        email: email,
        role: role,
        status: status,
      ),
    );
  }

  Future<void> deleteUser(String userId) async {
    await _api.adminService.deleteUser(admin.DeleteUserRequest(userId: userId));
  }

  Future<SyncTvUser> getUser(String userId) async {
    final response = await _api.adminService.getUser(
      admin.GetUserRequest(userId: userId),
    );
    return _api.mapAdminUser(response);
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
    await _api.adminService.setUserPassword(
      admin.SetUserPasswordRequest(
        userId: userId,
        password: password,
        reason: reason,
      ),
    );
  }

  Future<RuntimeSettingsModel> getSettings({bool refresh = false}) async {
    return _cache.get<RuntimeSettingsModel>(
      'admin:settings',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: _fetchSettings,
    );
  }

  Future<RuntimeSettingsModel> _fetchSettings() async {
    final response = await _api.adminService.getSettings(
      admin.GetSettingsRequest(),
    );
    return _settingsModelFromProto(response);
  }

  Future<void> banUser(String userId, bool ban, {String reason = ''}) async {
    if (ban) {
      await _api.adminService.banUser(
        admin.BanUserRequest(userId: userId, reason: reason),
      );
    } else {
      await _api.adminService.unbanUser(admin.UnbanUserRequest(userId: userId));
    }
  }

  Future<void> moderateRoomChatUser(
    String roomId,
    String userId, {
    required bool deleteAllMessages,
    required bool deleteAllReactions,
    required bool ban,
    String messageId = '',
    String reason = '',
  }) async {
    await _api.adminService.moderateRoomChatUser(
      admin.ModerateRoomChatUserRequest(
        roomId: roomId,
        userId: userId,
        deleteAllMessages: deleteAllMessages,
        deleteAllReactions: deleteAllReactions,
        banUser: ban,
        messageId: messageId,
        reason: reason,
      ),
    );
  }

  Future<AdminBatchOperationResult> batchBanUsers(
    List<String> userIds, {
    String reason = '',
  }) async {
    final response = await _api.adminService.batchBanUsers(
      admin.BatchBanUsersRequest(userIds: userIds, reason: reason),
    );
    return _batchOperationResult(
      response.results,
      response.succeeded,
      response.failed,
    );
  }

  Future<AdminBatchOperationResult> batchDeleteUsers(
    List<String> userIds,
  ) async {
    final response = await _api.adminService.batchDeleteUsers(
      admin.BatchDeleteUsersRequest(userIds: userIds),
    );
    return _batchOperationResult(
      response.results,
      response.succeeded,
      response.failed,
    );
  }

  Future<AdminRoomsPage> listRoomsPage({
    int page = 1,
    int pageSize = 20,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
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
        categoryId: categoryId,
        labelIds: labelIds,
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

  Future<void> banRoom(String roomId, bool ban, {String reason = ''}) async {
    if (ban) {
      await _api.adminService.banRoom(
        admin.BanRoomRequest(roomId: roomId, reason: reason),
      );
    } else {
      await _api.adminService.unbanRoom(admin.UnbanRoomRequest(roomId: roomId));
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
      response.results,
      response.succeeded,
      response.failed,
    );
  }

  Future<AdminBatchOperationResult> batchDeleteRooms(
    List<String> roomIds,
  ) async {
    final response = await _api.adminService.batchDeleteRooms(
      admin.BatchDeleteRoomsRequest(roomIds: roomIds),
    );
    return _batchOperationResult(
      response.results,
      response.succeeded,
      response.failed,
    );
  }

  Future<void> deleteRoom(String roomId) async {
    await _api.adminService.deleteRoom(admin.DeleteRoomRequest(roomId: roomId));
  }

  Future<SyncTvRoom> getRoom(String roomId) async {
    final response = await _api.adminService.getRoom(
      admin.GetRoomRequest(roomId: roomId),
    );
    return _api.mapAdminRoom(response);
  }

  Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  }) async {
    return _cache.get<SyncTvRoomSettings>(
      'admin:room:$roomId:settings',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: () => _fetchRoomSettings(roomId),
    );
  }

  Future<SyncTvRoomSettings> _fetchRoomSettings(String roomId) async {
    final response = await _api.adminService.getRoomSettings(
      admin.GetRoomSettingsRequest(roomId: roomId),
    );
    return SyncTvRoomSettings.fromJson(roomSettingsToJson(response.settings));
  }

  Future<void> updateRoomSettings(
    String roomId,
    SyncTvRoomSettings settings,
  ) async {
    final update = roomSettingsUpdateRequestFromJson(settings.toJson());
    await _api.adminService.updateRoomSettings(
      admin.UpdateRoomSettingsRequest(
        roomId: roomId,
        settings: update.settings,
        updateMask: update.updateMask,
      ),
    );
    _cache.put(
      'admin:room:$roomId:settings',
      settings,
      ttl: const Duration(minutes: 2),
    );
  }

  Future<void> resetRoomSettings(String roomId) async {
    await _api.adminService.resetRoomSettings(
      admin.ResetRoomSettingsRequest(roomId: roomId),
    );
    _cache.invalidate('admin:room:$roomId:settings');
  }

  Future<void> updateRoomPassword(String roomId, String password) async {
    await _api.adminService.updateRoomPassword(
      admin.UpdateRoomPasswordRequest(roomId: roomId, newPassword: password),
    );
  }

  Future<List<RoomCategoryInfo>> listRoomCategories({
    bool includeDisabled = false,
    bool refresh = false,
  }) {
    return _cache.get<List<RoomCategoryInfo>>(
      'admin:room-categories:$includeDisabled',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: () async {
        final response = await _api.adminService.listRoomCategories(
          admin.ListRoomCategoriesRequest(includeDisabled: includeDisabled),
        );
        return response.categories
            .map(_api.mapRoomCategory)
            .toList(growable: false);
      },
    );
  }

  Future<RoomCategoryInfo> upsertRoomCategory({
    required String key,
    required String name,
    String description = '',
    int sortOrder = 0,
    bool? isEnabled,
  }) async {
    final response = await _api.adminService.upsertRoomCategory(
      admin.UpsertRoomCategoryRequest(
        key: key,
        name: name,
        description: description,
        sortOrder: sortOrder,
        isEnabled: isEnabled,
      ),
    );
    _cache.invalidatePrefix('admin:room-categories');
    _cache.invalidatePrefix('public:room-categories');
    return _api.mapRoomCategory(response);
  }

  Future<void> deleteRoomCategory(String categoryId) async {
    await _api.adminService.deleteRoomCategory(
      admin.DeleteRoomCategoryRequest(categoryId: categoryId),
    );
    _cache.invalidatePrefix('admin:room-categories');
    _cache.invalidatePrefix('public:room-categories');
  }

  Future<List<RoomLabelInfo>> listRoomLabels({
    bool includeDisabled = false,
    String categoryId = '',
    bool refresh = false,
  }) {
    return _cache.get<List<RoomLabelInfo>>(
      'admin:room-labels:$includeDisabled:$categoryId',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: () async {
        final response = await _api.adminService.listRoomLabels(
          admin.ListRoomLabelsRequest(
            includeDisabled: includeDisabled,
            categoryId: categoryId,
          ),
        );
        return response.labels.map(_api.mapRoomLabel).toList(growable: false);
      },
    );
  }

  Future<RoomLabelInfo> upsertRoomLabel({
    required String key,
    required String name,
    String description = '',
    String color = '',
    String categoryId = '',
    int sortOrder = 0,
    bool? isEnabled,
  }) async {
    final response = await _api.adminService.upsertRoomLabel(
      admin.UpsertRoomLabelRequest(
        key: key,
        name: name,
        description: description,
        color: color,
        categoryId: categoryId,
        sortOrder: sortOrder,
        isEnabled: isEnabled,
      ),
    );
    _cache.invalidatePrefix('admin:room-labels');
    _cache.invalidatePrefix('public:room-labels');
    return _api.mapRoomLabel(response);
  }

  Future<void> deleteRoomLabel(String labelId) async {
    await _api.adminService.deleteRoomLabel(
      admin.DeleteRoomLabelRequest(labelId: labelId),
    );
    _cache.invalidatePrefix('admin:room-labels');
    _cache.invalidatePrefix('public:room-labels');
  }

  Future<SyncTvRoom> updateRoomTaxonomy(
    String roomId, {
    String? categoryId,
    List<String> labelIds = const [],
    bool clearCategory = false,
  }) async {
    final response = await _api.adminService.updateRoomTaxonomy(
      admin.UpdateRoomTaxonomyRequest(
        roomId: roomId,
        categoryId: categoryId,
        labelIds: labelIds,
        clearCategory: clearCategory,
      ),
    );
    return _api.mapAdminRoom(response);
  }

  Future<RuntimeSettingsSection> updateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    final response = await _api.adminService.updateSettings(
      _settingsUpdateRequest(section, key, value),
    );
    final updatedModel = _settingsModelFromProto(response);
    _cache.put('admin:settings', updatedModel, ttl: const Duration(minutes: 2));
    final updated =
        updatedModel.section(section) ??
        RuntimeSettingsSection(name: section, settings: const {});
    if (section == 'server' ||
        section == 'user' ||
        section == 'roomDefaults' ||
        section == 'roomCreation' ||
        section == 'rtmp' ||
        section == 'email') {
      _cache.invalidate('public:settings');
    }
    return updated;
  }

  Future<String> sendTestEmail(String to) async {
    final response = await _api.adminService.sendTestEmail(
      admin.SendTestEmailRequest(to: to),
    );
    if (!response.success) {
      throw StateError(
        response.message.isEmpty ? '测试邮件发送失败' : response.message,
      );
    }
    return response.message;
  }

  Future<AdminServiceState> getServiceState() async {
    final response = await _api.adminService.getServiceState(
      admin.GetServiceStateRequest(),
    );
    return AdminServiceState(
      totalUsers: response.totalUsers.toInt(),
      activeUsers: response.activeUsers.toInt(),
      bannedUsers: response.bannedUsers.toInt(),
      totalRooms: response.totalRooms.toInt(),
      activeRooms: response.activeRooms.toInt(),
      bannedRooms: response.bannedRooms.toInt(),
      totalMedia: response.totalMedia.toInt(),
      providerInstances: response.providerInstances.toInt(),
      onlineMembers: response.hasPresence()
          ? response.presence.onlineMemberCount
          : 0,
      onlineGuests: response.hasPresence()
          ? response.presence.onlineGuestCount
          : 0,
      onlineConnections: response.hasPresence()
          ? response.presence.connectionCount
          : 0,
      activePresenceRooms: response.hasPresence()
          ? response.presence.activeRoomCount
          : 0,
      activeStreams: response.hasAdditionalState()
          ? response.additionalState.activeStreams.toInt()
          : 0,
      openReports: response.hasAdditionalState()
          ? response.additionalState.openReports.toInt()
          : 0,
    );
  }

  Future<AdminSliceCacheStats> getSliceCacheStats({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    final response = await _api.adminService.getSliceCacheStats(
      admin.GetSliceCacheStatsRequest(nodeId: nodeId, allNodes: allNodes),
    );
    return AdminSliceCacheStats(
      nodes: response.nodes.map(_sliceCacheStatsFromProto).toList(),
      failures: response.failures.map(_sliceCacheFailureFromProto).toList(),
    );
  }

  Future<AdminSliceCacheOperationResult> purgeSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    final response = await _api.adminService.purgeSliceCache(
      admin.PurgeSliceCacheRequest(nodeId: nodeId, allNodes: allNodes),
    );
    return AdminSliceCacheOperationResult(
      success: response.success,
      removedEntries: response.removedEntries.toInt(),
      freedBytes: response.freedBytes.toInt(),
      stats: response.hasStats()
          ? _sliceCacheStatsFromProto(response.stats)
          : null,
      nodes: response.nodes
          .map(
            (node) => AdminSliceCacheOperationNode(
              nodeId: node.nodeId,
              success: node.success,
              removedEntries: node.removedEntries.toInt(),
              freedBytes: node.freedBytes.toInt(),
              stats: node.hasStats()
                  ? _sliceCacheStatsFromProto(node.stats)
                  : null,
            ),
          )
          .toList(),
      failures: response.failures.map(_sliceCacheFailureFromProto).toList(),
    );
  }

  Future<AdminSliceCacheOperationResult> evictExpiredSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) async {
    final response = await _api.adminService.evictExpiredSliceCache(
      admin.EvictExpiredSliceCacheRequest(nodeId: nodeId, allNodes: allNodes),
    );
    return AdminSliceCacheOperationResult(
      success: response.success,
      removedEntries: response.removedExpiredEntries.toInt(),
      freedBytes: 0,
      stats: response.hasStats()
          ? _sliceCacheStatsFromProto(response.stats)
          : null,
      nodes: response.nodes
          .map(
            (node) => AdminSliceCacheOperationNode(
              nodeId: node.nodeId,
              success: node.success,
              removedEntries: node.removedExpiredEntries.toInt(),
              freedBytes: 0,
              stats: node.hasStats()
                  ? _sliceCacheStatsFromProto(node.stats)
                  : null,
            ),
          )
          .toList(),
      failures: response.failures.map(_sliceCacheFailureFromProto).toList(),
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

  Future<List<SyncTvUser>> listAdmins({String search = ''}) async {
    final page = await listAdminsPage(page: 1, pageSize: 100, search: search);
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
      onlineMemberCount: response.hasPresence()
          ? response.presence.onlineMemberCount
          : 0,
      connectionCount: response.hasPresence()
          ? response.presence.connectionCount
          : 0,
    );
  }

  Future<void> addRoomMember(
    String roomId,
    String userId, {
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
    bool notify = true,
  }) async {
    await _api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: roomId,
        userId: userId,
        role: role,
        notify: notify,
      ),
    );
  }

  Future<void> updateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  ) async {
    await _api.adminService.updateMemberRemarkName(
      admin.UpdateMemberRemarkNameRequest(
        roomId: roomId,
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
    await _api.adminService.updateMemberDisplayTag(
      admin.UpdateMemberDisplayTagRequest(
        roomId: roomId,
        userId: userId,
        displayTag: displayTag,
      ),
    );
  }

  Future<void> setRoomMemberRole(
    String roomId,
    String userId,
    common_enum.RoomMemberRole role,
  ) async {
    await _api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: roomId,
        userId: userId,
        role: role,
      ),
    );
  }

  Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) async {
    await _api.adminService.updateMemberPermissions(
      admin.UpdateMemberPermissionsRequest(
        roomId: roomId,
        userId: userId,
        role: role,
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
            .ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
    provider_common_enum.SortDirection sortDirection =
        provider_common_enum.SortDirection.SORT_DIRECTION_ASC,
  }) async {
    final response = await _api.providerCommon.listProviderInstances(
      provider_common.ListProviderInstancesRequest(
        page: page,
        pageSize: pageSize,
        providerType: SourceConfigCodec.providerFromString(providerType),
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
            .ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
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
        providerType: SourceConfigCodec.providerFromString(providerType),
      ),
    );
    return response.instances.toList();
  }

  Future<List<String>> listProviderBackends(String providerType) async {
    final response = await _api.providerCommon.listProviderBackends(
      provider_common.ListProviderBackendsRequest(
        providerType: SourceConfigCodec.providerFromString(providerType),
      ),
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
        providers: SourceConfigCodec.providersFromStrings(providers),
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
        providers: SourceConfigCodec.providersFromStrings(providers),
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
    admin.BanTargetType targetType =
        admin.BanTargetType.BAN_TARGET_TYPE_UNSPECIFIED,
    bool? active,
    String userId = '',
    String roomId = '',
  }) async {
    final response = await _api.adminService.listBanRecords(
      admin.ListBanRecordsRequest(
        page: page,
        pageSize: pageSize,
        targetType: targetType,
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

  Future<AdminContentReportsPage> listContentReportsPage({
    int page = 1,
    int pageSize = 50,
    admin.ContentReportStatus status =
        admin.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
    admin.ContentReportTargetType targetType =
        admin.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    String reporterUserId = '',
    String roomId = '',
    String targetRoomId = '',
    String targetUserId = '',
    String targetMemberRoomId = '',
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
    admin.ContentReportScope scope =
        admin.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED,
    String search = '',
  }) async {
    final response = await _api.adminService.listContentReports(
      admin.ListContentReportsRequest(
        page: page,
        pageSize: pageSize,
        status: status,
        targetType: targetType,
        reporterUserId: reporterUserId,
        roomId: roomId,
        targetRoomId: targetRoomId,
        targetUserId: targetUserId,
        targetMemberRoomId: targetMemberRoomId,
        targetMemberUserId: targetMemberUserId,
        targetChatMessageId: Int64(targetChatMessageId),
        scope: scope,
        search: search,
      ),
    );
    return AdminContentReportsPage(
      reports: response.reports.map(_contentReportFromProto).toList(),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<AdminContentReport> getContentReport(String reportId) async {
    final response = await _api.adminService.getContentReport(
      admin.GetContentReportRequest(reportId: reportId),
    );
    return _contentReportFromProto(response);
  }

  Future<AdminContentReport> updateContentReportStatus(
    String reportId,
    admin.ContentReportStatus status, {
    String resolutionNote = '',
  }) async {
    final response = await _api.adminService.updateContentReportStatus(
      admin.UpdateContentReportStatusRequest(
        reportId: reportId,
        status: _requiredContentReportStatus(status),
        resolutionNote: resolutionNote,
      ),
    );
    return _contentReportFromProto(response.report);
  }

  Future<AdminContentReportsPage> listRoomContentReportsPage(
    String roomId, {
    int page = 1,
    int pageSize = 50,
    admin.ContentReportStatus status =
        admin.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
    admin.ContentReportTargetType targetType =
        admin.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
    String search = '',
  }) async {
    final response = await _api.room.listRoomContentReports(
      roomId,
      client.ListRoomContentReportsRequest(
        page: page,
        pageSize: pageSize,
        status: _clientContentReportStatus(status),
        targetType: _clientContentReportTargetType(targetType),
        targetMemberUserId: targetMemberUserId,
        targetChatMessageId: Int64(targetChatMessageId),
        search: search,
      ),
    );
    return AdminContentReportsPage(
      reports: response.reports.map(_clientContentReportFromProto).toList(),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<AdminContentReport> getRoomContentReport(
    String roomId,
    String reportId,
  ) async {
    final response = await _api.room.getRoomContentReport(
      roomId,
      client.GetRoomContentReportRequest(reportId: reportId),
    );
    return _clientContentReportFromProto(response);
  }

  Future<AdminContentReport> updateRoomContentReportStatus(
    String roomId,
    String reportId,
    admin.ContentReportStatus status, {
    String resolutionNote = '',
  }) async {
    final response = await _api.room.updateRoomContentReportStatus(
      roomId,
      client.UpdateRoomContentReportStatusRequest(
        reportId: reportId,
        status: _clientContentReportStatus(
          _requiredContentReportStatus(status),
        ),
        resolutionNote: resolutionNote,
      ),
    );
    return _clientContentReportFromProto(response.report);
  }

  Future<AdminReviewsPage> listReviewsPage({
    required AdminReviewKind kind,
    int page = 1,
    int pageSize = 50,
    common_enum.ReviewStatus status =
        common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
    String search = '',
    String requestedBy = '',
    String roomId = '',
    String userId = '',
  }) async {
    switch (kind) {
      case AdminReviewKind.userRegistration:
        final response = await _api.adminService.listUserRegistrationReviews(
          admin.ListUserRegistrationReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: status,
            search: search,
          ),
        );
        return AdminReviewsPage(
          reviews: response.reviews.map(_userReviewFromProto).toList(),
          total: response.total,
          page: page,
          pageSize: pageSize,
        );
      case AdminReviewKind.roomCreation:
        final response = await _api.adminService.listRoomCreationReviews(
          admin.ListRoomCreationReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: status,
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
      case AdminReviewKind.roomJoin:
        final response = await _api.adminService.listRoomJoinReviews(
          admin.ListRoomJoinReviewsRequest(
            page: page,
            pageSize: pageSize,
            status: status,
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
    }
  }

  Future<void> approveReview(AdminReviewKind kind, String requestId) async {
    switch (kind) {
      case AdminReviewKind.userRegistration:
        await _api.adminService.approveUserRegistrationReview(
          admin.ApproveUserRegistrationReviewRequest(requestId: requestId),
        );
        return;
      case AdminReviewKind.roomCreation:
        await _api.adminService.approveRoomCreationReview(
          admin.ApproveRoomCreationReviewRequest(requestId: requestId),
        );
        return;
      case AdminReviewKind.roomJoin:
        await _api.adminService.approveRoomJoinReview(
          admin.ApproveRoomJoinReviewRequest(requestId: requestId),
        );
        return;
    }
  }

  Future<void> rejectReview(
    AdminReviewKind kind,
    String requestId, {
    String reason = '',
  }) async {
    switch (kind) {
      case AdminReviewKind.userRegistration:
        await _api.adminService.rejectUserRegistrationReview(
          admin.RejectUserRegistrationReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
      case AdminReviewKind.roomCreation:
        await _api.adminService.rejectRoomCreationReview(
          admin.RejectRoomCreationReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
      case AdminReviewKind.roomJoin:
        await _api.adminService.rejectRoomJoinReview(
          admin.RejectRoomJoinReviewRequest(
            requestId: requestId,
            reason: reason,
          ),
        );
        return;
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

  admin.ContentReportStatus _requiredContentReportStatus(
    admin.ContentReportStatus status,
  ) {
    if (status == admin.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED) {
      throw ArgumentError.value(status, 'status', '请选择举报处置状态');
    }
    return status;
  }

  client.ContentReportStatus _clientContentReportStatus(
    admin.ContentReportStatus status,
  ) {
    return client.ContentReportStatus.valueOf(status.value) ??
        client.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED;
  }

  client.ContentReportTargetType _clientContentReportTargetType(
    admin.ContentReportTargetType targetType,
  ) {
    return client.ContentReportTargetType.valueOf(targetType.value) ??
        client.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED;
  }

  admin.UpdateSettingsRequest _settingsUpdateRequest(
    String sectionName,
    String key,
    dynamic value,
  ) {
    final settings = admin.RuntimeSettingsPatch();

    T patchSection<T extends pb.GeneratedMessage>(
      T message,
      Map<String, dynamic> data,
    ) {
      message.mergeFromProto3Json(
        data,
        supportNamesWithUnderscores: false,
        permissiveEnums: true,
      );
      return message;
    }

    T optionalPatchSection<T extends pb.GeneratedMessage>(T message) {
      return value == null ? message : patchSection(message, {key: value});
    }

    switch (sectionName) {
      case 'server':
        settings.server = optionalPatchSection(admin.ServerSettingsPatch());
        break;
      case 'roomDefaults':
        settings.roomDefaults = optionalPatchSection(
          admin.RoomDefaultsSettingsPatch(),
        );
        break;
      case 'permissions':
        settings.permissions = optionalPatchSection(
          admin.PermissionSettingsPatch(),
        );
        break;
      case 'roomCreation':
        settings.roomCreation = optionalPatchSection(
          admin.RoomCreationSettingsPatch(),
        );
        break;
      case 'user':
        settings.user = optionalPatchSection(admin.UserSettingsPatch());
        break;
      case 'oauth2':
        if (key != 'providers' && key != 'allowedRedirectUrls') {
          throw ArgumentError.value(key, 'key', 'unsupported oauth2 setting');
        }
        settings.oauth2 = optionalPatchSection(admin.OAuth2SettingsPatch());
        break;
      case 'rtmp':
        settings.rtmp = optionalPatchSection(admin.RtmpSettingsPatch());
        break;
      case 'email':
        settings.email = optionalPatchSection(admin.EmailSettingsPatch());
        break;
      case 'webrtc':
        if (key != 'externalIceServers' &&
            key != 'maxVoiceParticipantsPerRoom') {
          throw ArgumentError.value(key, 'key', 'unsupported webrtc setting');
        }
        settings.webrtc = optionalPatchSection(admin.WebRTCSettingsPatch());
        break;
      case 'chat':
        settings.chat = optionalPatchSection(admin.ChatSettingsPatch());
        break;
      case 'playbackHistory':
        settings.playbackHistory = optionalPatchSection(
          admin.PlaybackHistorySettingsPatch(),
        );
        break;
      case 'cors':
        if (key != 'allowedOrigins') {
          throw ArgumentError.value(key, 'key', 'unsupported cors setting');
        }
        settings.cors = optionalPatchSection(admin.CorsSettingsPatch());
        break;
      default:
        throw ArgumentError.value(sectionName, 'sectionName');
    }

    return admin.UpdateSettingsRequest(
      settings: settings,
      updateMask: field_mask.FieldMask(
        paths: ['${_protoFieldName(sectionName)}.${_protoFieldName(key)}'],
      ),
    );
  }

  String _protoFieldName(String value) {
    return value.replaceAllMapped(
      RegExp('[A-Z]'),
      (match) => '_${match[0]!.toLowerCase()}',
    );
  }

  RuntimeSettingsModel _settingsModelFromProto(admin.RuntimeSettings settings) {
    const names = [
      'server',
      'roomDefaults',
      'permissions',
      'roomCreation',
      'user',
      'oauth2',
      'rtmp',
      'email',
      'webrtc',
      'chat',
      'playbackHistory',
      'cors',
    ];
    return RuntimeSettingsModel(
      sections: [
        for (final name in names)
          RuntimeSettingsSection(
            name: name,
            settings: runtimeSettingsSectionToJson(settings, name),
          ),
      ],
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
      providers: SourceConfigCodec.providersToStrings(instance.providers),
      enabled: instance.enabled,
      status: instance.status,
      createdAt: instance.createdAt.toInt(),
      updatedAt: instance.updatedAt.toInt(),
    );
  }

  AdminSliceCacheNodeStats _sliceCacheStatsFromProto(
    admin.SliceCacheStatsNode stats,
  ) {
    final config = stats.config;
    return AdminSliceCacheNodeStats(
      nodeId: stats.nodeId,
      config: AdminSliceCacheConfig(
        engineEnabled: config.engineEnabled,
        backend: config.backend,
        fileCacheDir: config.fileCacheDir,
        sliceSize: config.sliceSize.toInt(),
        maxCacheSize: config.maxCacheSize.toInt(),
        segmentTtlSeconds: config.segmentTtlSecs.toInt(),
        staleMaxAgeSeconds: config.staleMaxAgeSecs.toInt(),
        staleWhileRevalidate: config.staleWhileRevalidate,
        evictionIntervalSeconds: config.evictionIntervalSecs.toInt(),
        watermarkRatio: config.watermarkRatio,
      ),
      currentSizeBytes: stats.currentSizeBytes.toInt(),
      entryCount: stats.entryCount.toInt(),
      metadataEntries: stats.metadataEntries.toInt(),
      updatingEntries: stats.updatingEntries.toInt(),
      lockCount: stats.lockCount.toInt(),
      usageRatio: stats.usageRatio,
    );
  }

  AdminSliceCacheFailure _sliceCacheFailureFromProto(
    admin.SliceCacheNodeFailure failure,
  ) {
    return AdminSliceCacheFailure(nodeId: failure.nodeId, error: failure.error);
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
      targetType: record.targetType,
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

  AdminContentReport _contentReportFromProto(admin.ContentReport report) {
    return AdminContentReport(
      id: report.id,
      reporterUserId: report.reporterUserId,
      reporterUsername: report.reporterUsername,
      roomId: report.roomId,
      roomName: report.roomName,
      targetType: report.targetType,
      targetRoomId: report.targetRoomId,
      targetRoomName: report.targetRoomName,
      targetUserId: report.targetUserId,
      targetUsername: report.targetUsername,
      targetMemberRoomId: report.targetMemberRoomId,
      targetMemberRoomName: report.targetMemberRoomName,
      targetMemberUserId: report.targetMemberUserId,
      targetMemberUsername: report.targetMemberUsername,
      targetChatMessageId: report.targetChatMessageId.toInt(),
      targetChatMessageCreatedAt: report.targetChatMessageCreatedAt.toInt(),
      targetChatMessagePreview: report.targetChatMessagePreview,
      reasonCode: report.reasonCode,
      reason: report.reason,
      metadata: protoMessageToJsonMap(report.metadata),
      status: report.status,
      reviewedBy: report.reviewedBy,
      reviewedByUsername: report.reviewedByUsername,
      reviewedAt: report.reviewedAt.toInt(),
      resolutionNote: report.resolutionNote,
      createdAt: report.createdAt.toInt(),
      updatedAt: report.updatedAt.toInt(),
    );
  }

  AdminContentReport _clientContentReportFromProto(
    client.ContentReport report,
  ) {
    return AdminContentReport(
      id: report.id,
      reporterUserId: report.reporterUserId,
      reporterUsername: report.reporterUsername,
      roomId: report.roomId,
      roomName: report.roomName,
      targetType:
          admin.ContentReportTargetType.valueOf(report.targetType.value) ??
          admin.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
      targetRoomId: report.targetRoomId,
      targetRoomName: report.targetRoomName,
      targetUserId: report.targetUserId,
      targetUsername: report.targetUsername,
      targetMemberRoomId: report.targetMemberRoomId,
      targetMemberRoomName: report.targetMemberRoomName,
      targetMemberUserId: report.targetMemberUserId,
      targetMemberUsername: report.targetMemberUsername,
      targetChatMessageId: report.targetChatMessageId.toInt(),
      targetChatMessageCreatedAt: report.targetChatMessageCreatedAt.toInt(),
      targetChatMessagePreview: report.targetChatMessagePreview,
      reasonCode: report.reasonCode,
      reason: report.reason,
      metadata: protoMessageToJsonMap(report.metadata),
      status:
          admin.ContentReportStatus.valueOf(report.status.value) ??
          admin.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
      reviewedBy: report.reviewedBy,
      reviewedByUsername: report.reviewedByUsername,
      reviewedAt: report.reviewedAt.toInt(),
      resolutionNote: report.resolutionNote,
      createdAt: report.createdAt.toInt(),
      updatedAt: report.updatedAt.toInt(),
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
      if (oauth2ProviderTypeToString(review.oauth2Provider).isNotEmpty)
        'OAuth2 ${oauth2ProviderTypeToString(review.oauth2Provider)}',
      if (review.oauth2ProviderInstanceName.isNotEmpty)
        '实例 ${review.oauth2ProviderInstanceName}',
      if (review.oauth2ProviderUsername.isNotEmpty)
        'Provider 用户 ${review.oauth2ProviderUsername}',
      if (review.oauth2ProviderUserId.isNotEmpty)
        'Provider ID ${review.oauth2ProviderUserId}',
      if (review.oauth2ProviderIssuer.isNotEmpty)
        'Issuer ${review.oauth2ProviderIssuer}',
      if (review.oauth2AvatarUrl.isNotEmpty) '头像 ${review.oauth2AvatarUrl}',
      if (review.webauthnCredentialName.isNotEmpty)
        'Passkey ${review.webauthnCredentialName}',
      if (review.webauthnCredentialId.isNotEmpty)
        'Credential ${review.webauthnCredentialId}',
    ];
    return AdminUserRegistrationReview(
      id: review.id,
      title: review.username,
      subtitle: review.email,
      status: review.status,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: _optionalTimestamp(review.reviewedAt.toInt()),
      reviewedBy: _optionalText(review.reviewedBy),
      rejectionReason: _optionalText(review.rejectionReason),
      detail: details.join(' · '),
      details: details,
      signupMethod: review.signupMethod,
      oauth2Provider: _optionalText(
        oauth2ProviderTypeToString(review.oauth2Provider),
      ),
      oauth2ProviderInstanceName: _optionalText(
        review.oauth2ProviderInstanceName,
      ),
      oauth2ProviderIssuer: _optionalText(review.oauth2ProviderIssuer),
      oauth2ProviderUserId: _optionalText(review.oauth2ProviderUserId),
      oauth2ProviderUsername: _optionalText(review.oauth2ProviderUsername),
      oauth2AvatarUrl: _optionalText(review.oauth2AvatarUrl),
      webauthnCredentialId: _optionalText(review.webauthnCredentialId),
      webauthnCredentialName: _optionalText(review.webauthnCredentialName),
    );
  }

  AdminReviewItem _roomCreationReviewFromProto(
    admin.RoomCreationReview review,
  ) {
    return AdminRoomCreationReview(
      id: review.id,
      title: review.name,
      subtitle: review.requestedByUsername,
      status: review.status,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: _optionalTimestamp(review.reviewedAt.toInt()),
      reviewedBy: _optionalText(review.reviewedBy),
      rejectionReason: _optionalText(review.rejectionReason),
      detail: review.description,
      details: [
        if (review.description.isNotEmpty) review.description,
        if (review.requestedBy.isNotEmpty) '申请人 ${review.requestedBy}',
      ],
    );
  }

  AdminReviewItem _adminRoomJoinReviewFromProto(admin.RoomJoinReview review) {
    return AdminRoomJoinReview(
      id: review.id,
      title: review.roomName,
      subtitle: review.username,
      status: review.status,
      requestedAt: review.requestedAt.toInt(),
      reviewedAt: _optionalTimestamp(review.reviewedAt.toInt()),
      reviewedBy: _optionalText(review.reviewedBy),
      rejectionReason: _optionalText(review.rejectionReason),
      requestedRole: review.requestedRole,
      detail: '${review.roomId} · ${review.userId}',
      details: [
        '房间 ${review.roomId}',
        '用户 ${review.userId}',
        '申请角色 ${review.requestedRole.value}',
      ],
    );
  }

  String _signupMethodLabel(admin.SignupMethod method) {
    return switch (method) {
      admin.SignupMethod.SIGNUP_METHOD_EMAIL => '邮箱',
      admin.SignupMethod.SIGNUP_METHOD_PASSWORD => '密码',
      admin.SignupMethod.SIGNUP_METHOD_OAUTH2 => 'OAuth2',
      admin.SignupMethod.SIGNUP_METHOD_ADMIN_CREATED => '管理员创建',
      admin.SignupMethod.SIGNUP_METHOD_WEBAUTHN => 'Passkey',
      _ => '未知',
    };
  }

  String? _optionalText(String value) => value.isEmpty ? null : value;

  int? _optionalTimestamp(int value) => value == 0 ? null : value;
}
