import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/app/app_viewport.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/features/account/presentation/account_center_page.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart' as oauth;
import 'package:synctv_app/theme/app_theme.dart';

import 'fixtures/populated_account_gateway.dart';

void main() {
  final dependencies = <Type, Object>{
    AccountGateway:
        const String.fromEnvironment('PREVIEW_ACCOUNT_STATE') == 'recovery'
        ? RecoveryCodesPreviewGateway()
        : const String.fromEnvironment('PREVIEW_ACCOUNT_STATE') ==
              'verification'
        ? UnavailableVerificationPreviewGateway()
        : const String.fromEnvironment('PREVIEW_ACCOUNT_STATE') == 'populated'
        ? PopulatedAccountPreviewGateway()
        : _Gateway(),
    OAuth2CallbackClient: _Callbacks(),
    NativeAppleSignInClient: _Apple(),
    PasskeyClient: _Passkey(),
    OpaqueAuthenticatorService: OpaqueAuthenticatorService(gateway: _Opaque()),
    ResourceUrlResolver: const IdentityResourceUrlResolver(),
  };
  runApp(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyRegistryScope(
        values: dependencies,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              double.parse(
                const String.fromEnvironment(
                  'PREVIEW_TEXT_SCALE',
                  defaultValue: '2',
                ),
              ),
            ),
          ),
          child: AppViewport(child: child!),
        ),
      ),
      home: AccountCenterPage(
        initialUser: SyncTvUser(
          id: 'preview-user',
          username: 'Preview',
          role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
        ),
        onOpenRoom: (_) async {},
        onCreateRoom: () async {},
        onManageRoom: (_) async {},
        onOpenProviderBinding: (_) async {},
      ),
    ),
  );
}

class _Gateway implements AccountGateway {
  @override
  String get activeServerName => 'Preview';
  @override
  String get serverBaseUrl => 'https://example.test';
  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() async => const [
    OAuth2ProviderOption(
      name: 'corporate-authentication-provider',
      type: 'github',
      signupEnabled: true,
      signupNeedReview: false,
      supportedModes: [oauth.OAuth2ProviderMode.OAUTH2_PROVIDER_MODE_BROWSER],
    ),
  ];
  @override
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async => const [];
  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async =>
      const SensitiveOperationVerificationComplete(verificationId: 'preview');
  @override
  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) async => OAuth2AuthorizationStart(
    provider: provider,
    authorizationUrl: 'https://example.test/authorize',
    state: 'preview',
    operation: oauth.OAuth2Operation.OAUTH2_OPERATION_BIND,
  );

  // Keep unrelated modules pending; this fixture performs no network requests.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    const state = String.fromEnvironment(
      'PREVIEW_ACCOUNT_STATE',
      defaultValue: 'empty',
    );
    if (state == 'loading') return Completer<Never>().future;
    if ([
      #getRooms,
      #listBlockedUsers,
      #listNotifications,
    ].contains(invocation.memberName)) {
      if (state == 'error')
        return Future<Never>.error(StateError('Unavailable'));
      return switch (invocation.memberName) {
        #getRooms => Future.value(
          const RoomsPage(rooms: [], total: 0, page: 1, pageSize: 24),
        ),
        #listBlockedUsers => Future.value(
          const BlockedUsersPage(users: [], total: 0),
        ),
        _ => Future.value(
          const UserNotificationsPage(
            notifications: [],
            total: 0,
            unreadCount: 0,
          ),
        ),
      };
    }
    return Completer<Never>().future;
  }
}

class _Callbacks implements OAuth2CallbackClient {
  @override
  bool get canCreateSession => true;
  @override
  Future<OAuth2CallbackSession> createSession() async => _Session();
}

class _Session implements OAuth2CallbackSession {
  @override
  String get redirectUrl => 'https://example.test/oauth2/callback';
  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 20));
    throw const OAuth2AuthorizationCanceled();
  }

  @override
  Future<void> close() async {}
}

class _Apple implements NativeAppleSignInClient {
  @override
  bool get isSupported => false;
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

class _Opaque implements OpaqueAuthGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
