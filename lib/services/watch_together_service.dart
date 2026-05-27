import 'dart:typed_data';

import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/admin_models.dart';
import 'package:synctv_app/models/provider_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/oauth2_callback_parser.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_domain_services.dart';
import 'package:synctv_app/services/synctv_runtime_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;

export 'package:synctv_app/models/admin_models.dart';
export 'package:synctv_app/models/provider_models.dart';
export 'package:synctv_app/models/room_media_models.dart';

class WatchTogetherService {
  static String get baseUrl => _runtime.baseUrl;
  static List<SyncTvServerProfile> get servers => _runtime.servers;
  static SyncTvServerProfile? get activeServer => _runtime.activeServer;
  static String resolveResourceUrl(String url) =>
      _runtime.resolveResourceUrl(url);
  static String? get guestRoomId => _runtime.guestRoomId;
  static bool get isGuestSession => _runtime.isGuestSession;

  static final SyncTvRuntimeService _runtime = SyncTvRuntimeService();
  static SyncTvApiClient get _api => _runtime.api;
  static SyncTvDomainServices _domains = _createDomains();

  static Stream<void> get onAuthError => _runtime.onAuthError;

  static Future<void> init() async {
    await _runtime.init();
    _domains = _createDomains();
  }

  static SyncTvDomainServices _createDomains() {
    return SyncTvDomainServices(
      api: _api,
      sessionStore: _runtime.sessionStore,
    );
  }

  static Future<void> setBaseUrl(String url) async {
    await _runtime.setBaseUrl(url);
  }

  static Future<SyncTvServerProfile> addServer(String url) async {
    return _runtime.addServer(url);
  }

  static Future<void> activateServer(String serverId) async {
    await _runtime.activateServer(serverId);
  }

  static Future<void> activateServerEndpoint(
    String serverId,
    String endpoint,
  ) async {
    await _runtime.activateServerEndpoint(serverId, endpoint);
  }

  static Future<void> removeServer(String serverId) async {
    await _runtime.removeServer(serverId);
  }

  static Future<String?> getToken() => _runtime.getToken();

  static Future<void> logout() async {
    await _runtime.logout();
  }

  static Future<void> closeAccount() async {
    await _runtime.closeAccount();
  }

  static Future<AuthResult> confirmEmailLoginResult(
      String email, String token) async {
    return _domains.auth.confirmEmailLoginResult(email, token);
  }

  static Future<void> requestEmailLogin(String email) async {
    await _domains.auth.requestEmailLogin(email);
  }

  static Future<OpaqueRegistrationStart> startOpaqueRegistration({
    required String username,
    required String email,
    required List<int> registrationRequest,
  }) async {
    return _domains.auth.startOpaqueRegistration(
      username: username,
      email: email,
      registrationRequest: registrationRequest,
    );
  }

  static Future<AuthResult> finishOpaqueRegistration({
    required String sessionId,
    required List<int> registrationUpload,
  }) async {
    return _domains.auth.finishOpaqueRegistration(
      sessionId: sessionId,
      registrationUpload: registrationUpload,
    );
  }

  static Future<OpaqueLoginStart> startOpaqueLogin({
    String username = '',
    String email = '',
    required List<int> credentialRequest,
  }) async {
    return _domains.auth.startOpaqueLogin(
      username: username,
      email: email,
      credentialRequest: credentialRequest,
    );
  }

  static Future<AuthResult> finishOpaqueLogin({
    required String sessionId,
    required List<int> credentialFinalization,
  }) async {
    return _domains.auth.finishOpaqueLogin(
      sessionId: sessionId,
      credentialFinalization: credentialFinalization,
    );
  }

  static Future<PasskeyChallengeStart> startPasskeyRegistration({
    required String username,
    String email = '',
    String name = '',
  }) async {
    return _domains.auth.startPasskeyRegistration(
      username: username,
      email: email,
      name: name,
    );
  }

  static Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  }) async {
    return _domains.auth.finishPasskeyRegistration(
      sessionId: sessionId,
      credential: credential,
    );
  }

  static Future<PasskeyChallengeStart> startPasskeyLogin({
    String username = '',
    String email = '',
  }) async {
    return _domains.auth.startPasskeyLogin(
      username: username,
      email: email,
    );
  }

  static Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  }) async {
    return _domains.auth.finishPasskeyLogin(
      sessionId: sessionId,
      credential: credential,
    );
  }

  static Future<String> requestMfaEmailCode(String mfaSessionId) async {
    return _domains.auth.requestMfaEmailCode(mfaSessionId);
  }

  static Future<AuthResult> verifyMfaEmailCode({
    required String mfaSessionId,
    required String emailToken,
  }) async {
    return _domains.auth.verifyMfaEmailCode(
      mfaSessionId: mfaSessionId,
      emailToken: emailToken,
    );
  }

  static Future<MfaPasskeyChallengeStart> startMfaPasskey(
    String mfaSessionId,
  ) async {
    return _domains.auth.startMfaPasskey(mfaSessionId);
  }

  static Future<AuthResult> finishMfaPasskey({
    required String mfaSessionId,
    required String passkeySessionId,
    required Object credential,
  }) async {
    return _domains.auth.finishMfaPasskey(
      mfaSessionId: mfaSessionId,
      passkeySessionId: passkeySessionId,
      credential: credential,
    );
  }

  static Future<void> sendVerificationEmail(String email) async {
    await _domains.auth.sendVerificationEmail(email);
  }

  static Future<WUser> confirmEmail({
    required String email,
    required String token,
  }) async {
    return _domains.auth.confirmEmail(email: email, token: token);
  }

  static Future<PublicSettingsInfo> getPublicSettings() async {
    return _domains.publicRooms.getPublicSettings();
  }

  static Future<WUser> createGuestToken(String roomId) async {
    return _domains.auth.createGuestToken(roomId);
  }

  static Future<List<OAuth2ProviderOption>> listOAuth2Providers() async {
    return _domains.auth.listOAuth2Providers();
  }

  static Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String redirectUrl = '',
  }) async {
    return _domains.auth.startOAuth2Login(
      provider,
      redirectUrl: redirectUrl,
    );
  }

  static OAuth2CallbackPayload parseOAuth2Callback(
    Uri uri, {
    String expectedState = '',
  }) =>
      OAuth2CallbackParser.parse(uri, expectedState: expectedState);

  static Future<AuthResult> finishOAuth2Login({
    required String provider,
    required String code,
    required String state,
  }) async {
    return _domains.auth.finishOAuth2Login(
      provider: provider,
      code: code,
      state: state,
    );
  }

  static Stream<client.ServerMessage> connectRoomMessageStream(
    String roomId,
    Stream<client.ClientMessage> messages, {
    Duration? timeout,
  }) {
    return _runtime.connectRoomMessageStream(
      roomId,
      messages,
      timeout: timeout,
    );
  }

  static Stream<RoomRealtimeMessage> connectRoomRealtimeStream(
    String roomId,
    Stream<List<int>> outgoing, {
    Duration? timeout,
  }) {
    final messages = outgoing
        .where((bytes) => bytes.isNotEmpty)
        .map(client.ClientMessage.fromBuffer);
    return connectRoomMessageStream(
      roomId,
      messages,
      timeout: timeout,
    ).map((message) {
      return RoomRealtimeCodec.decode(Uint8List.fromList(
        message.writeToBuffer(),
      ));
    });
  }

  static Future<WUser> getMe() async {
    return _domains.account.getMe();
  }

  static Future<WUser> updateUsername(String username) async {
    return _domains.account.updateUsername(username);
  }

  static Future<AccountPreferences> getAccountPreferences() async {
    return _domains.account.getAccountPreferences();
  }

  static Future<AccountPreferences> updateAccountPreferences({
    bool? twoFactorEnabled,
    NotificationPreferences? notifications,
  }) async {
    return _domains.account.updateAccountPreferences(
      twoFactorEnabled: twoFactorEnabled,
      notifications: notifications,
    );
  }

  static Future<UserNotificationsPage> listNotifications({
    int page = 1,
    int pageSize = 20,
    bool? isRead,
    client_enum.NotificationType? notificationType,
    String search = '',
    client_enum.NotificationListSortBy sortBy =
        client_enum.NotificationListSortBy.NOTIFICATION_LIST_SORT_BY_CREATED_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    return _domains.notifications.listNotifications(
      page: page,
      pageSize: pageSize,
      isRead: isRead,
      notificationType: notificationType,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<void> markNotificationAsRead(UserNotificationItem item) async {
    await _domains.notifications.markNotificationAsRead(item);
  }

  static Future<UserNotificationItem> getNotification(
      int notificationId) async {
    return _domains.notifications.getNotification(notificationId);
  }

  static Future<void> markNotificationsAsRead(List<int> notificationIds) async {
    await _domains.notifications.markNotificationsAsRead(notificationIds);
  }

  static Future<void> markAllNotificationsAsRead() async {
    await _domains.notifications.markAllNotificationsAsRead();
  }

  static Future<void> deleteNotification(UserNotificationItem item) async {
    await _domains.notifications.deleteNotification(item);
  }

  static Future<void> deleteAllReadNotifications() async {
    await _domains.notifications.deleteAllReadNotifications();
  }

  static Future<List<PasskeyCredentialInfo>> listPasskeys() async {
    return _domains.account.listPasskeys();
  }

  static Future<void> deletePasskey(String credentialId) async {
    await _domains.account.deletePasskey(credentialId);
  }

  static Future<OpaquePasswordUpdateStart> startOpaquePasswordUpdate({
    List<int> credentialRequest = const [],
    required List<int> registrationRequest,
    required int verificationMethod,
    String emailToken = '',
  }) async {
    return _domains.account.startOpaquePasswordUpdate(
      credentialRequest: credentialRequest,
      registrationRequest: registrationRequest,
      verificationMethod: verificationMethod,
      emailToken: emailToken,
    );
  }

  static Future<WUser> finishOpaquePasswordUpdate({
    required String sessionId,
    List<int> credentialFinalization = const [],
    required List<int> registrationUpload,
    String passkeySessionId = '',
    Object? passkeyCredential,
  }) async {
    return _domains.account.finishOpaquePasswordUpdate(
      sessionId: sessionId,
      credentialFinalization: credentialFinalization,
      registrationUpload: registrationUpload,
      passkeySessionId: passkeySessionId,
      passkeyCredential: passkeyCredential,
    );
  }

  static Future<PasskeyChallengeStart> startPasskeyBind({
    String name = '',
  }) async {
    return _domains.account.startPasskeyBind(name: name);
  }

  static Future<PasskeyCredentialInfo> finishPasskeyBind({
    required String sessionId,
    required Object credential,
  }) async {
    return _domains.account.finishPasskeyBind(
      sessionId: sessionId,
      credential: credential,
    );
  }

  static Future<String> requestPasswordReset(String email) async {
    return _domains.auth.requestPasswordReset(email);
  }

  static Future<OpaquePasswordResetStart> startOpaquePasswordReset({
    required String email,
    required String token,
    required List<int> registrationRequest,
  }) async {
    return _domains.auth.startOpaquePasswordReset(
      email: email,
      token: token,
      registrationRequest: registrationRequest,
    );
  }

  static Future<String> finishOpaquePasswordReset({
    required String sessionId,
    required List<int> registrationUpload,
  }) async {
    return _domains.auth.finishOpaquePasswordReset(
      sessionId: sessionId,
      registrationUpload: registrationUpload,
    );
  }

  static Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async {
    return _domains.auth.getLinkedOAuth2Accounts();
  }

  static Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String redirectUrl = '',
  }) async {
    return _domains.auth.startOAuth2Bind(
      provider,
      redirectUrl: redirectUrl,
    );
  }

  static Future<void> finishOAuth2Bind({
    required String provider,
    required String code,
    required String state,
  }) async {
    await _domains.auth.finishOAuth2Bind(
      provider: provider,
      code: code,
      state: state,
    );
  }

  static Future<void> unlinkOAuth2Account(OAuth2LinkedAccount account) async {
    await _domains.auth.unlinkOAuth2Account(account);
  }

  static Future<RoomsPage> getRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
    client_enum.RoomListSortBy sortBy =
        client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) async {
    return _domains.publicRooms.getRoomsPage(
      page: page,
      pageSize: pageSize,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<RoomsPage> getMyRoomsPage({
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
    return _domains.publicRooms.getMyRoomsPage(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      isBanned: isBanned,
      relation: relation,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<List<WRoom>> getHotRooms({int limit = 20}) async {
    return _domains.publicRooms.getHotRooms(limit: limit);
  }

  static Future<RoomCheckInfo> checkRoom(String roomId) async {
    return _domains.publicRooms.checkRoom(roomId);
  }

  static Future<WRoom> createRoom(String name, {String? password}) async {
    return _domains.publicRooms.createRoom(name, password: password);
  }

  static Future<void> deleteRoom(String roomId) async {
    await _domains.publicRooms.deleteRoom(roomId);
  }

  static Future<void> joinRoom(String roomId, String password) async {
    await _domains.publicRooms.joinRoom(roomId, password);
  }

  static Future<WRoom> getRoomInfo(String roomId) async {
    return _domains.publicRooms.getRoomInfo(roomId);
  }

  static Future<List<WUser>> getRoomMembers(String roomId) async {
    return _domains.roomManagement.getRoomMembers(roomId);
  }

  static Future<RoomMembersPage> getRoomMemberDetailsPage(
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
    return _domains.roomManagement.getRoomMemberDetailsPage(
      roomId,
      page: page,
      pageSize: pageSize,
      search: search,
      role: role,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<WPlaybackStatus> getCurrentMovie(String roomId) async {
    return _domains.roomMedia.getCurrentMovie(roomId);
  }

  static Stream<RoomResourceWatchEvent<WPlaybackStatus>> watchPlaybackState(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomMedia.watchPlaybackState(roomId, version: version);
  }

  static Stream<RoomResourceWatchEvent<WPlaybackStatus>> watchPlaybackSnapshot(
    String roomId, {
    String version = '',
    String mediaId = '',
    String playlistId = '',
    String? target,
  }) {
    return _domains.roomMedia.watchPlaybackSnapshot(
      roomId,
      version: version,
      mediaId: mediaId,
      playlistId: playlistId,
      target: target,
    );
  }

  static Stream<RoomResourceWatchEvent<WRoomSettings>> watchRoomSettings(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomManagement.watchRoomSettings(roomId, version: version);
  }

  static Stream<RoomResourceWatchEvent<RoomMediaLibraryPage>>
      watchPlaylistItems(
    String roomId, {
    String version = '',
    String playlistId = '',
    String? target,
    int page = 1,
    int pageSize = 100,
    String search = '',
    String sourceProvider = '',
    String providerInstanceName = '',
    client_enum.MediaListSortBy sortBy =
        client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
  }) {
    return _domains.roomMedia.watchPlaylistItems(
      roomId,
      version: version,
      playlistId: playlistId,
      target: target,
      page: page,
      pageSize: pageSize,
      search: search,
      sourceProvider: sourceProvider,
      providerInstanceName: providerInstanceName,
      sortBy: sortBy,
      sortDirection: sortDirection,
      availability: availability,
    );
  }

  static Stream<RoomResourceWatchEvent<List<AdminRoomMember>>> watchRoomMembers(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomManagement.watchRoomMembers(roomId, version: version);
  }

  static Stream<RoomResourceWatchEvent<List<WUser>>> watchRoomUsers(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomManagement.watchRoomUsers(roomId, version: version);
  }

  static Future<RoomMediaLibraryPage> listMediaLibrary(
    String roomId, {
    int page = 1,
    int pageSize = 50,
    String playlistId = '',
    String? target,
    String search = '',
    String sourceProvider = '',
    String providerInstanceName = '',
    client_enum.MediaListSortBy sortBy =
        client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
    bool refresh = false,
  }) async {
    return _domains.roomMedia.listMediaLibrary(
      roomId,
      playlistId: playlistId,
      target: target,
      page: page,
      pageSize: pageSize,
      search: search,
      sourceProvider: sourceProvider,
      providerInstanceName: providerInstanceName,
      sortBy: sortBy,
      sortDirection: sortDirection,
      availability: availability,
      refresh: refresh,
    );
  }

  static Future<PlaylistDetailInfo> getPlaylist(
    String roomId,
    String playlistId,
  ) async {
    return _domains.roomMedia.getPlaylist(roomId, playlistId);
  }

  static Future<RoomPlaylistsPage> listPlaylistsPage(
    String roomId, {
    String parentId = '',
    int page = 1,
    int pageSize = 100,
    String? search,
    String sourceProvider = '',
    String providerInstanceName = '',
    bool? dynamicOnly,
    client_enum.PlaylistListSortBy sortBy =
        client_enum.PlaylistListSortBy.PLAYLIST_LIST_SORT_BY_POSITION,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
    client_enum.ResourceAvailabilityFilter availability =
        client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL,
  }) async {
    return _domains.roomMedia.listPlaylistsPage(
      roomId,
      parentId: parentId,
      page: page,
      pageSize: pageSize,
      search: search,
      sourceProvider: sourceProvider,
      providerInstanceName: providerInstanceName,
      dynamicOnly: dynamicOnly,
      sortBy: sortBy,
      sortDirection: sortDirection,
      availability: availability,
    );
  }

  static Future<WMovie> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String sourceProvider = '',
    Map<String, dynamic> sourceConfig = const {},
    String providerInstanceName = '',
  }) async {
    return _domains.roomMedia.createPlaylist(
      roomId,
      name: name,
      parentId: parentId,
      sourceProvider: sourceProvider,
      sourceConfig: sourceConfig,
      providerInstanceName: providerInstanceName,
    );
  }

  static Future<WMovie> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
  }) async {
    return _domains.roomMedia.updatePlaylist(
      roomId,
      playlistId,
      name: name,
    );
  }

  static Future<WMovie> movePlaylist(
    String roomId,
    String playlistId, {
    String? beforePlaylistId,
    String? afterPlaylistId,
  }) async {
    return _domains.roomMedia.movePlaylist(
      roomId,
      playlistId,
      beforePlaylistId: beforePlaylistId,
      afterPlaylistId: afterPlaylistId,
    );
  }

  static Future<void> deletePlaylist(
    String roomId,
    String playlistId, {
    bool force = false,
  }) async {
    await _domains.roomMedia.deletePlaylist(roomId, playlistId, force: force);
  }

  static Future<WMovie> editMedia(
    String roomId,
    String mediaId, {
    required String name,
  }) async {
    return _domains.roomMedia.editMedia(roomId, mediaId, name: name);
  }

  static Future<WMovie> getMedia(String roomId, String mediaId) async {
    return _domains.roomMedia.getMedia(roomId, mediaId);
  }

  static Future<int> moveMedia(
    String roomId, {
    List<String> mediaIds = const [],
    String? sourcePlaylistId,
    String? targetPlaylistId,
    bool allFromScope = false,
    String? beforeMediaId,
    String? afterMediaId,
  }) async {
    return _domains.roomMedia.moveMedia(
      roomId,
      mediaIds: mediaIds,
      sourcePlaylistId: sourcePlaylistId,
      targetPlaylistId: targetPlaylistId,
      allFromScope: allFromScope,
      beforeMediaId: beforeMediaId,
      afterMediaId: afterMediaId,
    );
  }

  static Future<List<IceServerInfo>> getIceServers(String roomId) async {
    return _domains.roomManagement.getIceServers(roomId);
  }

  static Future<ChatHistoryPage> getChatHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
  }) async {
    return _domains.roomMedia.getChatHistory(
      roomId,
      limit: limit,
      cursor: cursor,
    );
  }

  static Future<String> addDirectUrlMedia(
    String roomId, {
    String playlistId = '',
    required String url,
    Map<String, String> headers = const {},
    String name = '',
  }) {
    return _domains.roomMedia.addDirectUrlMedia(
      roomId,
      playlistId: playlistId,
      url: url,
      headers: headers,
      name: name,
    );
  }

  static Future<String> addBilibiliMedia(
    String roomId, {
    String playlistId = '',
    String providerInstanceName = '',
    required Map<String, dynamic> sourceConfig,
    String name = '',
  }) {
    return _domains.roomMedia.addBilibiliMedia(
      roomId,
      playlistId: playlistId,
      providerInstanceName: providerInstanceName,
      sourceConfig: sourceConfig,
      name: name,
    );
  }

  static Future<String> addAlistMedia(
    String roomId, {
    String playlistId = '',
    required String serverId,
    required String path,
    String password = '',
    String name = '',
    String providerInstanceName = '',
  }) {
    return _domains.roomMedia.addAlistMedia(
      roomId,
      playlistId: playlistId,
      serverId: serverId,
      path: path,
      password: password,
      providerInstanceName: providerInstanceName,
      name: name,
    );
  }

  static Future<String> addEmbyMedia(
    String roomId, {
    String playlistId = '',
    required String serverId,
    required String itemId,
    String name = '',
    String providerInstanceName = '',
  }) {
    return _domains.roomMedia.addEmbyMedia(
      roomId,
      playlistId: playlistId,
      serverId: serverId,
      itemId: itemId,
      providerInstanceName: providerInstanceName,
      name: name,
    );
  }

  static Future<String> addRtmpMedia(
    String roomId, {
    String playlistId = '',
    String name = '',
  }) {
    return _domains.roomMedia.addRtmpMedia(
      roomId,
      playlistId: playlistId,
      name: name,
    );
  }

  static Future<RtmpPublishKeyInfo> createRtmpPublishKeyInfo(
    String roomId,
    String mediaId,
  ) async {
    return _domains.roomMedia.createRtmpPublishKeyInfo(roomId, mediaId);
  }

  static Future<RoomStreamEntryInfo> getRtmpStreamInfo({
    required String roomId,
    required String mediaId,
  }) async {
    return _domains.roomMedia.getRtmpStreamInfo(
      roomId: roomId,
      mediaId: mediaId,
    );
  }

  static Future<void> addMediaBatch(
    String roomId,
    List<Map<String, dynamic>> items,
  ) {
    return _domains.roomMedia.addMediaBatch(roomId, items);
  }

  static Future<void> deleteMovie(String roomId, String movieId) async {
    await _domains.roomMedia.deleteMovie(roomId, movieId);
  }

  static Future<void> deleteMediaLibraryEntries(
    String roomId, {
    List<String> mediaIds = const [],
    List<String> playlistIds = const [],
  }) async {
    await _domains.roomMedia.deleteMediaLibraryEntries(
      roomId,
      mediaIds: mediaIds,
      playlistIds: playlistIds,
    );
  }

  static Future<void> clearMovies(String roomId, {String? parentId}) async {
    await _domains.roomMedia.clearMovies(roomId, parentId: parentId);
  }

  static Future<void> switchMovie(
    String roomId,
    String movieId, {
    String? subPath,
    String? playlistId,
  }) async {
    await _domains.roomMedia.switchMovie(
      roomId,
      movieId,
      subPath: subPath,
      playlistId: playlistId,
    );
  }

  static Future<void> updatePlayback(
    String roomId, {
    PlaybackControlAction? action,
    required bool isPlaying,
    double? position,
    double speed = 1.0,
    int? version,
  }) async {
    await _domains.roomMedia.updatePlayback(
      roomId,
      action: action,
      isPlaying: isPlaying,
      position: position,
      speed: speed,
      version: version,
    );
  }

  static Future<AlistLoginInfo> loginAList(
    String host,
    String username,
    String password, {
    String hashedPassword = '',
    String otpCode = '',
    String otpSecret = '',
    String instanceName = '',
  }) async {
    return _domains.providers.loginAList(
      host,
      username,
      password,
      hashedPassword: hashedPassword,
      otpCode: otpCode,
      otpSecret: otpSecret,
      instanceName: instanceName,
    );
  }

  static Future<void> logoutAList(
    String serverId, {
    String instanceName = '',
  }) {
    return _domains.providers.logoutAList(
      serverId,
      instanceName: instanceName,
    );
  }

  static Future<void> logoutEmby(
    String serverId, {
    String instanceName = '',
  }) {
    return _domains.providers.logoutEmby(
      serverId,
      instanceName: instanceName,
    );
  }

  static Future<void> logoutBilibili({String instanceName = ''}) async {
    await _domains.providers.logoutBilibili(instanceName: instanceName);
  }

  static Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    return _domains.providers.getBilibiliAccount(instanceName: instanceName);
  }

  static Future<BilibiliQrLoginInfo> startBilibiliQrLogin({
    String instanceName = '',
  }) async {
    return _domains.providers.startBilibiliQrLogin(instanceName: instanceName);
  }

  static Future<bilibili_enum.QRLoginStatus> checkBilibiliQrLogin(
    String key, {
    String instanceName = '',
  }) async {
    return _domains.providers.checkBilibiliQrLogin(
      key,
      instanceName: instanceName,
    );
  }

  static Future<BilibiliSmsLoginInfo> startBilibiliSmsLogin({
    String instanceName = '',
  }) async {
    return _domains.providers.startBilibiliSmsLogin(
      instanceName: instanceName,
    );
  }

  static Future<int> sendBilibiliSms({
    required String sessionId,
    required String phone,
    required String validate,
  }) async {
    return _domains.providers.sendBilibiliSms(
      sessionId: sessionId,
      phone: phone,
      validate: validate,
    );
  }

  static Future<void> loginBilibiliSms({
    required String sessionId,
    required String code,
  }) async {
    await _domains.providers.loginBilibiliSms(
      sessionId: sessionId,
      code: code,
    );
  }

  static Future<List<AlistBindInfo>> getAlistBindInfos({
    String instanceName = '',
  }) async {
    return _domains.providers.getAlistBindInfos(instanceName: instanceName);
  }

  static Future<List<AlistBindInfo>> getAllAlistBindInfos() async {
    return _domains.providers.getAllAlistBindInfos();
  }

  static Future<List<EmbyBindInfo>> getEmbyBindInfos({
    String instanceName = '',
  }) async {
    return _domains.providers.getEmbyBindInfos(instanceName: instanceName);
  }

  static Future<List<EmbyBindInfo>> getAllEmbyBindInfos() async {
    return _domains.providers.getAllEmbyBindInfos();
  }

  static Future<List<BilibiliBindInfo>> getBilibiliBindInfos({
    String instanceName = '',
  }) async {
    return _domains.providers.getBilibiliBindInfos(instanceName: instanceName);
  }

  static Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async {
    return _domains.providers.getAllBilibiliBindInfos();
  }

  static Future<AlistAccountInfo> getAlistAccount(
    String serverId, {
    String instanceName = '',
  }) async {
    return _domains.providers.getAlistAccount(
      serverId,
      instanceName: instanceName,
    );
  }

  static Future<EmbyAccountInfo> getEmbyAccount(
    String serverId, {
    String instanceName = '',
  }) async {
    return _domains.providers.getEmbyAccount(
      serverId,
      instanceName: instanceName,
    );
  }

  static Future<BilibiliParseInfo> parseBilibiliInfo(
    String url, {
    String instanceName = '',
  }) async {
    return _domains.providers.parseBilibiliInfo(
      url,
      instanceName: instanceName,
    );
  }

  static Future<AlistListPage> listAlistPage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    String password = '',
    String serverId = '',
    String instanceName = '',
  }) async {
    return _domains.providers.listAlistPage(
      path,
      keyword: keyword,
      page: page,
      max: max,
      password: password,
      serverId: serverId,
      instanceName: instanceName,
    );
  }

  static Future<EmbyLoginInfo> loginEmbyInfo(
    String host,
    String username,
    String password, {
    String apiKey = '',
    String instanceName = '',
  }) async {
    return _domains.providers.loginEmbyInfo(
      host,
      username,
      password,
      apiKey: apiKey,
      instanceName: instanceName,
    );
  }

  static Future<EmbyListPage> listEmbyPage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    String serverId = '',
    String instanceName = '',
  }) async {
    return _domains.providers.listEmbyPage(
      path,
      keyword: keyword,
      page: page,
      max: max,
      serverId: serverId,
      instanceName: instanceName,
    );
  }

  static Future<void> updateRoomPassword(String roomId, String? password) {
    return _domains.roomManagement.updateRoomPassword(roomId, password);
  }

  static Future<WRoomSettings> getRoomSettings(String roomId) async {
    return _domains.roomManagement.getRoomSettings(roomId);
  }

  static Future<void> updateRoomSettings(
    String roomId,
    WRoomSettings settings,
  ) async {
    await _domains.roomManagement.updateRoomSettings(roomId, settings);
  }

  static Future<void> kickMember(String roomId, String userId) {
    return _domains.roomManagement.kickMember(roomId, userId);
  }

  static Future<RoomStreamsPage> listRoomStreamsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String? search,
    client_enum.RoomStreamListSortBy sortBy =
        client_enum.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_ASC,
  }) async {
    return _domains.roomManagement.listRoomStreamsPage(
      roomId,
      page: page,
      pageSize: pageSize,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<RoomStreamEntryInfo> getRoomStreamInfo(
    String roomId,
    String mediaId,
  ) async {
    return _domains.roomManagement.getRoomStreamInfo(roomId, mediaId);
  }

  static Future<void> kickRoomStream(
    String roomId,
    String mediaId, {
    String reason = '',
  }) async {
    await _domains.roomManagement.kickRoomStream(
      roomId,
      mediaId,
      reason: reason,
    );
  }

  static Future<RoomJoinReviewsPage> listRoomJoinReviewsPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    common_enum.ReviewStatus status =
        common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
    String userId = '',
  }) async {
    return _domains.roomManagement.listRoomJoinReviewsPage(
      roomId,
      page: page,
      pageSize: pageSize,
      status: status,
      userId: userId,
    );
  }

  static Future<void> approveRoomJoinReview(
    String roomId,
    String requestId,
  ) async {
    await _domains.roomManagement.approveRoomJoinReview(roomId, requestId);
  }

  static Future<void> rejectRoomJoinReview(
    String roomId,
    String requestId, {
    String reason = '',
  }) async {
    await _domains.roomManagement.rejectRoomJoinReview(
      roomId,
      requestId,
      reason: reason,
    );
  }

  static Future<void> addRoomMember(
    String roomId,
    String userId, {
    int role = 3,
    bool notify = true,
  }) async {
    await _domains.roomManagement.addRoomMember(
      roomId,
      userId,
      role: role,
      notify: notify,
    );
  }

  static Future<void> setRoomMemberRole(
    String roomId,
    String userId,
    int role,
  ) async {
    await _domains.roomManagement.setRoomMemberRole(roomId, userId, role);
  }

  static Future<void> updateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) async {
    await _domains.roomManagement.updateRoomMemberPermissionOverrides(
      roomId,
      userId,
      addedPermissions: addedPermissions,
      removedPermissions: removedPermissions,
      adminAddedPermissions: adminAddedPermissions,
      adminRemovedPermissions: adminRemovedPermissions,
    );
  }

  static Future<void> transferRoomOwnership(
    String roomId,
    String newOwnerId,
  ) async {
    await _domains.roomManagement.transferRoomOwnership(roomId, newOwnerId);
  }

  static Future<void> leaveRoom(String roomId) async {
    await _domains.roomManagement.leaveRoom(roomId);
  }

  static Future<void> resetRoomSettings(String roomId) async {
    await _domains.roomManagement.resetRoomSettings(roomId);
  }

  static Future<void> setRoomAdmin(String roomId, String userId) async {
    await _domains.roomManagement.setRoomAdmin(roomId, userId);
  }

  static Future<void> removeRoomAdmin(String roomId, String userId) async {
    await _domains.roomManagement.removeRoomAdmin(roomId, userId);
  }

  static Future<AdminUsersPage> adminListUsersPage({
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
  }) {
    return _domains.admin.listUsersPage(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      role: role,
      isBanned: isBanned,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<void> adminAddUser(
    String username,
    String password,
    int role, {
    String email = '',
    common_enum.UserStatus status = common_enum.UserStatus.USER_STATUS_ACTIVE,
  }) {
    return _domains.admin.addUser(
      username,
      password,
      role,
      email: email,
      status: status,
    );
  }

  static Future<void> adminDeleteUser(String userId) {
    return _domains.admin.deleteUser(userId);
  }

  static Future<WUser> adminGetUser(String userId) {
    return _domains.admin.getUser(userId);
  }

  static Future<AdminRoomsPage> adminListUserRoomsPage(
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
  }) {
    return _domains.admin.listUserRoomsPage(
      userId,
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      isBanned: isBanned,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<AccountPreferences> adminGetUserPreferences(String userId) {
    return _domains.admin.getUserPreferences(userId);
  }

  static Future<AccountPreferences> adminUpdateUserPreferences(
    String userId, {
    bool? twoFactorEnabled,
    NotificationPreferences? notifications,
  }) {
    return _domains.admin.updateUserPreferences(
      userId,
      twoFactorEnabled: twoFactorEnabled,
      notifications: notifications,
    );
  }

  static Future<void> adminUpdateUsername(String userId, String username) {
    return _domains.admin.updateUsername(userId, username);
  }

  static Future<void> adminUpdatePassword(
    String userId,
    String password, {
    String reason = '',
  }) {
    return _domains.admin.updatePassword(userId, password, reason: reason);
  }

  static Future<void> adminSetAdmin(String userId, bool isAdmin) {
    return _domains.admin.setAdmin(userId, isAdmin);
  }

  static Future<List<AdminSettingsGroup>> adminGetAllSettings() {
    return _domains.admin.getAllSettings();
  }

  static Future<AdminSettingsGroup> adminGetSettingsGroup(String group) {
    return _domains.admin.getSettingsGroup(group);
  }

  static Future<void> adminBanUser(
    String userId,
    bool ban, {
    String reason = '',
  }) {
    return _domains.admin.banUser(userId, ban, reason: reason);
  }

  static Future<AdminBatchOperationResult> adminBatchBanUsers(
    List<String> userIds, {
    String reason = '',
  }) {
    return _domains.admin.batchBanUsers(userIds, reason: reason);
  }

  static Future<AdminBatchOperationResult> adminBatchDeleteUsers(
    List<String> userIds,
  ) {
    return _domains.admin.batchDeleteUsers(userIds);
  }

  static Future<AdminRoomsPage> adminListRoomsPage({
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
  }) {
    return _domains.admin.listRoomsPage(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      isBanned: isBanned,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<void> adminBanRoom(
    String roomId,
    bool ban, {
    String reason = '',
  }) {
    return _domains.admin.banRoom(roomId, ban, reason: reason);
  }

  static Future<AdminBatchOperationResult> adminBatchBanRooms(
    List<String> roomIds, {
    String reason = '',
  }) {
    return _domains.admin.batchBanRooms(roomIds, reason: reason);
  }

  static Future<AdminBatchOperationResult> adminBatchDeleteRooms(
    List<String> roomIds,
  ) {
    return _domains.admin.batchDeleteRooms(roomIds);
  }

  static Future<void> adminDeleteRoom(String roomId) {
    return _domains.admin.deleteRoom(roomId);
  }

  static Future<WRoom> adminGetRoom(String roomId) {
    return _domains.admin.getRoom(roomId);
  }

  static Future<WRoomSettings> adminGetRoomSettings(String roomId) {
    return _domains.admin.getRoomSettings(roomId);
  }

  static Future<void> adminUpdateRoomSettings(
    String roomId,
    WRoomSettings settings,
  ) {
    return _domains.admin.updateRoomSettings(roomId, settings);
  }

  static Future<void> adminResetRoomSettings(String roomId) {
    return _domains.admin.resetRoomSettings(roomId);
  }

  static Future<void> adminUpdateRoomPassword(String roomId, String password) {
    return _domains.admin.updateRoomPassword(roomId, password);
  }

  static Future<AdminSettingsGroup> adminUpdateSettingInGroup(
    String group,
    String key,
    dynamic value,
  ) {
    return _domains.admin.updateSettingInGroup(group, key, value);
  }

  static Future<String> adminSendTestEmail(String to) {
    return _domains.admin.sendTestEmail(to);
  }

  static Future<AdminSystemStats> adminGetSystemStats() {
    return _domains.admin.getSystemStats();
  }

  static Future<AdminsPage> adminListAdminsPage({
    int page = 1,
    int pageSize = 20,
    String search = '',
    admin_enum.UserListSortBy sortBy =
        admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) {
    return _domains.admin.listAdminsPage(
      page: page,
      pageSize: pageSize,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<List<WUser>> adminListAdmins({String search = ''}) {
    return _domains.admin.listAdmins(search: search);
  }

  static Future<void> adminAddAdmin(String userId) {
    return _domains.admin.addAdmin(userId);
  }

  static Future<void> adminRemoveAdmin(String userId) {
    return _domains.admin.removeAdmin(userId);
  }

  static Future<AdminRoomMembersPage> adminListRoomMembersPage(
    String roomId, {
    int page = 1,
    int pageSize = 100,
    String search = '',
    common_enum.RoomMemberRole? role,
    admin_enum.RoomMemberListSortBy sortBy =
        admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    admin_enum.SortDirection sortDirection =
        admin_enum.SortDirection.SORT_DIRECTION_DESC,
  }) {
    return _domains.admin.listRoomMembersPage(
      roomId,
      page: page,
      pageSize: pageSize,
      search: search,
      role: role,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<void> adminAddRoomMember(
    String roomId,
    String userId, {
    int role = 2,
    bool notify = true,
  }) {
    return _domains.admin.addRoomMember(
      roomId,
      userId,
      role: role,
      notify: notify,
    );
  }

  static Future<void> adminSetRoomMemberRole(
    String roomId,
    String userId,
    int role,
  ) {
    return _domains.admin.setRoomMemberRole(roomId, userId, role);
  }

  static Future<void> adminUpdateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    int role = 3,
    int addedPermissions = 0,
    int removedPermissions = 0,
    int adminAddedPermissions = 0,
    int adminRemovedPermissions = 0,
  }) {
    return _domains.admin.updateRoomMemberPermissionOverrides(
      roomId,
      userId,
      role: role,
      addedPermissions: addedPermissions,
      removedPermissions: removedPermissions,
      adminAddedPermissions: adminAddedPermissions,
      adminRemovedPermissions: adminRemovedPermissions,
    );
  }

  static Future<void> adminKickRoomMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  }) {
    return _domains.admin.kickRoomMember(
      roomId,
      userId,
      kickCooldownSeconds: kickCooldownSeconds,
    );
  }

  static Future<AdminProviderInstancesPage> adminListProviderInstancesPage({
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
  }) {
    return _domains.admin.listProviderInstancesPage(
      page: page,
      pageSize: pageSize,
      providerType: providerType,
      search: search,
      enabled: enabled,
      tls: tls,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<List<AdminProviderInstance>> adminListProviderInstances({
    String providerType = '',
    String search = '',
    bool? enabled,
    bool? tls,
    provider_common_enum.ProviderInstanceListSortBy sortBy =
        provider_common_enum
            .ProviderInstanceListSortBy.PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
    provider_common_enum.SortDirection sortDirection =
        provider_common_enum.SortDirection.SORT_DIRECTION_ASC,
  }) {
    return _domains.admin.listProviderInstances(
      providerType: providerType,
      search: search,
      enabled: enabled,
      tls: tls,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) {
    return _domains.admin.listAvailableProviderInstances(
      providerType: providerType,
    );
  }

  static Future<List<String>> listProviderBackends(String providerType) {
    return _domains.admin.listProviderBackends(providerType);
  }

  static Future<AdminProviderInstance> adminAddProviderInstance({
    required String name,
    required String endpoint,
    required List<String> providers,
    String comment = '',
    int timeoutSeconds = 30,
    bool tls = true,
    bool insecureTls = false,
    String? jwtSecret,
    String? customCa,
  }) {
    return _domains.admin.addProviderInstance(
      name: name,
      endpoint: endpoint,
      providers: providers,
      comment: comment,
      timeoutSeconds: timeoutSeconds,
      tls: tls,
      insecureTls: insecureTls,
      jwtSecret: jwtSecret,
      customCa: customCa,
    );
  }

  static Future<AdminProviderInstance> adminUpdateProviderInstance({
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
  }) {
    return _domains.admin.updateProviderInstance(
      name: name,
      endpoint: endpoint,
      comment: comment,
      timeoutSeconds: timeoutSeconds,
      tls: tls,
      insecureTls: insecureTls,
      providers: providers,
      jwtSecret: jwtSecret,
      customCa: customCa,
      clearComment: clearComment,
      clearJwtSecret: clearJwtSecret,
      clearCustomCa: clearCustomCa,
    );
  }

  static Future<void> adminDeleteProviderInstance(String name) {
    return _domains.admin.deleteProviderInstance(name);
  }

  static Future<void> adminReconnectProviderInstance(String name) {
    return _domains.admin.reconnectProviderInstance(name);
  }

  static Future<void> adminSetProviderInstanceEnabled(
    String name,
    bool enabled,
  ) {
    return _domains.admin.setProviderInstanceEnabled(name, enabled);
  }

  static Future<AdminActiveStreamsPage> adminListActiveStreamsPage({
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
  }) {
    return _domains.admin.listActiveStreamsPage(
      page: page,
      pageSize: pageSize,
      roomId: roomId,
      userId: userId,
      nodeId: nodeId,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<List<AdminActiveStream>> adminListActiveStreams({
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
  }) {
    return _domains.admin.listActiveStreams(
      page: page,
      pageSize: pageSize,
      roomId: roomId,
      userId: userId,
      nodeId: nodeId,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
  }

  static Future<void> adminKickStream(AdminActiveStream stream) {
    return _domains.admin.kickStream(stream);
  }

  static Future<AdminBanRecordsPage> adminListBanRecordsPage({
    int page = 1,
    int pageSize = 50,
    int targetType = 0,
    bool? active,
    String userId = '',
    String roomId = '',
  }) {
    return _domains.admin.listBanRecordsPage(
      page: page,
      pageSize: pageSize,
      targetType: targetType,
      active: active,
      userId: userId,
      roomId: roomId,
    );
  }

  static Future<AdminReviewsPage> adminListReviewsPage({
    required String kind,
    int page = 1,
    int pageSize = 50,
    int status = 1,
    String search = '',
    String requestedBy = '',
    String roomId = '',
    String userId = '',
  }) {
    return _domains.admin.listReviewsPage(
      kind: kind,
      page: page,
      pageSize: pageSize,
      status: status,
      search: search,
      requestedBy: requestedBy,
      roomId: roomId,
      userId: userId,
    );
  }

  static Future<void> adminApproveReview(String kind, String requestId) {
    return _domains.admin.approveReview(kind, requestId);
  }

  static Future<void> adminRejectReview(
    String kind,
    String requestId, {
    String reason = '',
  }) {
    return _domains.admin.rejectReview(kind, requestId, reason: reason);
  }
}
