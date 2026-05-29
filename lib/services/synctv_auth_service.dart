import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;

class SyncTvAuthDomainService {
  SyncTvAuthDomainService({
    required SyncTvApiClient api,
    required SyncTvSessionStore sessionStore,
  })  : _api = api,
        _sessionStore = sessionStore;

  final SyncTvApiClient _api;
  final SyncTvSessionStore _sessionStore;

  Future<AuthResult> confirmEmailLoginResult(
    String email,
    String token,
  ) async {
    final response = await _api.auth.confirmEmailLogin(
      client.ConfirmEmailLoginRequest(email: email, emailToken: token),
    );
    return _loginResponseToAuthResult(response);
  }

  Future<void> requestEmailLogin(String email) async {
    await _api.auth.requestEmailLogin(client.RequestEmailLoginRequest(
      email: email,
    ));
  }

  Future<OpaqueRegistrationStart> startOpaqueRegistration({
    required String username,
    required String email,
    required List<int> registrationRequest,
  }) async {
    final response = await _api.auth.startOpaqueRegistration(
      client.StartOpaqueRegistrationRequest(
        username: username,
        email: email,
        registrationRequest: registrationRequest,
      ),
    );
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
    String username = '',
    String email = '',
    required List<int> credentialRequest,
  }) async {
    final response = await _api.auth.startOpaqueLogin(
      client.StartOpaqueLoginRequest(
        username: username,
        email: email,
        credentialRequest: credentialRequest,
      ),
    );
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
      options: response.options,
    );
  }

  Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  }) async {
    final response = await _api.auth.finishPasskeyRegistration(
      client.FinishPasskeyRegistrationRequest(
        sessionId: sessionId,
        credential: _api.encodeJsonBytes(credential),
      ),
    );
    return _registerResponseToAuthResult(response);
  }

  Future<PasskeyChallengeStart> startPasskeyLogin({
    String username = '',
    String email = '',
  }) async {
    final response = await _api.auth.startPasskeyLogin(
      client.StartPasskeyLoginRequest(username: username, email: email),
    );
    return PasskeyChallengeStart(
      sessionId: response.sessionId,
      options: response.options,
    );
  }

  Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  }) async {
    final response = await _api.auth.finishPasskeyLogin(
      client.FinishPasskeyLoginRequest(
        sessionId: sessionId,
        credential: _api.encodeJsonBytes(credential),
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

  Future<MfaPasskeyChallengeStart> startMfaPasskey(
    String mfaSessionId,
  ) async {
    final response = await _api.auth.startMfaPasskey(
      client.StartMfaPasskeyRequest(mfaSessionId: mfaSessionId),
    );
    return MfaPasskeyChallengeStart(
      passkeySessionId: response.passkeySessionId,
      options: response.options,
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
        credential: _api.encodeJsonBytes(credential),
      ),
    );
    return _loginResponseToAuthResult(response);
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

  Future<WUser> createGuestToken(String roomId) async {
    final response = await _api.auth.createGuestToken(
      client.CreateGuestTokenRequest(roomId: roomId),
    );
    await _sessionStore.activateGuest(
      accessToken: response.token,
      roomId: response.roomId,
      displayName: response.displayName,
    );
    return WUser(
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
            type: provider.type,
            signupEnabled: provider.signupEnabled,
            signupNeedReview: provider.signupNeedReview,
          ),
        )
        .toList(growable: false);
  }

  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String redirectUrl = '',
  }) async {
    final response = await _api.oauth2Service.getAuthorizationUrl(
      oauth2.GetAuthorizationUrlRequest(
        provider: provider,
        redirectUrl: redirectUrl,
      ),
    );
    return OAuth2AuthorizationStart(
      provider: provider,
      authorizationUrl: response.authorizationUrl,
      state: response.state,
    );
  }

  Future<AuthResult> finishOAuth2Login({
    required String provider,
    required String code,
    required String state,
  }) async {
    final response = await _api.oauth2Service.exchangeAuthorizationCode(
      oauth2.ExchangeAuthorizationCodeRequest(
        provider: provider,
        code: code,
        state: state,
      ),
    );
    await _sessionStore.persistTokens();
    if (response.registrationReviewRequired) {
      return AuthResult(
        registrationReviewRequired: true,
        registrationReviewId: response.registrationReviewId,
        redirectUrl: response.redirectUrl,
        expiresIn: response.expiresIn.toInt(),
        oauth2Bind: response.isBind,
      );
    }
    return AuthResult(
      user: WUser(
        id: response.userInfo.userId,
        username: response.userInfo.username,
        email: response.userInfo.email.isEmpty ? null : response.userInfo.email,
        role: response.userInfo.role.value,
        createdAt: response.userInfo.createdAt.toInt(),
        status: response.userInfo.status.value,
      ),
      redirectUrl: response.redirectUrl,
      expiresIn: response.expiresIn.toInt(),
      oauth2Bind: response.isBind,
    );
  }

  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async {
    final response = await _api.oauth2Service.getLinkedProviders(
      oauth2.GetLinkedProvidersRequest(),
    );
    return response.providers
        .map(
          (provider) => OAuth2LinkedAccount(
            providerType: provider.providerType,
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
    String redirectUrl = '',
  }) async {
    final response = await _api.oauth2Service.getAuthorizationUrlForBind(
      oauth2.GetAuthorizationUrlForBindRequest(
        provider: provider,
        redirectUrl: redirectUrl,
      ),
    );
    return OAuth2AuthorizationStart(
      provider: provider,
      authorizationUrl: response.authorizationUrl,
      state: response.state,
    );
  }

  Future<void> finishOAuth2Bind({
    required String provider,
    required String code,
    required String state,
  }) async {
    await _api.oauth2Service.exchangeAuthorizationCode(
      oauth2.ExchangeAuthorizationCodeRequest(
        provider: provider,
        code: code,
        state: state,
      ),
    );
    await _sessionStore.persistTokens();
  }

  Future<void> unlinkOAuth2Account(OAuth2LinkedAccount account) async {
    await _api.oauth2Service.unlinkProvider(
      oauth2.UnlinkProviderRequest(
        provider: account.providerType,
        providerInstanceName: account.providerInstanceName,
        providerUserId: account.providerUserId,
      ),
    );
  }

  Future<AuthResult> _loginResponseToAuthResult(
    client.LoginResponse response,
  ) async {
    if (response.hasMfa() && response.mfa.required) {
      return AuthResult(mfa: _mfaChallengeFromProto(response.mfa));
    }
    await _sessionStore.persistTokens();
    return AuthResult(user: _api.mapUser(response.user));
  }

  Future<AuthResult> _registerResponseToAuthResult(
    client.RegisterResponse response,
  ) async {
    await _sessionStore.persistTokens();
    return AuthResult(user: _api.mapUser(response.user));
  }

  MfaChallengeInfo _mfaChallengeFromProto(client.MfaChallenge mfa) {
    return MfaChallengeInfo(
      sessionId: mfa.sessionId,
      availableMethods:
          mfa.availableMethods.map((method) => method.value).toList(),
      maskedEmail: mfa.maskedEmail,
      expiresAt: mfa.expiresAt.toInt(),
    );
  }
}
