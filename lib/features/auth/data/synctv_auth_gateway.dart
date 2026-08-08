import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

final class SyncTvAuthGateway implements AuthGateway {
  const SyncTvAuthGateway();

  @override
  String get serverBaseUrl => SyncTvService.baseUrl;

  @override
  String? get activeServerName => SyncTvService.activeServer?.name;

  @override
  Future<PublicSettingsInfo> getPublicSettings() =>
      SyncTvService.getPublicSettings();

  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() =>
      SyncTvService.listOAuth2Providers();

  @override
  Future<LoginStart> startLogin(String identifier) =>
      SyncTvService.startLogin(identifier);

  @override
  Future<void> requestEmailLogin(String loginSessionId) =>
      SyncTvService.requestEmailLogin(loginSessionId);

  @override
  Future<AuthResult> confirmEmailLogin(String loginSessionId, String token) =>
      SyncTvService.confirmEmailLoginResult(loginSessionId, token);

  @override
  Future<PasskeyChallengeStart> startPasskeyLogin({
    required String loginSessionId,
  }) => SyncTvService.startPasskeyLogin(loginSessionId: loginSessionId);

  @override
  Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  }) => SyncTvService.finishPasskeyLogin(
    sessionId: sessionId,
    credential: credential,
  );

  @override
  Future<String> requestEmailRegistration({
    required String username,
    required String email,
  }) =>
      SyncTvService.requestEmailRegistration(username: username, email: email);

  @override
  Future<AuthResult> confirmEmailRegistration({
    required String emailToken,
    required String password,
  }) => SyncTvService.confirmEmailRegistration(
    emailToken: emailToken,
    password: password,
  );

  @override
  Future<PasskeyChallengeStart> startPasskeyRegistration({
    required String username,
    required String email,
    required String name,
  }) => SyncTvService.startPasskeyRegistration(
    username: username,
    email: email,
    name: name,
  );

  @override
  Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  }) => SyncTvService.finishPasskeyRegistration(
    sessionId: sessionId,
    credential: credential,
  );

  @override
  Future<void> createGuestSession(String roomId) async {
    await SyncTvService.createGuestToken(roomId);
  }

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  }) => SyncTvService.startOAuth2Login(
    provider,
    redirectUrl: redirectUrl,
    native: native,
  );

  @override
  Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  }) => SyncTvService.finishOAuth2Login(code: code, state: state);

  @override
  Future<String> requestMfaEmailCode(String mfaSessionId) =>
      SyncTvService.requestMfaEmailCode(mfaSessionId);

  @override
  Future<AuthResult> verifyMfaEmailCode({
    required String mfaSessionId,
    required String emailToken,
  }) => SyncTvService.verifyMfaEmailCode(
    mfaSessionId: mfaSessionId,
    emailToken: emailToken,
  );

  @override
  Future<MfaPasskeyChallengeStart> startMfaPasskey(String mfaSessionId) =>
      SyncTvService.startMfaPasskey(mfaSessionId);

  @override
  Future<AuthResult> finishMfaPasskey({
    required String mfaSessionId,
    required String passkeySessionId,
    required Object credential,
  }) => SyncTvService.finishMfaPasskey(
    mfaSessionId: mfaSessionId,
    passkeySessionId: passkeySessionId,
    credential: credential,
  );

  @override
  Future<AuthResult> verifyMfaTotp({
    required String mfaSessionId,
    required String code,
  }) => SyncTvService.verifyMfaTotp(mfaSessionId: mfaSessionId, code: code);

  @override
  Future<AuthResult> verifyMfaRecoveryCode({
    required String mfaSessionId,
    required String recoveryCode,
  }) => SyncTvService.verifyMfaRecoveryCode(
    mfaSessionId: mfaSessionId,
    recoveryCode: recoveryCode,
  );

  @override
  Future<String> requestPasswordReset(String email) =>
      SyncTvService.requestPasswordReset(email);
}
