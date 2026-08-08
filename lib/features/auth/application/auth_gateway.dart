import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';

abstract interface class AuthGateway {
  String get serverBaseUrl;

  String? get activeServerName;

  Future<PublicSettingsInfo> getPublicSettings();

  Future<List<OAuth2ProviderOption>> listOAuth2Providers();

  Future<LoginStart> startLogin(String identifier);

  Future<void> requestEmailLogin(String loginSessionId);

  Future<AuthResult> confirmEmailLogin(String loginSessionId, String token);

  Future<PasskeyChallengeStart> startPasskeyLogin({
    required String loginSessionId,
  });

  Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  });

  Future<String> requestEmailRegistration({
    required String username,
    required String email,
  });

  Future<AuthResult> confirmEmailRegistration({
    required String emailToken,
    required String password,
  });

  Future<PasskeyChallengeStart> startPasskeyRegistration({
    required String username,
    required String email,
    required String name,
  });

  Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  });

  Future<void> createGuestSession(String roomId);

  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  });

  Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  });

  Future<String> requestMfaEmailCode(String mfaSessionId);

  Future<AuthResult> verifyMfaEmailCode({
    required String mfaSessionId,
    required String emailToken,
  });

  Future<MfaPasskeyChallengeStart> startMfaPasskey(String mfaSessionId);

  Future<AuthResult> finishMfaPasskey({
    required String mfaSessionId,
    required String passkeySessionId,
    required Object credential,
  });

  Future<AuthResult> verifyMfaTotp({
    required String mfaSessionId,
    required String code,
  });

  Future<AuthResult> verifyMfaRecoveryCode({
    required String mfaSessionId,
    required String recoveryCode,
  });

  Future<String> requestPasswordReset(String email);
}
