import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;

sealed class SyncTvSessionIdentity {
  const SyncTvSessionIdentity();
}

final class AnonymousSessionIdentity extends SyncTvSessionIdentity {
  const AnonymousSessionIdentity();
}

final class AccountSessionIdentity extends SyncTvSessionIdentity {
  const AccountSessionIdentity({this.accessToken, this.refreshToken});

  final String? accessToken;
  final String? refreshToken;
}

final class GuestSessionIdentity extends SyncTvSessionIdentity {
  const GuestSessionIdentity({
    required this.accessToken,
    required this.roomId,
    required this.displayName,
  });

  final String accessToken;
  final String roomId;
  final String displayName;
}

class OAuth2ProviderOption {
  final String name;
  final String type;
  final bool signupEnabled;
  final bool signupNeedReview;
  final List<oauth2_enum.OAuth2ProviderMode> supportedModes;

  const OAuth2ProviderOption({
    required this.name,
    required this.type,
    required this.signupEnabled,
    required this.signupNeedReview,
    this.supportedModes = const [],
  });

  bool get supportsBrowser => supportedModes.contains(
    oauth2_enum.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_BROWSER,
  );

  bool get supportsNative => supportedModes.contains(
    oauth2_enum.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_NATIVE,
  );
}

class OAuth2AuthorizationStart {
  final String provider;

  /// Browser authorization URL. Native authorization omits this value.
  final String? authorizationUrl;
  final String state;
  final oauth2_enum.OAuth2Operation operation;

  /// OIDC nonce used by native authorization when the provider supplies one.
  final String? nonce;

  const OAuth2AuthorizationStart({
    required this.provider,
    required this.authorizationUrl,
    required this.state,
    required this.operation,
    this.nonce,
  });
}

class OAuth2CallbackPayload {
  final String code;
  final String state;

  const OAuth2CallbackPayload({required this.code, required this.state});
}

class OAuth2LinkedAccount {
  final String providerType;
  final String providerUsername;
  final String providerInstanceName;
  final String providerIssuer;
  final String providerUserId;
  final int linkedAt;

  const OAuth2LinkedAccount({
    required this.providerType,
    required this.providerUsername,
    required this.providerInstanceName,
    required this.providerIssuer,
    required this.providerUserId,
    required this.linkedAt,
  });
}

List<OAuth2ProviderOption> oauth2BindableProviders(
  List<OAuth2ProviderOption> providers,
) {
  return List.unmodifiable(providers);
}

sealed class AuthResult {
  const AuthResult();
}

final class Authenticated extends AuthResult {
  const Authenticated(this.user);

  final SyncTvUser user;
}

final class MfaRequired extends AuthResult {
  const MfaRequired(this.challenge);

  final MfaChallengeInfo challenge;
}

final class RegistrationReviewPending extends AuthResult {
  const RegistrationReviewPending({required this.reviewId});

  final String reviewId;
}

sealed class SensitiveOperationVerificationInfo {
  const SensitiveOperationVerificationInfo();
}

final class SensitiveOperationVerificationComplete
    extends SensitiveOperationVerificationInfo {
  final String verificationId;

  const SensitiveOperationVerificationComplete({required this.verificationId});
}

final class SensitiveOperationVerificationPending
    extends SensitiveOperationVerificationInfo {
  final SensitiveOperationVerificationChallengeInfo challenge;

  const SensitiveOperationVerificationPending({required this.challenge});
}

class SensitiveOperationVerificationChallengeInfo {
  final String sessionId;
  final int requiredCount;
  final List<client_enum.SensitiveOperationVerificationMethod> requiredMethods;
  final List<client_enum.SensitiveOperationVerificationMethod> completedMethods;
  final List<client_enum.SensitiveOperationVerificationMethod> availableMethods;
  final DateTime expiresAt;

  const SensitiveOperationVerificationChallengeInfo({
    required this.sessionId,
    required this.requiredCount,
    required this.requiredMethods,
    required this.completedMethods,
    required this.availableMethods,
    required this.expiresAt,
  });

  bool get isExpired => !DateTime.now().isBefore(expiresAt);

  bool get requiresPassword => requiredMethods.contains(
    client_enum
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD,
  );

  bool get requiresPasskey => requiredMethods.contains(
    client_enum
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
  );

  bool get requiresEmail => requiredMethods.contains(
    client_enum
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL,
  );

  bool supportsMethodOnDevice(
    client_enum.SensitiveOperationVerificationMethod method, {
    required bool passkeyAvailable,
  }) {
    if (method ==
            client_enum
                .SensitiveOperationVerificationMethod
                .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN &&
        !passkeyAvailable) {
      return false;
    }
    return availableMethods.contains(method);
  }

  client_enum.SensitiveOperationVerificationMethod? preferredMethodOnDevice({
    required bool passkeyAvailable,
  }) {
    const preferenceOrder = [
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD,
      client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL,
    ];
    for (final method in preferenceOrder) {
      if (supportsMethodOnDevice(method, passkeyAvailable: passkeyAvailable)) {
        return method;
      }
    }
    return null;
  }
}

class SensitiveOperationPasskeyStart {
  final String passkeySessionId;
  final List<int> options;

  const SensitiveOperationPasskeyStart({
    required this.passkeySessionId,
    required this.options,
  });
}

class SensitiveOperationEmailCodeInfo {
  final String message;
  final String maskedEmail;

  const SensitiveOperationEmailCodeInfo({
    required this.message,
    required this.maskedEmail,
  });
}

class MfaChallengeInfo {
  final String sessionId;
  final List<client_enum.MfaMethod> availableMethods;
  final String maskedEmail;
  final DateTime expiresAt;

  const MfaChallengeInfo({
    required this.sessionId,
    required this.availableMethods,
    required this.maskedEmail,
    required this.expiresAt,
  });

  bool get supportsEmail =>
      availableMethods.contains(client_enum.MfaMethod.MFA_METHOD_EMAIL);

  bool get supportsPasskey =>
      availableMethods.contains(client_enum.MfaMethod.MFA_METHOD_WEBAUTHN);

  bool get supportsTotp =>
      availableMethods.contains(client_enum.MfaMethod.MFA_METHOD_TOTP);

  bool get supportsRecoveryCode =>
      availableMethods.contains(client_enum.MfaMethod.MFA_METHOD_RECOVERY_CODE);
}

class OpaqueRegistrationStart {
  final String sessionId;
  final List<int> registrationResponse;

  const OpaqueRegistrationStart({
    required this.sessionId,
    required this.registrationResponse,
  });
}

class OpaqueLoginStart {
  final String sessionId;
  final List<int> credentialResponse;

  const OpaqueLoginStart({
    required this.sessionId,
    required this.credentialResponse,
  });
}

class LoginStart {
  final String sessionId;
  final List<client_enum.LoginMethod> availableMethods;
  final DateTime expiresAt;

  const LoginStart({
    required this.sessionId,
    required this.availableMethods,
    required this.expiresAt,
  });

  bool get supportsPassword =>
      availableMethods.contains(client_enum.LoginMethod.LOGIN_METHOD_PASSWORD);

  bool get supportsPasskey =>
      availableMethods.contains(client_enum.LoginMethod.LOGIN_METHOD_PASSKEY);

  bool get supportsEmailCode => availableMethods.contains(
    client_enum.LoginMethod.LOGIN_METHOD_EMAIL_CODE,
  );
}

class OpaquePasswordUpdateStart {
  final String sessionId;
  final List<int> credentialResponse;
  final List<int> registrationResponse;
  final String passkeySessionId;
  final List<int> passkeyOptions;

  const OpaquePasswordUpdateStart({
    required this.sessionId,
    required this.credentialResponse,
    required this.registrationResponse,
    required this.passkeySessionId,
    required this.passkeyOptions,
  });
}

class PasskeyChallengeStart {
  final String sessionId;
  final List<int> options;

  const PasskeyChallengeStart({required this.sessionId, required this.options});
}

class MfaPasskeyChallengeStart {
  final String passkeySessionId;
  final List<int> options;

  const MfaPasskeyChallengeStart({
    required this.passkeySessionId,
    required this.options,
  });
}

class OpaquePasswordResetStart {
  final String sessionId;
  final List<int> registrationResponse;

  const OpaquePasswordResetStart({
    required this.sessionId,
    required this.registrationResponse,
  });
}

class NotificationPreferences {
  final bool roomInvitationInApp;
  final bool roomEventInApp;
  final bool systemAnnouncementInApp;
  final bool roomInvitationEmail;
  final bool roomEventEmail;
  final bool systemAnnouncementEmail;

  const NotificationPreferences({
    required this.roomInvitationInApp,
    required this.roomEventInApp,
    required this.systemAnnouncementInApp,
    required this.roomInvitationEmail,
    required this.roomEventEmail,
    required this.systemAnnouncementEmail,
  });

  factory NotificationPreferences.defaults() {
    return const NotificationPreferences(
      roomInvitationInApp: true,
      roomEventInApp: true,
      systemAnnouncementInApp: true,
      roomInvitationEmail: false,
      roomEventEmail: false,
      systemAnnouncementEmail: false,
    );
  }

  factory NotificationPreferences.fromProto(
    client.UserNotificationPreferences preferences,
  ) {
    return NotificationPreferences(
      roomInvitationInApp: preferences.roomInvitationInApp,
      roomEventInApp: preferences.roomEventInApp,
      systemAnnouncementInApp: preferences.systemAnnouncementInApp,
      roomInvitationEmail: preferences.roomInvitationEmail,
      roomEventEmail: preferences.roomEventEmail,
      systemAnnouncementEmail: preferences.systemAnnouncementEmail,
    );
  }

  client.UserNotificationPreferences toProto() {
    return client.UserNotificationPreferences(
      roomInvitationInApp: roomInvitationInApp,
      roomEventInApp: roomEventInApp,
      systemAnnouncementInApp: systemAnnouncementInApp,
      roomInvitationEmail: roomInvitationEmail,
      roomEventEmail: roomEventEmail,
      systemAnnouncementEmail: systemAnnouncementEmail,
    );
  }

  NotificationPreferences copyWith({
    bool? roomInvitationInApp,
    bool? roomEventInApp,
    bool? systemAnnouncementInApp,
    bool? roomInvitationEmail,
    bool? roomEventEmail,
    bool? systemAnnouncementEmail,
  }) {
    return NotificationPreferences(
      roomInvitationInApp: roomInvitationInApp ?? this.roomInvitationInApp,
      roomEventInApp: roomEventInApp ?? this.roomEventInApp,
      systemAnnouncementInApp:
          systemAnnouncementInApp ?? this.systemAnnouncementInApp,
      roomInvitationEmail: roomInvitationEmail ?? this.roomInvitationEmail,
      roomEventEmail: roomEventEmail ?? this.roomEventEmail,
      systemAnnouncementEmail:
          systemAnnouncementEmail ?? this.systemAnnouncementEmail,
    );
  }
}

class AccountPreferences {
  final bool twoFactorEnabled;
  final bool canUsePassword;
  final bool canUsePasskey;
  final bool canUseTotp;
  final int totpRecoveryCodesRemaining;
  final bool canUseEmail;
  final int eligibleFactorCount;
  final NotificationPreferences notifications;
  final Map<String, dynamic> settings;

  const AccountPreferences({
    required this.twoFactorEnabled,
    required this.canUsePassword,
    required this.canUsePasskey,
    required this.canUseTotp,
    required this.totpRecoveryCodesRemaining,
    required this.canUseEmail,
    required this.eligibleFactorCount,
    required this.notifications,
    this.settings = const {},
  });
}

class TotpSetupInfo {
  final String setupId;
  final String secret;
  final String otpauthUri;
  final int expiresAt;

  const TotpSetupInfo({
    required this.setupId,
    required this.secret,
    required this.otpauthUri,
    required this.expiresAt,
  });
}

class UserNotificationItem {
  final int numericId;
  final String id;
  final client_enum.NotificationType type;
  final String title;
  final String content;
  final Map<String, dynamic> data;
  final bool isRead;
  final int createdAt;
  final int updatedAt;

  const UserNotificationItem({
    required this.numericId,
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.data,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });
}

class UserNotificationsPage {
  final List<UserNotificationItem> notifications;
  final int total;
  final int unreadCount;

  const UserNotificationsPage({
    required this.notifications,
    required this.total,
    required this.unreadCount,
  });
}

class BlockedUserInfo {
  const BlockedUserInfo({required this.user, required this.blockedAt});

  final SyncTvUser user;
  final int blockedAt;
}

class BlockedUsersPage {
  const BlockedUsersPage({required this.users, required this.total});

  final List<BlockedUserInfo> users;
  final int total;
}

class PasskeyCredentialInfo {
  final String credentialId;
  final String name;
  final int signCount;
  final int createdAt;
  final int updatedAt;
  final int lastUsedAt;

  const PasskeyCredentialInfo({
    required this.credentialId,
    required this.name,
    required this.signCount,
    required this.createdAt,
    required this.updatedAt,
    required this.lastUsedAt,
  });
}
