import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
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
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart'
    as oauth2_enum;

import '../../../test_app.dart';
import '../../../support/populated_account_gateway.dart';

void main() {
  setUpAll(() async {
    if (kIsWeb) return;
    final loader = FontLoader('SyncTV UI CJK')
      ..addFont(rootBundle.load('assets/fonts/SyncTvUiCjk.ttf'));
    await loader.load();
    final roboto = FontLoader('Roboto');
    for (final weight in ['Regular', 'Bold']) {
      final file = File.fromUri(
        Uri.file(Platform.resolvedExecutable)
            .resolve('../../../artifacts/material_fonts/Roboto-$weight.ttf'),
      );
      roboto.addFont(
        file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
      );
    }
    await roboto.load();
  });
  testWidgets(
    'room overview survives search and refreshes after membership changes',
    (tester) async {
      final gateway = _OverviewRoomsGateway();
      await _pumpAccount(
        tester,
        gateway,
        onCreateRoom: () async {
          gateway.hasRoom = false;
        },
      );
      expect(find.text('Preview watch room'), findsOneWidget);
      await tester.tap(find.text('Rooms').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'missing-room');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(find.text('Preview watch room'), findsNothing);
      await tester.tap(find.text('Overview').first);
      await tester.pumpAndSettle();
      expect(find.text('Preview watch room'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.refresh_rounded).first);
      await tester.pumpAndSettle();
      expect(find.text('Preview watch room'), findsOneWidget);
      expect(gateway.listSearches.last, 'missing-room');
      expect(gateway.listRefreshes.last, isTrue);
      await tester.tap(find.text('Rooms').first);
      await tester.pumpAndSettle();
      expect(find.text('Preview watch room'), findsNothing);
      await tester.tap(find.text('Create room').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Overview').first);
      await tester.pumpAndSettle();
      expect(find.text('Preview watch room'), findsNothing);
      expect(find.text('No rooms'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'global refresh returns to a valid room page after external deletion',
    (tester) async {
      final gateway = _ShrinkingRoomsGateway();
      await _pumpAccount(tester, gateway);
      await tester.tap(find.text('Rooms').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right_rounded).first);
      await tester.pumpAndSettle();
      expect(gateway.pages.last, 2);
      expect(find.text('Preview watch room'), findsNothing);
      gateway.total = 2;
      gateway.pages.clear();
      await tester.tap(find.byIcon(Icons.refresh_rounded).first);
      await tester.pumpAndSettle();
      expect(gateway.pages, [2, 1]);
      expect(find.text('Preview watch room'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'global notification refresh preserves query and clears stale selection',
    (tester) async {
      final gateway = _RefreshingNotificationsGateway();
      await _pumpAccount(tester, gateway);
      await tester.tap(find.text('Notifications').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Read').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'preview');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      await tester.tap(find.text('All types').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Room invitation').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Created at').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Title').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.south_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      final query = Map<Symbol, dynamic>.from(gateway.queries.last);
      gateway.total = 0;
      await tester.tap(find.byIcon(Icons.refresh_rounded).first);
      await tester.pumpAndSettle();
      expect(gateway.queries.last, query);
      expect(query[#isRead], isTrue);
      expect(query[#search], 'preview');
      expect(
        query[#notificationType],
        client_enum.NotificationType.NOTIFICATION_TYPE_ROOM_INVITATION,
      );
      expect(
        query[#sortBy],
        client_enum.NotificationListSortBy.NOTIFICATION_LIST_SORT_BY_TITLE,
      );
      expect(
        query[#sortDirection],
        client_enum.SortDirection.SORT_DIRECTION_ASC,
      );
      expect(query[#refresh], isTrue);
      expect(find.text('Preview notification'), findsNothing);
      gateway.total = 1;
      await tester.tap(find.byIcon(Icons.refresh_rounded).first);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Checkbox>(find.byType(Checkbox).first).value,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'global notification refresh clamps page after external deletion',
    (tester) async {
      final gateway = _RefreshingNotificationsGateway()..total = 51;
      await _pumpAccount(tester, gateway);
      await tester.tap(find.text('Notifications').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right_rounded).first);
      await tester.pumpAndSettle();
      expect(gateway.queries.last[#page], 2);
      gateway.total = 1;
      gateway.queries.clear();
      await tester.tap(find.byIcon(Icons.refresh_rounded).first);
      await tester.pumpAndSettle();
      expect(gateway.queries.map((query) => query[#page]), [2, 1]);
      expect(find.text('Preview notification'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 900)]) {
      testWidgets('Unavailable verification readable at $locale/$size', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => DependencyRegistryScope(
              values: {
                AccountGateway: UnavailableVerificationPreviewGateway(),
                OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
                OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                NativeAppleSignInClient: _UnavailableAppleSignIn(),
                PasskeyClient: _UnavailablePasskeyClient(),
                ResourceUrlResolver: const IdentityResourceUrlResolver(),
              },
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(3)),
                child: buildThemedTestApp(context, child),
              ),
            ),
            home: AccountCenterPage(
              initialUser: PopulatedAccountPreviewGateway.user,
              onOpenRoom: (_) async {},
              onCreateRoom: () async {},
              onManageRoom: (_) async {},
              onOpenProviderBinding: (_) async {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
        final profile = find.text(l10n.profile).first;
        await tester.ensureVisible(profile);
        await tester.pumpAndSettle();
        await tester.tap(profile);
        await tester.pumpAndSettle();
        if (locale == 'en') {
          for (final value in [
            l10n.personalProfile,
            l10n.personalProfileDescription,
          ]) {
            final paragraph = tester.renderObject<RenderParagraph>(
              find.text(value),
            );
            for (final word in RegExp(r'\S+').allMatches(value)) {
              expect(
                paragraph.getBoxesForSelection(
                  TextSelection(baseOffset: word.start, extentOffset: word.end),
                ),
                hasLength(1),
                reason: 'Profile heading: ${word.group(0)}',
              );
            }
          }
        }
        final bindings = find.text(l10n.bindings).first;
        await tester.ensureVisible(bindings);
        await tester.pumpAndSettle();
        await tester.tap(bindings);
        await tester.pumpAndSettle();
        final unlink = find.byWidgetPredicate(
          (widget) => widget is AppIconButton && widget.tooltip == l10n.unbind,
        );
        await tester.scrollUntilVisible(
          unlink,
          300,
          scrollable: find.byType(Scrollable).last,
          maxScrolls: 80,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(unlink);
        await tester.pumpAndSettle();
        expect(unlink.hitTestable(), findsOneWidget);
        await tester.tap(unlink);
        await tester.pumpAndSettle();
        for (final value in [
          l10n.identityVerification,
          l10n.noVerificationMethods,
          l10n.noVerificationMethodsDescription,
        ]) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(value),
          );
          expect(paragraph.didExceedMaxLines, isFalse);
          if (locale == 'en') {
            for (final word in RegExp(r'\S+').allMatches(value)) {
              expect(
                paragraph.getBoxesForSelection(
                  TextSelection(baseOffset: word.start, extentOffset: word.end),
                ),
                hasLength(1),
                reason: word.group(0),
              );
            }
          }
        }
        final cancel = find.text(l10n.cancel);
        await tester.ensureVisible(cancel);
        await tester.pumpAndSettle();
        await tester.tap(cancel);
        await tester.pumpAndSettle();
        expect(find.text(l10n.noVerificationMethods), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final phase in [
    'duplicate',
    'verification-disposed',
    'unlink-disposed',
    'failure-retry',
    'cancel',
  ]) {
    testWidgets('OAuth unlink lifecycle $phase', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _ControlledUnlinkGateway();
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyRegistryScope(
            values: {
              AccountGateway: gateway,
              OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
              OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
              NativeAppleSignInClient: _UnavailableAppleSignIn(),
              PasskeyClient: _UnavailablePasskeyClient(),
              ResourceUrlResolver: const IdentityResourceUrlResolver(),
            },
            child: child!,
          ),
          home: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, show, _) => show
                ? AccountCenterPage(
                    initialUser: PopulatedAccountPreviewGateway.user,
                    onOpenRoom: (_) async {},
                    onCreateRoom: () async {},
                    onManageRoom: (_) async {},
                    onOpenProviderBinding: (_) async {},
                  )
                : const Scaffold(body: Text('Replacement page')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bindings').first);
      await tester.pumpAndSettle();
      final unlink = find.byWidgetPredicate(
        (widget) => widget is AppIconButton && widget.tooltip == 'Unbind',
      );
      await tester.scrollUntilVisible(
        unlink,
        300,
        scrollable: find.byType(Scrollable).last,
        maxScrolls: 40,
      );
      final callback = tester.widget<AppIconButton>(unlink).onPressed!;
      callback();
      callback();
      await tester.pump();
      expect(gateway.verifications, 1);
      if (phase == 'verification-disposed') {
        visible.value = false;
        await tester.pump();
      } else if (phase == 'cancel') {
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }
      gateway.verification.complete(
        const SensitiveOperationVerificationComplete(
          verificationId: 'preview-verification',
        ),
      );
      await tester.pumpAndSettle();
      if (phase == 'verification-disposed' || phase == 'cancel') {
        expect(gateway.unlinks, isEmpty);
        expect(gateway.linkLoads, 1);
        if (phase == 'cancel') {
          expect(tester.widget<AppIconButton>(unlink).onPressed, isNotNull);
        }
      } else {
        expect(gateway.unlinks.single.providerUserId, 'linked-user');
        expect(gateway.verificationIds, ['preview-verification']);
        expect(tester.widget<AppIconButton>(unlink).onPressed, isNull);
        callback();
        expect(gateway.unlinks, hasLength(1));
        if (phase == 'unlink-disposed') {
          visible.value = false;
          await tester.pump();
        }
        if (phase == 'failure-retry') {
          gateway.unlink.completeError(StateError('Preview failure'));
          await tester.pumpAndSettle();
          expect(tester.widget<AppIconButton>(unlink).onPressed, isNotNull);
          expect(gateway.linkLoads, 1);
          gateway.unlink = Completer<void>();
          callback();
          await tester.pumpAndSettle();
          expect(gateway.unlinks, hasLength(2));
          expect(gateway.verifications, 2);
        }
        gateway.unlink.complete();
        await tester.pumpAndSettle();
        expect(gateway.linkLoads, phase == 'unlink-disposed' ? 1 : 2);
        if (visible.value) {
          expect(find.textContaining('preview-linked-account'), findsNothing);
        }
      }
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final phase in ['duplicate', 'cancel', 'disposed', 'verification']) {
    testWidgets('TOTP setup callback $phase', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _TotpSetupGateway(verifyTotp: phase == 'verification');
      final submitted = phase == 'duplicate' || phase == 'verification';
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyRegistryScope(
            values: {
              AccountGateway: gateway,
              OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
              OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
              NativeAppleSignInClient: _UnavailableAppleSignIn(),
              PasskeyClient: _AvailablePasskeyClient(),
              ResourceUrlResolver: const IdentityResourceUrlResolver(),
            },
            child: child!,
          ),
          home: AccountCenterPage(
            initialUser: PopulatedAccountPreviewGateway.user,
            onOpenRoom: (_) async {},
            onCreateRoom: () async {},
            onManageRoom: (_) async {},
            onOpenProviderBinding: (_) async {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
      await tester.tap(find.text(l10n.security).first);
      await tester.pumpAndSettle();
      final setup = find.text(l10n.setup);
      await tester.ensureVisible(setup);
      await tester.tap(setup);
      await tester.pumpAndSettle();
      if (phase == 'verification') {
        for (final invalid in [
          'abcdef',
          '0x1234',
          '+12345',
          '-12345',
          '12 345',
          '12345',
          '1234567',
        ]) {
          await tester.enterText(find.byType(TextField), invalid);
          tester.widget<TextField>(find.byType(TextField)).onSubmitted!('');
          await tester.pumpAndSettle();
          expect(gateway.verificationCodes, isEmpty, reason: invalid);
          expect(find.text(l10n.enterAuthenticatorCode), findsOneWidget);
          await tester.pump(const Duration(seconds: 4));
          await tester.pumpAndSettle();
        }
        await tester.enterText(find.byType(TextField), ' 012345 ');
        tester.widget<TextField>(find.byType(TextField)).onSubmitted!('');
        await tester.pumpAndSettle();
        expect(gateway.verificationCodes, ['012345']);
      }
      for (final invalid in [
        '0x1234',
        '+12345',
        '-12345',
        '12345',
        '1234567',
        '12 345',
        'abcdef',
      ]) {
        await tester.enterText(find.byType(TextField), invalid);
        tester.widget<TextField>(find.byType(TextField)).onSubmitted!('');
        await tester.pumpAndSettle();
        expect(gateway.codes, isEmpty, reason: invalid);
        expect(find.text(l10n.confirmSetup), findsOneWidget, reason: invalid);
        expect(find.text(l10n.enterAuthenticatorCode), findsOneWidget);
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
      }
      await tester.enterText(find.byType(TextField), ' 012345 ');
      final keyboard = tester
          .widget<TextField>(find.byType(TextField))
          .onSubmitted!;
      final button = tester
          .widget<AppActionButton>(
            find.ancestor(
              of: find.text(l10n.confirmSetup),
              matching: find.byType(AppActionButton),
            ),
          )
          .onPressed!;
      if (!submitted) {
        await tester.tap(find.text(l10n.cancel));
        if (phase == 'disposed') await tester.pumpAndSettle();
      }
      keyboard('');
      button();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(gateway.codes, submitted ? ['012345'] : isEmpty);
      if (submitted) {
        final saved = find.text(l10n.savedRecoveryCodes);
        await tester.ensureVisible(saved);
        await tester.tap(saved);
        await tester.pumpAndSettle();
      }
      expect(find.byType(AccountCenterPage), findsOneWidget);
    });
  }

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(1200, 900), const Size(320, 568)]) {
      for (final refreshState in ['ready', 'failed', 'pending']) {
        testWidgets('Recovery codes layout $locale/$size/$refreshState', (
          tester,
        ) async {
          String? copiedCodes;
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            (call) async {
              if (call.method == 'Clipboard.setData') {
                copiedCodes = (call.arguments as Map)['text'] as String;
              }
              return null;
            },
          );
          addTearDown(
            () => tester.binding.defaultBinaryMessenger
                .setMockMethodCallHandler(SystemChannels.platform, null),
          );
          await tester.binding.setSurfaceSize(size);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => DependencyRegistryScope(
                values: {
                  AccountGateway: _RecoveryRefreshGateway(refreshState),
                  OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
                  OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                  NativeAppleSignInClient: _UnavailableAppleSignIn(),
                  PasskeyClient: _AvailablePasskeyClient(),
                  ResourceUrlResolver: const IdentityResourceUrlResolver(),
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(3)),
                  child: child!,
                ),
              ),
              home: AccountCenterPage(
                initialUser: PopulatedAccountPreviewGateway.user,
                onOpenRoom: (_) async {},
                onCreateRoom: () async {},
                onManageRoom: (_) async {},
                onOpenProviderBinding: (_) async {},
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
          final security = find.text(l10n.security).first;
          await tester.ensureVisible(security);
          await tester.pumpAndSettle();
          await tester.tap(security);
          await tester.pumpAndSettle();
          final open = find.text(l10n.recoveryCodes);
          await tester.ensureVisible(open);
          await tester.pumpAndSettle();
          await tester.tap(open);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          Rect? previousCode;
          for (var index = 0; index < 10; index++) {
            final code = find.text(
              'TEST-CODE-${index.toString().padLeft(2, '0')}',
            );
            expect(code, findsOneWidget);
            final bounds = tester.getRect(code);
            if (previousCode != null) {
              expect(
                bounds.top - previousCode.bottom,
                greaterThanOrEqualTo(24),
              );
            }
            previousCode = bounds;
          }
          for (final label in [l10n.copyAll, l10n.savedRecoveryCodes]) {
            final action = find.text(label);
            await tester.ensureVisible(action);
            await tester.pumpAndSettle();
            expect(action.hitTestable(), findsOneWidget);
            expect(
              tester.renderObject<RenderParagraph>(action).didExceedMaxLines,
              isFalse,
            );
            if (label == l10n.copyAll) {
              await tester.tap(action);
              await tester.pumpAndSettle();
              expect(
                copiedCodes,
                List.generate(
                  10,
                  (index) => 'TEST-CODE-${index.toString().padLeft(2, '0')}',
                ).join('\n'),
              );
              await tester.pump(const Duration(seconds: 5));
              await tester.pumpAndSettle();
            }
          }
          final saved = tester
              .widget<AppActionButton>(
                find.ancestor(
                  of: find.text(l10n.savedRecoveryCodes),
                  matching: find.byType(AppActionButton),
                ),
              )
              .onPressed!;
          saved();
          saved();
          await tester.pumpAndSettle();
          saved();
          expect(tester.takeException(), isNull);
          expect(find.byType(AccountCenterPage), findsOneWidget);
        });
      }
    }
  }

  for (final action in ['submit', 'cancel', 'close']) {
    for (final phase in ['exiting', 'disposed', 'parent-disposed']) {
      testWidgets('Rename dialog late $action phase=$phase', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final gateway = _RecordingRenameGateway();
        final visible = ValueNotifier(true);
        addTearDown(visible.dispose);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => DependencyRegistryScope(
              values: {
                AccountGateway: gateway,
                OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
                OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                NativeAppleSignInClient: _UnavailableAppleSignIn(),
                PasskeyClient: _AvailablePasskeyClient(),
                ResourceUrlResolver: const IdentityResourceUrlResolver(),
              },
              child: child!,
            ),
            home: ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (_, show, _) => show
                  ? AccountCenterPage(
                      initialUser: PopulatedAccountPreviewGateway.user,
                      onOpenRoom: (_) async {},
                      onCreateRoom: () async {},
                      onManageRoom: (_) async {},
                      onOpenProviderBinding: (_) async {},
                    )
                  : const Scaffold(body: Text('Replacement page')),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Profile').first);
        await tester.pumpAndSettle();
        final open = find.text('Edit');
        await tester.ensureVisible(open);
        await tester.tap(open);
        await tester.pumpAndSettle();
        if (action == 'submit' && phase == 'exiting') {
          await tester.enterText(find.byType(TextField), '   ');
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
          expect(find.text('Enter a username'), findsOneWidget);
          expect(gateway.names, isEmpty);
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();
          expect(find.text('Enter a username'), findsOneWidget);
          expect(gateway.names, isEmpty);
          gateway.failNext = true;
          await tester.enterText(find.byType(TextField), 'Rejected name');
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
          expect(find.textContaining('Rename rejected'), findsOneWidget);
          expect(
            tester.widget<TextField>(find.byType(TextField)).controller!.text,
            'Rejected name',
          );
          expect(gateway.names, ['Rejected name']);
          gateway.names.clear();
        }
        await tester.enterText(find.byType(TextField), ' Updated account ');
        final submit = tester
            .widget<TextField>(find.byType(TextField))
            .onSubmitted!;
        final cancel = tester
            .widget<AppActionButton>(
              find.ancestor(
                of: find.text('Cancel'),
                matching: find.byType(AppActionButton),
              ),
            )
            .onPressed!;
        final close = tester
            .widget<AppIconButton>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is AppIconButton && widget.tooltip == 'Close',
              ),
            )
            .onPressed!;
        final VoidCallback callback = switch (action) {
          'submit' => () => submit(''),
          'cancel' => cancel,
          _ => close,
        };
        if (phase == 'parent-disposed') {
          visible.value = false;
          await tester.pumpAndSettle();
        }
        callback();
        if (phase == 'disposed') await tester.pumpAndSettle();
        callback();
        if (action != 'submit') submit('');
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          phase == 'parent-disposed'
              ? find.text('Replacement page')
              : find.byType(AccountCenterPage),
          findsOneWidget,
        );
        expect(
          gateway.names,
          action == 'submit' && phase != 'parent-disposed'
              ? ['Updated account']
              : isEmpty,
        );
      });
    }
  }

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(1200, 900), const Size(320, 568)]) {
      for (final reset in [false, true]) {
        testWidgets('Password dialog layout $locale/$size/reset=$reset', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(size);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.light,
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => DependencyRegistryScope(
                values: {
                  AccountGateway: PopulatedAccountPreviewGateway(),
                  OpaqueAuthenticatorService: _RecordingPasswordAuthenticator(),
                  OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                  NativeAppleSignInClient: _UnavailableAppleSignIn(),
                  PasskeyClient: _AvailablePasskeyClient(),
                  ResourceUrlResolver: const IdentityResourceUrlResolver(),
                },
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(3)),
                  child: child!,
                ),
              ),
              home: AccountCenterPage(
                initialUser: PopulatedAccountPreviewGateway.user,
                onOpenRoom: (_) async {},
                onCreateRoom: () async {},
                onManageRoom: (_) async {},
                onOpenProviderBinding: (_) async {},
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
          final security = find.text(l10n.security).first;
          await tester.ensureVisible(security);
          await tester.pumpAndSettle();
          await tester.tap(security);
          await tester.pumpAndSettle();
          final open = find.text(reset ? l10n.emailReset : l10n.edit);
          await tester.ensureVisible(open);
          await tester.pumpAndSettle();
          await tester.tap(open);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          for (final keyboard in [false, true]) {
            tester.view.viewInsets = FakeViewPadding(
              bottom: keyboard ? 240 : 0,
            );
            addTearDown(tester.view.resetViewInsets);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final fields = find.byWidgetPredicate(
              (widget) => widget is TextField && !widget.readOnly,
            );
            for (var i = 0; i < fields.evaluate().length; i++) {
              await tester.ensureVisible(fields.at(i));
              await tester.pumpAndSettle();
              expect(fields.at(i).hitTestable(), findsOneWidget);
            }
            for (final field in find.byType(AppTextField).evaluate()) {
              final label = (field.widget as AppTextField).label;
              final text = find.descendant(
                of: find.byWidget(field.widget),
                matching: find.text(label),
              );
              expect(text, findsOneWidget);
              expect(
                tester.renderObject<RenderParagraph>(text).didExceedMaxLines,
                isFalse,
                reason: label,
              );
            }
            if (reset) {
              final recipient = find.byWidgetPredicate(
                (widget) => widget is TextField && widget.readOnly,
              );
              final editable = find.descendant(
                of: recipient,
                matching: find.byType(EditableText),
              );
              final render = tester
                  .state<EditableTextState>(editable)
                  .renderEditable;
              expect(render.maxScrollExtent, 0);
            }
            for (final label in [
              if (reset) l10n.send,
              reset ? l10n.resetPassword : l10n.savePassword,
              l10n.cancel,
            ]) {
              final action = find.text(label).last;
              await tester.ensureVisible(action);
              await tester.pumpAndSettle();
              expect(action.hitTestable(), findsOneWidget);
              expect(
                tester.renderObject<RenderParagraph>(action).didExceedMaxLines,
                isFalse,
                reason: label,
              );
            }
          }
          await tester.tap(find.text(l10n.cancel).last);
          await tester.pumpAndSettle();
          expect(find.byType(TextField), findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  for (final method in ['password', 'email', 'passkey', 'reset']) {
    for (final phase in [
      'live',
      'disposed',
      'duplicate',
      'cancel',
      'dialog-disposed',
    ]) {
      testWidgets('Password operation $method at $phase', (tester) async {
        final dispose = phase == 'disposed';
        final canceled = phase == 'cancel' || phase == 'dialog-disposed';
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final visible = ValueNotifier(true);
        addTearDown(visible.dispose);
        final authenticator = _RecordingPasswordAuthenticator();
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => DependencyRegistryScope(
              values: {
                AccountGateway: PopulatedAccountPreviewGateway(),
                OpaqueAuthenticatorService: authenticator,
                OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                NativeAppleSignInClient: _UnavailableAppleSignIn(),
                PasskeyClient: _AvailablePasskeyClient(),
                ResourceUrlResolver: const IdentityResourceUrlResolver(),
              },
              child: child!,
            ),
            home: ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (_, show, _) => show
                  ? AccountCenterPage(
                      initialUser: PopulatedAccountPreviewGateway.user,
                      onOpenRoom: (_) async {},
                      onCreateRoom: () async {},
                      onManageRoom: (_) async {},
                      onOpenProviderBinding: (_) async {},
                    )
                  : const Scaffold(body: Text('Replacement page')),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Security').first);
        await tester.pumpAndSettle();
        final open = find.text(method == 'reset' ? 'Email reset' : 'Edit');
        await tester.ensureVisible(open);
        await tester.tap(open);
        await tester.pumpAndSettle();
        if (method == 'email' || method == 'passkey') {
          final segment = find
              .text(method == 'email' ? 'Email' : 'Passkey')
              .last;
          await tester.ensureVisible(segment);
          await tester.pumpAndSettle();
          await tester.tap(segment);
          await tester.pumpAndSettle();
        }
        final fields = find.byWidgetPredicate(
          (widget) => widget is TextField && !widget.readOnly,
        );
        if (method != 'reset' && phase == 'live') {
          final save = find.text('Save password');
          await tester.ensureVisible(save);
          await tester.tap(save);
          await tester.pumpAndSettle();
          expect(find.text('Enter a password'), findsNWidgets(2));
          if (method != 'passkey') {
            expect(
              find.text(
                method == 'email'
                    ? 'Enter the email verification code'
                    : 'Enter the current password',
              ),
              findsOneWidget,
            );
          }
          expect(authenticator.calls, 0);
          await tester.enterText(
            fields.at(method == 'passkey' ? 0 : 1),
            'first',
          );
          await tester.enterText(fields.last, 'different');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();
          expect(find.text('The new passwords do not match'), findsOneWidget);
          expect(authenticator.calls, 0);
        }
        if (method != 'passkey') {
          await tester.enterText(fields.at(0), 'verification');
        }
        await tester.enterText(
          fields.at(method == 'passkey' ? 0 : 1),
          ' new password ',
        );
        await tester.enterText(
          fields.at(method == 'passkey' ? 1 : 2),
          ' new password ',
        );
        if (dispose) {
          visible.value = false;
          await tester.pumpAndSettle();
        }
        final submit = find.text(
          method == 'reset' ? 'Reset password' : 'Save password',
        );
        await tester.ensureVisible(submit);
        if (phase == 'duplicate' || canceled) {
          final button = tester.widget<AppActionButton>(
            find.ancestor(of: submit, matching: find.byType(AppActionButton)),
          );
          final keyboardSubmit = tester
              .widget<TextField>(fields.last)
              .onSubmitted!;
          if (canceled) {
            await tester.tap(find.text('Cancel'));
            if (phase == 'dialog-disposed') await tester.pumpAndSettle();
          }
          keyboardSubmit('');
          button.onPressed!();
        } else {
          await tester.tap(submit);
        }
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(authenticator.calls, dispose || canceled ? 0 : 1);
        if (!dispose && !canceled) {
          expect(authenticator.password, ' new password ');
        }
        if (dispose) expect(find.text('Replacement page'), findsOneWidget);
        if (!dispose) expect(find.byType(AccountCenterPage), findsOneWidget);
      });
    }
  }

  for (final phase in [
    'duplicate',
    'session',
    'verification',
    'start',
    'authorization',
    'finish',
    'cancel-session',
    'cancel-start',
    'cancel-authorization',
    'cancel-finish',
  ]) {
    testWidgets('OAuth binding lifecycle at $phase', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final stage = phase.replaceFirst('cancel-', '');
      final cancel = phase.startsWith('cancel-');
      final gateway = _ControlledBindingGateway(stage);
      final callbacks = _ControlledBindingCallbacks();
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
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
            child: child!,
          ),
          home: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, show, _) => show
                ? AccountCenterPage(
                    initialUser: _testUser,
                    onOpenRoom: (_) async {},
                    onCreateRoom: () async {},
                    onManageRoom: (_) async {},
                    onOpenProviderBinding: (_) async {},
                  )
                : const Scaffold(body: Text('Replacement page')),
          ),
        ),
      );
      Future<void> pumpFrames() async {
        for (var frame = 0; frame < 5; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await tester.pump();
      final cancelLabel = tester
          .element(find.byType(AccountCenterPage))
          .l10n
          .cancelBinding;
      await tester.tap(find.text('Bindings').first);
      await pumpFrames();
      final bind = find.text('GitHub (github)');
      await tester.scrollUntilVisible(
        bind,
        300,
        scrollable: find.byType(Scrollable).last,
        maxScrolls: 40,
      );
      await tester.pump();
      if (phase == 'duplicate') {
        final start = tester
            .widget<AppActionButton>(
              find.ancestor(of: bind, matching: find.byType(AppActionButton)),
            )
            .onPressed!;
        start();
        start();
        expect(callbacks.creationCalls, 1);
      } else {
        await tester.tap(bind);
      }
      if (stage != 'session') callbacks.creation.complete(callbacks.session);
      await pumpFrames();
      if (stage == 'finish') {
        callbacks.session.authorization.complete(
          const OAuth2CallbackPayload(code: 'code', state: 'state'),
        );
        await pumpFrames();
        expect(gateway.finishCalls, 1);
      }
      if (cancel) {
        final cancelButton = find.text(cancelLabel);
        await tester.ensureVisible(cancelButton);
        await tester.pump();
        await tester.tap(cancelButton);
        await tester.pump();
        await tester.ensureVisible(bind);
        await tester.pump();
        await tester.tap(bind);
        expect(callbacks.creationCalls, 2);
      } else {
        visible.value = false;
      }
      await pumpFrames();
      if (stage == 'session') callbacks.creation.complete(callbacks.session);
      gateway.verification.complete(
        const SensitiveOperationVerificationComplete(
          verificationId: 'verification-id',
        ),
      );
      gateway.start.complete();
      if (!callbacks.session.authorization.isCompleted) {
        callbacks.session.authorization.complete(
          const OAuth2CallbackPayload(code: 'code', state: 'state'),
        );
      }
      gateway.finish.complete();
      await pumpFrames();
      expect(tester.takeException(), isNull);
      if (cancel) {
        expect(find.text(cancelLabel), findsOneWidget);
        visible.value = false;
        await pumpFrames();
        callbacks.nextCreation.complete(callbacks.nextSession);
        await pumpFrames();
        expect(callbacks.nextSession.closeCount, 1);
      }
      expect(find.text('Replacement page'), findsOneWidget);
      expect(
        gateway.startCalls,
        ['session', 'verification'].contains(stage) ? 0 : 1,
      );
      expect(
        callbacks.session.authorizeCalls,
        ['duplicate', 'authorization', 'finish'].contains(stage) ? 1 : 0,
      );
      expect(gateway.finishCalls, stage == 'finish' ? 1 : 0);
      expect(gateway.linkLoads, 1);
      expect(callbacks.session.closeCount, 1);
    });
  }

  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      for (final size in [
        const Size(1200, 900),
        const Size(1200, 360),
        const Size(320, 568),
      ]) {
        for (final state in ['loading', 'empty', 'error', 'populated']) {
          testWidgets(
            'Account pages stay readable at $locale/$scale/${size.width}/$state',
            (tester) async {
              final openedProviders = <String>[];
              await tester.binding.setSurfaceSize(size);
              addTearDown(() => tester.binding.setSurfaceSize(null));
              final initialUser = state == 'loading'
                  ? _testUser.copyWith(
                      username: 'Preview account with a longer display name',
                      email: 'preview.account.with.a.long.address@example.test',
                    )
                  : _testUser;
              await tester.pumpWidget(
                MaterialApp(
                  locale: Locale(locale),
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  builder: (context, child) => DependencyRegistryScope(
                    values: {
                      AccountGateway: state == 'populated'
                          ? PopulatedAccountPreviewGateway()
                          : _AccountLayoutGateway(state),
                      OpaqueAuthenticatorService: OpaqueAuthenticatorService(
                        gateway: _UnusedOpaqueGateway(),
                      ),
                      OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                      NativeAppleSignInClient: _UnavailableAppleSignIn(),
                      PasskeyClient: _UnavailablePasskeyClient(),
                      ResourceUrlResolver: const IdentityResourceUrlResolver(),
                    },
                    child: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(scale)),
                      child: buildThemedTestApp(context, child),
                    ),
                  ),
                  home: AccountCenterPage(
                    initialUser: initialUser,
                    onOpenRoom: (_) async {},
                    onCreateRoom: () async {},
                    onManageRoom: (_) async {},
                    onOpenProviderBinding: (id) async =>
                        openedProviders.add(id),
                  ),
                ),
              );
              await tester.pump();
              final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
              for (final label in [
                l10n.overview,
                l10n.profile,
                l10n.rooms,
                l10n.privacy,
                l10n.security,
                l10n.notifications,
                l10n.bindings,
              ]) {
                final target = find.text(label).first;
                await tester.ensureVisible(target);
                await tester.pump(const Duration(milliseconds: 300));
                expect(target.hitTestable(), findsOneWidget);
                expect(
                  tester
                      .renderObject<RenderParagraph>(target)
                      .didExceedMaxLines,
                  isFalse,
                  reason: label,
                );
                await tester.tap(target);
                await tester.pump();
                await tester.pump(const Duration(milliseconds: 300));
                expect(tester.takeException(), isNull, reason: label);
                if (label == l10n.overview &&
                    state == 'loading' &&
                    size.width >= 900) {
                  for (final value in [
                    initialUser.username,
                    initialUser.email!,
                  ]) {
                    expect(
                      tester
                          .renderObject<RenderParagraph>(find.text(value).first)
                          .didExceedMaxLines,
                      isFalse,
                    );
                  }
                }
                if (label == l10n.overview && state == 'populated') {
                  if (size.width >= 900) {
                    for (final value in [
                      PopulatedAccountPreviewGateway.user.username,
                      PopulatedAccountPreviewGateway.user.email!,
                    ]) {
                      final sidebarText = tester.renderObject<RenderParagraph>(
                        find.text(value).first,
                      );
                      expect(sidebarText.didExceedMaxLines, isFalse);
                    }
                  }
                  final identity = find.byWidgetPredicate(
                    (widget) =>
                        widget is Text &&
                        widget.data ==
                            PopulatedAccountPreviewGateway.user.username &&
                        widget.style?.fontWeight == FontWeight.w900,
                  );
                  expect(identity, findsOneWidget);
                  expect(
                    tester
                        .renderObject<RenderParagraph>(identity)
                        .didExceedMaxLines,
                    isFalse,
                  );
                  for (final metric in [
                    l10n.myRooms,
                    l10n.unreadNotifications,
                    l10n.loginFactors,
                    l10n.emailStatus,
                  ]) {
                    final paragraph = tester.renderObject<RenderParagraph>(
                      find.text(metric).first,
                    );
                    expect(paragraph.didExceedMaxLines, isFalse);
                    if (locale == 'en' &&
                        paragraph.getMinIntrinsicWidth(double.infinity) <=
                            paragraph.size.width) {
                      for (final word in RegExp(r'\S+').allMatches(metric)) {
                        expect(
                          paragraph.getBoxesForSelection(
                            TextSelection(
                              baseOffset: word.start,
                              extentOffset: word.end,
                            ),
                          ),
                          hasLength(1),
                          reason: 'Overview metric word: ${word.group(0)}',
                        );
                      }
                    }
                  }
                }
                final commands = label == l10n.overview
                    ? [
                        l10n.viewProfile,
                        l10n.manageSecurity,
                        l10n.createRoom,
                        l10n.manageRooms,
                      ]
                    : label == l10n.profile
                    ? [l10n.edit]
                    : label == l10n.security
                    ? [
                        if (state == 'populated') ...[
                          l10n.unbind,
                          l10n.emailReset,
                          l10n.edit,
                          l10n.recoveryCodes,
                          l10n.bind,
                        ],
                        l10n.close,
                      ]
                    : <String>[];
                for (final command in commands) {
                  final action = find.text(command).first;
                  await tester.ensureVisible(action);
                  await tester.pump(const Duration(milliseconds: 300));
                  expect(action.hitTestable(), findsOneWidget, reason: command);
                  expect(
                    tester
                        .renderObject<RenderParagraph>(action)
                        .didExceedMaxLines,
                    isFalse,
                    reason: command,
                  );
                  if (locale == 'en' && label == l10n.profile) {
                    final paragraph = tester.renderObject<RenderParagraph>(
                      action,
                    );
                    for (final word in RegExp(r'\S+').allMatches(command)) {
                      expect(
                        paragraph.getBoxesForSelection(
                          TextSelection(
                            baseOffset: word.start,
                            extentOffset: word.end,
                          ),
                        ),
                        hasLength(1),
                        reason:
                            'Username command word must stay intact: ${word.group(0)}',
                      );
                    }
                  }
                }
                if (state == 'error' &&
                    [
                      l10n.rooms,
                      l10n.privacy,
                      l10n.notifications,
                    ].contains(label)) {
                  final retry = find.text(l10n.retry);
                  await tester.scrollUntilVisible(
                    retry,
                    300,
                    scrollable: find
                        .descendant(
                          of: find.byType(NestedScrollView).first,
                          matching: find.byType(Scrollable),
                        )
                        .first,
                    maxScrolls: 40,
                  );
                  await tester.ensureVisible(retry);
                  await tester.pump(const Duration(milliseconds: 300));
                  expect(retry.hitTestable(), findsOneWidget);
                }
                if (state == 'populated') {
                  if (label == l10n.bindings) {
                    final providers = [
                      ('AList', 'alist', l10n.alistAccountDescription),
                      (
                        'Cloudreve',
                        'cloudreve',
                        l10n.cloudreveAccountDescription,
                      ),
                      ('Emby', 'emby', l10n.embyAccountDescription),
                      ('FNOS', 'fnos', l10n.fnosAccountDescription),
                      ('QNAP', 'qnap', l10n.qnapAccountDescription),
                      (
                        'Synology DSM',
                        'synology',
                        l10n.synologyAccountDescription,
                      ),
                      (
                        'Nextcloud',
                        'nextcloud',
                        l10n.nextcloudAccountDescription,
                      ),
                      ('Seafile', 'seafile', l10n.seafileAccountDescription),
                      ('TrueNAS', 'truenas', l10n.truenasAccountDescription),
                    ];
                    for (final (name, id, description) in providers) {
                      final entry = find.text(name);
                      await tester.ensureVisible(entry);
                      await tester.pump(const Duration(milliseconds: 300));
                      expect(entry.hitTestable(), findsOneWidget);
                      for (final text in [entry, find.text(description)]) {
                        final paragraph = tester.renderObject<RenderParagraph>(
                          text,
                        );
                        expect(paragraph.didExceedMaxLines, isFalse);
                        expect(
                          paragraph.overflow,
                          isNot(TextOverflow.ellipsis),
                        );
                      }
                      await tester.tap(entry);
                      await tester.pump();
                      expect(openedProviders.last, id);
                      expect(tester.takeException(), isNull);
                    }
                  }
                  if (label == l10n.profile && size.width == 320) {
                    final username = tester.renderObject<RenderParagraph>(
                      find.text('Preview account').last,
                    );
                    final email = tester.renderObject<RenderParagraph>(
                      find.text('preview@example.test').last,
                    );
                    expect(username.size.width, greaterThan(230));
                    expect(email.size.width, greaterThan(230));
                  }
                  final marker = {
                    l10n.rooms: 'Preview watch room',
                    l10n.privacy: 'Preview blocked user',
                    l10n.notifications: 'Preview notification',
                    l10n.bindings: 'preview-linked-account',
                  }[label];
                  if (marker != null) {
                    final content = find.textContaining(marker);
                    final nested = find.byType(NestedScrollView);
                    await tester.scrollUntilVisible(
                      content,
                      300,
                      scrollable: nested.evaluate().isEmpty
                          ? find.byType(Scrollable).last
                          : find
                                .descendant(
                                  of: nested.first,
                                  matching: find.byType(Scrollable),
                                )
                                .first,
                      maxScrolls: 40,
                    );
                    await tester.pump(const Duration(milliseconds: 300));
                    expect(content, findsOneWidget, reason: marker);
                    expect(
                      tester.getRect(content).overlaps(Offset.zero & size),
                      isTrue,
                      reason: marker,
                    );
                    if (label == l10n.bindings && size.width == 320) {
                      expect(tester.getSize(content).width, greaterThan(230));
                    }
                    expect(tester.takeException(), isNull, reason: marker);
                  }
                }
              }
            },
          );
        }
      }

      testWidgets('OAuth binding provider stays readable at $locale/$scale', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const providerName = 'corporate-authentication-provider';
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => DependencyRegistryScope(
              values: {
                AccountGateway: _OAuth2BindingAccountGateway(
                  [],
                  providerName: providerName,
                ),
                OpaqueAuthenticatorService: OpaqueAuthenticatorService(
                  gateway: _UnusedOpaqueGateway(),
                ),
                OAuth2CallbackClient: _OAuth2Callbacks([]),
                NativeAppleSignInClient: _UnavailableAppleSignIn(),
                PasskeyClient: _UnavailablePasskeyClient(),
                ResourceUrlResolver: const IdentityResourceUrlResolver(),
              },
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: buildThemedTestApp(context, child),
              ),
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
        final l10n = tester.element(find.byType(AccountCenterPage)).l10n;
        final tab = find.text(l10n.bindings).first;
        await tester.ensureVisible(tab);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.tap(tab);
        for (var frame = 0; frame < 5; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        final label = find.text('GitHub ($providerName)');
        await tester.scrollUntilVisible(
          label,
          300,
          scrollable: find.byType(Scrollable).last,
          maxScrolls: 40,
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(label.hitTestable(), findsOneWidget);
        expect(
          tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
          isFalse,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }

  for (final width in [320.0, 600.0, 1200.0]) {
    for (final scale in [1.0, 1.5]) {
      for (final hasEmail in [false, true]) {
        testWidgets(
          'overview metric labels remain inside their surfaces at $width/$scale, email=$hasEmail',
          (tester) async {
            await tester.binding.setSurfaceSize(Size(width, 900));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            await tester.pumpWidget(
              MaterialApp(
                locale: const Locale('en'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) => DependencyRegistryScope(
                  values: {
                    AccountGateway: _HangingAccountGateway(),
                    OpaqueAuthenticatorService: OpaqueAuthenticatorService(
                      gateway: _UnusedOpaqueGateway(),
                    ),
                    OAuth2CallbackClient: _UnavailableOAuth2Callbacks(),
                    NativeAppleSignInClient: _UnavailableAppleSignIn(),
                    PasskeyClient: _UnavailablePasskeyClient(),
                    ResourceUrlResolver: const IdentityResourceUrlResolver(),
                  },
                  child: MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.linear(scale)),
                    child: child!,
                  ),
                ),
                home: AccountCenterPage(
                  initialUser: hasEmail
                      ? _testUser.copyWith(email: 'user@example.test')
                      : _testUser,
                  onOpenRoom: (_) async {},
                  onCreateRoom: () async {},
                  onManageRoom: (_) async {},
                  onOpenProviderBinding: (_) async {},
                ),
              ),
            );
            await tester.pump();
            for (final label in [
              'My rooms',
              'Unread notifications',
              'Login factors',
              if (hasEmail) 'Email status',
            ]) {
              final text = find.text(label);
              await tester.ensureVisible(text);
              await tester.pump();
              final surface = find
                  .ancestor(of: text, matching: find.byType(AppInkSurface))
                  .first;
              final bounds = tester.getRect(surface);
              final textBounds = tester.getRect(text);
              expect(textBounds.left, greaterThanOrEqualTo(bounds.left + 15));
              expect(textBounds.right, lessThanOrEqualTo(bounds.right - 15));
              expect(textBounds.bottom, lessThanOrEqualTo(bounds.bottom - 15));
              expect(tester.widget<Text>(text).maxLines, isNull);
              expect(tester.takeException(), isNull);
            }
          },
        );
      }
    }
  }

  for (final fail in [false, true]) {
    testWidgets(
      'selected notification result preserves newer selection, failure=$fail',
      (tester) async {
        final gateway = _NotificationAccountGateway()
          ..secondNotification = true;
        await _pumpNotifications(tester, gateway);
        List<AppCheckbox> boxes() => tester
            .widgetList<AppCheckbox>(
              find.byWidgetPredicate(
                (w) =>
                    w is AppCheckbox &&
                    w.semanticsLabel == 'Select notification',
              ),
            )
            .toList();
        expect(boxes(), hasLength(2));
        boxes()[0].onChanged!(true);
        await tester.pump();
        await tester.tap(byAppTooltip('Mark selected unread notifications'));
        await tester.pump();
        expect(gateway.submittedIds, ['9007199254740992']);
        boxes()[1].onChanged!(true);
        await tester.pump();
        if (fail) {
          gateway.mutations.single.completeError(
            StateError('selected read failed'),
          );
        } else {
          gateway.mutations.single.complete();
        }
        await tester.pump();
        await tester.pump(const Duration(seconds: 4));
        expect(boxes()[0].value, fail);
        expect(boxes()[1].value, isTrue);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final fail in [false, true]) {
    testWidgets(
      'notification result after leaving page is ignored, failure=$fail',
      (tester) async {
        final gateway = _NotificationAccountGateway();
        await _pumpNotifications(tester, gateway);
        await tester.tap(byAppTooltip('Mark all as read'));
        await tester.pump();
        final loads = gateway.loads;
        await tester.pumpWidget(const SizedBox.shrink());
        if (fail) {
          gateway.mutations.single.completeError(
            StateError('late notification error'),
          );
        } else {
          gateway.mutations.single.complete();
        }
        await tester.pump();
        expect(gateway.loads, loads);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final action in [
    'Mark all as read',
    'Delete read notifications',
    'Mark as read',
    'Delete',
  ]) {
    testWidgets(
      'notification $action blocks repeats and retries after failure',
      (tester) async {
        final gateway = _NotificationAccountGateway();
        await _pumpNotifications(tester, gateway);
        final button = tester.widget<AppIconButton>(
          find.byWidgetPredicate(
            (w) => w is AppIconButton && w.tooltip == action,
          ),
        );
        button.onPressed!();
        button.onPressed!();
        await tester.pump();
        expect(gateway.mutations, hasLength(1));
        for (final label in [
          'Mark all as read',
          'Delete read notifications',
          'Mark as read',
          'Delete',
        ]) {
          for (final control in tester.widgetList<AppIconButton>(
            find.byWidgetPredicate(
              (w) => w is AppIconButton && w.tooltip == label,
            ),
          )) {
            expect(control.onPressed, isNull, reason: label);
          }
        }
        gateway.mutations.single.completeError(
          StateError('notification operation failed'),
        );
        await tester.pump();
        await tester.pump();
        final retry = tester.widget<AppIconButton>(
          find.byWidgetPredicate(
            (w) => w is AppIconButton && w.tooltip == action,
          ),
        );
        expect(retry.onPressed, isNotNull);
        retry.onPressed!();
        await tester.pump();
        expect(gateway.mutations, hasLength(2));
        gateway.mutations.last.complete();
        await tester.pump();
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('account lists have no extra page at pagination boundaries', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final total in [0, 1, 3, 24, 25, 48]) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyRegistryScope(
            values: {
              AccountGateway: _PaginationAccountGateway(total),
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
            initialUser: _testUser,
            onOpenRoom: (_) async {},
            onCreateRoom: () async {},
            onManageRoom: (_) async {},
            onOpenProviderBinding: (_) async {},
          ),
        ),
      );
      await tester.pump();
      for (final section in ['Rooms', 'Privacy']) {
        await tester.tap(find.text(section).first);
        for (var frame = 0; frame < 5; frame++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        final pagination = tester.widget<AppPaginationBar>(
          find.byType(AppPaginationBar),
        );
        expect(
          pagination.onNext != null,
          total > 24,
          reason: '$section total $total',
        );
        expect(pagination.label, contains('Page 1 of ${total <= 24 ? 1 : 2}'));
      }
      expect(tester.takeException(), isNull);
    }
  });

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
    await tester.scrollUntilVisible(
      bindButton,
      300,
      scrollable: find.byType(Scrollable).last,
      maxScrolls: 40,
    );
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

class _ControlledUnlinkGateway extends PopulatedAccountPreviewGateway {
  final verification = Completer<SensitiveOperationVerificationInfo>();
  var unlink = Completer<void>();
  final unlinks = <OAuth2LinkedAccount>[];
  final verificationIds = <String>[];
  int verifications = 0;
  int linkLoads = 0;

  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() {
    verifications++;
    return verification.future;
  }

  @override
  Future<void> unlinkOAuth2Account(
    OAuth2LinkedAccount account, {
    required String verificationId,
  }) {
    unlinks.add(account);
    verificationIds.add(verificationId);
    return unlink.future;
  }

  @override
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() {
    linkLoads++;
    return linkLoads == 1 ? super.getLinkedOAuth2Accounts() : Future.value([]);
  }
}

class _TotpSetupGateway extends RecoveryCodesPreviewGateway {
  _TotpSetupGateway({this.verifyTotp = false});
  final bool verifyTotp;
  final verificationCodes = <String>[];
  final codes = <String>[];

  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() async {
    if (!verifyTotp) return super.startSensitiveOperationVerification();
    return SensitiveOperationVerificationPending(
      challenge: SensitiveOperationVerificationChallengeInfo(
        sessionId: 'preview-verification',
        requiredCount: 1,
        requiredMethods: const [],
        completedMethods: const [],
        availableMethods: const [
          client_enum
              .SensitiveOperationVerificationMethod
              .SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP,
        ],
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      ),
    );
  }

  @override
  Future<SensitiveOperationVerificationInfo>
  finishSensitiveOperationVerification({
    required String sessionId,
    required client_enum.SensitiveOperationVerificationMethod method,
    String password = '',
    String emailToken = '',
    String passkeySessionId = '',
    Object? passkeyCredential,
    String totpCode = '',
    String recoveryCode = '',
  }) async {
    verificationCodes.add(totpCode);
    return const SensitiveOperationVerificationComplete(
      verificationId: 'preview-verified',
    );
  }

  @override
  Future<AccountPreferences> getPreferences({bool refresh = false}) async =>
      AccountPreferences(
        twoFactorEnabled: false,
        canUsePassword: true,
        canUsePasskey: false,
        canUseTotp: false,
        canUseEmail: true,
        eligibleFactorCount: 2,
        totpRecoveryCodesRemaining: 0,
        notifications: NotificationPreferences.defaults(),
      );

  @override
  Future<TotpSetupInfo> startTotpSetup({
    required String verificationId,
  }) async => const TotpSetupInfo(
    setupId: 'preview-setup',
    secret: 'PREVIEWONLY',
    otpauthUri: 'otpauth://totp/Preview?secret=PREVIEWONLY',
    expiresAt: 0,
  );

  @override
  Future<List<String>> finishTotpSetup({
    required String setupId,
    required String code,
  }) async {
    codes.add(code);
    return ['TEST-CODE-00'];
  }
}

class _RecoveryRefreshGateway extends RecoveryCodesPreviewGateway {
  _RecoveryRefreshGateway(this.refreshState);
  final String refreshState;
  bool generated = false;

  @override
  Future<List<String>> regenerateTotpRecoveryCodes({
    required String verificationId,
  }) async {
    generated = true;
    return super.regenerateTotpRecoveryCodes(verificationId: verificationId);
  }

  @override
  Future<AccountPreferences> getPreferences({bool refresh = false}) {
    if (generated && refreshState == 'failed') {
      return Future.error(StateError('Preview preferences unavailable'));
    }
    if (generated && refreshState == 'pending') {
      return Completer<AccountPreferences>().future;
    }
    return super.getPreferences(refresh: refresh);
  }
}

class _RecordingRenameGateway extends PopulatedAccountPreviewGateway {
  final names = <String>[];
  bool failNext = false;

  @override
  Future<SyncTvUser> updateUsername(String username) async {
    names.add(username);
    if (failNext) {
      failNext = false;
      throw StateError('Rename rejected');
    }
    return PopulatedAccountPreviewGateway.user;
  }
}

Future<void> _pumpAccount(
  WidgetTester tester,
  AccountGateway gateway, {
  Future<void> Function()? onCreateRoom,
  bool settle = true,
}) async {
  await tester.binding.setSurfaceSize(const Size(1200, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
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
        initialUser: _testUser,
        onOpenRoom: (_) async {},
        onCreateRoom: onCreateRoom ?? () async {},
        onManageRoom: (_) async {},
        onOpenProviderBinding: (_) async {},
      ),
    ),
  );
  await tester.pump();
  if (settle) await tester.pumpAndSettle();
}

Future<void> _pumpNotifications(
  WidgetTester tester,
  _NotificationAccountGateway gateway,
) async {
  await _pumpAccount(tester, gateway, settle: false);
  await tester.tap(find.text('Notifications').first);
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class _NotificationAccountGateway extends _HangingAccountGateway {
  final mutations = <Completer<void>>[];
  bool secondNotification = false;
  List<String>? submittedIds;
  int loads = 0;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #listNotifications) {
      loads++;
      return Future.value(
        UserNotificationsPage(
          notifications: [
            UserNotificationItem(
              id: '9007199254740992',
              type: client_enum.NotificationType.NOTIFICATION_TYPE_UNSPECIFIED,
              title: 'Test notification',
              content: 'Notification body',
              data: {},
              isRead: false,
              createdAt: 1,
              updatedAt: 1,
            ),
            if (secondNotification)
              const UserNotificationItem(
                id: '9007199254740993',
                type:
                    client_enum.NotificationType.NOTIFICATION_TYPE_UNSPECIFIED,
                title: 'Second notification',
                content: 'Second body',
                data: {},
                isRead: false,
                createdAt: 2,
                updatedAt: 2,
              ),
          ],
          total: secondNotification ? 2 : 1,
          unreadCount: secondNotification ? 2 : 1,
        ),
      );
    }
    if (invocation.memberName == #markNotificationsAsRead) {
      submittedIds = List<String>.of(
        invocation.positionalArguments.single as List<String>,
      );
    }
    if (invocation.memberName == #markNotificationsAsRead ||
        invocation.memberName == #markAllNotificationsAsRead ||
        invocation.memberName == #deleteAllReadNotifications ||
        invocation.memberName == #markNotificationAsRead ||
        invocation.memberName == #deleteNotification) {
      final request = Completer<void>();
      mutations.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}

class _HangingAccountGateway implements AccountGateway {
  final Completer<Never> pending = Completer<Never>();

  @override
  String? get activeServerName => 'Slow server';

  @override
  String get serverBaseUrl => 'https://slow.example.test';

  @override
  dynamic noSuchMethod(Invocation invocation) => pending.future;
}

class _AccountLayoutGateway extends _HangingAccountGateway {
  _AccountLayoutGateway(this.state);
  final String state;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (state == 'loading') return super.noSuchMethod(invocation);
    final result = switch (invocation.memberName) {
      #getRooms => const RoomsPage(rooms: [], total: 0, page: 1, pageSize: 24),
      #listBlockedUsers => const BlockedUsersPage(users: [], total: 0),
      #listNotifications => const UserNotificationsPage(
        notifications: [],
        total: 0,
        unreadCount: 0,
      ),
      _ => null,
    };
    if (result == null) return super.noSuchMethod(invocation);
    if (state == 'error') return Future<Never>.error(StateError('Unavailable'));
    return switch (result) {
      RoomsPage value => Future<RoomsPage>.value(value),
      BlockedUsersPage value => Future<BlockedUsersPage>.value(value),
      UserNotificationsPage value => Future<UserNotificationsPage>.value(value),
      _ => throw StateError('Unexpected fixture result'),
    };
  }
}

class _PaginationAccountGateway extends _HangingAccountGateway {
  _PaginationAccountGateway(this.total);
  final int total;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getRooms) {
      return Future.value(
        RoomsPage(rooms: const [], total: total, page: 1, pageSize: 24),
      );
    }
    if (invocation.memberName == #listBlockedUsers) {
      return Future.value(BlockedUsersPage(users: const [], total: total));
    }
    return super.noSuchMethod(invocation);
  }
}

final class _OAuth2BindingAccountGateway extends _HangingAccountGateway {
  _OAuth2BindingAccountGateway(this.events, {this.providerName = 'github'});

  final String providerName;

  final List<String> events;
  String? redirectUrl;
  String? finishedCode;
  String? finishedState;
  var _linkedAccountLoads = 0;

  @override
  String get serverBaseUrl => 'https://app.example.test';

  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() async => [
    OAuth2ProviderOption(
      name: providerName,
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

final class _ControlledBindingGateway extends _OAuth2BindingAccountGateway {
  _ControlledBindingGateway(this.phase) : super([]);
  final String phase;
  final verification = Completer<SensitiveOperationVerificationInfo>();
  final start = Completer<void>();
  final finish = Completer<void>();
  int startCalls = 0;
  int finishCalls = 0;
  int linkLoads = 0;

  @override
  Future<SensitiveOperationVerificationInfo>
  startSensitiveOperationVerification() => phase == 'verification'
      ? verification.future
      : super.startSensitiveOperationVerification();

  @override
  Future<OAuth2AuthorizationStart> startOAuth2Bind(
    String provider, {
    String? redirectUrl,
    required String verificationId,
    bool native = false,
  }) async {
    startCalls++;
    if (phase == 'start') await start.future;
    return super.startOAuth2Bind(
      provider,
      redirectUrl: redirectUrl,
      verificationId: verificationId,
      native: native,
    );
  }

  @override
  Future<void> finishOAuth2Bind({
    required String code,
    required String state,
  }) async {
    finishCalls++;
    if (phase == 'finish') await finish.future;
  }

  @override
  Future<List<OAuth2LinkedAccount>> getLinkedOAuth2Accounts() async {
    linkLoads++;
    return const [];
  }
}

final class _ControlledBindingCallbacks implements OAuth2CallbackClient {
  final creation = Completer<OAuth2CallbackSession>();
  final session = _ControlledBindingSession();
  final nextCreation = Completer<OAuth2CallbackSession>();
  final nextSession = _ControlledBindingSession();
  int creationCalls = 0;
  @override
  bool get canCreateSession => true;
  @override
  Future<OAuth2CallbackSession> createSession() {
    creationCalls++;
    return creationCalls == 1 ? creation.future : nextCreation.future;
  }
}

final class _ControlledBindingSession implements OAuth2CallbackSession {
  final authorization = Completer<OAuth2CallbackPayload>();
  int authorizeCalls = 0;
  int closeCount = 0;
  @override
  String get redirectUrl => 'https://app.example.test/oauth2/callback';
  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) {
    authorizeCalls++;
    return authorization.future;
  }

  @override
  Future<void> close() async => closeCount++;
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

class _RecordingPasswordAuthenticator implements OpaqueAuthenticatorService {
  int calls = 0;
  String? password;
  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls++;
    password = invocation.namedArguments[#newPassword] as String;
    if (invocation.memberName == #resetWithEmailToken) {
      return Future<void>.value();
    }
    return Future<SyncTvUser>.value(PopulatedAccountPreviewGateway.user);
  }
}

class _AvailablePasskeyClient implements PasskeyClient {
  @override
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async => true;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  }) async => false;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _OverviewRoomsGateway extends PopulatedAccountPreviewGateway {
  bool hasRoom = true;
  final listSearches = <String>[];
  final listRefreshes = <bool>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getRooms) {
      final args = invocation.namedArguments;
      final isOverview = args[#pageSize] == 3;
      final search = args[#search] as String? ?? '';
      if (!isOverview) {
        listSearches.add(search);
        listRefreshes.add(args[#refresh] as bool? ?? false);
      }
      if (!hasRoom || search.isNotEmpty) {
        return Future.value(
          const RoomsPage(rooms: [], total: 0, page: 1, pageSize: 24),
        );
      }
    }
    return super.noSuchMethod(invocation);
  }
}

class _ShrinkingRoomsGateway extends PopulatedAccountPreviewGateway {
  int total = 25;
  final pages = <int>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final result = super.noSuchMethod(invocation);
    if (invocation.memberName == #getRooms &&
        invocation.namedArguments[#pageSize] != 3) {
      final page = invocation.namedArguments[#page] as int;
      pages.add(page);
      return (result as Future<RoomsPage>).then(
        (value) => RoomsPage(
          rooms: page == 1 ? value.rooms : [],
          total: total,
          page: page,
          pageSize: 24,
        ),
      );
    }
    return result;
  }
}

class _RefreshingNotificationsGateway extends PopulatedAccountPreviewGateway {
  int total = 1;
  final queries = <Map<Symbol, dynamic>>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final result = super.noSuchMethod(invocation);
    if (invocation.memberName == #listNotifications) {
      queries.add(Map.from(invocation.namedArguments));
      final page = invocation.namedArguments[#page] as int;
      return (result as Future<UserNotificationsPage>).then(
        (value) => UserNotificationsPage(
          notifications: total > 0 && page == 1 ? value.notifications : [],
          total: total,
          unreadCount: total,
        ),
      );
    }
    return result;
  }
}
