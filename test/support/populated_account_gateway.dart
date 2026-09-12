import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart' as oauth;

/// Read-only account data shared by widget checks and the browser preview.
class RecoveryCodesPreviewGateway extends PopulatedAccountPreviewGateway {
  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async =>
      const SensitiveOperationVerificationComplete(
        verificationId: 'preview-verification',
      );

  @override
  Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  }) async => List.generate(
    10,
    (index) => 'TEST-CODE-${index.toString().padLeft(2, '0')}',
  );
}

class UnavailableVerificationPreviewGateway
    extends PopulatedAccountPreviewGateway {
  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async =>
      SensitiveOperationVerificationPending(
        challenge: SensitiveOperationVerificationChallengeInfo(
          sessionId: 'preview-verification',
          requiredCount: 1,
          requiredMethods: const [],
          completedMethods: const [],
          availableMethods: const [],
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        ),
      );
}

class PopulatedAccountPreviewGateway implements AccountGateway {
  static final user = SyncTvUser(
    id: 'preview-user',
    username: 'Preview account',
    email: 'preview@example.test',
    role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
  );

  @override
  String get serverBaseUrl => 'https://example.test';
  @override
  String get activeServerName => 'Preview';

  @override
  Future<SyncTvUser> getCurrentUser({bool refresh = false}) async => user;

  @override
  Future<AccountPreferences> getPreferences({bool refresh = false}) async =>
      AccountPreferences(
        twoFactorEnabled: true,
        canUsePassword: true,
        canUsePasskey: true,
        canUseTotp: true,
        totpRecoveryCodesRemaining: 8,
        canUseEmail: true,
        eligibleFactorCount: 4,
        notifications: NotificationPreferences.defaults(),
      );

  @override
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) async =>
      const PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 10,
        defaultMaxMembers: 10,
        roomCreationApprovalRequired: false,
        roomPasswordPolicy:
            common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_UNSPECIFIED,
        enablePasswordSignup: true,
        passwordSignupNeedReview: false,
        enableEmailSignup: true,
        enableEmail: true,
        enableGuest: true,
        emailSignupNeedReview: false,
        enableWebauthn: true,
        webauthnRpId: 'example.test',
        enableWebauthnSignup: true,
        webauthnSignupNeedReview: false,
        emailWhitelistEnabled: false,
        emailWhitelistDomains: [],
        tsDisguisedAsPng: false,
        rtmpAdvertiseAddress: null,
      );

  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() async => const [
    OAuth2ProviderOption(
      name: 'github',
      type: 'github',
      signupEnabled: true,
      signupNeedReview: false,
      supportedModes: [oauth.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_BROWSER],
    ),
  ];

  @override
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async => const [
    OAuth2LinkedAccount(
      providerType: 'github',
      providerUsername: 'preview-linked-account',
      providerInstanceName: 'github',
      providerIssuer: 'https://example.test',
      providerUserId: 'linked-user',
      linkedAt: 1700000000,
    ),
  ];

  @override
  Future<List<PasskeyCredentialInfo>> listPasskeys({
    bool refresh = false,
  }) async => const [
    PasskeyCredentialInfo(
      credentialId: 'preview-credential',
      name: 'Preview passkey',
      signCount: 1,
      createdAt: 1700000000,
      updatedAt: 1700000000,
      lastUsedAt: 1700000000,
    ),
  ];

  // Mutations and unsupported requests fail immediately instead of reaching a server.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      switch (invocation.memberName) {
        #getRooms => Future.value(
          RoomsPage(
            rooms: [
              SyncTvRoom(
                roomId: 'preview-room',
                roomName: 'Preview watch room',
                creatorId: user.id,
                creator: user.username,
                myRole: common.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                myRelation: client.MyRoomRelation.MY_ROOM_RELATION_CREATED,
              ),
            ],
            total: 1,
            page: 1,
            pageSize: 24,
          ),
        ),
        #listBlockedUsers => Future.value(
          BlockedUsersPage(
            users: [
              BlockedUserInfo(
                user: SyncTvUser(
                  id: 'blocked-user',
                  username: 'Preview blocked user',
                  role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
                ),
                blockedAt: 1700000000,
              ),
            ],
            total: 1,
          ),
        ),
        #listNotifications => Future.value(
          const UserNotificationsPage(
            notifications: [
              UserNotificationItem(
                id: '1',
                type: client.NotificationType.NOTIFICATION_TYPE_UNSPECIFIED,
                title: 'Preview notification',
                content: 'A notification with readable account details.',
                data: {},
                isRead: false,
                createdAt: 1700000000,
                updatedAt: 1700000000,
              ),
            ],
            total: 1,
            unreadCount: 1,
          ),
        ),
        _ => throw UnsupportedError('Read-only account preview'),
      };
}
