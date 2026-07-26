import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/auth/infrastructure/passkey_authenticator_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

class SyncTvOpaqueAuthGateway implements OpaqueAuthGateway {
  const SyncTvOpaqueAuthGateway();

  @override
  Future<OpaqueLoginStart> startLogin({
    required String loginSessionId,
    required List<int> credentialRequest,
  }) => SyncTvService.startOpaqueLogin(
    loginSessionId: loginSessionId,
    credentialRequest: credentialRequest,
  );

  @override
  Future<AuthResult> finishLogin({
    required String sessionId,
    required List<int> credentialFinalization,
  }) => SyncTvService.finishOpaqueLogin(
    sessionId: sessionId,
    credentialFinalization: credentialFinalization,
  );

  @override
  Future<OpaqueRegistrationStart> startRegistration({
    required String username,
    required String email,
    required List<int> registrationRequest,
  }) => SyncTvService.startOpaqueRegistration(
    username: username,
    email: email,
    registrationRequest: registrationRequest,
  );

  @override
  Future<AuthResult> finishRegistration({
    required String sessionId,
    required List<int> registrationUpload,
  }) => SyncTvService.finishOpaqueRegistration(
    sessionId: sessionId,
    registrationUpload: registrationUpload,
  );

  @override
  Future<OpaquePasswordUpdateStart> startPasswordUpdate({
    required List<int> registrationRequest,
    List<int> credentialRequest = const [],
    required OpaquePasswordVerification verification,
    String emailToken = '',
  }) => SyncTvService.startOpaquePasswordUpdate(
    registrationRequest: registrationRequest,
    credentialRequest: credentialRequest,
    verificationMethod: switch (verification) {
      OpaquePasswordVerification.currentPassword =>
        client_enum
            .OpaquePasswordUpdateVerificationMethod
            .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD
            .value,
      OpaquePasswordVerification.emailToken =>
        client_enum
            .OpaquePasswordUpdateVerificationMethod
            .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN
            .value,
      OpaquePasswordVerification.passkey =>
        client_enum
            .OpaquePasswordUpdateVerificationMethod
            .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY
            .value,
    },
    emailToken: emailToken,
  );

  @override
  Future<SyncTvUser> finishPasswordUpdate({
    required String sessionId,
    required List<int> registrationUpload,
    List<int> credentialFinalization = const [],
    String passkeySessionId = '',
    Object? passkeyCredential,
  }) => SyncTvService.finishOpaquePasswordUpdate(
    sessionId: sessionId,
    registrationUpload: registrationUpload,
    credentialFinalization: credentialFinalization,
    passkeySessionId: passkeySessionId,
    passkeyCredential: passkeyCredential,
  );

  @override
  Future<Map<String, dynamic>> getPasskeyCredential(List<int> options) {
    return PasskeyAuthenticatorService.getCredential(
      options,
      serverBaseUrl: SyncTvService.baseUrl,
    );
  }

  @override
  Future<OpaquePasswordResetStart> startPasswordReset({
    required String email,
    required String token,
    required List<int> registrationRequest,
  }) => SyncTvService.startOpaquePasswordReset(
    email: email,
    token: token,
    registrationRequest: registrationRequest,
  );

  @override
  Future<void> finishPasswordReset({
    required String sessionId,
    required List<int> registrationUpload,
  }) async {
    await SyncTvService.finishOpaquePasswordReset(
      sessionId: sessionId,
      registrationUpload: registrationUpload,
    );
  }
}
