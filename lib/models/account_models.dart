import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

class OAuth2ProviderOption {
  final String name;
  final String type;
  final bool signupEnabled;
  final bool signupNeedReview;

  const OAuth2ProviderOption({
    required this.name,
    required this.type,
    required this.signupEnabled,
    required this.signupNeedReview,
  });
}

class OAuth2AuthorizationStart {
  final String provider;
  final String authorizationUrl;
  final String state;

  const OAuth2AuthorizationStart({
    required this.provider,
    required this.authorizationUrl,
    required this.state,
  });
}

class OAuth2CallbackPayload {
  final String code;
  final String state;

  const OAuth2CallbackPayload({
    required this.code,
    required this.state,
  });
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

class AuthResult {
  final SyncTvUser? user;
  final MfaChallengeInfo? mfa;
  final bool registrationReviewRequired;
  final String registrationReviewId;
  final String redirectUrl;
  final int expiresIn;
  final bool oauth2Bind;

  const AuthResult({
    this.user,
    this.mfa,
    this.registrationReviewRequired = false,
    this.registrationReviewId = '',
    this.redirectUrl = '',
    this.expiresIn = 0,
    this.oauth2Bind = false,
  });

  bool get authenticated => user != null;
  bool get requiresMfa => mfa != null;
}

class SensitiveOperationVerificationInfo {
  final String verificationId;
  final SensitiveOperationVerificationChallengeInfo challenge;

  const SensitiveOperationVerificationInfo({
    required this.verificationId,
    required this.challenge,
  });
}

class SensitiveOperationVerificationChallengeInfo {
  final String sessionId;
  final List<int> requiredMethods;
  final List<int> completedMethods;
  final List<int> availableMethods;

  const SensitiveOperationVerificationChallengeInfo({
    required this.sessionId,
    required this.requiredMethods,
    required this.completedMethods,
    required this.availableMethods,
  });

  bool get requiresPassword => requiredMethods.contains(
        client_enum.SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD.value,
      );

  bool get requiresPasskey => requiredMethods.contains(
        client_enum.SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN.value,
      );

  bool get requiresEmail => requiredMethods.contains(
        client_enum.SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL.value,
      );
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
  final List<int> availableMethods;
  final String maskedEmail;
  final int expiresAt;

  const MfaChallengeInfo({
    required this.sessionId,
    required this.availableMethods,
    required this.maskedEmail,
    required this.expiresAt,
  });

  bool get supportsEmail => availableMethods.contains(
        client_enum.MfaMethod.MFA_METHOD_EMAIL.value,
      );

  bool get supportsPasskey => availableMethods.contains(
        client_enum.MfaMethod.MFA_METHOD_WEBAUTHN.value,
      );
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

  const PasskeyChallengeStart({
    required this.sessionId,
    required this.options,
  });
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
  final bool canUseEmail;
  final int eligibleFactorCount;
  final NotificationPreferences notifications;
  final Map<String, dynamic> settings;

  const AccountPreferences({
    required this.twoFactorEnabled,
    required this.canUsePassword,
    required this.canUsePasskey,
    required this.canUseEmail,
    required this.eligibleFactorCount,
    required this.notifications,
    this.settings = const {},
  });
}

class UserNotificationItem {
  final int numericId;
  final String id;
  final int type;
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
