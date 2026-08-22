import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}

final class _HangingAccountGateway implements AccountGateway {
  final Completer<Never> pending = Completer<Never>();

  @override
  String? get activeServerName => 'Slow server';

  @override
  String get serverBaseUrl => 'https://slow.example.test';

  @override
  dynamic noSuchMethod(Invocation invocation) => pending.future;
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
