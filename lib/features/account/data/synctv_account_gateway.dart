import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

final class SyncTvAccountGateway implements AccountGateway {
  const SyncTvAccountGateway();

  @override
  String get serverBaseUrl => SyncTvService.baseUrl;

  @override
  String? get activeServerName => SyncTvService.activeServer?.name;

  @override
  Future<SyncTvUser> getCurrentUser({bool refresh = false}) =>
      SyncTvService.getMe(refresh: refresh);

  @override
  Future<BlockedUserInfo> blockUser(String userId) =>
      SyncTvService.blockUser(userId);

  @override
  Future<void> unblockUser(String userId) => SyncTvService.unblockUser(userId);

  @override
  Future<BlockedUsersPage> listBlockedUsers({
    int page = 1,
    int pageSize = 50,
    String? search,
  }) => SyncTvService.listBlockedUsers(
    page: page,
    pageSize: pageSize,
    search: search,
  );

  @override
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) =>
      SyncTvService.getPublicSettings(refresh: refresh);

  @override
  Future<AccountPreferences> getPreferences({bool refresh = false}) =>
      SyncTvService.getAccountPreferences(refresh: refresh);

  @override
  Future<AccountPreferences> updatePreferences({
    NotificationPreferences? notifications,
  }) => SyncTvService.updateAccountPreferences(notifications: notifications);

  @override
  Future<AccountPreferences> setTwoFactorEnabled({
    required bool enabled,
    required String verificationId,
  }) => SyncTvService.setTwoFactorEnabled(
    enabled: enabled,
    verificationId: verificationId,
  );

  @override
  Future<SyncTvUser> updateUsername(String username) =>
      SyncTvService.updateUsername(username);

  @override
  Future<SyncTvUser> updateAvatar(LocalImageUpload upload) =>
      SyncTvService.updateUserAvatar(upload);

  @override
  Future<SyncTvUser> clearAvatar() => SyncTvService.clearUserAvatar();

  @override
  Future<String> startEmailBind(String email) =>
      SyncTvService.startEmailBind(email);

  @override
  Future<SyncTvUser> confirmEmailBind({
    required String email,
    required String token,
    required String verificationId,
  }) => SyncTvService.confirmEmailBind(
    email: email,
    token: token,
    verificationId: verificationId,
  );

  @override
  Future<SyncTvUser> unbindEmail({required String verificationId}) =>
      SyncTvService.unbindEmail(verificationId: verificationId);

  @override
  Future<UserNotificationsPage> listNotifications({
    int page = 1,
    int pageSize = 20,
    bool? isRead,
    client.NotificationType? notificationType,
    String search = '',
    client.NotificationListSortBy sortBy =
        client.NotificationListSortBy.NOTIFICATION_LIST_SORT_BY_CREATED_AT,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_DESC,
    bool refresh = false,
  }) => SyncTvService.listNotifications(
    page: page,
    pageSize: pageSize,
    isRead: isRead,
    notificationType: notificationType,
    search: search,
    sortBy: sortBy,
    sortDirection: sortDirection,
    refresh: refresh,
  );

  @override
  Future<UserNotificationItem> getNotification(int notificationId) =>
      SyncTvService.getNotification(notificationId);

  @override
  Future<void> markNotificationAsRead(UserNotificationItem item) =>
      SyncTvService.markNotificationAsRead(item);

  @override
  Future<void> markNotificationsAsRead(List<int> notificationIds) =>
      SyncTvService.markNotificationsAsRead(notificationIds);

  @override
  Future<void> markAllNotificationsAsRead() =>
      SyncTvService.markAllNotificationsAsRead();

  @override
  Future<void> deleteNotification(UserNotificationItem item) =>
      SyncTvService.deleteNotification(item);

  @override
  Future<void> deleteAllReadNotifications() =>
      SyncTvService.deleteAllReadNotifications();

  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() =>
      SyncTvService.listOAuth2Providers();

  @override
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() =>
      SyncTvService.getLinkedOAuth2Accounts();

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) => SyncTvService.startOAuth2Bind(
    provider,
    redirectUrl: redirectUrl,
    verificationId: verificationId,
    native: native,
  );

  @override
  Future<void> finishOAuth2Bind({
    required String code,
    required String state,
  }) => SyncTvService.finishOAuth2Bind(code: code, state: state);

  @override
  Future<void> unlinkOAuth2Account(
    OAuth2LinkedAccount account, {
    required String verificationId,
  }) => SyncTvService.unlinkOAuth2Account(
    account,
    verificationId: verificationId,
  );

  @override
  Future<List<PasskeyCredentialInfo>> listPasskeys({bool refresh = false}) =>
      SyncTvService.listPasskeys(refresh: refresh);

  @override
  Future<void> deletePasskey(
    String credentialId, {
    required String verificationId,
  }) =>
      SyncTvService.deletePasskey(credentialId, verificationId: verificationId);

  @override
  Future<PasskeyChallengeStart> startPasskeyBind({String name = ''}) =>
      SyncTvService.startPasskeyBind(name: name);

  @override
  Future<PasskeyCredentialInfo> finishPasskeyBind({
    required String sessionId,
    required Object credential,
    required String verificationId,
  }) => SyncTvService.finishPasskeyBind(
    sessionId: sessionId,
    credential: credential,
    verificationId: verificationId,
  );

  @override
  Future<TotpSetupInfo> startTotpSetup({required String verificationId}) =>
      SyncTvService.startTotpSetup(verificationId: verificationId);

  @override
  Future<List<String>> finishTotpSetup({
    required String setupId,
    required String code,
  }) => SyncTvService.finishTotpSetup(setupId: setupId, code: code);

  @override
  Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  }) =>
      SyncTvService.regenerateTotpRecoveryCodes(verificationId: verificationId);

  @override
  Future<void> deleteTotp({required String verificationId}) =>
      SyncTvService.deleteTotp(verificationId: verificationId);

  @override
  Future<String> requestPasswordReset(String email) =>
      SyncTvService.requestPasswordReset(email);

  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() =>
      SyncTvService.startSensitiveOperationVerification();

  @override
  Future<SensitiveOperationPasskeyStart> startSensitiveOperationPasskey(
    String sessionId,
  ) => SyncTvService.startSensitiveOperationPasskey(sessionId);

  @override
  Future<SensitiveOperationEmailCodeInfo> requestSensitiveOperationEmailCode(
    String sessionId,
  ) => SyncTvService.requestSensitiveOperationEmailCode(sessionId);

  @override
  Future<SensitiveOperationVerificationInfo>
  finishSensitiveOperationVerification({
    required String sessionId,
    required client.SensitiveOperationVerificationMethod method,
    String password = '',
    String emailToken = '',
    String passkeySessionId = '',
    Object? passkeyCredential,
    String totpCode = '',
    String recoveryCode = '',
  }) => SyncTvService.finishSensitiveOperationVerification(
    sessionId: sessionId,
    method: method,
    password: password,
    emailToken: emailToken,
    passkeySessionId: passkeySessionId,
    passkeyCredential: passkeyCredential,
    totpCode: totpCode,
    recoveryCode: recoveryCode,
  );

  @override
  Future<RoomsPage> getRooms({
    int page = 1,
    int pageSize = 100,
    String? search,
    client.MyRoomRelation relation = client.MyRoomRelation.MY_ROOM_RELATION_ALL,
    client.MyRoomListSortBy sortBy =
        client.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_FREQUENT,
    client.SortDirection sortDirection =
        client.SortDirection.SORT_DIRECTION_DESC,
    bool refresh = false,
  }) => SyncTvService.getMyRoomsPage(
    page: page,
    pageSize: pageSize,
    search: search,
    relation: relation,
    sortBy: sortBy,
    sortDirection: sortDirection,
    refresh: refresh,
  );

  @override
  Future<SyncTvRoom> getRoom(String roomId) =>
      SyncTvService.getRoomInfo(roomId);

  @override
  Future<SyncTvRoomSettings> getRoomSettings(String roomId) =>
      SyncTvService.getRoomSettings(roomId);

  @override
  Future<void> deleteRoom(String roomId) => SyncTvService.deleteRoom(roomId);

  @override
  Future<void> leaveRoom(String roomId) => SyncTvService.leaveRoom(roomId);

  @override
  Future<void> closeAccount() => SyncTvService.closeAccount();
}
