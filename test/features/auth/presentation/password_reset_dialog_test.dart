import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/presentation/password_reset_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

class _Gateway implements AuthGateway {
  final request = Completer<String>();
  int calls = 0;
  @override
  Future<String> requestPasswordReset(String email) {
    calls++;
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'reset submission preserves parent route and password whitespace',
    (tester) async {
      ({String email, String token, String password})? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('Parent'),
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => Builder(
                      builder: (context) => Scaffold(
                        body: TextButton(
                          child: const Text('Open'),
                          onPressed: () async {
                            result = await showPasswordResetDialog(
                              context: context,
                              gateway: _Gateway(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Parent'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), ' preview@example.test ');
      await tester.enterText(fields.at(1), ' verification-token ');
      await tester.enterText(fields.at(2), ' password with spaces ');
      await tester.enterText(fields.at(3), ' password with spaces ');
      final submit = tester
          .widget<AppActionButton>(
            find.widgetWithText(AppActionButton, 'Reset'),
          )
          .onPressed!;
      submit();
      submit();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Open'), findsOneWidget);
      expect(result, (
        email: 'preview@example.test',
        token: 'verification-token',
        password: ' password with spaces ',
      ));
    },
  );

  testWidgets(
    'malformed reset email is rejected without sending or losing fields',
    (tester) async {
      final gateway = _Gateway();
      Object? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showPasswordResetDialog(
                    context: context,
                    gateway: gateway,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      final l10n = tester.element(find.byType(Scaffold)).l10n;
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'invalid');
      await tester.enterText(fields.at(1), 'retained-token');
      await tester.enterText(fields.at(2), 'example-password');
      await tester.enterText(fields.at(3), 'example-password');
      await tester.tap(find.text(l10n.send));
      await tester.pumpAndSettle();
      expect(gateway.calls, 0);
      expect(find.text(l10n.emailInvalidFormat), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.reset));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(find.text('retained-token'), findsOneWidget);
      await tester.enterText(fields.at(0), '  preview+reset@example.test  ');
      await tester.tap(find.text(l10n.send));
      await tester.pump();
      expect(gateway.calls, 1);
      await tester.tap(find.text(l10n.cancel));
      await tester.pumpAndSettle();
      gateway.request.complete('Sent');
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets('reset form remains accessible at $locale/$scale', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(320, 568)
          ..devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final gateway = _Gateway();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showPasswordResetDialog(
                    context: context,
                    gateway: gateway,
                    initialEmail: 'preview@example.test',
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        final l10n = tester.element(find.byType(Scaffold)).l10n;
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (final label in [
          l10n.email,
          l10n.resetCode,
          l10n.newPassword,
          l10n.confirmNewPassword,
        ]) {
          final paragraphs = find.descendant(
            of: find.text(label),
            matching: find.byType(RichText),
          );
          expect(paragraphs, findsWidgets);
          for (final element in paragraphs.evaluate()) {
            expect(
              (element.renderObject! as RenderParagraph).didExceedMaxLines,
              isFalse,
              reason: '$locale/$scale: $label must remain fully readable',
            );
          }
        }
        final email = find.byType(TextField).first;
        expect(tester.getSize(email).width, greaterThan(150));
        final send = find.text(l10n.send);
        await tester.ensureVisible(send);
        await tester.pumpAndSettle();
        final sendAction = tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, l10n.send),
            )
            .onPressed!;
        sendAction();
        sendAction();
        await tester.pump();
        expect(gateway.calls, 1);
        tester.view.viewInsets = const FakeViewPadding(bottom: 240);
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
        final cancel = find.text(l10n.cancel);
        await tester.ensureVisible(cancel);
        await tester.pump(const Duration(milliseconds: 300));
        expect(cancel.hitTestable(), findsOneWidget);
        await tester.tap(cancel);
        await tester.pumpAndSettle();
        gateway.request.complete('Sent');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(TextField), findsNothing);
      });
    }
  }
}
