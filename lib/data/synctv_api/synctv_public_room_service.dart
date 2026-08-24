import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_auth_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

class SyncTvPublicRoomDomainService {
  SyncTvPublicRoomDomainService({
    required this._api,
    required this._authService,
    SyncTvMemoryCache? cache,
    opaque.SyncTvOpaqueClient? opaqueClient,
  }) : _cache = cache ?? SyncTvMemoryCache(),
       _opaqueClient = opaqueClient ?? opaque.SyncTvOpaqueClient();

  final SyncTvApiClient _api;
  final SyncTvAuthDomainService _authService;
  final SyncTvMemoryCache _cache;
  final opaque.SyncTvOpaqueClient _opaqueClient;

  Future<bool> _hasAuthenticatedUserSession() async {
    return switch (_api.session.identity) {
      AnonymousSessionIdentity() || GuestSessionIdentity() => false,
      AccountSessionIdentity(:final accessToken) when accessToken != null =>
        true,
      AccountSessionIdentity(:final refreshToken) when refreshToken != null =>
        _api.refreshAccessTokenIfPossible(),
      AccountSessionIdentity() => false,
    };
  }

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

  Future<client.GetServerTimeResponse> getServerTime({
    int clientSentAtNanos = 0,
  }) {
    return _api.publicService.getServerTime(
      client.GetServerTimeRequest(clientSentAtNanos: Int64(clientSentAtNanos)),
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
      roomCreationEnabled: settings.roomCreationEnabled,
      maxRoomsPerUser: settings.maxRoomsPerUser.toInt(),
      defaultMaxMembers: settings.defaultMaxMembers.toInt(),
      roomCreationApprovalRequired: settings.roomCreationApprovalRequired,
      roomPasswordPolicy: settings.roomPasswordPolicy,
      enablePasswordSignup: settings.enablePasswordSignup,
      passwordSignupNeedReview: settings.passwordSignupNeedReview,
      enableEmailSignup: settings.enableEmailSignup,
      enableEmail: settings.enableEmail,
      enableGuest: settings.enableGuest,
      emailSignupNeedReview: settings.emailSignupNeedReview,
      enableWebauthn: settings.enableWebauthn,
      webauthnRpId: settings.webauthnRpId,
      enableWebauthnSignup: settings.enableWebauthnSignup,
      webauthnSignupNeedReview: settings.webauthnSignupNeedReview,
      emailWhitelistEnabled: settings.emailWhitelistEnabled,
      emailWhitelistDomains: settings.emailWhitelistDomains.toList(
        growable: false,
      ),
      tsDisguisedAsPng: settings.tsDisguisedAsPng,
      rtmpAdvertiseAddress: settings.hasAdvertiseAddress()
          ? settings.advertiseAddress
          : null,
    );
  }

  Future<RoomDiscoveryPage> discoverRooms({
    int page = 1,
    int pageSize = 100,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
  }) async {
    final request = client.DiscoverRoomsRequest(
      page: page,
      pageSize: pageSize,
      search: search ?? '',
      categoryId: categoryId,
      labelIds: labelIds,
    );
    if (await _hasAuthenticatedUserSession()) {
      final response = await _api.user.discoverRooms(request);
      return RoomDiscoveryPage(
        featuredRooms: response.featuredRooms
            .map(_api.mapRoomDiscoveryItem)
            .toList(growable: false),
        rooms: response.rooms
            .map(_api.mapRoomDiscoveryItem)
            .toList(growable: false),
        total: response.total,
        page: page,
        pageSize: pageSize,
      );
    }
    final response = await _api.publicService.discoverRooms(request);
    return RoomDiscoveryPage(
      featuredRooms: response.featuredRooms
          .map(_api.mapRoomDiscoveryItem)
          .toList(growable: false),
      rooms: response.rooms
          .map(_api.mapRoomDiscoveryItem)
          .toList(growable: false),
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
        client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_FREQUENT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    if (_api.session.identity case GuestSessionIdentity(:final roomId)) {
      final response = await _api.user.getRoom(
        client.GetRoomRequest(roomId: roomId),
      );
      return RoomsPage(
        rooms: [
          _api
              .mapRoom(response.room)
              .copyWith(
                joined: true,
                canJoin: false,
                isFavorite: response.favorited,
              ),
        ],
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

  Future<RoomsPage> getFavoriteRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
  }) async {
    if (_api.session.identity is GuestSessionIdentity) {
      return RoomsPage(
        rooms: const <SyncTvRoom>[],
        total: 0,
        page: page,
        pageSize: pageSize,
      );
    }
    final response = await _api.user.listFavoriteRooms(
      client.ListFavoriteRoomsRequest(
        page: page,
        pageSize: pageSize,
        search: search ?? '',
      ),
    );
    return RoomsPage(
      rooms: response.rooms
          .map(
            (room) => _api
                .mapRoom(room)
                .copyWith(joined: true, canJoin: false, isFavorite: true),
          )
          .toList(growable: false),
      total: response.total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<SyncTvRoom> favoriteRoom(String roomId) async {
    final response = await _api.user.favoriteRoom(
      client.FavoriteRoomRequest(roomId: roomId),
    );
    return _api
        .mapRoom(response.room)
        .copyWith(joined: true, canJoin: false, isFavorite: true);
  }

  Future<SyncTvRoom> unfavoriteRoom(String roomId) async {
    final response = await _api.user.unfavoriteRoom(
      client.UnfavoriteRoomRequest(roomId: roomId),
    );
    return _api
        .mapRoom(response.room)
        .copyWith(joined: true, canJoin: false, isFavorite: false);
  }

  Future<SyncTvRoom> getRoomDiscovery(String roomId) async {
    final request = client.GetRoomDiscoveryRequest(roomId: roomId);
    if (await _hasAuthenticatedUserSession()) {
      return _api.mapRoomDiscoveryItem(
        await _api.user.getRoomDiscovery(request),
      );
    }
    return _api.mapRoomDiscoveryItem(
      await _api.publicService.getRoomDiscovery(request),
    );
  }

  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
    bool isPublic = true,
  }) async {
    if (_api.session.identity is GuestSessionIdentity) {
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
    request.isPublic = isPublic;
    final room = await _api.user.createRoom(request);
    return _api
        .mapRoom(room)
        .copyWith(
          joined: true,
          canJoin: false,
          discoveryAccess:
              client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_ENTER,
          myRelation: client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED,
        );
  }

  Future<void> deleteRoom(String roomId) async {
    await _api.room.deleteRoom(roomId, client.DeleteRoomRequest());
  }

  Future<JoinRoomResult> joinRoom(String roomId, String password) async {
    if (_api.session.identity case GuestSessionIdentity(
      roomId: final guestRoomId,
    )) {
      if (password.isNotEmpty) {
        throw AuthException('访客 token 不能进入带密码房间，请使用用户账号加入。');
      }
      if (guestRoomId != roomId) {
        await _authService.createGuestToken(roomId);
      }
      return const RoomJoined();
    }
    if (password.isNotEmpty) {
      return _joinRoomWithOpaquePassword(roomId, password);
    }
    final response = await _api.user.joinRoom(
      client.JoinRoomRequest(roomId: roomId),
    );
    return response.requiresApproval
        ? const RoomJoinReviewPending()
        : const RoomJoined();
  }

  Future<JoinRoomResult> _joinRoomWithOpaquePassword(
    String roomId,
    String password,
  ) async {
    final start = await _opaqueClient.startLogin(password);
    final challenge = await _api.user.startRoomPasswordLogin(
      roomId,
      client.StartRoomPasswordLoginRequest(
        roomId: roomId,
        credentialRequest: start.credentialRequest,
      ),
    );
    late final opaque.OpaqueLoginFinish finish;
    try {
      finish = await _opaqueClient.finishLogin(
        password: password,
        state: start.state,
        credentialResponse: Uint8List.fromList(challenge.credentialResponse),
      );
    } on opaque.OpaqueOperationException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RoomPasswordRejectedException(error),
        stackTrace,
      );
    }
    final response = await _api.user.finishRoomPasswordLogin(
      roomId,
      client.FinishRoomPasswordLoginRequest(
        sessionId: challenge.sessionId,
        credentialFinalization: finish.credentialFinalization,
      ),
    );
    return response.requiresApproval
        ? const RoomJoinReviewPending()
        : const RoomJoined();
  }

  Future<SyncTvRoom> getRoomInfo(String roomId) async {
    final response = await _api.user.getRoom(
      client.GetRoomRequest(roomId: roomId),
    );
    return _api
        .mapRoom(response.room)
        .copyWith(joined: true, canJoin: false, isFavorite: response.favorited);
  }
}
