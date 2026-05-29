import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_auth_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class SyncTvPublicRoomDomainService {
  SyncTvPublicRoomDomainService({
    required SyncTvApiClient api,
    required SyncTvSessionStore sessionStore,
    required SyncTvAuthDomainService authService,
  })  : _api = api,
        _sessionStore = sessionStore,
        _authService = authService;

  final SyncTvApiClient _api;
  final SyncTvSessionStore _sessionStore;
  final SyncTvAuthDomainService _authService;

  Future<PublicSettingsInfo> getPublicSettings() async {
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
      emailWhitelistDomains:
          settings.emailWhitelistDomains.toList(growable: false),
      tsDisguisedAsPng: settings.tsDisguisedAsPng,
      customPublishHost: settings.customPublishHost,
    );
  }

  Future<RoomsPage> getRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
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
          rooms: const <WRoom>[],
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

  Future<List<WRoom>> getHotRooms({int limit = 20}) async {
    final response = await _api.publicService.getHotRooms(
      client.GetHotRoomsRequest(limit: limit),
    );
    return response.rooms.map((item) {
      final room = _api.mapRoom(item.room);
      return room.copyWith(
        viewerCount: item.onlineCount,
        memberCount: item.totalMembers,
      );
    }).toList(growable: false);
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

  Future<WRoom> createRoom(
    String name, {
    String? password,
    String? description,
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
    await _api.user.joinRoom(client.JoinRoomRequest(
      roomId: roomId,
      password: password,
    ));
  }

  Future<WRoom> getRoomInfo(String roomId) async {
    final response = await _api.user.getRoom(
      client.GetRoomRequest(roomId: roomId),
    );
    return _api.mapRoom(response.room);
  }
}
