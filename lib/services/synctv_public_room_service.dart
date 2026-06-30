import 'dart:typed_data';

import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_auth_service.dart';
import 'package:synctv_app/services/synctv_memory_cache.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

class SyncTvPublicRoomDomainService {
  SyncTvPublicRoomDomainService({
    required this._api,
    required this._sessionStore,
    required this._authService,
    SyncTvMemoryCache? cache,
    opaque.SyncTvOpaqueClient? opaqueClient,
  }) : _cache = cache ?? SyncTvMemoryCache(),
       _opaqueClient = opaqueClient ?? opaque.SyncTvOpaqueClient();

  final SyncTvApiClient _api;
  final SyncTvSessionStore _sessionStore;
  final SyncTvAuthDomainService _authService;
  final SyncTvMemoryCache _cache;
  final opaque.SyncTvOpaqueClient _opaqueClient;

  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) async {
    return _cache.get<PublicSettingsInfo>(
      'public:settings',
      ttl: const Duration(minutes: 5),
      refresh: refresh,
      loader: _fetchPublicSettings,
    );
  }

  Future<ServerInfo> getServerInfo({bool refresh = false}) async {
    return _cache.get<ServerInfo>(
      'public:server-info',
      ttl: const Duration(minutes: 5),
      refresh: refresh,
      loader: _fetchServerInfo,
    );
  }

  Future<List<RoomCategoryInfo>> listRoomCategories({
    bool includeDisabled = false,
    bool refresh = false,
  }) {
    return _cache.get<List<RoomCategoryInfo>>(
      'public:room-categories:$includeDisabled',
      ttl: const Duration(minutes: 10),
      refresh: refresh,
      loader: () async {
        final response = await _api.publicService.listRoomCategories(
          client.ListRoomCategoriesRequest(includeDisabled: includeDisabled),
        );
        return response.categories
            .map(_api.mapRoomCategory)
            .toList(growable: false);
      },
    );
  }

  Future<List<RoomLabelInfo>> listRoomLabels({
    bool includeDisabled = false,
    String categoryId = '',
    bool refresh = false,
  }) {
    return _cache.get<List<RoomLabelInfo>>(
      'public:room-labels:$includeDisabled:$categoryId',
      ttl: const Duration(minutes: 10),
      refresh: refresh,
      loader: () async {
        final response = await _api.publicService.listRoomLabels(
          client.ListRoomLabelsRequest(
            includeDisabled: includeDisabled,
            categoryId: categoryId,
          ),
        );
        return response.labels.map(_api.mapRoomLabel).toList(growable: false);
      },
    );
  }

  Future<ServerInfo> _fetchServerInfo() async {
    final response = await _api.publicService.getServerInfo(
      client.GetServerInfoRequest(),
    );
    return ServerInfo(
      serverId: response.serverId,
      serverName: response.serverName,
    );
  }

  Future<PublicSettingsInfo> _fetchPublicSettings() async {
    final settings = await _api.publicService.getPublicSettings(
      client.GetPublicSettingsRequest(),
    );
    return PublicSettingsInfo(
      allowRoomCreation: settings.allowRoomCreation,
      maxRoomsPerUser: settings.maxRoomsPerUser.toInt(),
      maxMembersPerRoom: settings.maxMembersPerRoom.toInt(),
      disableCreateRoom: settings.disableCreateRoom,
      createRoomNeedReview: settings.createRoomNeedReview,
      roomPasswordPolicy: settings.roomPasswordPolicy,
      enablePasswordSignup: settings.enablePasswordSignup,
      passwordSignupNeedReview: settings.passwordSignupNeedReview,
      enableEmailSignup: settings.enableEmailSignup,
      enableEmail: settings.enableEmail,
      enableGuest: settings.enableGuest,
      emailSignupNeedReview: settings.emailSignupNeedReview,
      enableWebauthn: settings.enableWebauthn,
      enableWebauthnSignup: settings.enableWebauthnSignup,
      webauthnSignupNeedReview: settings.webauthnSignupNeedReview,
      movieProxy: settings.movieProxy,
      liveProxy: settings.liveProxy,
      emailWhitelistEnabled: settings.emailWhitelistEnabled,
      emailWhitelistDomains: settings.emailWhitelistDomains.toList(
        growable: false,
      ),
      tsDisguisedAsPng: settings.tsDisguisedAsPng,
      customPublishHost: settings.customPublishHost,
    );
  }

  Future<RoomsPage> getRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
    client_enum.RoomListSortBy sortBy =
        client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    final response = await _api.publicService.listRooms(
      client.ListRoomsRequest(
        page: page,
        pageSize: pageSize,
        search: search ?? '',
        categoryId: categoryId,
        labelIds: labelIds,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
    return RoomsPage(
      rooms: response.rooms.map(_api.mapRoom).toList(growable: false),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<RoomsPage> getMyRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
    common_enum.RoomStatus status =
        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
    bool? isBanned,
    client_enum.MyRoomRelation relation =
        client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL,
    client_enum.MyRoomListSortBy sortBy =
        client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    if (_api.session.isGuest) {
      final roomId = _sessionStore.guestRoomId;
      if (roomId == null || roomId.isEmpty) {
        return RoomsPage(
          rooms: const <SyncTvRoom>[],
          total: 0,
          page: page,
          pageSize: pageSize,
        );
      }
      final response = await _api.user.getRoom(
        client.GetRoomRequest(roomId: roomId),
      );
      return RoomsPage(
        rooms: [_api.mapRoom(response.room)],
        total: 1,
        page: page,
        pageSize: pageSize,
      );
    }

    final request = client.ListMyRoomsRequest(
      page: page,
      pageSize: pageSize,
      search: search ?? '',
      status: status,
      relation: relation,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
    if (isBanned != null) request.isBanned = isBanned;
    final response = await _api.user.listMyRooms(request);
    return RoomsPage(
      rooms: response.rooms.map(_api.mapMyRoom).toList(growable: false),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<SyncTvRoom>> getHotRooms({int limit = 20}) async {
    final response = await _api.publicService.getHotRooms(
      client.GetHotRoomsRequest(limit: limit),
    );
    return response.rooms
        .map((item) {
          final room = _api.mapRoom(item.room);
          return room.copyWith(
            viewerCount: item.room.hasPresence()
                ? room.viewerCount
                : item.onlineCount,
            memberCount: item.totalMembers,
          );
        })
        .toList(growable: false);
  }

  Future<RoomCheckInfo> checkRoom(String roomId) async {
    final response = await _api.publicService.checkRoom(
      client.CheckRoomRequest(roomId: roomId),
    );
    return RoomCheckInfo(
      exists: response.exists,
      requiresPassword: response.requiresPassword,
      name: response.name,
      availability: response.availability.value,
    );
  }

  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
  }) async {
    if (_api.session.isGuest) {
      throw AuthException('访客 token 只能访问对应房间，不能创建房间。');
    }
    final request = client.CreateRoomRequest(name: name);
    if (password != null && password.isNotEmpty) {
      request.password = password;
    }
    if (description != null && description.trim().isNotEmpty) {
      request.description = description.trim();
    }
    if (categoryId.isNotEmpty) {
      request.categoryId = categoryId;
    }
    request.labelIds.addAll(labelIds);
    final response = await _api.user.createRoom(request);
    return _api.mapRoom(response.room);
  }

  Future<void> deleteRoom(String roomId) async {
    await _api.room.deleteRoom(roomId, client.DeleteRoomRequest());
  }

  Future<void> joinRoom(String roomId, String password) async {
    if (_api.session.isGuest) {
      if (password.isNotEmpty) {
        throw AuthException('访客 token 不能进入带密码房间，请使用用户账号加入。');
      }
      if (_sessionStore.guestRoomId != roomId) {
        await _authService.createGuestToken(roomId);
      }
      return;
    }
    if (password.isNotEmpty) {
      await _joinRoomWithOpaquePassword(roomId, password);
      return;
    }
    await _api.user.joinRoom(client.JoinRoomRequest(roomId: roomId));
  }

  Future<void> _joinRoomWithOpaquePassword(
    String roomId,
    String password,
  ) async {
    final start = _opaqueClient.startLogin(password);
    final challenge = await _api.user.startRoomPasswordLogin(
      roomId,
      client.StartRoomPasswordLoginRequest(
        roomId: roomId,
        credentialRequest: start.credentialRequest,
      ),
    );
    final finish = _opaqueClient.finishLogin(
      password: password,
      state: start.state,
      credentialResponse: Uint8List.fromList(challenge.credentialResponse),
    );
    await _api.user.finishRoomPasswordLogin(
      roomId,
      client.FinishRoomPasswordLoginRequest(
        sessionId: challenge.sessionId,
        credentialFinalization: finish.credentialFinalization,
      ),
    );
  }

  Future<SyncTvRoom> getRoomInfo(String roomId) async {
    final response = await _api.user.getRoom(
      client.GetRoomRequest(roomId: roomId),
    );
    return _api.mapRoom(response.room);
  }
}
