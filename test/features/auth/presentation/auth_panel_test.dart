import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;

void main() {
  testWidgets('OAuth2 login returns to the page that opened the auth panel', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final events = <String>[];
    final gateway = _OAuth2AuthGateway(events);
    final callbacks = _OAuth2Callbacks(events);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                const Text('Origin page'),
                TextButton(
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        body: AuthPanel(
                          gateway: gateway,
                          passkeyClient: _UnavailablePasskeyClient(),
                          opaqueAuthenticator: OpaqueAuthenticatorService(
                            gateway: _UnusedOpaqueGateway(),
                          ),
                          oauth2Callbacks: callbacks,
                          nativeAppleSignIn: _UnavailableAppleSignIn(),
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Open auth'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open auth'));
    await tester.pumpAndSettle();
    final oauthButton = find.text('Continue with GitHub');
    await tester.ensureVisible(oauthButton);
    await tester.pumpAndSettle();
    await tester.tap(oauthButton);
    await tester.pumpAndSettle();

    expect(find.text('Origin page'), findsOneWidget);
    expect(find.byType(AuthPanel), findsNothing);
    expect(gateway.redirectUrl, 'https://app.example.test/oauth2/callback');
    expect(gateway.finishedCode, 'authorization-code');
    expect(gateway.finishedState, 'oauth-state');
    expect(callbacks.session.expectedState, 'oauth-state');
    expect(callbacks.session.closeCount, 1);
    expect(events, containsAllInOrder(['session', 'start']));
  });
}

final class _OAuth2AuthGateway implements AuthGateway {
  _OAuth2AuthGateway(this.events);

  final List<String> events;
  String? redirectUrl;
  String? finishedCode;
  String? finishedState;

  @override
  String? get activeServerName => 'Test server';

  @override
  String get serverBaseUrl => 'https://app.example.test';

  @override
  Future<PublicSettingsInfo> getPublicSettings() async =>
      const PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 10,
        defaultMaxMembers: 10,
        roomCreationApprovalRequired: false,
        roomPasswordPolicy:
            common_enum.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_UNSPECIFIED,
        enablePasswordSignup: true,
        passwordSignupNeedReview: false,
        enableEmailSignup: false,
        enableEmail: false,
        enableGuest: false,
        emailSignupNeedReview: false,
        enableWebauthn: false,
        webauthnRpId: '',
        enableWebauthnSignup: false,
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
      supportedModes: [
        oauth2_enum.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_BROWSER,
      ],
    ),
  ];

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  }) async {
    events.add('start');
    this.redirectUrl = redirectUrl;
    return const OAuth2AuthorizationStart(
      provider: 'github',
      authorizationUrl: 'https://github.example.test/authorize',
      state: 'oauth-state',
      operation: oauth2_enum.OAuth2Operation.OAUTH2_OPERATION_LOGIN,
    );
  }

  @override
  Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  }) async {
    finishedCode = code;
    finishedState = state;
    return Authenticated(
      SyncTvUser(
        id: 'user-1',
        username: 'Test user',
        role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

final class _OAuth2Callbacks implements OAuth2CallbackClient {
  _OAuth2Callbacks(this.events);

  final List<String> events;
  final session = _OAuth2CallbackSession();

  @override
  bool get canCreateSession => true;

  @override
  Future<OAuth2CallbackSession> createSession() async {
    events.add('session');
    return session;
  }
}

final class _OAuth2CallbackSession implements OAuth2CallbackSession {
  String? expectedState;
  int closeCount = 0;

  @override
  String get redirectUrl => 'https://app.example.test/oauth2/callback';

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    this.expectedState = expectedState;
    return OAuth2CallbackPayload(
      code: 'authorization-code',
      state: expectedState,
    );
  }

  @override
  Future<void> close() async => closeCount++;
}

final class _UnavailablePasskeyClient implements PasskeyClient {
  @override
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

final class _UnavailableAppleSignIn implements NativeAppleSignInClient {
  @override
  bool get isSupported => false;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

final class _UnusedOpaqueGateway implements OpaqueAuthGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
