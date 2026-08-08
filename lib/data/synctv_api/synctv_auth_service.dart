import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;

class SyncTvAuthDomainService {
  SyncTvAuthDomainService({required this._api, required this._sessionStore});

  final SyncTvApiClient _api;
  final SyncTvSessionStore _sessionStore;

  Future<AuthResult> registerWithDirectPassword({
    required String username,
    String email = '',
    required String password,
  }) async {
    final response = await _api.auth.registerWithDirectPassword(
      client.RegisterWithDirectPasswordRequest(
        username: username,
        email: email,
        password: password,
      ),
    );
    return _registerResponseToAuthResult(response);
  }

  Future<AuthResult> loginWithDirectPassword({
    required String loginSessionId,
    required String password,
  }) async {
    final request = client.LoginWithDirectPasswordRequest(
      loginSessionId: loginSessionId,
      password: password,
    );
    final response = await _api.auth.loginWithDirectPassword(request);
    return _loginResponseToAuthResult(response);
  }

  Future<String> requestEmailRegistration({
    required String username,
    required String email,
  }) async {
    final response = await _api.auth.requestEmailRegistration(
      client.RequestEmailRegistrationRequest(username: username, email: email),
    );
    return response.message;
  }

  Future<AuthResult> confirmEmailRegistration({
    required String emailToken,
    required String password,
  }) async {
    final response = await _api.auth.confirmEmailRegistration(
      client.ConfirmEmailRegistrationRequest(
        emailToken: emailToken,
        password: password,
      ),
    );
    return _registerResponseToAuthResult(response);
  }

  Future<LoginStart> startLogin(String identifier) async {
    final normalized = identifier.trim();
    final request = client.StartLoginRequest();
    if (normalized.contains('@')) {
      request.email = normalized;
    } else {
      request.username = normalized;
    }
    final response = await _api.auth.startLogin(request);
    return LoginStart(
      sessionId: response.loginSessionId,
      availableMethods: response.availableMethods
          .map((method) => method.value)
          .toList(growable: false),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        response.expiresAt.toInt() * 1000,
        isUtc: true,
      ),
    );
  }

  Future<AuthResult> confirmEmailLoginResult(
    String loginSessionId,
    String token,
  ) async {
    final response = await _api.auth.confirmEmailLogin(
      client.ConfirmEmailLoginRequest(
        loginSessionId: loginSessionId,
        emailToken: token,
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<void> requestEmailLogin(String loginSessionId) async {
    await _api.auth.requestEmailLogin(
      client.RequestEmailLoginRequest(loginSessionId: loginSessionId),
    );
  }

  Future<OpaqueRegistrationStart> startOpaqueRegistration({
    required String username,
    required String email,
    required List<int> registrationRequest,
  }) async {
    final request = client.StartOpaqueRegistrationRequest(
      registrationRequest: registrationRequest,
    );
    if (email.isNotEmpty) {
      request.email = email;
    } else {
      request.username = username;
    }
    final response = await _api.auth.startOpaqueRegistration(request);
    return OpaqueRegistrationStart(
      sessionId: response.sessionId,
      registrationResponse: response.registrationResponse,
    );
  }

  Future<AuthResult> finishOpaqueRegistration({
    required String sessionId,
    required List<int> registrationUpload,
  }) async {
    final response = await _api.auth.finishOpaqueRegistration(
      client.FinishOpaqueRegistrationRequest(
        sessionId: sessionId,
        registrationUpload: registrationUpload,
      ),
    );
    return _registerResponseToAuthResult(response);
  }

  Future<OpaqueLoginStart> startOpaqueLogin({
    required String loginSessionId,
    required List<int> credentialRequest,
  }) async {
    final request = client.StartOpaqueLoginRequest(
      loginSessionId: loginSessionId,
      credentialRequest: credentialRequest,
    );
    final response = await _api.auth.startOpaqueLogin(request);
    return OpaqueLoginStart(
      sessionId: response.sessionId,
      credentialResponse: response.credentialResponse,
    );
  }

  Future<AuthResult> finishOpaqueLogin({
    required String sessionId,
    required List<int> credentialFinalization,
  }) async {
    final response = await _api.auth.finishOpaqueLogin(
      client.FinishOpaqueLoginRequest(
        sessionId: sessionId,
        credentialFinalization: credentialFinalization,
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<PasskeyChallengeStart> startPasskeyRegistration({
    required String username,
    String email = '',
    String name = '',
  }) async {
    final response = await _api.auth.startPasskeyRegistration(
      client.StartPasskeyRegistrationRequest(
        username: username,
        email: email,
        name: name,
      ),
    );
    return PasskeyChallengeStart(
      sessionId: response.sessionId,
      options: _api.encodeJsonBytes(passkeyChallengeToJson(response.options)),
    );
  }

  Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  }) async {
    final response = await _api.auth.finishPasskeyRegistration(
      client.FinishPasskeyRegistrationRequest(
        sessionId: sessionId,
        credential: passkeyRegistrationCredentialFromJson(credential),
      ),
    );
    return _registerResponseToAuthResult(response);
  }

  Future<PasskeyChallengeStart> startPasskeyLogin({
    String? loginSessionId,
  }) async {
    final request = client.StartPasskeyLoginRequest();
    if (loginSessionId != null && loginSessionId.isNotEmpty) {
      request.loginSessionId = loginSessionId;
    }
    final response = await _api.auth.startPasskeyLogin(request);
    return PasskeyChallengeStart(
      sessionId: response.sessionId,
      options: _api.encodeJsonBytes(passkeyChallengeToJson(response.options)),
    );
  }

  Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  }) async {
    final response = await _api.auth.finishPasskeyLogin(
      client.FinishPasskeyLoginRequest(
        sessionId: sessionId,
        credential: passkeyAuthenticationCredentialFromJson(credential),
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<String> requestMfaEmailCode(String mfaSessionId) async {
    final response = await _api.auth.requestMfaEmailCode(
      client.RequestMfaEmailCodeRequest(mfaSessionId: mfaSessionId),
    );
    return response.message;
  }

  Future<AuthResult> verifyMfaEmailCode({
    required String mfaSessionId,
    required String emailToken,
  }) async {
    final response = await _api.auth.verifyMfaEmailCode(
      client.VerifyMfaEmailCodeRequest(
        mfaSessionId: mfaSessionId,
        emailToken: emailToken,
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<MfaPasskeyChallengeStart> startMfaPasskey(String mfaSessionId) async {
    final response = await _api.auth.startMfaPasskey(
      client.StartMfaPasskeyRequest(mfaSessionId: mfaSessionId),
    );
    return MfaPasskeyChallengeStart(
      passkeySessionId: response.passkeySessionId,
      options: _api.encodeJsonBytes(passkeyChallengeToJson(response.options)),
    );
  }

  Future<AuthResult> finishMfaPasskey({
    required String mfaSessionId,
    required String passkeySessionId,
    required Object credential,
  }) async {
    final response = await _api.auth.finishMfaPasskey(
      client.FinishMfaPasskeyRequest(
        mfaSessionId: mfaSessionId,
        passkeySessionId: passkeySessionId,
        credential: passkeyAuthenticationCredentialFromJson(credential),
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<AuthResult> verifyMfaTotp({
    required String mfaSessionId,
    required String code,
  }) async {
    final response = await _api.auth.verifyMfaTotp(
      client.VerifyMfaTotpRequest(mfaSessionId: mfaSessionId, code: code),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<AuthResult> verifyMfaRecoveryCode({
    required String mfaSessionId,
    required String recoveryCode,
  }) async {
    final response = await _api.auth.verifyMfaRecoveryCode(
      client.VerifyMfaRecoveryCodeRequest(
        mfaSessionId: mfaSessionId,
        recoveryCode: recoveryCode,
      ),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async {
    final response = await _api.user.startSensitiveOperationVerification(
      client.StartSensitiveOperationVerificationRequest(),
    );
    return _sensitiveOperationVerificationInfo(response);
  }

  Future<SensitiveOperationPasskeyStart> startSensitiveOperationPasskey(
    String sessionId,
  ) async {
    final response = await _api.user.startSensitiveOperationPasskey(
      client.StartSensitiveOperationPasskeyRequest(sessionId: sessionId),
    );
    return SensitiveOperationPasskeyStart(
      passkeySessionId: response.passkeySessionId,
      options: _api.encodeJsonBytes(passkeyChallengeToJson(response.options)),
    );
  }

  Future<SensitiveOperationEmailCodeInfo> requestSensitiveOperationEmailCode(
    String sessionId,
  ) async {
    final response = await _api.user.requestSensitiveOperationEmailCode(
      client.RequestSensitiveOperationEmailCodeRequest(sessionId: sessionId),
    );
    return SensitiveOperationEmailCodeInfo(
      message: response.message,
      maskedEmail: response.maskedEmail,
    );
  }

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
  }) async {
    final request = client.FinishSensitiveOperationVerificationRequest(
      sessionId: sessionId,
      method: method,
      password: password,
      emailToken: emailToken,
      passkeySessionId: passkeySessionId,
      totpCode: totpCode,
      recoveryCode: recoveryCode,
    );
    if (passkeyCredential != null) {
      request.passkeyCredential = passkeyAuthenticationCredentialFromJson(
        passkeyCredential,
      );
    }
    final response = await _api.user.finishSensitiveOperationVerification(
      request,
    );
    return _sensitiveOperationVerificationInfo(response);
  }

  Future<String> requestPasswordReset(String email) async {
    final response = await _api.emailService.requestPasswordReset(
      client.RequestPasswordResetRequest(email: email),
    );
    return response.message;
  }

  Future<OpaquePasswordResetStart> startOpaquePasswordReset({
    required String email,
    required String token,
    required List<int> registrationRequest,
  }) async {
    final response = await _api.emailService.startOpaquePasswordReset(
      client.StartOpaquePasswordResetRequest(
        email: email,
        token: token,
        registrationRequest: registrationRequest,
      ),
    );
    return OpaquePasswordResetStart(
      sessionId: response.sessionId,
      registrationResponse: response.registrationResponse,
    );
  }

  Future<String> finishOpaquePasswordReset({
    required String sessionId,
    required List<int> registrationUpload,
  }) async {
    final response = await _api.emailService.finishOpaquePasswordReset(
      client.FinishOpaquePasswordResetRequest(
        sessionId: sessionId,
        registrationUpload: registrationUpload,
      ),
    );
    return response.message;
  }

  Future<SyncTvUser> createGuestToken(String roomId) async {
    final response = await _api.auth.createGuestToken(
      client.CreateGuestTokenRequest(roomId: roomId),
    );
    await _api.runForCurrentEndpointResponse(
      response,
      () => _sessionStore.activateGuest(
        accessToken: response.token,
        roomId: response.roomId,
        displayName: response.displayName,
      ),
    );
    return SyncTvUser(
      id: response.guestId,
      username: response.displayName.isEmpty ? 'Guest' : response.displayName,
      role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST.value,
    );
  }

  Future<List<OAuth2ProviderOption>> listOAuth2Providers() async {
    final response = await _api.oauth2Service.listAvailableProviders(
      oauth2.ListAvailableProvidersRequest(),
    );
    return response.providers
        .map(
          (provider) => OAuth2ProviderOption(
            name: provider.name,
            type: oauth2ProviderTypeToString(provider.type),
            signupEnabled: provider.signupEnabled,
            signupNeedReview: provider.signupNeedReview,
            supportedModes: provider.supportedModes,
          ),
        )
        .toList(growable: false);
  }

  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  }) async {
    final response = await _api.oauth2Service.getAuthorizationUrl(
      oauth2.GetAuthorizationUrlRequest(
        provider: provider,
        redirectUrl: redirectUrl,
        native: native ? true : null,
      ),
    );
    return OAuth2AuthorizationStart(
      provider: provider,
      authorizationUrl: response.hasAuthorizationUrl()
          ? response.authorizationUrl
          : null,
      state: response.state,
      operation: response.operation,
      nonce: response.hasNonce() ? response.nonce : null,
    );
  }

  Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  }) async {
    final response = await _api.oauth2Service.exchangeAuthorizationCode(
      oauth2.ExchangeAuthorizationCodeRequest(code: code, state: state),
    );
    await _api.runForCurrentEndpointResponse(
      response,
      _sessionStore.persistTokens,
    );
    if (response.registrationReviewRequired) {
      return AuthResult(
        registrationReviewRequired: true,
        registrationReviewId: response.registrationReviewId,
        redirectUrl: response.hasRedirectUrl() ? response.redirectUrl : null,
        expiresIn: response.expiresIn.toInt(),
        oauth2Operation: response.operation,
      );
    }
    return AuthResult(
      user: SyncTvUser(
        id: response.userInfo.userId,
        username: response.userInfo.username,
        email: null,
        role: response.userInfo.role.value,
        createdAt: response.userInfo.createdAt.toInt(),
        status: response.userInfo.status.value,
      ),
      redirectUrl: response.hasRedirectUrl() ? response.redirectUrl : null,
      expiresIn: response.expiresIn.toInt(),
      oauth2Operation: response.operation,
    );
  }

  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async {
    final response = await _api.oauth2Service.getLinkedProviders(
      oauth2.GetLinkedProvidersRequest(),
    );
    return response.providers
        .map(
          (provider) => OAuth2LinkedAccount(
            providerType: oauth2ProviderTypeToString(provider.providerType),
            providerUsername: provider.providerUsername,
            providerInstanceName: provider.providerInstanceName,
            providerIssuer: provider.providerIssuer,
            providerUserId: provider.providerUserId,
            linkedAt: provider.linkedAt.toInt(),
          ),
        )
        .toList(growable: false);
  }

  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) async {
    final response = await _api.oauth2Service.getAuthorizationUrlForBind(
      oauth2.GetAuthorizationUrlForBindRequest(
        provider: provider,
        redirectUrl: redirectUrl,
        verificationId: verificationId,
        native: native ? true : null,
      ),
    );
    return OAuth2AuthorizationStart(
      provider: provider,
      authorizationUrl: response.hasAuthorizationUrl()
          ? response.authorizationUrl
          : null,
      state: response.state,
      operation: response.operation,
      nonce: response.hasNonce() ? response.nonce : null,
    );
  }

  Future<void> finishOAuth2Bind({
    required String code,
    required String state,
  }) async {
    final response = await _api.oauth2Service.exchangeAuthorizationCode(
      oauth2.ExchangeAuthorizationCodeRequest(code: code, state: state),
    );
    await _api.runForCurrentEndpointResponse(
      response,
      _sessionStore.persistTokens,
    );
  }

  Future<void> unlinkOAuth2Account(
    OAuth2LinkedAccount account, {
    required String verificationId,
  }) async {
    await _api.oauth2Service.unlinkProvider(
      oauth2.UnlinkProviderRequest(
        provider: oauth2ProviderTypeFromString(account.providerType),
        providerInstanceName: account.providerInstanceName,
        providerUserId: account.providerUserId,
        verificationId: verificationId,
      ),
    );
  }

  Future<AuthResult> _loginResponseToAuthResult(
    client.LoginResponse response,
  ) async {
    if (response.hasMfa() && response.mfa.required) {
      return AuthResult(mfa: _mfaChallengeFromProto(response.mfa));
    }
    await _api.runForCurrentEndpointResponse(
      response,
      _sessionStore.persistTokens,
    );
    return AuthResult(user: _api.mapUser(response.user));
  }

  Future<AuthResult> _registerResponseToAuthResult(
    client.RegisterResponse response,
  ) async {
    if (response.status ==
            client_enum.RegistrationStatus.REGISTRATION_STATUS_PENDING_REVIEW ||
        response.hasPendingReview()) {
      return AuthResult(
        registrationReviewRequired: true,
        registrationReviewId: response.pendingReview.reviewRequestId,
      );
    }
    await _api.runForCurrentEndpointResponse(
      response,
      _sessionStore.persistTokens,
    );
    return AuthResult(user: _api.mapUser(response.user));
  }

  SensitiveOperationVerificationInfo _sensitiveOperationVerificationInfo(
    client.SensitiveOperationVerificationOutcome outcome,
  ) {
    return switch (outcome.whichOutcome()) {
      client.SensitiveOperationVerificationOutcome_Outcome.verificationId =>
        SensitiveOperationVerificationComplete(
          verificationId: outcome.verificationId,
        ),
      client.SensitiveOperationVerificationOutcome_Outcome.challenge =>
        SensitiveOperationVerificationPending(
          challenge: _sensitiveOperationChallengeInfo(outcome.challenge),
        ),
      client.SensitiveOperationVerificationOutcome_Outcome.notSet =>
        throw const FormatException(
          'Sensitive verification response is missing its outcome',
        ),
    };
  }

  SensitiveOperationVerificationChallengeInfo _sensitiveOperationChallengeInfo(
    client.SensitiveOperationVerificationChallenge challenge,
  ) {
    return SensitiveOperationVerificationChallengeInfo(
      sessionId: challenge.sessionId,
      requiredCount: challenge.requiredCount,
      requiredMethods: challenge.requiredMethods
          .map((method) => method.value)
          .toList(),
      completedMethods: challenge.completedMethods
          .map((method) => method.value)
          .toList(),
      availableMethods: challenge.availableMethods
          .map((method) => method.value)
          .toList(),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        challenge.expiresAt.toInt() * 1000,
      ),
    );
  }

  MfaChallengeInfo _mfaChallengeFromProto(client.MfaChallenge mfa) {
    return MfaChallengeInfo(
      sessionId: mfa.sessionId,
      availableMethods: mfa.availableMethods
          .map((method) => method.value)
          .toList(),
      maskedEmail: mfa.maskedEmail,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
        mfa.expiresAt.toInt() * 1000,
        isUtc: true,
      ),
    );
  }
}
