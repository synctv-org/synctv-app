import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

abstract interface class AccountGateway {
  String get serverBaseUrl;

  String? get activeServerName;

  Future<SyncTvUser> getCurrentUser({bool refresh = false});

  Future<BlockedUserInfo> blockUser(String userId);

  Future<void> unblockUser(String userId);

  Future<BlockedUsersPage> listBlockedUsers({
    int page = 1,
    int pageSize = 50,
    String? search,
  });

  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false});

  Future<AccountPreferences> getPreferences({bool refresh = false});

  Future<AccountPreferences> updatePreferences({
    NotificationPreferences? notifications,
  });

  Future<AccountPreferences> setTwoFactorEnabled({
    required bool enabled,
    required String verificationId,
  });

  Future<SyncTvUser> updateUsername(String username);

  Future<SyncTvUser> updateAvatar(LocalImageUpload upload);

  Future<SyncTvUser> clearAvatar();

  Future<String> startEmailBind(String email);

  Future<SyncTvUser> confirmEmailBind({
    required String email,
    required String token,
    required String verificationId,
  });

  Future<SyncTvUser> unbindEmail({required String verificationId});

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
  });

  Future<UserNotificationItem> getNotification(int notificationId);

  Future<void> markNotificationAsRead(UserNotificationItem item);

  Future<void> markNotificationsAsRead(List<int> notificationIds);

  Future<void> markAllNotificationsAsRead();

  Future<void> deleteNotification(UserNotificationItem item);

  Future<void> deleteAllReadNotifications();

  Future<List<OAuth2ProviderOption>> listOAuth2Providers();

  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts();

  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  });

  Future<void> finishOAuth2Bind({required String code, required String state});

  Future<void> unlinkOAuth2Account(
    OAuth2LinkedAccount account, {
    required String verificationId,
  });

  Future<List<PasskeyCredentialInfo>> listPasskeys({bool refresh = false});

  Future<void> deletePasskey(
    String credentialId, {
    required String verificationId,
  });

  Future<PasskeyChallengeStart> startPasskeyBind({String name = ''});

  Future<PasskeyCredentialInfo> finishPasskeyBind({
    required String sessionId,
    required Object credential,
    required String verificationId,
  });

  Future<TotpSetupInfo> startTotpSetup({required String verificationId});

  Future<List<String>> finishTotpSetup({
    required String setupId,
    required String code,
  });

  Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  });

  Future<void> deleteTotp({required String verificationId});

  Future<String> requestPasswordReset(String email);

  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification();

  Future<SensitiveOperationPasskeyStart> startSensitiveOperationPasskey(
    String sessionId,
  );

  Future<SensitiveOperationEmailCodeInfo> requestSensitiveOperationEmailCode(
    String sessionId,
  );

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
  });

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
  });

  Future<SyncTvRoom> getRoom(String roomId);

  Future<SyncTvRoomSettings> getRoomSettings(String roomId);

  Future<void> deleteRoom(String roomId);

  Future<void> leaveRoom(String roomId);

  Future<void> closeAccount();
}
