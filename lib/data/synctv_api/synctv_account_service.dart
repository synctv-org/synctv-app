import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class SyncTvAccountDomainService {
  SyncTvAccountDomainService({required this._api, SyncTvMemoryCache? cache})
    : _cache = cache ?? SyncTvMemoryCache();

  final SyncTvApiClient _api;
  final SyncTvMemoryCache _cache;

  Future<SyncTvUser> getMe({bool refresh = false}) async {
    return switch (_api.session.identity) {
      GuestSessionIdentity(:final roomId, :final displayName) => SyncTvUser(
        id: roomId,
        username: displayName,
        role: const RoomMembershipRole(
          common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
        ),
      ),
      AccountSessionIdentity() => _cache.get<SyncTvUser>(
        'account:me',
        ttl: const Duration(minutes: 2),
        refresh: refresh,
        loader: _fetchMe,
      ),
      AnonymousSessionIdentity() => throw StateError(
        'Current session is anonymous',
      ),
    };
  }

  Future<SyncTvUser> _fetchMe() async {
    final user = await _api.user.getProfile(client.GetProfileRequest());
    return _api.mapUser(user);
  }

  Future<BlockedUserInfo> blockUser(String userId) async {
    final response = await _api.user.blockUser(
      client.BlockUserRequest(userId: userId),
    );
    if (!response.hasBlockedUser() || !response.blockedUser.hasUser()) {
      throw StateError('Block user response is missing the blocked user');
    }
    return BlockedUserInfo(
      user: _api.mapPublicUser(response.blockedUser.user),
      blockedAt: response.blockedUser.blockedAt.toInt(),
    );
  }

  Future<void> unblockUser(String userId) async {
    await _api.user.unblockUser(client.UnblockUserRequest(userId: userId));
  }

  Future<BlockedUsersPage> listBlockedUsers({
    int page = 1,
    int pageSize = 50,
    String? search,
  }) async {
    final response = await _api.user.listBlockedUsers(
      client.ListBlockedUsersRequest(
        page: page,
        pageSize: pageSize,
        search: search ?? '',
      ),
    );
    return BlockedUsersPage(
      users: response.users
          .where((blocked) => blocked.hasUser())
          .map(
            (blocked) => BlockedUserInfo(
              user: _api.mapPublicUser(blocked.user),
              blockedAt: blocked.blockedAt.toInt(),
            ),
          )
          .toList(growable: false),
      total: response.total,
    );
  }

  Future<SyncTvUser> updateUsername(String username) async {
    await _api.user.setUsername(
      client.SetUsernameRequest(newUsername: username),
    );
    final user = await _fetchMe();
    _cache.put('account:me', user, ttl: const Duration(minutes: 2));
    return user;
  }

  Future<String> startEmailBind(String email) async {
    final response = await _api.user.startEmailBind(
      client.StartEmailBindRequest(email: email),
    );
    return response.maskedEmail;
  }

  Future<SyncTvUser> confirmEmailBind({
    required String email,
    required String token,
    required String verificationId,
  }) async {
    final response = await _api.user.confirmEmailBind(
      client.ConfirmEmailBindRequest(
        email: email,
        token: token,
        verificationId: verificationId,
      ),
    );
    final user = _api.mapUser(response);
    _cache.put('account:me', user, ttl: const Duration(minutes: 2));
    _cache.invalidate('account:preferences');
    return user;
  }

  Future<SyncTvUser> unbindEmail({required String verificationId}) async {
    final response = await _api.user.unbindEmail(
      client.UnbindEmailRequest(verificationId: verificationId),
    );
    final user = _api.mapUser(response);
    _cache.put('account:me', user, ttl: const Duration(minutes: 2));
    _cache.invalidate('account:preferences');
    return user;
  }

  Future<AccountPreferences> getAccountPreferences({bool refresh = false}) {
    return _cache.get<AccountPreferences>(
      'account:preferences',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: _fetchAccountPreferences,
    );
  }

  Future<AccountPreferences> _fetchAccountPreferences() async {
    final response = await _api.user.getUserPreferences(
      client.GetUserPreferencesRequest(),
    );
    return accountPreferencesFromProto(
      response.preferences,
      response.authFactors,
    );
  }

  Future<AccountPreferences> updateAccountPreferences({
    NotificationPreferences? notifications,
  }) async {
    final request = client.UpdateUserPreferencesRequest();
    final notificationPreferences = notifications?.toProto();
    if (notificationPreferences != null) {
      request.notifications = notificationPreferences;
    }
    final response = await _api.user.updateUserPreferences(request);
    final preferences = accountPreferencesFromProto(
      response.preferences,
      response.authFactors,
    );
    _cache.put(
      'account:preferences',
      preferences,
      ttl: const Duration(minutes: 2),
    );
    return preferences;
  }

  Future<AccountPreferences> setTwoFactorEnabled({
    required bool enabled,
    required String verificationId,
  }) async {
    final response = await _api.user.setTwoFactorEnabled(
      client.SetTwoFactorEnabledRequest(
        enabled: enabled,
        verificationId: verificationId,
      ),
    );
    final preferences = accountPreferencesFromProto(
      response.preferences,
      response.authFactors,
    );
    _cache.put(
      'account:preferences',
      preferences,
      ttl: const Duration(minutes: 2),
    );
    return preferences;
  }

  Future<List<PasskeyCredentialInfo>> listPasskeys({
    bool refresh = false,
  }) async {
    return _cache.get<List<PasskeyCredentialInfo>>(
      'account:passkeys',
      ttl: const Duration(minutes: 2),
      refresh: refresh,
      loader: _fetchPasskeys,
    );
  }

  Future<List<PasskeyCredentialInfo>> _fetchPasskeys() async {
    final response = await _api.user.listPasskeys(client.ListPasskeysRequest());
    return response.credentials.map(passkeyFromProto).toList(growable: false);
  }

  Future<void> deletePasskey(
    String credentialId, {
    required String verificationId,
  }) async {
    await _api.user.deletePasskey(
      client.DeletePasskeyRequest(
        credentialId: credentialId,
        verificationId: verificationId,
      ),
    );
    _cache.invalidate('account:passkeys');
    _cache.invalidate('account:preferences');
  }

  Future<OpaquePasswordUpdateStart> startOpaquePasswordUpdate({
    List<int> credentialRequest = const [],
    required List<int> registrationRequest,
    required client_enum.OpaquePasswordUpdateVerificationMethod
    verificationMethod,
    String emailToken = '',
  }) async {
    final response = await _api.user.startOpaquePasswordUpdate(
      client.StartOpaquePasswordUpdateRequest(
        credentialRequest: credentialRequest,
        registrationRequest: registrationRequest,
        verificationMethod: verificationMethod,
        emailToken: emailToken,
      ),
    );
    return OpaquePasswordUpdateStart(
      sessionId: response.sessionId,
      credentialResponse: response.credentialResponse,
      registrationResponse: response.registrationResponse,
      passkeySessionId: response.passkeySessionId,
      passkeyOptions: _api.encodeJsonBytes(
        passkeyChallengeToJson(response.passkeyOptions),
      ),
    );
  }

  Future<SyncTvUser> finishOpaquePasswordUpdate({
    required String sessionId,
    List<int> credentialFinalization = const [],
    required List<int> registrationUpload,
    String passkeySessionId = '',
    Object? passkeyCredential,
  }) async {
    final response = await _api.user.finishOpaquePasswordUpdate(
      client.FinishOpaquePasswordUpdateRequest(
        sessionId: sessionId,
        credentialFinalization: credentialFinalization,
        registrationUpload: registrationUpload,
        passkeySessionId: passkeySessionId,
        passkeyCredential: passkeyCredential == null
            ? null
            : passkeyAuthenticationCredentialFromJson(passkeyCredential),
      ),
    );
    return _api.mapUser(response);
  }

  Future<PasskeyChallengeStart> startPasskeyBind({String name = ''}) async {
    final response = await _api.user.startPasskeyBind(
      client.StartPasskeyBindRequest(name: name),
    );
    return PasskeyChallengeStart(
      sessionId: response.sessionId,
      options: _api.encodeJsonBytes(passkeyChallengeToJson(response.options)),
    );
  }

  Future<PasskeyCredentialInfo> finishPasskeyBind({
    required String sessionId,
    required Object credential,
    required String verificationId,
  }) async {
    final response = await _api.user.finishPasskeyBind(
      client.FinishPasskeyBindRequest(
        sessionId: sessionId,
        credential: passkeyRegistrationCredentialFromJson(credential),
        verificationId: verificationId,
      ),
    );
    final passkey = passkeyFromProto(response);
    _cache.invalidate('account:passkeys');
    _cache.invalidate('account:preferences');
    return passkey;
  }

  Future<TotpSetupInfo> startTotpSetup({required String verificationId}) async {
    final response = await _api.user.startTotpSetup(
      client.StartTotpSetupRequest(verificationId: verificationId),
    );
    return TotpSetupInfo(
      setupId: response.setupId,
      secret: response.secret,
      otpauthUri: response.otpauthUri,
      expiresAt: response.expiresAt.toInt(),
    );
  }

  Future<List<String>> finishTotpSetup({
    required String setupId,
    required String code,
  }) async {
    final response = await _api.user.finishTotpSetup(
      client.FinishTotpSetupRequest(setupId: setupId, code: code),
    );
    _cache.invalidate('account:preferences');
    return List.unmodifiable(response.recoveryCodes);
  }

  Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  }) async {
    final response = await _api.user.regenerateTotpRecoveryCodes(
      client.RegenerateTotpRecoveryCodesRequest(verificationId: verificationId),
    );
    _cache.invalidate('account:preferences');
    return List.unmodifiable(response.recoveryCodes);
  }

  Future<void> deleteTotp({required String verificationId}) async {
    await _api.user.deleteTotp(
      client.DeleteTotpRequest(verificationId: verificationId),
    );
    _cache.invalidate('account:preferences');
  }
}

class SyncTvNotificationDomainService {
  SyncTvNotificationDomainService(this._api, {SyncTvMemoryCache? cache})
    : _cache = cache ?? SyncTvMemoryCache();

  final SyncTvApiClient _api;
  final SyncTvMemoryCache _cache;

  Future<UserNotificationsPage> listNotifications({
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
    final key = [
      'account:notifications',
      page,
      pageSize,
      isRead,
      notificationType?.value,
      search,
      sortBy.value,
      sortDirection.value,
    ].join('|');
    return _cache.get<UserNotificationsPage>(
      key,
      ttl: const Duration(seconds: 45),
      refresh: refresh,
      loader: () => _fetchNotifications(
        page: page,
        pageSize: pageSize,
        isRead: isRead,
        notificationType: notificationType,
        search: search,
        sortBy: sortBy,
        sortDirection: sortDirection,
      ),
    );
  }

  Future<UserNotificationsPage> _fetchNotifications({
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
    final request = client.ListNotificationsRequest(
      page: page,
      pageSize: pageSize,
      search: search,
      sortBy: sortBy,
      sortDirection: sortDirection,
    );
    if (isRead != null) request.isRead = isRead;
    if (notificationType != null) request.notificationType = notificationType;

    final response = await _api.notifications.listNotifications(request);
    return UserNotificationsPage(
      notifications: response.notifications
          .map(notificationFromProto)
          .toList(growable: false),
      total: response.total,
      unreadCount: response.unreadCount,
    );
  }

  Future<UserNotificationItem> getNotification(int notificationId) async {
    final response = await _api.notifications.getNotification(
      client.GetNotificationRequest(notificationId: Int64(notificationId)),
    );
    return notificationFromProto(response);
  }

  Future<void> markNotificationAsRead(UserNotificationItem item) async {
    if (item.numericId <= 0) return;
    await markNotificationsAsRead([item.numericId]);
  }

  Future<void> markNotificationsAsRead(List<int> notificationIds) async {
    final ids = notificationIds
        .where((id) => id > 0)
        .map(Int64.new)
        .toList(growable: false);
    if (ids.isEmpty) return;
    await _api.notifications.markAsRead(
      client.MarkAsReadRequest(notificationIds: ids),
    );
    _cache.invalidatePrefix('account:notifications');
  }

  Future<void> markAllNotificationsAsRead() async {
    await _api.notifications.markAllAsRead(client.MarkAllAsReadRequest());
    _cache.invalidatePrefix('account:notifications');
  }

  Future<void> deleteNotification(UserNotificationItem item) async {
    if (item.numericId <= 0) return;
    await _api.notifications.deleteNotification(
      client.DeleteNotificationRequest(notificationId: Int64(item.numericId)),
    );
    _cache.invalidatePrefix('account:notifications');
  }

  Future<void> deleteAllReadNotifications() async {
    await _api.notifications.deleteAllRead(client.DeleteAllReadRequest());
    _cache.invalidatePrefix('account:notifications');
  }
}

UserNotificationItem notificationFromProto(
  client.NotificationProto notification,
) {
  return UserNotificationItem(
    numericId: int.tryParse(notification.id) ?? 0,
    id: notification.id,
    type: notification.notificationType,
    title: notification.title,
    content: notification.content,
    data: notificationDataToJson(notification.data),
    isRead: notification.isRead,
    createdAt: notification.createdAt.toInt(),
    updatedAt: notification.updatedAt.toInt(),
  );
}

PasskeyCredentialInfo passkeyFromProto(client.PasskeyCredential credential) {
  return PasskeyCredentialInfo(
    credentialId: credential.credentialId,
    name: credential.name,
    signCount: credential.signCount.toInt(),
    createdAt: credential.createdAt.toInt(),
    updatedAt: credential.updatedAt.toInt(),
    lastUsedAt: credential.lastUsedAt.toInt(),
  );
}

AccountPreferences accountPreferencesFromProto(
  client.UserPreferences preferences,
  client.UserAuthFactors authFactors,
) {
  return AccountPreferences(
    twoFactorEnabled: preferences.twoFactorEnabled,
    canUsePassword: authFactors.password,
    canUsePasskey: authFactors.webauthn,
    canUseTotp: authFactors.totp,
    totpRecoveryCodesRemaining: authFactors.totpRecoveryCodesRemaining,
    canUseEmail: authFactors.email,
    eligibleFactorCount: authFactors.eligibleCount,
    notifications: NotificationPreferences.fromProto(preferences.notifications),
    settings: roomSettingsToJson(preferences.settings),
  );
}

Map<String, dynamic> decodeJsonBytes(List<int> bytes) {
  if (bytes.isEmpty) return <String, dynamic>{};
  try {
    final decoded = jsonDecode(utf8.decode(bytes));
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  } catch (_) {
    return <String, dynamic>{};
  }
}
