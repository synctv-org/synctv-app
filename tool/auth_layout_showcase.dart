import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/app/app_viewport.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/features/auth/presentation/password_reset_dialog.dart';
import 'package:synctv_app/features/auth/presentation/oauth2_callback_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart' as oauth;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: Uri.base.queryParameters['theme'] == 'dark'
        ? AppTheme.dark
        : AppTheme.light,
    locale: Locale(Uri.base.queryParameters['locale'] ?? 'en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          double.tryParse(Uri.base.queryParameters['scale'] ?? '') ?? 2,
        ),
      ),
      child: AppViewport(child: child!),
    ),
    home: ['completion', 'recovery'].contains(Uri.base.queryParameters['page'])
        ? const _CompletionPreview()
        : Uri.base.queryParameters['page'] == 'callback'
        ? OAuth2CallbackPage(dispatcher: _Dispatcher())
        : Scaffold(
            body: const bool.fromEnvironment('PREVIEW_PASSWORD_RESET')
                ? Builder(
                    builder: (context) => Center(
                      child: TextButton(
                        onPressed: () => showPasswordResetDialog(
                          context: context,
                          gateway: _Gateway(),
                        ),
                        child: Text(context.l10n.resetPassword),
                      ),
                    ),
                  )
                : AuthPanel(
                    gateway: _Gateway(),
                    passkeyClient: _Passkey(),
                    opaqueAuthenticator: OpaqueAuthenticatorService(
                      gateway: _Opaque(),
                    ),
                    oauth2Callbacks: _Callbacks(),
                    nativeAppleSignIn: _Apple(),
                  ),
          ),
  ),
);

class _CompletionPreview extends StatefulWidget {
  const _CompletionPreview();

  @override
  State<_CompletionPreview> createState() => _CompletionPreviewState();
}

class _CompletionPreviewState extends State<_CompletionPreview> {
  String _result = 'Not completed';

  Future<void> _open() async {
    final pending = Completer<AuthResult>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (authContext) => Scaffold(
          appBar: Uri.base.queryParameters['page'] == 'recovery'
              ? null
              : AppBar(
                  actions: [
                    TextButton(
                      onPressed: () => showDialog<void>(
                        context: authContext,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Independent dialog'),
                          content: const Text(
                            'Complete the pending login while this dialog stays open.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (!pending.isCompleted) {
                                  pending.complete(
                                    Authenticated(
                                      SyncTvUser(
                                        id: 'preview',
                                        username: 'Preview',
                                        role: const AccountUserRole(
                                          common.UserRole.USER_ROLE_USER,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Complete login'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Close dialog'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text('Open independent dialog'),
                    ),
                  ],
                ),
          body: AuthPanel(
            gateway: _Gateway()..oauthResult = pending,
            passkeyClient: _Passkey(),
            opaqueAuthenticator: OpaqueAuthenticatorService(gateway: _Opaque()),
            oauth2Callbacks: _Callbacks(),
            nativeAppleSignIn: _Apple(),
          ),
        ),
      ),
    );
    if (mounted) setState(() => _result = 'Login result: $result');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_result),
          FilledButton(onPressed: _open, child: const Text('Open auth')),
        ],
      ),
    ),
  );
}

class _Dispatcher implements OAuth2CallbackDispatcher {
  bool _failNext = Uri.base.queryParameters['dispatch'] == 'fail-once';

  @override
  void dispatch() {
    if (_failNext) {
      _failNext = false;
      throw StateError('Preview dispatch failure');
    }
  }
}

class _Gateway implements AuthGateway {
  Completer<AuthResult>? oauthResult;

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Login(
    String provider, {
    String? redirectUrl,
    bool native = false,
  }) async => const OAuth2AuthorizationStart(
    provider: 'github',
    authorizationUrl: 'https://example.test/authorize',
    state: 'preview-state',
    operation: oauth.OAuth2Operation.OAUTH2_OPERATION_LOGIN,
  );

  @override
  Future<AuthResult> finishOAuth2Login({
    required String code,
    required String state,
  }) {
    if (Uri.base.queryParameters['page'] == 'recovery') {
      return Future.value(
        MfaRequired(
          MfaChallengeInfo(
            sessionId: 'preview-mfa',
            availableMethods: const [
              client.MfaMethod.MFA_METHOD_TOTP,
              client.MfaMethod.MFA_METHOD_RECOVERY_CODE,
            ],
            maskedEmail: '',
            expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
          ),
        ),
      );
    }
    return oauthResult?.future ??
        Future.error(StateError('Preview login unavailable'));
  }

  @override
  Future<AuthResult> verifyMfaRecoveryCode({
    required String mfaSessionId,
    required String recoveryCode,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (recoveryCode != 'demo-recovery-code') {
      throw StateError('Preview: invalid recovery code');
    }
    return Authenticated(
      SyncTvUser(
        id: 'preview',
        username: 'Preview',
        role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
      ),
    );
  }

  static const emailCodes = bool.fromEnvironment('PREVIEW_EMAIL_CODE');

  @override
  Future<LoginStart> startLogin(String identifier) async => LoginStart(
    sessionId: 'preview-session',
    availableMethods: [
      emailCodes
          ? client.LoginMethod.LOGIN_METHOD_EMAIL_CODE
          : client.LoginMethod.LOGIN_METHOD_PASSWORD,
    ],
    expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
  );

  @override
  String? get activeServerName => 'Preview';
  @override
  String get serverBaseUrl => 'https://example.test';
  @override
  Future<PublicSettingsInfo> getPublicSettings() async =>
      const PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 10,
        defaultMaxMembers: 10,
        roomCreationApprovalRequired: false,
        roomPasswordPolicy:
            common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_UNSPECIFIED,
        enablePasswordSignup: !emailCodes,
        passwordSignupNeedReview: false,
        enableEmailSignup: emailCodes,
        enableEmail: emailCodes,
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
      supportedModes: [oauth.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_BROWSER],
    ),
  ];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Passkey implements PasskeyClient {
  @override
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Apple implements NativeAppleSignInClient {
  @override
  bool get isSupported => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Callbacks implements OAuth2CallbackClient {
  @override
  Future<OAuth2CallbackSession> createSession() async => _CallbackSession();
  @override
  bool get canCreateSession => true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CallbackSession implements OAuth2CallbackSession {
  @override
  String get redirectUrl => 'https://example.test/oauth2/callback';

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async => OAuth2CallbackPayload(code: 'preview-code', state: expectedState);

  @override
  Future<void> close() async {}
}

class _Opaque implements OpaqueAuthGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
