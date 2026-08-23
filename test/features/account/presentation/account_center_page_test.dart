import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/features/account/presentation/account_center_page.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;

import '../../../test_app.dart';

void main() {
  testWidgets('slow account modules do not block navigation or local actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final gateway = _HangingAccountGateway();
    var createRoomCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => DependencyRegistryScope(
          values: {
            AccountGateway: gateway,
            OpaqueAuthenticatorService: OpaqueAuthenticatorService(
              gateway: _UnusedOpaqueGateway(),
            ),
            OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
            NativeAppleSignInClient: _UnavailableAppleSignIn(),
            PasskeyClient: _UnavailablePasskeyClient(),
            ResourceUrlResolver: const IdentityResourceUrlResolver(),
          },
          child: buildThemedTestApp(context, child),
        ),
        home: AccountCenterPage(
          initialUser: SyncTvUser(
            id: 'user-1',
            username: 'Cached user',
            role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
          ),
          onOpenRoom: (_) async {},
          onCreateRoom: () async => createRoomCalls++,
          onManageRoom: (_) async {},
          onOpenProviderBinding: (_) async {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Cached user'), findsWidgets);
    expect(find.byType(AppLinearProgress), findsOneWidget);

    await tester.tap(find.text('Rooms').first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final createRoomButton = find.widgetWithText(
      AppActionButton,
      'Create room',
    );
    await tester.ensureVisible(createRoomButton);
    await tester.pump();
    await tester.tap(createRoomButton);
    await tester.pump();

    expect(createRoomCalls, 1);
    expect(gateway.pending.isCompleted, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('OAuth2 bind returns to account center and refreshes links', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final events = <String>[];
    final gateway = _OAuth2BindingAccountGateway(events);
    final callbacks = _OAuth2Callbacks(events);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => DependencyRegistryScope(
          values: {
            AccountGateway: gateway,
            OpaqueAuthenticatorService: OpaqueAuthenticatorService(
              gateway: _UnusedOpaqueGateway(),
            ),
            OAuth2CallbackClient: callbacks,
            NativeAppleSignInClient: _UnavailableAppleSignIn(),
            PasskeyClient: _UnavailablePasskeyClient(),
            ResourceUrlResolver: const IdentityResourceUrlResolver(),
          },
          child: buildThemedTestApp(context, child),
        ),
        home: AccountCenterPage(
          initialUser: _testUser,
          onOpenRoom: (_) async {},
          onCreateRoom: () async {},
          onManageRoom: (_) async {},
          onOpenProviderBinding: (_) async {},
        ),
      ),
    );
    await tester.pump();

    final bindingsTab = find.text('Bindings').first;
    await tester.ensureVisible(bindingsTab);
    await tester.pump();
    await tester.tap(bindingsTab);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Media source accounts'), findsOneWidget);
    final bindButton = find.text('GitHub (github)');
    await tester.ensureVisible(bindButton);
    await tester.pump();
    await tester.tap(bindButton);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(AccountCenterPage), findsOneWidget);
    expect(find.text('github / github'), findsOneWidget);
    expect(gateway.redirectUrl, 'https://app.example.test/oauth2/callback');
    expect(gateway.finishedCode, 'authorization-code');
    expect(gateway.finishedState, 'bind-state');
    expect(callbacks.session.expectedState, 'bind-state');
    expect(callbacks.session.closeCount, 1);
    expect(events, containsAllInOrder(['session', 'verification', 'start']));
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 4));
  });
}

final _testUser = SyncTvUser(
  id: 'user-1',
  username: 'Cached user',
  role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
);

class _HangingAccountGateway implements AccountGateway {
  final Completer<Never> pending = Completer<Never>();

  @override
  String? get activeServerName => 'Slow server';

  @override
  String get serverBaseUrl => 'https://slow.example.test';

  @override
  dynamic noSuchMethod(Invocation invocation) => pending.future;
}

final class _OAuth2BindingAccountGateway extends _HangingAccountGateway {
  _OAuth2BindingAccountGateway(this.events);

  final List<String> events;
  String? redirectUrl;
  String? finishedCode;
  String? finishedState;
  var _linkedAccountLoads = 0;

  @override
  String get serverBaseUrl => 'https://app.example.test';

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
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async {
    _linkedAccountLoads++;
    if (_linkedAccountLoads == 1) return const [];
    return const [
      OAuth2LinkedAccount(
        providerType: 'github',
        providerUsername: 'octocat',
        providerInstanceName: 'github',
        providerIssuer: 'https://github.com',
        providerUserId: '42',
        linkedAt: 1,
      ),
    ];
  }

  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async {
    events.add('verification');
    return const SensitiveOperationVerificationComplete(
      verificationId: 'verification-id',
    );
  }

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) async {
    events.add('start');
    this.redirectUrl = redirectUrl;
    return const OAuth2AuthorizationStart(
      provider: 'github',
      authorizationUrl: 'https://github.example.test/authorize',
      state: 'bind-state',
      operation: oauth2_enum.OAuth2Operation.OAUTH2_OPERATION_BIND,
    );
  }

  @override
  Future<void> finishOAuth2Bind({
    required String code,
    required String state,
  }) async {
    finishedCode = code;
    finishedState = state;
  }
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

final class _UnusedOpaqueGateway implements OpaqueAuthGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

final class _UnavailableOAuth2Callbacks implements OAuth2CallbackClient {
  @override
  bool get canCreateSession => false;

  @override
  Future<OAuth2CallbackSession> createSession() =>
      throw const OAuth2CallbackBindFailed();
}

final class _UnavailableAppleSignIn implements NativeAppleSignInClient {
  @override
  bool get isSupported => false;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

final class _UnavailablePasskeyClient implements PasskeyClient {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
