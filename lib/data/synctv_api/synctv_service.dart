import 'dart:convert';

import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/data/synctv_api/synctv_domain_services.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

export 'package:synctv_app/contracts/admin_models.dart';
export 'package:synctv_app/contracts/provider_models.dart';
export 'package:synctv_app/contracts/room_media_models.dart';
export 'package:synctv_app/data/synctv_api/synctv_file_upload_service.dart';

class SyncTvService {
  static const _serverTimeSyncTimeout = Duration(seconds: 5);

  static String get baseUrl => _runtime.baseUrl;
  static List<SyncTvServerProfile> get servers => _runtime.servers;
  static SyncTvServerProfile? get activeServer => _runtime.activeServer;
  static bool get allowInsecureTls => _runtime.allowInsecureTls;
  static String resolveResourceUrl(String url) =>
      _runtime.resolveResourceUrl(url);
  static Map<String, String> get authenticatedResourceHeaders =>
      _api.authenticatedResourceHeaders;
  static String? get guestRoomId => _runtime.guestRoomId;
  static SyncTvSessionIdentity get sessionIdentity => _runtime.sessionIdentity;

  static final SyncTvRuntimeService _runtime = SyncTvRuntimeService();
  static SyncTvApiClient get _api => _runtime.api;
  static SyncTvDomainServices _domains = _createDomains();
  static int _serverTimeSyncRevision = 0;

  static Stream<void> get onAuthError => _runtime.onAuthError;

  static Future<void> init() async {
    await _runtime.init();
    _domains = _createDomains();
    _invalidateServerTime();
  }

  static SyncTvDomainServices _createDomains() {
    return SyncTvDomainServices(api: _api, sessionStore: _runtime.sessionStore);
  }

  static Future<void> setBaseUrl(String url) async {
    await _runtime.setBaseUrl(url);
    _domains = _createDomains();
    _invalidateServerTime();
  }

  static Future<SyncTvServerProfile> addServer(
    String url, {
    bool allowInsecureTls = false,
  }) async {
    final profile = await _runtime.addServer(
      url,
      allowInsecureTls: allowInsecureTls,
    );
    _domains = _createDomains();
    _invalidateServerTime();
    return profile;
  }

  static Future<void> activateServer(String endpoint) async {
    await _runtime.activateServer(endpoint);
    _domains = _createDomains();
    _invalidateServerTime();
  }

  static Future<void> removeServer(String endpoint) async {
    final previousEndpoint = activeServer?.endpoint;
    await _runtime.removeServer(endpoint);
    _domains = _createDomains();
    if (activeServer?.endpoint != previousEndpoint) {
      _invalidateServerTime();
    }
  }

  static Future<String?> getToken() => _runtime.getToken();

  static Future<bool> refreshSessionAfterUnauthorized() =>
      _runtime.refreshSessionAfterUnauthorized();

  static Future<Uri> createRoomWebSocketUri(String roomId) {
    return _runtime.createRoomWebSocketUri(roomId);
  }

  static String encodeRealtimeMessageJson(client.ClientMessage message) {
    return jsonEncode(_runtime.encodeRealtimeJson(message));
  }

  static client.ServerMessage decodeRealtimeMessageJson(String json) {
    return _runtime.decodeRealtimeJson(jsonDecode(json));
  }

  static Future<void> logout() async {
    await _runtime.logout();
    _domains.cache.clear();
  }

  static Future<void> closeAccount() async {
    await _runtime.closeAccount();
    _domains.cache.clear();
  }

  static Future<AuthResult> registerWithDirectPassword({
    required String username,
    String email = '',
    required String password,
  }) async {
    return _domains.auth.registerWithDirectPassword(
      username: username,
      email: email,
      password: password,
    );
  }

  static Future<AuthResult> loginWithDirectPassword({
    required String loginSessionId,
    required String password,
  }) async {
    return _domains.auth.loginWithDirectPassword(
      loginSessionId: loginSessionId,
      password: password,
    );
  }

  static Future<String> requestEmailRegistration({
    required String username,
    required String email,
  }) async {
    return _domains.auth.requestEmailRegistration(
      username: username,
      email: email,
    );
  }

  static Future<AuthResult> confirmEmailRegistration({
    required String emailToken,
    required String password,
  }) async {
    return _domains.auth.confirmEmailRegistration(
      emailToken: emailToken,
      password: password,
    );
  }

  static Future<AuthResult> confirmEmailLoginResult(
    String loginSessionId,
    String token,
  ) async {
    return _domains.auth.confirmEmailLoginResult(loginSessionId, token);
  }

  static Future<LoginStart> startLogin(String identifier) {
    return _domains.auth.startLogin(identifier);
  }

  static Future<void> requestEmailLogin(String loginSessionId) async {
    await _domains.auth.requestEmailLogin(loginSessionId);
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
    required String loginSessionId,
    required List<int> credentialRequest,
  }) async {
    return _domains.auth.startOpaqueLogin(
      loginSessionId: loginSessionId,
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
    String? loginSessionId,
  }) async {
    return _domains.auth.startPasskeyLogin(loginSessionId: loginSessionId);
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

  static Future<AuthResult> verifyMfaTotp({
    required String mfaSessionId,
    required String code,
  }) => _domains.auth.verifyMfaTotp(mfaSessionId: mfaSessionId, code: code);

  static Future<AuthResult> verifyMfaRecoveryCode({
    required String mfaSessionId,
    required String recoveryCode,
  }) => _domains.auth.verifyMfaRecoveryCode(
    mfaSessionId: mfaSessionId,
    recoveryCode: recoveryCode,
  );

  static Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async {
    return _domains.auth.startSensitiveOperationVerification();
  }

  static Future<SensitiveOperationPasskeyStart> startSensitiveOperationPasskey(
    String sessionId,
  ) async {
    return _domains.auth.startSensitiveOperationPasskey(sessionId);
  }

  static Future<SensitiveOperationEmailCodeInfo>
  requestSensitiveOperationEmailCode(String sessionId) async {
    return _domains.auth.requestSensitiveOperationEmailCode(sessionId);
  }

  static Future<SensitiveOperationVerificationInfo>
  finishSensitiveOperationVerification({
    required String sessionId,
    required client.SensitiveOperationVerificationMethod method,
    String password = '',
    String emailToken = '',
    String passkeySessionId = '',
    Object? passkeyCredential,
    String totpCode = '',
    String recoveryCode = '',
  }) async {
    return _domains.auth.finishSensitiveOperationVerification(
      sessionId: sessionId,
      method: method,
      password: password,
      emailToken: emailToken,
      passkeySessionId: passkeySessionId,
      passkeyCredential: passkeyCredential,
      totpCode: totpCode,
      recoveryCode: recoveryCode,
    );
  }

  static Future<PublicSettingsInfo> getPublicSettings({
    bool refresh = false,
  }) async {
    return _domains.publicRooms.getPublicSettings(refresh: refresh);
  }

  static Future<ServerInfo> getServerInfo({bool refresh = false}) async {
    return _domains.publicRooms.getServerInfo(refresh: refresh);
  }

  static Future<client.GetServerTimeResponse> getServerTime({
    int clientSentAtNanos = 0,
  }) {
    return _domains.publicRooms.getServerTime(
      clientSentAtNanos: clientSentAtNanos,
    );
  }

  static DateTime serverNow() => SyncedClock.now();

  static int serverNowMillis() => SyncedClock.nowMillis();

  static Future<void> syncServerTime({bool refresh = false}) async {
    if (!refresh && SyncedClock.isSynced) return;
    final revision = ++_serverTimeSyncRevision;
    final endpointGeneration = _api.endpointGeneration;
    try {
      final sentAt = SyncedClock.localUnixNanos();
      final response = await getServerTime(clientSentAtNanos: sentAt)
          .timeout(_serverTimeSyncTimeout);
      final receivedAt = SyncedClock.localUnixNanos();
      if (revision != _serverTimeSyncRevision ||
          !_api.isEndpointGenerationCurrent(endpointGeneration)) {
        return;
      }
      SyncedClock.updateFromServerTime(
        clientSentAtNanos: response.clientSentAtNanos.toInt(),
        clientReceivedAtNanos: receivedAt,
        serverReceivedAtNanos: response.serverReceivedAtNanos.toInt(),
        serverSentAtNanos: response.serverSentAtNanos.toInt(),
      );
    } catch (_) {
      if (revision == _serverTimeSyncRevision &&
          _api.isEndpointGenerationCurrent(endpointGeneration)) {
        SyncedClock.reset();
      }
    }
  }

  static void _invalidateServerTime() {
    _serverTimeSyncRevision++;
    SyncedClock.reset();
  }

  static Future<List<RoomCategoryInfo>> listRoomCategories({
    bool includeDisabled = false,
    bool refresh = false,
  }) {
    return _domains.publicRooms.listRoomCategories(
      includeDisabled: includeDisabled,
      refresh: refresh,
    );
  }

  static Future<List<RoomLabelInfo>> listRoomLabels({
    bool includeDisabled = false,
    String categoryId = '',
    bool refresh = false,
  }) {
    return _domains.publicRooms.listRoomLabels(
      includeDisabled: includeDisabled,
      categoryId: categoryId,
      refresh: refresh,
    );
  }

  static Future<SyncTvUser> createGuestToken(String roomId) async {
    return _domains.auth.createGuestToken(roomId);
  }

  static Future<List<OAuth2ProviderOption>> listOAuth2Providers() async {
    return _domains.cache.get<List<OAuth2ProviderOption>>(
      'account:oauth2:providers',
      ttl: const Duration(minutes: 5),
      loader: _domains.auth.listOAuth2Providers,
    );
  }

  static Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  }) async {
    return _domains.auth.startOAuth2Login(
      provider,
      redirectUrl: redirectUrl,
      native: native,
    );
  }

  static OAuth2CallbackPayload parseOAuth2Callback(
    Uri uri, {
    String expectedState = '',
  }) => OAuth2CallbackParser.parse(uri, expectedState: expectedState);

  static Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  }) async {
    return _domains.auth.finishOAuth2Login(code: code, state: state);
  }

  static Future<SyncTvUser> getMe({bool refresh = false}) async {
    return _domains.account.getMe(refresh: refresh);
  }

  static Future<BlockedUserInfo> blockUser(String userId) =>
      _domains.account.blockUser(userId);

  static Future<void> unblockUser(String userId) =>
      _domains.account.unblockUser(userId);

  static Future<BlockedUsersPage> listBlockedUsers({
    int page = 1,
    int pageSize = 50,
    String? search,
  }) => _domains.account.listBlockedUsers(
    page: page,
    pageSize: pageSize,
    search: search,
  );

  static Future<SyncTvUser> updateUsername(String username) async {
    return _domains.account.updateUsername(username);
  }

  static Future<SyncTvUser> updateUserAvatar(LocalImageUpload upload) async {
    final user = await _domains.fileUploads.updateUserAvatar(upload);
    final mapped = _api.mapUser(user);
    _domains.cache.put('account:me', mapped, ttl: const Duration(minutes: 2));
    return mapped;
  }

  static Future<SyncTvUser> clearUserAvatar() async {
    final user = await _domains.fileUploads.clearUserAvatar();
    final mapped = _api.mapUser(user);
    _domains.cache.put('account:me', mapped, ttl: const Duration(minutes: 2));
    return mapped;
  }

  static Future<String> startEmailBind(String email) async {
    return _domains.account.startEmailBind(email);
  }

  static Future<SyncTvUser> confirmEmailBind({
    required String email,
    required String token,
    required String verificationId,
  }) async {
    return _domains.account.confirmEmailBind(
      email: email,
      token: token,
      verificationId: verificationId,
    );
  }

  static Future<SyncTvUser> unbindEmail({
    required String verificationId,
  }) async {
    return _domains.account.unbindEmail(verificationId: verificationId);
  }

  static Future<AccountPreferences> getAccountPreferences({
    bool refresh = false,
  }) async {
    return _domains.account.getAccountPreferences(refresh: refresh);
  }

  static Future<AccountPreferences> updateAccountPreferences({
    NotificationPreferences? notifications,
  }) async {
    return _domains.account.updateAccountPreferences(
      notifications: notifications,
    );
  }

  static Future<AccountPreferences> setTwoFactorEnabled({
    required bool enabled,
    required String verificationId,
  }) async {
    return _domains.account.setTwoFactorEnabled(
      enabled: enabled,
      verificationId: verificationId,
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
    bool refresh = false,
  }) async {
    return _domains.notifications.listNotifications(
      page: page,
      pageSize: pageSize,
      isRead: isRead,
      notificationType: notificationType,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
      refresh: refresh,
    );
  }

  static Future<void> markNotificationAsRead(UserNotificationItem item) async {
    await _domains.notifications.markNotificationAsRead(item);
  }

  static Future<UserNotificationItem> getNotification(
    int notificationId,
  ) async {
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

  static Future<List<PasskeyCredentialInfo>> listPasskeys({
    bool refresh = false,
  }) async {
    return _domains.account.listPasskeys(refresh: refresh);
  }

  static Future<void> deletePasskey(
    String credentialId, {
    required String verificationId,
  }) async {
    await _domains.account.deletePasskey(
      credentialId,
      verificationId: verificationId,
    );
  }

  static Future<OpaquePasswordUpdateStart> startOpaquePasswordUpdate({
    List<int> credentialRequest = const [],
    required List<int> registrationRequest,
    required client_enum.OpaquePasswordUpdateVerificationMethod
    verificationMethod,
    String emailToken = '',
  }) async {
    return _domains.account.startOpaquePasswordUpdate(
      credentialRequest: credentialRequest,
      registrationRequest: registrationRequest,
      verificationMethod: verificationMethod,
      emailToken: emailToken,
    );
  }

  static Future<SyncTvUser> finishOpaquePasswordUpdate({
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
    required String verificationId,
  }) async {
    return _domains.account.finishPasskeyBind(
      sessionId: sessionId,
      credential: credential,
      verificationId: verificationId,
    );
  }

  static Future<TotpSetupInfo> startTotpSetup({
    required String verificationId,
  }) => _domains.account.startTotpSetup(verificationId: verificationId);

  static Future<List<String>> finishTotpSetup({
    required String setupId,
    required String code,
  }) => _domains.account.finishTotpSetup(setupId: setupId, code: code);

  static Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  }) => _domains.account.regenerateTotpRecoveryCodes(
    verificationId: verificationId,
  );

  static Future<void> deleteTotp({required String verificationId}) =>
      _domains.account.deleteTotp(verificationId: verificationId);

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
    return _domains.cache.get<List<OAuth2LinkedAccount>>(
      'account:oauth2:linked',
      ttl: const Duration(minutes: 2),
      loader: _domains.auth.getLinkedOAuth2Accounts,
    );
  }

  static Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) async {
    return _domains.auth.startOAuth2Bind(
      provider,
      redirectUrl: redirectUrl,
      verificationId: verificationId,
      native: native,
    );
  }

  static Future<void> finishOAuth2Bind({
    required String code,
    required String state,
  }) async {
    await _domains.auth.finishOAuth2Bind(code: code, state: state);
    _domains.cache.invalidate('account:oauth2:linked');
  }

  static Future<void> unlinkOAuth2Account(
    OAuth2LinkedAccount account, {
    required String verificationId,
  }) async {
    await _domains.auth.unlinkOAuth2Account(
      account,
      verificationId: verificationId,
    );
    _domains.cache.invalidate('account:oauth2:linked');
  }

  static Future<RoomDiscoveryPage> discoverRooms({
    int page = 1,
    int pageSize = 100,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
  }) async {
    return _domains.publicRooms.discoverRooms(
      page: page,
      pageSize: pageSize,
      search: search,
      categoryId: categoryId,
      labelIds: labelIds,
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
        client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_FREQUENT,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
    bool refresh = false,
  }) async {
    final key = [
      'account:rooms',
      page,
      pageSize,
      search ?? '',
      status.value,
      isBanned,
      relation.value,
      sortBy.value,
      sortDirection.value,
    ].join('|');
    return _domains.cache.get<RoomsPage>(
      key,
      ttl: const Duration(seconds: 45),
      refresh: refresh,
      loader: () => _domains.publicRooms.getMyRoomsPage(
        page: page,
        pageSize: pageSize,
        search: search,
        status: status,
        isBanned: isBanned,
        relation: relation,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
  }

  static Future<RoomsPage> getFavoriteRoomsPage({
    int page = 1,
    int pageSize = 100,
    String? search,
    bool refresh = false,
  }) async {
    final key = [
      'account:favorite-rooms',
      page,
      pageSize,
      search ?? '',
    ].join('|');
    return _domains.cache.get<RoomsPage>(
      key,
      ttl: const Duration(seconds: 45),
      refresh: refresh,
      loader: () => _domains.publicRooms.getFavoriteRoomsPage(
        page: page,
        pageSize: pageSize,
        search: search,
      ),
    );
  }

  static Future<SyncTvRoom> favoriteRoom(String roomId) async {
    final room = await _domains.publicRooms.favoriteRoom(roomId);
    _domains.cache.invalidatePrefix('account:favorite-rooms');
    _domains.cache.invalidatePrefix('account:rooms');
    return room;
  }

  static Future<SyncTvRoom> unfavoriteRoom(String roomId) async {
    final room = await _domains.publicRooms.unfavoriteRoom(roomId);
    _domains.cache.invalidatePrefix('account:favorite-rooms');
    _domains.cache.invalidatePrefix('account:rooms');
    return room;
  }

  static Future<SyncTvRoom> getRoomDiscovery(String roomId) async {
    return _domains.publicRooms.getRoomDiscovery(roomId);
  }

  static Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
    bool isPublic = true,
  }) async {
    final room = await _domains.publicRooms.createRoom(
      name,
      password: password,
      description: description,
      categoryId: categoryId,
      labelIds: labelIds,
      isPublic: isPublic,
    );
    _domains.cache.invalidatePrefix('account:rooms');
    return room;
  }

  static Future<void> deleteRoom(String roomId) async {
    await _domains.publicRooms.deleteRoom(roomId);
    _domains.cache.invalidatePrefix('account:rooms');
  }

  static Future<JoinRoomResult> joinRoom(String roomId, String password) async {
    final result = await _domains.publicRooms.joinRoom(roomId, password);
    _domains.cache.invalidatePrefix('account:rooms');
    return result;
  }

  static Future<SyncTvRoom> getRoomInfo(String roomId) async {
    return _domains.publicRooms.getRoomInfo(roomId);
  }

  static Future<List<SyncTvUser>> getRoomMembers(String roomId) async {
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

  static Future<SyncTvPlaybackStatus> playPrevious(String roomId) {
    return _domains.roomMedia.playPrevious(roomId);
  }

  static Future<SyncTvPlaybackStatus> playNext(String roomId) {
    return _domains.roomMedia.playNext(roomId);
  }

  static Future<client.ListPlaybackHistoryResponse> listPlaybackHistory(
    String roomId, {
    String cursorEntryId = '',
    int limit = 50,
    client_enum.SortDirection sortDirection =
        client_enum.SortDirection.SORT_DIRECTION_DESC,
  }) {
    return _domains.roomMedia.listPlaybackHistory(
      roomId,
      cursorEntryId: cursorEntryId,
      limit: limit,
      sortDirection: sortDirection,
    );
  }

  static Future<SyncTvPlaybackStatus> playHistoryEntry(
    String roomId,
    String entryId,
  ) {
    return _domains.roomMedia.playHistoryEntry(roomId, entryId);
  }

  static Future<bool> deletePlaybackHistoryEntry(
    String roomId,
    String entryId,
  ) {
    return _domains.roomMedia.deletePlaybackHistoryEntry(roomId, entryId);
  }

  static Future<int> clearPlaybackHistory(String roomId) {
    return _domains.roomMedia.clearPlaybackHistory(roomId);
  }

  static Stream<RoomResourceWatchEvent<SyncTvPlaybackStatus>>
  watchPlaybackState(String roomId, {String version = ''}) {
    return _domains.roomMedia.watchPlaybackState(roomId, version: version);
  }

  static Stream<RoomResourceWatchEvent<SyncTvPlaybackStatus>>
  watchPlaybackSnapshot(String roomId) {
    return _domains.roomMedia.watchPlaybackSnapshot(roomId);
  }

  static Stream<RoomResourceWatchEvent<SyncTvRoomSettings>> watchRoomSettings(
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
    int? page,
    int pageSize = 100,
    String search = '',
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
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

  static Stream<RoomResourceWatchEvent<List<SyncTvUser>>> watchRoomUsers(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomManagement.watchRoomUsers(roomId, version: version);
  }

  static Future<RoomMediaLibraryPage> listMediaLibrary(
    String roomId, {
    int? page,
    String? cursor,
    int pageSize = 50,
    String playlistId = '',
    String? target,
    String search = '',
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    Map<String, dynamic>? previewSourceConfig,
    source_config.PlaylistSourceConfig? typedPreviewSourceConfig,
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
      cursor: cursor,
      pageSize: pageSize,
      search: search,
      sourceProvider: sourceProvider,
      previewSourceConfig: previewSourceConfig,
      typedPreviewSourceConfig: typedPreviewSourceConfig,
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
    source_enum.SourceProvider sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
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

  static Future<RoomPlaylistItem> createPlaylist(
    String roomId, {
    required String name,
    String parentId = '',
    String description = '',
    client_enum.PlaylistBrowseAccessMode browseAccessMode = client_enum
        .PlaylistBrowseAccessMode
        .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
  }) async {
    return _domains.roomMedia.createPlaylist(
      roomId,
      name: name,
      parentId: parentId,
      description: description,
      browseAccessMode: browseAccessMode,
    );
  }

  static Future<provider_common.PreparedMediaSource> prepareDirectUrl(
    provider_common.PrepareDirectUrlRequest intent,
  ) => _domains.providers.prepareDirectUrl(intent);

  static Future<provider_common.PreparedMediaSource> prepareLiveProxy(
    provider_common.PrepareLiveProxyRequest intent,
  ) => _domains.providers.prepareLiveProxy(intent);

  static Future<provider_common.PreparedMediaSource> prepareRtmp(
    source_enum.RtmpStreamMode mode,
  ) => _domains.providers.prepareRtmp(mode);

  static Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) => _domains.providers.resolvePlaybackProxyPolicy(source);

  static Future<RoomPlaylistItem> updatePlaylist(
    String roomId,
    String playlistId, {
    required String name,
    String? description,
    source_config.PlaylistSourceConfig? sourceConfig,
    client_enum.PlaylistBrowseAccessMode? browseAccessMode,
  }) async {
    return _domains.roomMedia.updatePlaylist(
      roomId,
      playlistId,
      name: name,
      description: description,
      sourceConfig: sourceConfig,
      browseAccessMode: browseAccessMode,
    );
  }

  static Future<SyncTvRoom> updateRoomCover(
    String roomId,
    LocalImageUpload upload,
  ) async {
    final room = await _domains.fileUploads.updateRoomCover(roomId, upload);
    return _api.mapRoom(room);
  }

  static Future<SyncTvRoom> clearRoomCover(String roomId) async {
    final room = await _domains.fileUploads.clearRoomCover(roomId);
    return _api.mapRoom(room);
  }

  static Future<RoomPlaylistItem> updatePlaylistCover(
    String roomId,
    String playlistId,
    LocalImageUpload upload,
  ) async {
    final playlist = await _domains.fileUploads.updatePlaylistCover(
      roomId,
      playlistId,
      upload,
    );
    return _api.mapPlaylist(playlist);
  }

  static Future<RoomPlaylistItem> clearPlaylistCover(
    String roomId,
    String playlistId,
  ) async {
    final playlist = await _domains.fileUploads.clearPlaylistCover(
      roomId,
      playlistId,
    );
    return _api.mapPlaylist(playlist);
  }

  static Future<RoomPlaylistItem> movePlaylist(
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

  static Future<RoomMediaItem> editMedia(
    String roomId,
    String mediaId, {
    required String name,
    String? description,
    source_enum.PlaybackProxyMode? playbackProxyMode,
  }) async {
    return _domains.roomMedia.editMedia(
      roomId,
      mediaId,
      name: name,
      description: description,
      playbackProxyMode: playbackProxyMode,
    );
  }

  static Future<RoomMediaItem> updateVideoCover(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) async {
    final media = await _domains.fileUploads.updateVideoCover(
      roomId,
      mediaId,
      upload,
    );
    return _api.mapMedia(media);
  }

  static Future<RoomMediaItem> clearVideoCover(
    String roomId,
    String mediaId,
  ) async {
    final media = await _domains.fileUploads.clearVideoCover(roomId, mediaId);
    return _api.mapMedia(media);
  }

  static Future<RoomMediaItem> updateVideoThumbnail(
    String roomId,
    String mediaId,
    LocalImageUpload upload,
  ) async {
    final media = await _domains.fileUploads.updateVideoThumbnail(
      roomId,
      mediaId,
      upload,
    );
    return _api.mapMedia(media);
  }

  static Future<RoomMediaItem> clearVideoThumbnail(
    String roomId,
    String mediaId,
  ) async {
    final media = await _domains.fileUploads.clearVideoThumbnail(
      roomId,
      mediaId,
    );
    return _api.mapMedia(media);
  }

  static Future<RoomMediaItem> getMedia(String roomId, String mediaId) async {
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
    List<client_enum.ChatMessageType> includeMessageTypes =
        chatTimelineMessageTypes,
  }) async {
    return _domains.roomMedia.getChatHistory(
      roomId,
      limit: limit,
      cursor: cursor,
      includeMessageTypes: includeMessageTypes,
    );
  }

  static Future<ChatHistoryPage> getAdminChatHistory(
    String roomId, {
    int limit = 50,
    String cursor = '',
    List<client_enum.ChatMessageType> includeMessageTypes =
        chatTimelineMessageTypes,
  }) {
    return _domains.roomMedia.getChatHistoryAsAdmin(
      roomId,
      limit: limit,
      cursor: cursor,
      includeMessageTypes: includeMessageTypes,
    );
  }

  static Future<ChatMessageContextInfo> getAdminChatMessageContext(
    String roomId,
    String messageId, {
    int beforeLimit = 20,
    int afterLimit = 20,
    bool includeDeleted = false,
  }) {
    return _domains.roomMedia.getChatMessageContextAsAdmin(
      roomId,
      messageId,
      beforeLimit: beforeLimit,
      afterLimit: afterLimit,
      includeDeleted: includeDeleted,
    );
  }

  static Future<ChatSearchPage> searchChatMessages(
    String roomId, {
    required String query,
    int limit = 50,
    String cursor = '',
    bool includeDeleted = false,
    String userId = '',
  }) {
    return _domains.roomMedia.searchChatMessages(
      roomId,
      query: query,
      limit: limit,
      cursor: cursor,
      includeDeleted: includeDeleted,
      userId: userId,
    );
  }

  static Future<StoredImageInfo> uploadChatImage(
    String roomId,
    LocalImageUpload upload,
  ) async {
    final reference = await _domains.fileUploads.uploadChatImage(
      roomId,
      upload,
    );
    return StoredImageInfo(
      id: reference.id,
      uploadReference: true,
      storageBackend: '',
      objectKey: '',
      url: '',
      mimeType: upload.mimeType,
      sizeBytes: upload.sizeBytes,
      width: upload.width,
      height: upload.height,
      metadata: utf8.encode(
        jsonEncode(
          fileMetadataToJson(
            client.FileMetadata(
              width: upload.width == 0 ? null : upload.width,
              height: upload.height == 0 ? null : upload.height,
            ),
          ),
        ),
      ),
    );
  }

  static Future<RoomChatMessageInfo> sendChatMessage(
    String roomId, {
    String content = '',
    List<StoredImageInfo> images = const [],
    String displayPosition = '',
    String displayColor = '',
    String replyToMessageId = '',
    List<ChatMentionInfo> mentions = const [],
  }) async {
    return _domains.roomMedia.sendChatMessage(
      roomId,
      content: content,
      images: images,
      displayPosition: displayPosition,
      displayColor: displayColor,
      replyToMessageId: replyToMessageId,
      mentions: mentions,
    );
  }

  static Future<List<ChatPinnedMessageInfo>> listPinnedChatMessages(
    String roomId, {
    int limit = 50,
  }) {
    return _domains.roomMedia.listPinnedChatMessages(roomId, limit: limit);
  }

  static Future<ChatPinEventInfo> pinChatMessage(
    String roomId,
    String messageId, {
    String note = '',
  }) {
    return _domains.roomMedia.pinChatMessage(roomId, messageId, note: note);
  }

  static Future<ChatPinEventInfo> unpinChatMessage(
    String roomId,
    String messageId,
  ) {
    return _domains.roomMedia.unpinChatMessage(roomId, messageId);
  }

  static Stream<RoomResourceWatchEvent<ChatPinEventInfo>> watchChatPinEvents(
    String roomId, {
    String version = '',
  }) {
    return _domains.roomMedia.watchChatPinEvents(roomId, version: version);
  }

  static Future<RoomChatMessageInfo> editChatMessage(
    String roomId,
    String messageId, {
    required String content,
    required int expectedVersion,
  }) {
    return _domains.roomMedia.editChatMessage(
      roomId,
      messageId,
      content: content,
      expectedVersion: expectedVersion,
    );
  }

  static Future<RoomChatMessageInfo> deleteChatMessage(
    String roomId,
    String messageId, {
    required int expectedVersion,
    String reason = '',
  }) {
    return _domains.roomMedia.deleteChatMessage(
      roomId,
      messageId,
      expectedVersion: expectedVersion,
      reason: reason,
    );
  }

  static Future<RoomChatMessageInfo> setChatReaction(
    String roomId,
    String messageId,
    String reactionKey, {
    required bool enabled,
  }) {
    return _domains.roomMedia.setChatReaction(
      roomId,
      messageId,
      reactionKey,
      enabled: enabled,
    );
  }

  static Future<String> reportChatMessage(
    String roomId,
    String messageId, {
    required String reasonCode,
    String reason = '',
  }) {
    return _domains.roomMedia.reportChatMessage(
      roomId,
      messageId,
      reasonCode: reasonCode,
      reason: reason,
    );
  }

  static Future<String> reportRoom(
    String roomId, {
    required String reasonCode,
    String reason = '',
  }) {
    return _domains.roomMedia.reportRoom(
      roomId,
      reasonCode: reasonCode,
      reason: reason,
    );
  }

  static Future<String> reportUser(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) {
    return _domains.roomMedia.reportUser(
      roomId,
      userId,
      reasonCode: reasonCode,
      reason: reason,
    );
  }

  static Future<String> reportRoomMember(
    String roomId,
    String userId, {
    required String reasonCode,
    String reason = '',
  }) {
    return _domains.roomMedia.reportRoomMember(
      roomId,
      userId,
      reasonCode: reasonCode,
      reason: reason,
    );
  }

  static Future<RoomChatMessageInfo> getChatMessage(
    String roomId,
    String messageId, {
    bool includeDeleted = false,
  }) {
    return _domains.roomMedia.getChatMessage(
      roomId,
      messageId,
      includeDeleted: includeDeleted,
    );
  }

  static Future<ChatReactionUsersPage> listChatReactionUsers(
    String roomId,
    String messageId,
    String reactionKey, {
    int limit = 50,
    String cursor = '',
  }) {
    return _domains.roomMedia.listChatReactionUsers(
      roomId,
      messageId,
      reactionKey,
      limit: limit,
      cursor: cursor,
    );
  }

  static Future<ChatMessageContextInfo> getChatMessageContext(
    String roomId,
    String messageId, {
    int beforeLimit = 20,
    int afterLimit = 20,
    bool includeDeleted = false,
  }) {
    return _domains.roomMedia.getChatMessageContext(
      roomId,
      messageId,
      beforeLimit: beforeLimit,
      afterLimit: afterLimit,
      includeDeleted: includeDeleted,
    );
  }

  static Future<List<RoomChatMessageInfo>> getChatPlaybackMessages(
    String roomId, {
    String playbackMediaId = '',
    String playbackPlaylistId = '',
    List<int> playbackTarget = const [],
    double positionSeconds = 0,
    double beforeSeconds = 30,
    double afterSeconds = 30,
    int limit = 50,
    bool includeDeleted = false,
    List<client_enum.ChatMessageType> includeMessageTypes = const [],
  }) {
    return _domains.roomMedia.getChatPlaybackMessages(
      roomId,
      playbackMediaId: playbackMediaId,
      playbackPlaylistId: playbackPlaylistId,
      playbackTarget: playbackTarget,
      positionSeconds: positionSeconds,
      beforeSeconds: beforeSeconds,
      afterSeconds: afterSeconds,
      limit: limit,
      includeDeleted: includeDeleted,
      includeMessageTypes: includeMessageTypes,
    );
  }

  static Future<ChatReadStateInfo> markChatRead(
    String roomId,
    String messageId,
  ) {
    return _domains.roomMedia.markChatRead(roomId, messageId);
  }

  static Future<ChatReadStateInfo> getChatReadState(String roomId) {
    return _domains.roomMedia.getChatReadState(roomId);
  }

  static Future<ChatMessageReadReceiptsInfo> getChatMessageReadReceipts(
    String roomId,
    String messageId, {
    int page = 1,
    int pageSize = 50,
  }) {
    return _domains.roomMedia.getChatMessageReadReceipts(
      roomId,
      messageId,
      page: page,
      pageSize: pageSize,
    );
  }

  static Future<String> addDiscoveredSource(
    String roomId, {
    required provider_common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    if (source.isMedia) {
      return _domains.roomMedia.addMediaFromSourceConfig(
        roomId,
        playlistId: playlistId,
        providerInstanceName: source.providerInstanceName,
        sourceConfig: source.requireMedia(),
        name: name,
      );
    }
    final playlist = await _domains.roomMedia.createPlaylistFromSourceConfig(
      roomId,
      parentId: playlistId,
      providerInstanceName: source.providerInstanceName,
      sourceConfig: source.requirePlaylist(),
      name: name,
    );
    return playlist.id;
  }

  static Future<RtmpPublishKeyInfo> createRtmpPublishKeyInfo(
    String roomId,
    String mediaId, {
    required client.PublishKeyType keyType,
    int? expiresAt,
  }) async {
    return _domains.roomMedia.createRtmpPublishKeyInfo(
      roomId,
      mediaId,
      keyType: keyType,
      expiresAt: expiresAt,
    );
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

  static Future<void> deleteMedia(String roomId, String mediaId) async {
    await _domains.roomMedia.deleteMedia(roomId, mediaId);
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

  static Future<void> clearMediaLibrary(
    String roomId, {
    String? parentId,
  }) async {
    await _domains.roomMedia.clearMediaLibrary(roomId, parentId: parentId);
  }

  static Future<SyncTvPlaybackStatus> switchMedia(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  }) async {
    return _domains.roomMedia.switchMedia(
      roomId,
      entryId,
      subPath: subPath,
      playlistId: playlistId,
    );
  }

  static Future<SyncTvPlaybackStatus> switchMediaAndPlay(
    String roomId,
    String entryId, {
    String? subPath,
    String? playlistId,
  }) {
    return switchMedia(
      roomId,
      entryId,
      subPath: subPath,
      playlistId: playlistId,
    );
  }

  static Future<SyncTvPlaybackStatus> updatePlaybackState(
    String roomId, {
    PlaybackControlAction? action,
    required bool isPlaying,
    double? position,
    double speed = 1.0,
    int? version,
  }) async {
    return _domains.roomMedia.updatePlaybackState(
      roomId,
      action: action,
      isPlaying: isPlaying,
      position: position,
      speed: speed,
      version: version,
    );
  }

  static Duration? resourceWatchReconnectDelay(Object error) {
    if (error is SyncTvApiException) {
      if (error.statusCode == 401 ||
          error.statusCode == 403 ||
          error.statusCode == 404) {
        return null;
      }
      if (error.statusCode == 429) return const Duration(seconds: 30);
      if (error.statusCode >= 400 && error.statusCode < 500) return null;
      return const Duration(seconds: 10);
    }
    return const Duration(seconds: 5);
  }

  static Future<AlistLoginInfo> loginAList(
    String host,
    String username,
    String hashedPassword, {
    String otpCode = '',
    String otpSecret = '',
    String instanceName = '',
  }) async {
    return _domains.providers.loginAList(
      host,
      username,
      hashedPassword,
      otpCode: otpCode,
      otpSecret: otpSecret,
      instanceName: instanceName,
    );
  }

  static Future<void> logoutAList(String serverId) {
    return _domains.providers.logoutAList(serverId);
  }

  static Future<String> loginCloudreve(
    String host,
    String email,
    String password, {
    String instanceName = '',
  }) => _domains.providers.loginCloudreve(
    host,
    email,
    password,
    instanceName: instanceName,
  );

  static Future<void> logoutCloudreve(String serverId) =>
      _domains.providers.logoutCloudreve(serverId);

  static Future<FnosLoginInfo> loginFnos({
    required String endpoint,
    required String username,
    required String password,
    String webdavEndpoint = '',
    String mediaEndpoint = '',
    String twoFactorCode = '',
    bool trustDevice = true,
    String instanceName = '',
  }) => _domains.providers.loginFnos(
    endpoint: endpoint,
    username: username,
    password: password,
    webdavEndpoint: webdavEndpoint,
    mediaEndpoint: mediaEndpoint,
    twoFactorCode: twoFactorCode,
    trustDevice: trustDevice,
    instanceName: instanceName,
  );

  static Future<void> logoutFnos(String serverId) =>
      _domains.providers.logoutFnos(serverId);

  static Future<List<FnosBindInfo>> getAllFnosBindInfos() =>
      _domains.providers.getAllFnosBindInfos();

  static Future<FnosFileListPage> listFnosFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listFnosFiles(
    serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<List<FnosMediaLibraryInfo>> listFnosMediaLibraries(
    String serverId, {
    String instanceName = '',
  }) => _domains.providers.listFnosMediaLibraries(
    serverId,
    instanceName: instanceName,
  );

  static Future<FnosMediaListPage> listFnosMediaItems(
    String serverId, {
    FnosMediaCollection collection = FnosMediaCollection.library,
    String libraryGuid = '',
    String parentGuid = '',
    int page = 1,
    int pageSize = 50,
    List<String> mediaTypes = const [],
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listFnosMediaItems(
    serverId,
    collection: collection,
    libraryGuid: libraryGuid,
    parentGuid: parentGuid,
    page: page,
    pageSize: pageSize,
    mediaTypes: mediaTypes,
    search: search,
    instanceName: instanceName,
  );

  static Future<bool> setFnosFavorite(
    String serverId,
    String itemGuid,
    bool favorite, {
    String instanceName = '',
  }) => _domains.providers.setFnosFavorite(
    serverId,
    itemGuid,
    favorite,
    instanceName: instanceName,
  );

  static Future<bool> setFnosWatched(
    String serverId,
    String itemGuid,
    bool watched, {
    String instanceName = '',
  }) => _domains.providers.setFnosWatched(
    serverId,
    itemGuid,
    watched,
    instanceName: instanceName,
  );

  static Future<QnapBindInfo> loginQnap({
    required String endpoint,
    required String username,
    required String password,
    String instanceName = '',
  }) => _domains.providers.loginQnap(
    endpoint: endpoint,
    username: username,
    password: password,
    instanceName: instanceName,
  );

  static Future<void> logoutQnap(String serverId) =>
      _domains.providers.logoutQnap(serverId);

  static Future<List<QnapBindInfo>> getAllQnapBindInfos() =>
      _domains.providers.getAllQnapBindInfos();

  static Future<QnapCapabilitiesInfo> getQnapCapabilities(
    String serverId, {
    String instanceName = '',
  }) => _domains.providers.getQnapCapabilities(
    serverId,
    instanceName: instanceName,
  );

  static Future<QnapFileListPage> listQnapFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listQnapFiles(
    serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<SynologyBindInfo> loginSynology({
    required String endpoint,
    required String username,
    required String password,
    String otpCode = '',
    String deviceName = '',
    String instanceName = '',
  }) => _domains.providers.loginSynology(
    endpoint: endpoint,
    username: username,
    password: password,
    otpCode: otpCode,
    deviceName: deviceName,
    instanceName: instanceName,
  );

  static Future<void> logoutSynology(String serverId) =>
      _domains.providers.logoutSynology(serverId);

  static Future<List<SynologyBindInfo>> getAllSynologyBindInfos() =>
      _domains.providers.getAllSynologyBindInfos();

  static Future<NextcloudBindInfo> loginNextcloud({
    required String endpoint,
    required String username,
    required String appPassword,
    String instanceName = '',
  }) => _domains.providers.loginNextcloud(
    endpoint: endpoint,
    username: username,
    appPassword: appPassword,
    instanceName: instanceName,
  );

  static Future<NextcloudLoginFlowInfo> startNextcloudLoginFlow(
    String endpoint,
  ) => _domains.providers.startNextcloudLoginFlow(endpoint);

  static Future<NextcloudBindInfo> pollNextcloudLoginFlow({
    required String endpoint,
    required NextcloudLoginFlowInfo flow,
    String instanceName = '',
  }) => _domains.providers.pollNextcloudLoginFlow(
    endpoint: endpoint,
    flow: flow,
    instanceName: instanceName,
  );

  static Future<void> logoutNextcloud(String serverId) =>
      _domains.providers.logoutNextcloud(serverId);

  static Future<List<NextcloudBindInfo>> getAllNextcloudBindInfos() =>
      _domains.providers.getAllNextcloudBindInfos();

  static Future<NextcloudFileListPage> listNextcloudFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listNextcloudFiles(
    serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<NextcloudFileListPage> listNextcloudFavorites(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) => _domains.providers.listNextcloudFavorites(
    serverId,
    page: page,
    pageSize: pageSize,
    instanceName: instanceName,
  );

  static Future<SeafileBindInfo> loginSeafile({
    required String endpoint,
    required String username,
    required String password,
    String instanceName = '',
  }) => _domains.providers.loginSeafile(
    endpoint: endpoint,
    username: username,
    password: password,
    instanceName: instanceName,
  );

  static Future<void> unlockSeafileLibrary(
    String serverId,
    String repositoryId,
    String password, {
    String instanceName = '',
  }) => _domains.providers.unlockSeafileLibrary(
    serverId,
    repositoryId,
    password,
    instanceName: instanceName,
  );

  static Future<void> logoutSeafile(String serverId) =>
      _domains.providers.logoutSeafile(serverId);

  static Future<List<SeafileBindInfo>> getAllSeafileBindInfos() =>
      _domains.providers.getAllSeafileBindInfos();

  static Future<SeafileFileListPage> listSeafileRepositories(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) => _domains.providers.listSeafileRepositories(
    serverId,
    page: page,
    pageSize: pageSize,
    instanceName: instanceName,
  );

  static Future<SeafileFileListPage> listSeafileFiles(
    String serverId,
    String repositoryId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listSeafileFiles(
    serverId,
    repositoryId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<SeafileFileListPage> listSeafileStarred(
    String serverId, {
    int page = 1,
    int pageSize = 50,
    String instanceName = '',
  }) => _domains.providers.listSeafileStarred(
    serverId,
    page: page,
    pageSize: pageSize,
    instanceName: instanceName,
  );

  static Future<TrueNasBindInfo> loginTrueNas({
    required String endpoint,
    required String apiKey,
    String instanceName = '',
  }) => _domains.providers.loginTrueNas(
    endpoint: endpoint,
    apiKey: apiKey,
    instanceName: instanceName,
  );

  static Future<void> logoutTrueNas(String serverId) =>
      _domains.providers.logoutTrueNas(serverId);

  static Future<List<TrueNasBindInfo>> getAllTrueNasBindInfos() =>
      _domains.providers.getAllTrueNasBindInfos();

  static Future<TrueNasFileListPage> listTrueNasFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listTrueNasFiles(
    serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<SynologyFileListPage> listSynologyFiles(
    String serverId,
    String path, {
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listSynologyFiles(
    serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<List<SynologyVideoLibraryInfo>> listSynologyLibraries(
    String serverId, {
    String instanceName = '',
  }) => _domains.providers.listSynologyLibraries(
    serverId,
    instanceName: instanceName,
  );

  static Future<SynologyVideoListPage> listSynologyVideos(
    String serverId, {
    required SynologyVideoCollection collection,
    required int libraryId,
    int? tvShowId,
    int page = 1,
    int pageSize = 50,
    String search = '',
    String instanceName = '',
  }) => _domains.providers.listSynologyVideos(
    serverId,
    collection: collection,
    libraryId: libraryId,
    tvShowId: tvShowId,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: instanceName,
  );

  static Future<TwitchBindInfo> bindTwitch({
    required String authToken,
    String deviceId = '',
    String clientIntegrity = '',
    String instanceName = '',
  }) => _domains.providers.bindTwitch(
    authToken: authToken,
    deviceId: deviceId,
    clientIntegrity: clientIntegrity,
    instanceName: instanceName,
  );

  static Future<void> unbindTwitch(String serverId) =>
      _domains.providers.unbindTwitch(serverId);

  static Future<twitch.ResolveResponse> resolveTwitch(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.resolveTwitch(
    resource,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.ListChannelItemsResponse> listTwitchChannelItems(
    String resource, {
    required source_enum.TwitchPlaylistContent content,
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTwitchChannelItems(
    resource,
    content: content,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.ListFollowedLiveResponse> listTwitchFollowedLive({
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTwitchFollowedLive(
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.ListCategoryStreamsResponse> listTwitchCategoryStreams({
    required String categoryId,
    required String categoryName,
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTwitchCategoryStreams(
    categoryId: categoryId,
    categoryName: categoryName,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.ListTopCategoriesResponse> listTwitchTopCategories({
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTwitchTopCategories(
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.SearchLiveChannelsResponse> searchTwitchLiveChannels(
    String query, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.searchTwitchLiveChannels(
    query,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<twitch.ListScheduleResponse> listTwitchSchedule(
    String broadcasterId, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTwitchSchedule(
    broadcasterId,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<huya.ResolveResponse> resolveHuya(
    String resource, {
    String instanceName = '',
  }) => _domains.providers.resolveHuya(resource, instanceName: instanceName);

  static Future<douyu.ResolveResponse> resolveDouyu(
    String resource, {
    String instanceName = '',
  }) => _domains.providers.resolveDouyu(resource, instanceName: instanceName);

  static Future<acfun.ResolveResponse> resolveAcFun(
    String resource, {
    String instanceName = '',
  }) => _domains.providers.resolveAcFun(resource, instanceName: instanceName);

  static Future<cctv.ResolveResponse> resolveCctv(
    String resource, {
    String instanceName = '',
  }) => _domains.providers.resolveCctv(resource, instanceName: instanceName);

  static Future<YoutubeBindInfo> bindYoutube({
    required String label,
    String visitorData = '',
    String poToken = '',
    String cookie = '',
    String instanceName = '',
  }) => _domains.providers.bindYoutube(
    label: label,
    visitorData: visitorData,
    poToken: poToken,
    cookie: cookie,
    instanceName: instanceName,
  );

  static Future<void> unbindYoutube(String serverId) =>
      _domains.providers.unbindYoutube(serverId);

  static Future<youtube.ResolveResponse> resolveYoutube(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.resolveYoutube(
    resource,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<youtube.ListResponse> listYoutube(
    youtube.ListRequest request,
  ) => _domains.providers.listYoutube(request);

  static Future<DouyinBindInfo> bindDouyin({
    required String label,
    required String cookie,
    String instanceName = '',
  }) => _domains.providers.bindDouyin(
    label: label,
    cookie: cookie,
    instanceName: instanceName,
  );

  static Future<void> unbindDouyin(String serverId) =>
      _domains.providers.unbindDouyin(serverId);

  static Future<douyin.ResolveResponse> resolveDouyin(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.resolveDouyin(
    resource,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<douyin.ListUserPostsResponse> listDouyinUserPosts(
    String secUid, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listDouyinUserPosts(
    secUid,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<TikTokBindInfo> bindTikTok({
    required String label,
    required String cookie,
    String instanceName = '',
  }) => _domains.providers.bindTikTok(
    label: label,
    cookie: cookie,
    instanceName: instanceName,
  );

  static Future<void> unbindTikTok(String serverId) =>
      _domains.providers.unbindTikTok(serverId);

  static Future<tiktok.ResolveResponse> resolveTikTok(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.resolveTikTok(
    resource,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<tiktok.GetUserResponse> getTikTokUser(
    String resource, {
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.getTikTokUser(
    resource,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<tiktok.ListUserPostsResponse> listTikTokUserPosts(
    String secUid, {
    String? cursor,
    int pageSize = 20,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listTikTokUserPosts(
    secUid,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<void> logoutEmby(String serverId) {
    return _domains.providers.logoutEmby(serverId);
  }

  static Future<void> logoutBilibili() async {
    await _domains.providers.logoutBilibili();
  }

  static Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    return _domains.providers.getBilibiliAccount(instanceName: instanceName);
  }

  static Future<List<BilibiliLiveAreaInfo>> listBilibiliLiveAreas({
    String instanceName = '',
    bool shared = false,
  }) {
    return _domains.providers.listBilibiliLiveAreas(
      instanceName: instanceName,
      shared: shared,
    );
  }

  static Future<List<BilibiliFavoriteFolderInfo>> listBilibiliFavoriteFolders({
    String instanceName = '',
    bool shared = false,
  }) {
    return _domains.providers.listBilibiliFavoriteFolders(
      instanceName: instanceName,
      shared: shared,
    );
  }

  static Future<BilibiliFollowedPgcPage> listBilibiliFollowedPgc({
    required bool cinema,
    int page = 1,
    int pageSize = 30,
    String instanceName = '',
    bool shared = false,
  }) {
    return _domains.providers.listBilibiliFollowedPgc(
      cinema: cinema,
      page: page,
      pageSize: pageSize,
      instanceName: instanceName,
      shared: shared,
    );
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
    return _domains.providers.startBilibiliSmsLogin(instanceName: instanceName);
  }

  static Future<BilibiliSmsLoginInfo> sendBilibiliSms({
    required BilibiliSmsLoginInfo session,
    required String phone,
    required String validate,
  }) async {
    return _domains.providers.sendBilibiliSms(
      session: session,
      phone: phone,
      validate: validate,
    );
  }

  static Future<void> loginBilibiliSms({
    required String sessionToken,
    required String code,
  }) async {
    await _domains.providers.loginBilibiliSms(
      sessionToken: sessionToken,
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

  static Future<List<CloudreveBindInfo>> getCloudreveBindInfos({
    String instanceName = '',
  }) => _domains.providers.getCloudreveBindInfos(instanceName: instanceName);

  static Future<List<CloudreveBindInfo>> getAllCloudreveBindInfos() =>
      _domains.providers.getAllCloudreveBindInfos();

  static Future<List<TwitchBindInfo>> getTwitchBindInfos({
    String instanceName = '',
  }) => _domains.providers.getTwitchBindInfos(instanceName: instanceName);

  static Future<List<TwitchBindInfo>> getAllTwitchBindInfos() =>
      _domains.providers.getAllTwitchBindInfos();

  static Future<List<YoutubeBindInfo>> getYoutubeBindInfos({
    String instanceName = '',
  }) => _domains.providers.getYoutubeBindInfos(instanceName: instanceName);

  static Future<List<YoutubeBindInfo>> getAllYoutubeBindInfos() =>
      _domains.providers.getAllYoutubeBindInfos();

  static Future<List<DouyinBindInfo>> getDouyinBindInfos({
    String instanceName = '',
  }) => _domains.providers.getDouyinBindInfos(instanceName: instanceName);

  static Future<List<DouyinBindInfo>> getAllDouyinBindInfos() =>
      _domains.providers.getAllDouyinBindInfos();

  static Future<List<TikTokBindInfo>> getTikTokBindInfos({
    String instanceName = '',
  }) => _domains.providers.getTikTokBindInfos(instanceName: instanceName);

  static Future<List<TikTokBindInfo>> getAllTikTokBindInfos() =>
      _domains.providers.getAllTikTokBindInfos();

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

  static Future<CloudreveAccountInfo> getCloudreveAccount(
    String serverId, {
    String instanceName = '',
  }) => _domains.providers.getCloudreveAccount(
    serverId,
    instanceName: instanceName,
  );

  static Future<bilibili.ListHistoryResponse> listBilibiliHistory({
    source_enum.BilibiliHistoryType type =
        source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ALL,
    String? cursor,
    int pageSize = 30,
    String instanceName = '',
  }) => _domains.providers.listBilibiliHistory(
    type: type,
    cursor: cursor,
    pageSize: pageSize,
    instanceName: instanceName,
  );

  static Future<BilibiliPgcTimelineInfo> listBilibiliPgcTimeline({
    required BilibiliPgcTimelineKind type,
    int beforeDays = 3,
    int afterDays = 7,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listBilibiliPgcTimeline(
    type: type,
    beforeDays: beforeDays,
    afterDays: afterDays,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<BilibiliPgcSeasonPage> listBilibiliPgcSeasons({
    required BilibiliPgcSeasonKind type,
    int page = 1,
    int pageSize = 30,
    BilibiliPgcSeasonOrder order = BilibiliPgcSeasonOrder.updated,
    bool ascending = false,
    bool? finished,
    String? area,
    String? year,
    int? styleId,
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listBilibiliPgcSeasons(
    type: type,
    page: page,
    pageSize: pageSize,
    order: order,
    ascending: ascending,
    finished: finished,
    area: area,
    year: year,
    styleId: styleId,
    instanceName: instanceName,
    shared: shared,
  );

  static Future<BilibiliParseInfo> parseBilibiliInfo(
    String url, {
    String instanceName = '',
    bool shared = false,
  }) async {
    return _domains.providers.parseBilibiliInfo(
      url,
      instanceName: instanceName,
      shared: shared,
    );
  }

  static Future<BilibiliPlaylistListPage> listBilibiliPlaylist(
    BilibiliPlaylistListIntent intent, {
    int page = 1,
    int pageSize = 30,
    String? cursor,
    String search = '',
    String instanceName = '',
    bool shared = false,
  }) => _domains.providers.listBilibiliPlaylist(
    intent,
    page: page,
    pageSize: pageSize,
    cursor: cursor,
    search: search,
    instanceName: instanceName,
    shared: shared,
  );

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
    bool passwordless = false,
    String instanceName = '',
  }) async {
    return _domains.providers.loginEmbyInfo(
      host,
      username,
      password,
      apiKey: apiKey,
      passwordless: passwordless,
      instanceName: instanceName,
    );
  }

  static Future<CloudreveListPage> listCloudrevePage(
    String path, {
    String? keyword,
    int page = 1,
    int max = 20,
    int? offset,
    String? cursor,
    String serverId = '',
    String instanceName = '',
  }) => _domains.providers.listCloudrevePage(
    path,
    keyword: keyword,
    page: page,
    max: max,
    offset: offset,
    cursor: cursor,
    serverId: serverId,
    instanceName: instanceName,
  );

  static Future<EmbyListPage> listEmbyPage(
    EmbyListMode mode, {
    String targetId = '',
    List<String> itemTypes = const [],
    String? keyword,
    int page = 1,
    int max = 20,
    String serverId = '',
    String instanceName = '',
  }) async {
    return _domains.providers.listEmbyPage(
      mode,
      targetId: targetId,
      itemTypes: itemTypes,
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

  static Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  }) async {
    return _domains.roomManagement.getRoomSettings(roomId, refresh: refresh);
  }

  static Future<void> updateRoomSettings(
    String roomId,
    SyncTvRoomSettings settings,
  ) async {
    await _domains.roomManagement.updateRoomSettings(roomId, settings);
  }

  static Future<SyncTvRoom> updateRoomVisibility(
    String roomId,
    bool isPublic,
  ) async {
    final room = await _domains.roomManagement.updateRoomVisibility(
      roomId,
      isPublic,
    );
    _domains.cache.invalidatePrefix('account:rooms');
    _domains.cache.invalidatePrefix('account:favorite-rooms');
    return room;
  }

  static Future<void> updateRoomAutoPlay(
    String roomId, {
    required bool enabled,
    required client_enum.PlayMode mode,
  }) {
    return _domains.roomManagement.updateRoomAutoPlay(
      roomId,
      enabled: enabled,
      mode: mode,
    );
  }

  static Future<void> kickMember(
    String roomId,
    String userId, {
    int kickCooldownSeconds = 60,
  }) {
    return _domains.roomManagement.kickMember(
      roomId,
      userId,
      kickCooldownSeconds: kickCooldownSeconds,
    );
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
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
    bool notify = true,
  }) async {
    await _domains.roomManagement.addRoomMember(
      roomId,
      userId,
      role: role,
      notify: notify,
    );
  }

  static Future<void> updateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  ) async {
    await _domains.roomManagement.updateRoomMemberRemarkName(
      roomId,
      userId,
      remarkName,
    );
  }

  static Future<void> updateRoomMemberDisplayTag(
    String roomId,
    String userId,
    String displayTag,
  ) async {
    await _domains.roomManagement.updateRoomMemberDisplayTag(
      roomId,
      userId,
      displayTag,
    );
  }

  static Future<AdminRoomMember> setRoomMemberRole(
    String roomId,
    String userId,
    common_enum.RoomMemberRole role,
  ) => _domains.roomManagement.setRoomMemberRole(roomId, userId, role);

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
    common_enum.UserRole role, {
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

  static Future<SyncTvUser> adminGetUser(String userId) {
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

  static Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) {
    return _domains.admin.getSettings(refresh: refresh);
  }

  static Future<void> adminBanUser(
    String userId,
    bool ban, {
    String reason = '',
  }) {
    return _domains.admin.banUser(userId, ban, reason: reason);
  }

  static Future<void> adminModerateRoomChatUser(
    String roomId,
    String userId, {
    required bool deleteAllMessages,
    required bool deleteAllReactions,
    required bool ban,
    String messageId = '',
    String reason = '',
  }) {
    return _domains.admin.moderateRoomChatUser(
      roomId,
      userId,
      deleteAllMessages: deleteAllMessages,
      deleteAllReactions: deleteAllReactions,
      ban: ban,
      messageId: messageId,
      reason: reason,
    );
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
    String categoryId = '',
    List<String> labelIds = const [],
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
      categoryId: categoryId,
      labelIds: labelIds,
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

  static Future<SyncTvRoom> adminGetRoom(String roomId) {
    return _domains.admin.getRoom(roomId);
  }

  static Future<SyncTvRoomSettings> adminGetRoomSettings(
    String roomId, {
    bool refresh = false,
  }) {
    return _domains.admin.getRoomSettings(roomId, refresh: refresh);
  }

  static Future<void> adminUpdateRoomSettings(
    String roomId,
    SyncTvRoomSettings settings,
  ) {
    return _domains.admin.updateRoomSettings(roomId, settings);
  }

  static Future<void> adminResetRoomSettings(String roomId) {
    return _domains.admin.resetRoomSettings(roomId);
  }

  static Future<void> adminUpdateRoomPassword(String roomId, String password) {
    return _domains.admin.updateRoomPassword(roomId, password);
  }

  static Future<List<RoomCategoryInfo>> adminListRoomCategories({
    bool includeDisabled = false,
    bool refresh = false,
  }) {
    return _domains.admin.listRoomCategories(
      includeDisabled: includeDisabled,
      refresh: refresh,
    );
  }

  static Future<RoomCategoryInfo> adminUpsertRoomCategory({
    required String key,
    required String name,
    String description = '',
    int sortOrder = 0,
    bool? isEnabled,
  }) {
    return _domains.admin.upsertRoomCategory(
      key: key,
      name: name,
      description: description,
      sortOrder: sortOrder,
      isEnabled: isEnabled,
    );
  }

  static Future<void> adminDeleteRoomCategory(String categoryId) {
    return _domains.admin.deleteRoomCategory(categoryId);
  }

  static Future<List<RoomLabelInfo>> adminListRoomLabels({
    bool includeDisabled = false,
    String categoryId = '',
    bool refresh = false,
  }) {
    return _domains.admin.listRoomLabels(
      includeDisabled: includeDisabled,
      categoryId: categoryId,
      refresh: refresh,
    );
  }

  static Future<RoomLabelInfo> adminUpsertRoomLabel({
    required String key,
    required String name,
    String description = '',
    String color = '',
    String categoryId = '',
    int sortOrder = 0,
    bool? isEnabled,
  }) {
    return _domains.admin.upsertRoomLabel(
      key: key,
      name: name,
      description: description,
      color: color,
      categoryId: categoryId,
      sortOrder: sortOrder,
      isEnabled: isEnabled,
    );
  }

  static Future<void> adminDeleteRoomLabel(String labelId) {
    return _domains.admin.deleteRoomLabel(labelId);
  }

  static Future<SyncTvRoom> adminUpdateRoomTaxonomy(
    String roomId, {
    String? categoryId,
    List<String> labelIds = const [],
    bool clearCategory = false,
  }) {
    return _domains.admin.updateRoomTaxonomy(
      roomId,
      categoryId: categoryId,
      labelIds: labelIds,
      clearCategory: clearCategory,
    );
  }

  static Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) {
    return _domains.admin.updateSettingInSection(section, key, value);
  }

  static Future<String> adminSendTestEmail(String to) {
    return _domains.admin.sendTestEmail(to);
  }

  static Future<AdminServiceState> adminGetServiceState() {
    return _domains.admin.getServiceState();
  }

  static Future<AdminSliceCacheStats> adminGetSliceCacheStats({
    String nodeId = '',
    bool allNodes = false,
  }) {
    return _domains.admin.getSliceCacheStats(
      nodeId: nodeId,
      allNodes: allNodes,
    );
  }

  static Future<AdminSliceCacheOperationResult> adminPurgeSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) {
    return _domains.admin.purgeSliceCache(nodeId: nodeId, allNodes: allNodes);
  }

  static Future<AdminSliceCacheOperationResult> adminEvictExpiredSliceCache({
    String nodeId = '',
    bool allNodes = false,
  }) {
    return _domains.admin.evictExpiredSliceCache(
      nodeId: nodeId,
      allNodes: allNodes,
    );
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

  static Future<List<SyncTvUser>> adminListAdmins({String search = ''}) {
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
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
    bool notify = true,
  }) {
    return _domains.admin.addRoomMember(
      roomId,
      userId,
      role: role,
      notify: notify,
    );
  }

  static Future<void> adminUpdateRoomMemberRemarkName(
    String roomId,
    String userId,
    String remarkName,
  ) {
    return _domains.admin.updateRoomMemberRemarkName(
      roomId,
      userId,
      remarkName,
    );
  }

  static Future<void> adminUpdateRoomMemberDisplayTag(
    String roomId,
    String userId,
    String displayTag,
  ) {
    return _domains.admin.updateRoomMemberDisplayTag(
      roomId,
      userId,
      displayTag,
    );
  }

  static Future<void> adminSetRoomMemberRole(
    String roomId,
    String userId,
    common_enum.RoomMemberRole role,
  ) {
    return _domains.admin.setRoomMemberRole(roomId, userId, role);
  }

  static Future<void> adminUpdateRoomMemberPermissionOverrides(
    String roomId,
    String userId, {
    common_enum.RoomMemberRole role =
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
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
            .ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
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
            .ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
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
    admin_enum.BanTargetType targetType =
        admin_enum.BanTargetType.BAN_TARGET_TYPE_UNSPECIFIED,
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

  static Future<AdminContentReportsPage> adminListContentReportsPage({
    int page = 1,
    int pageSize = 50,
    admin_enum.ContentReportStatus status =
        admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
    admin_enum.ContentReportTargetType targetType = admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    String reporterUserId = '',
    String roomId = '',
    String targetRoomId = '',
    String targetUserId = '',
    String targetMemberRoomId = '',
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
    admin_enum.ContentReportScope scope =
        admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED,
    String search = '',
  }) {
    return _domains.admin.listContentReportsPage(
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
      targetChatMessageId: targetChatMessageId,
      scope: scope,
      search: search,
    );
  }

  static Future<AdminContentReport> adminGetContentReport(String reportId) {
    return _domains.admin.getContentReport(reportId);
  }

  static Future<AdminContentReport> adminUpdateContentReportStatus(
    String reportId,
    admin_enum.ContentReportStatus status, {
    String resolutionNote = '',
  }) {
    return _domains.admin.updateContentReportStatus(
      reportId,
      status,
      resolutionNote: resolutionNote,
    );
  }

  static Future<AdminContentReportsPage> listRoomContentReportsPage(
    String roomId, {
    int page = 1,
    int pageSize = 50,
    admin_enum.ContentReportStatus status =
        admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_UNSPECIFIED,
    admin_enum.ContentReportTargetType targetType = admin_enum
        .ContentReportTargetType
        .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    String targetMemberUserId = '',
    int targetChatMessageId = 0,
    String search = '',
  }) {
    return _domains.admin.listRoomContentReportsPage(
      roomId,
      page: page,
      pageSize: pageSize,
      status: status,
      targetType: targetType,
      targetMemberUserId: targetMemberUserId,
      targetChatMessageId: targetChatMessageId,
      search: search,
    );
  }

  static Future<AdminContentReport> getRoomContentReport(
    String roomId,
    String reportId,
  ) {
    return _domains.admin.getRoomContentReport(roomId, reportId);
  }

  static Future<AdminContentReport> updateRoomContentReportStatus(
    String roomId,
    String reportId,
    admin_enum.ContentReportStatus status, {
    String resolutionNote = '',
  }) {
    return _domains.admin.updateRoomContentReportStatus(
      roomId,
      reportId,
      status,
      resolutionNote: resolutionNote,
    );
  }

  static Future<AdminReviewsPage> adminListReviewsPage({
    required AdminReviewKind kind,
    int page = 1,
    int pageSize = 50,
    common_enum.ReviewStatus status =
        common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
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

  static Future<void> adminApproveReview(
    AdminReviewKind kind,
    String requestId,
  ) {
    return _domains.admin.approveReview(kind, requestId);
  }

  static Future<void> adminRejectReview(
    AdminReviewKind kind,
    String requestId, {
    String reason = '',
  }) {
    return _domains.admin.rejectReview(kind, requestId, reason: reason);
  }
}
