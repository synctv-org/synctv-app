@TestOn('vm')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/app/app_viewport.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

class _Gateway implements ServerConnectionGateway {
  @override
  ServerConnectionProfile? get activeServer => null;
  @override
  List<ServerConnectionProfile> get servers => [];
  @override
  String get serverBaseUrl => '';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets('server form at 320px, $locale/$scale with keyboard', (
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
            theme: AppTheme.light,
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (_, child) => DependencyScope<ServerConnectionGateway>(
              value: _Gateway(),
              child: AppViewport(child: child!),
            ),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showServerSettingsDialog(context: context),
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
        await tester.tap(find.widgetWithText(AppActionButton, l10n.addServer));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.enterText(find.byType(TextField), 'https://example.test');
        tester.view.viewInsets = const FakeViewPadding(bottom: 240);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final cancel = find.widgetWithText(AppActionButton, l10n.cancel);
        await tester.ensureVisible(cancel);
        await tester.pumpAndSettle();
        expect(cancel.hitTestable(), findsOneWidget);
        await tester.tap(cancel);
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
