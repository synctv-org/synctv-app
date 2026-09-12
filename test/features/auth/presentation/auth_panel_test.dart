import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/features/auth/presentation/user_agreement_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;

void main() {
  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets('recovery form labels and back reset: $locale/$scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            theme: AppTheme.light,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: AuthPanel(
                gateway: _OAuth2AuthGateway([], totp: true, recovery: true),
                passkeyClient: _UnavailablePasskeyClient(),
                opaqueAuthenticator: OpaqueAuthenticatorService(
                  gateway: _UnusedOpaqueGateway(),
                ),
                oauth2Callbacks: _OAuth2Callbacks([]),
                nativeAppleSignIn: _UnavailableAppleSignIn(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(AuthPanel)).l10n;
        final oauth = find.text(l10n.continueWithProvider('GitHub'));
        await tester.ensureVisible(oauth);
        await tester.tap(oauth);
        await tester.pumpAndSettle();
        final open = find.text(l10n.useRecoveryCode);
        await tester.ensureVisible(open);
        await tester.tap(open);
        await tester.pumpAndSettle();
        final submit = find.text(l10n.verifyWithRecoveryCode);
        await tester.ensureVisible(submit);
        expect(
          tester.renderObject<RenderParagraph>(submit).didExceedMaxLines,
          isFalse,
        );
        final input = find.descendant(
          of: find.byKey(const ValueKey('mfa-recovery-code-field')),
          matching: find.byType(TextField),
        );
        await tester.enterText(input, 'draft-code');
        final back = find.text(l10n.backToVerificationMethods);
        await tester.ensureVisible(back);
        await tester.tap(back);
        await tester.pumpAndSettle();
        expect(input, findsNothing);
        await tester.ensureVisible(open);
        await tester.tap(open);
        await tester.pumpAndSettle();
        expect(tester.widget<TextField>(input).controller!.text, isEmpty);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  for (final covered in [false, true]) {
    testWidgets(
      'OAuth completion closes only its own route: covered=$covered',
      (tester) async {
        final navigator = GlobalKey<NavigatorState>();
        final pending = Completer<AuthResult>();
        final gateway = _OAuth2AuthGateway([])..oauthResult = pending;
        bool? result;
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigator,
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(body: Text('Origin')),
          ),
        );
        final authResult = navigator.currentState!.push<bool>(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              body: AuthPanel(
                gateway: gateway,
                passkeyClient: _UnavailablePasskeyClient(),
                opaqueAuthenticator: OpaqueAuthenticatorService(
                  gateway: _UnusedOpaqueGateway(),
                ),
                oauth2Callbacks: _OAuth2Callbacks([]),
                nativeAppleSignIn: _UnavailableAppleSignIn(),
              ),
            ),
          ),
        );
        unawaited(authResult.then((value) => result = value));
        await tester.pumpAndSettle();
        final oauth = find.text('Continue with GitHub');
        await tester.ensureVisible(oauth);
        await tester.tap(oauth);
        await tester.pump();
        if (covered) {
          unawaited(
            showDialog<void>(
              context: tester.element(find.byType(AuthPanel)),
              builder: (_) =>
                  const AlertDialog(title: Text('Independent dialog')),
            ),
          );
          await tester.pump(const Duration(seconds: 1));
        }
        pending.complete(
          Authenticated(
            SyncTvUser(
              id: 'user',
              username: 'User',
              role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(result, isTrue);
        expect(find.byType(AuthPanel, skipOffstage: false), findsNothing);
        expect(
          find.text('Independent dialog'),
          covered ? findsOneWidget : findsNothing,
        );
        if (covered) {
          navigator.currentState!.pop();
          await tester.pumpAndSettle();
        }
        expect(find.text('Origin'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'MFA response can require another challenge without closing auth',
    (tester) async {
      final gateway = _OAuth2AuthGateway([], totp: true)
        ..totpResult = MfaRequired(
          MfaChallengeInfo(
            sessionId: 'replacement',
            availableMethods: const [
              client_enum.MfaMethod.MFA_METHOD_RECOVERY_CODE,
            ],
            maskedEmail: '',
            expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
          ),
        );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: AuthPanel(
              gateway: gateway,
              passkeyClient: _UnavailablePasskeyClient(),
              opaqueAuthenticator: OpaqueAuthenticatorService(
                gateway: _UnusedOpaqueGateway(),
              ),
              oauth2Callbacks: _OAuth2Callbacks([]),
              nativeAppleSignIn: _UnavailableAppleSignIn(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final oauth = find.text('Continue with GitHub');
      await tester.ensureVisible(oauth);
      await tester.tap(oauth);
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(AuthPanel)).l10n;
      await tester.enterText(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is AppTextField && w.label == l10n.authenticatorCode,
          ),
          matching: find.byType(TextField),
        ),
        '012345',
      );
      await tester.tap(find.text(l10n.verifyWithAuthenticator));
      await tester.pumpAndSettle();
      expect(find.byType(AuthPanel), findsOneWidget);
      expect(find.text(l10n.useRecoveryCode), findsOneWidget);
      expect(find.text(l10n.verifyWithAuthenticator), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final accept in [true, false]) {
    testWidgets(
      'agreement result updates consent only on acceptance: $accept',
      (tester) async {
        await tester.pumpWidget(_agreementAuthApp());
        await tester.pumpAndSettle();
        final tile = find.byType(AppCheckboxTile);
        tester.widget<AppCheckboxTile>(tile).onChanged!(false);
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(AuthPanel)).l10n;
        tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, l10n.userAgreementLink),
            )
            .onPressed!();
        await tester.pumpAndSettle();
        if (accept) {
          final scrollable = tester.state<ScrollableState>(
            find.descendant(
              of: find.byType(UserAgreementDialog),
              matching: find.byType(Scrollable),
            ),
          );
          scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(AppActionButton, l10n.agree));
        } else {
          Navigator.of(tester.element(find.byType(UserAgreementDialog))).pop();
        }
        await tester.pumpAndSettle();
        expect(find.byType(UserAgreementDialog), findsNothing);
        expect(tester.widget<AppCheckboxTile>(tile).value, accept);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('agreement links do not open duplicate dialogs', (tester) async {
    await tester.pumpWidget(_agreementAuthApp());
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AuthPanel)).l10n;
    final open = tester
        .widget<AppActionButton>(
          find.widgetWithText(AppActionButton, l10n.userAgreementLink),
        )
        .onPressed!;
    open();
    open();
    await tester.pumpAndSettle();
    expect(
      find.byType(UserAgreementDialog, skipOffstage: false),
      findsOneWidget,
    );
  });
  testWidgets('MFA TOTP rejects non-digit codes and preserves leading zero', (
    tester,
  ) async {
    final gateway = _OAuth2AuthGateway([], totp: true);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: AuthPanel(
            gateway: gateway,
            passkeyClient: _UnavailablePasskeyClient(),
            opaqueAuthenticator: OpaqueAuthenticatorService(
              gateway: _UnusedOpaqueGateway(),
            ),
            oauth2Callbacks: _OAuth2Callbacks([]),
            nativeAppleSignIn: _UnavailableAppleSignIn(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AuthPanel)).l10n;
    final oauth = find.text(l10n.continueWithProvider('GitHub'));
    await tester.ensureVisible(oauth);
    await tester.tap(oauth);
    await tester.pumpAndSettle();
    final input = find.descendant(
      of: find.byWidgetPredicate(
        (widget) =>
            widget is AppTextField && widget.label == l10n.authenticatorCode,
      ),
      matching: find.byType(TextField),
    );
    final submit = find.text(l10n.verifyWithAuthenticator);
    for (final invalid in [
      'abcdef',
      '0x1234',
      '+12345',
      '-12345',
      '12 345',
      '12345',
      '1234567',
    ]) {
      await tester.enterText(input, invalid);
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(gateway.totpCodes, isEmpty, reason: invalid);
      expect(find.text(l10n.enterAuthenticatorCode), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    }
    await tester.enterText(input, ' 012345 ');
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(gateway.totpCodes, ['012345']);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final flow in ['login', 'registration', 'mfa']) {
    for (final locale in ['en', 'zh']) {
      for (final scale in [2.0, 3.0]) {
        testWidgets('email code layout $flow/$locale/$scale', (tester) async {
          tester.view
            ..physicalSize = const Size(320, 568)
            ..devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: Scaffold(
                body: AuthPanel(
                  gateway: _OAuth2AuthGateway([], emailCodes: true),
                  passkeyClient: _UnavailablePasskeyClient(),
                  opaqueAuthenticator: OpaqueAuthenticatorService(
                    gateway: _UnusedOpaqueGateway(),
                  ),
                  oauth2Callbacks: _OAuth2Callbacks([]),
                  nativeAppleSignIn: _UnavailableAppleSignIn(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester.element(find.byType(AuthPanel)).l10n;
          if (flow == 'mfa') {
            final oauth = find.text(l10n.continueWithProvider('GitHub'));
            await tester.ensureVisible(oauth);
            await tester.pumpAndSettle();
            await tester.tap(oauth);
          } else {
            if (flow == 'registration') {
              final register = find.widgetWithText(Tab, l10n.register);
              await tester.ensureVisible(register);
              await tester.pumpAndSettle();
              expect(register.hitTestable(), findsOneWidget);
              await tester.tap(register);
              await tester.pumpAndSettle();
            }
            await tester.enterText(
              find.byType(TextField),
              'preview@example.test',
            );
            final next = find.text(l10n.continueAction);
            await tester.ensureVisible(next);
            await tester.pumpAndSettle();
            await tester.tap(next);
          }
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final code = find.byWidgetPredicate(
            (widget) =>
                widget is AppTextField &&
                widget.label ==
                    (flow == 'mfa' ? l10n.getMfaCodeFirst : l10n.getCodeFirst),
          );
          expect(tester.getSize(code).width, greaterThan(160));
          await tester.ensureVisible(code);
          await tester.pumpAndSettle();
          await tester.enterText(
            find.descendant(of: code, matching: find.byType(TextField)),
            '123456',
          );
          tester.view.viewInsets = const FakeViewPadding(bottom: 240);
          await tester.pumpAndSettle();
          final send = find.widgetWithText(AppActionButton, l10n.send);
          await tester.ensureVisible(send);
          await tester.pumpAndSettle();
          expect(send.hitTestable(), findsOneWidget);
          final submitLabel = switch (flow) {
            'registration' => l10n.createAccountWithEmailCode,
            'mfa' => l10n.verifyWithEmail,
            _ => l10n.emailCodeLogin,
          };
          final submit = find.widgetWithText(AppActionButton, submitLabel);
          await tester.ensureVisible(submit);
          await tester.pumpAndSettle();
          expect(submit.hitTestable(), findsOneWidget);
          final label = find.descendant(
            of: submit,
            matching: find.text(submitLabel),
          );
          expect(
            tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
            isFalse,
          );
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
        });
      }
    }
  }

  for (final flow in ['login', 'registration', 'mfa']) {
    for (final phase in ['challenge', 'credential', 'complete']) {
      testWidgets('passkey $flow lifecycle at $phase', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final gateway = _OAuth2AuthGateway([], passkeys: true);
        final client = _PendingPasskeyClient();
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: AuthPanel(
                gateway: gateway,
                passkeyClient: client,
                opaqueAuthenticator: OpaqueAuthenticatorService(
                  gateway: _UnusedOpaqueGateway(),
                ),
                oauth2Callbacks: _OAuth2Callbacks([]),
                nativeAppleSignIn: _UnavailableAppleSignIn(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(AuthPanel)).l10n;
        if (flow == 'mfa') {
          await tester.tap(find.text(l10n.continueWithProvider('GitHub')));
          await tester.pumpAndSettle();
        } else {
          if (flow == 'registration') {
            await tester.tap(find.widgetWithText(Tab, l10n.register));
            await tester.pumpAndSettle();
          }
          await tester.enterText(find.byType(TextField), 'preview');
          await tester.ensureVisible(find.text(l10n.continueAction));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.continueAction));
          await tester.pumpAndSettle();
        }
        final label = switch (flow) {
          'registration' => l10n.createPasskeyAccount,
          'mfa' => l10n.verifyWithPasskey,
          _ => l10n.passkeyLogin,
        };
        final action = find.widgetWithText(AppActionButton, label);
        await tester.ensureVisible(action);
        await tester.pumpAndSettle();
        expect(action.hitTestable(), findsOneWidget);
        await tester.tap(action);
        await tester.pump();
        expect(gateway.challengeCalls, 1);
        if (phase != 'challenge') {
          gateway.challenge.complete();
          await tester.pump();
          expect(client.calls, 1);
        }
        if (phase != 'complete') {
          await tester.pumpWidget(
            const MaterialApp(home: Text('Replacement page')),
          );
        }
        if (phase == 'challenge') gateway.challenge.complete();
        client.credential.complete({'id': 'test-credential'});
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(client.calls, phase == 'challenge' ? 0 : 1);
        expect(gateway.finishCalls, phase == 'complete' ? 1 : 0);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }

  testWidgets('reset result is ignored after the auth panel is disposed', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    final opaqueGateway = _UnusedOpaqueGateway();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, show, _) => show
                ? AuthPanel(
                    gateway: _OAuth2AuthGateway([]),
                    passkeyClient: _UnavailablePasskeyClient(),
                    opaqueAuthenticator: OpaqueAuthenticatorService(
                      gateway: opaqueGateway,
                    ),
                    oauth2Callbacks: _OAuth2Callbacks([]),
                    nativeAppleSignIn: _UnavailableAppleSignIn(),
                  )
                : const Text('Replacement page'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(AuthPanel)).l10n;
    await tester.enterText(find.byType(TextField), 'preview@example.test');
    await tester.tap(find.text(l10n.continueAction));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(l10n.forgotPassword));
    await tester.tap(find.text(l10n.forgotPassword));
    await tester.pumpAndSettle();
    visible.value = false;
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsNothing);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(1), 'verification-token');
    await tester.enterText(fields.at(2), 'test-password');
    await tester.enterText(fields.at(3), 'test-password');
    tester
        .widget<AppActionButton>(
          find.widgetWithText(AppActionButton, l10n.reset),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Replacement page'), findsOneWidget);
    expect(opaqueGateway.calls, 0);
  });

  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets('large text auth tabs remain reachable: $locale/$scale', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(320, 568)
          ..devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: AuthPanel(
                gateway: _OAuth2AuthGateway([]),
                passkeyClient: _UnavailablePasskeyClient(),
                opaqueAuthenticator: OpaqueAuthenticatorService(
                  gateway: _UnusedOpaqueGateway(),
                ),
                oauth2Callbacks: _OAuth2Callbacks([]),
                nativeAppleSignIn: _UnavailableAppleSignIn(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l10n = tester.element(find.byType(AuthPanel)).l10n;
        final oauthButton = find.text(l10n.continueWithProvider('GitHub'));
        await tester.ensureVisible(oauthButton);
        await tester.pumpAndSettle();
        expect(oauthButton.hitTestable(), findsOneWidget);
        expect(
          tester.renderObject<RenderParagraph>(oauthButton).didExceedMaxLines,
          isFalse,
        );
        final register = find.widgetWithText(Tab, l10n.register);
        await tester.ensureVisible(register);
        await tester.pumpAndSettle();
        await tester.tap(register);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(l10n.guestAccessDisabled), findsOneWidget);
        await tester.ensureVisible(oauthButton);
        await tester.pumpAndSettle();
        expect(
          tester.renderObject<RenderParagraph>(oauthButton).didExceedMaxLines,
          isFalse,
        );
        await tester.enterText(find.byType(TextField), 'preview');
        tester.view.viewInsets = const FakeViewPadding(bottom: 240);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        tester.view.viewInsets = const FakeViewPadding();
        await tester.pumpAndSettle();
        final guest = find.widgetWithText(Tab, l10n.guest);
        await tester.ensureVisible(guest);
        await tester.pumpAndSettle();
        expect(guest.hitTestable(), findsOneWidget);
        await tester.tap(guest);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(tester.widget<TabBar>(find.byType(TabBar)).controller!.index, 2);
        tester.view.physicalSize = const Size(568, 320);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

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

Widget _agreementAuthApp() => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(
    body: AuthPanel(
      gateway: _OAuth2AuthGateway([]),
      passkeyClient: _UnavailablePasskeyClient(),
      opaqueAuthenticator: OpaqueAuthenticatorService(
        gateway: _UnusedOpaqueGateway(),
      ),
      oauth2Callbacks: _OAuth2Callbacks([]),
      nativeAppleSignIn: _UnavailableAppleSignIn(),
    ),
  ),
);

final class _OAuth2AuthGateway implements AuthGateway {
  _OAuth2AuthGateway(
    this.events, {
    this.passkeys = false,
    this.emailCodes = false,
    this.totp = false,
    this.recovery = false,
  });

  final bool passkeys;
  final bool emailCodes;
  final bool totp;
  final bool recovery;
  final totpCodes = <String>[];
  Completer<AuthResult>? oauthResult;
  AuthResult? totpResult;

  @override
  Future<AuthResult> verifyMfaTotp({
    required String mfaSessionId,
    required String code,
  }) async {
    totpCodes.add(code);
    if (totpResult != null) return totpResult!;
    throw StateError('Preview verification rejected');
  }

  final challenge = Completer<void>();
  int challengeCalls = 0;
  int finishCalls = 0;

  @override
  Future<PasskeyChallengeStart> startPasskeyLogin({
    required String loginSessionId,
  }) async {
    challengeCalls++;
    await challenge.future;
    return const PasskeyChallengeStart(
      sessionId: 'passkey-session',
      options: [],
    );
  }

  @override
  Future<PasskeyChallengeStart> startPasskeyRegistration({
    required String username,
    required String email,
    required String name,
  }) => startPasskeyLogin(loginSessionId: 'registration');

  @override
  Future<MfaPasskeyChallengeStart> startMfaPasskey(String mfaSessionId) async {
    challengeCalls++;
    await challenge.future;
    return const MfaPasskeyChallengeStart(
      passkeySessionId: 'passkey-session',
      options: [],
    );
  }

  @override
  Future<AuthResult> finishPasskeyLogin({
    required String sessionId,
    required Object credential,
  }) async {
    finishCalls++;
    return Authenticated(
      SyncTvUser(
        id: 'passkey-user',
        username: 'Passkey user',
        role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
      ),
    );
  }

  @override
  Future<AuthResult> finishPasskeyRegistration({
    required String sessionId,
    required Object credential,
  }) => finishPasskeyLogin(sessionId: sessionId, credential: credential);

  @override
  Future<AuthResult> finishMfaPasskey({
    required String mfaSessionId,
    required String passkeySessionId,
    required Object credential,
  }) => finishPasskeyLogin(sessionId: passkeySessionId, credential: credential);

  final List<String> events;
  String? redirectUrl;
  String? finishedCode;
  String? finishedState;

  @override
  Future<LoginStart> startLogin(String identifier) async => LoginStart(
    sessionId: 'test-session',
    availableMethods: [
      passkeys
          ? client_enum.LoginMethod.LOGIN_METHOD_PASSKEY
          : emailCodes
          ? client_enum.LoginMethod.LOGIN_METHOD_EMAIL_CODE
          : client_enum.LoginMethod.LOGIN_METHOD_PASSWORD,
    ],
    expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
  );

  @override
  String? get activeServerName => 'Test server';

  @override
  String get serverBaseUrl => 'https://app.example.test';

  @override
  Future<PublicSettingsInfo> getPublicSettings() async => PublicSettingsInfo(
    roomCreationEnabled: true,
    maxRoomsPerUser: 10,
    defaultMaxMembers: 10,
    roomCreationApprovalRequired: false,
    roomPasswordPolicy:
        common_enum.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_UNSPECIFIED,
    enablePasswordSignup: !passkeys && !emailCodes,
    passwordSignupNeedReview: false,
    enableEmailSignup: emailCodes,
    enableEmail: emailCodes,
    enableGuest: false,
    emailSignupNeedReview: false,
    enableWebauthn: passkeys,
    webauthnRpId: '',
    enableWebauthnSignup: passkeys,
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
    if (oauthResult != null) return oauthResult!.future;
    if (passkeys || emailCodes || totp) {
      return MfaRequired(
        MfaChallengeInfo(
          sessionId: 'mfa-session',
          availableMethods: [
            if (recovery) client_enum.MfaMethod.MFA_METHOD_RECOVERY_CODE,
            totp
                ? client_enum.MfaMethod.MFA_METHOD_TOTP
                : emailCodes
                ? client_enum.MfaMethod.MFA_METHOD_EMAIL
                : client_enum.MfaMethod.MFA_METHOD_WEBAUTHN,
          ],
          maskedEmail: '',
          expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 5)),
        ),
      );
    }
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

final class _PendingPasskeyClient implements PasskeyClient {
  final credential = Completer<Map<String, dynamic>>();
  int calls = 0;

  @override
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async => true;

  @override
  Future<Map<String, dynamic>> getCredential(
    List<int> options, {
    required String serverBaseUrl,
  }) {
    calls++;
    return credential.future;
  }

  @override
  Future<Map<String, dynamic>> createCredential(
    List<int> options, {
    required String serverBaseUrl,
  }) => getCredential(options, serverBaseUrl: serverBaseUrl);
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
  int calls = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls++;
    throw UnimplementedError('${invocation.memberName}');
  }
}
