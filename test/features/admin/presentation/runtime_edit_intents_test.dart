import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final kind in ['text', 'boolean', 'oauth', 'delete']) {
    for (final confirm in [false, true]) {
      testWidgets('$kind coalesces opens and duplicate completion ($confirm)', (
        tester,
      ) async {
        final gateway = _Gateway(kind);
        await _open(tester, gateway);
        final VoidCallback open;
        if (kind == 'boolean') {
          final toggle = tester
              .widget<AppSwitch>(find.byType(AppSwitch))
              .onChanged!;
          open = () => toggle(true);
        } else {
          final icon = kind == 'delete'
              ? Icons.delete_outline_rounded
              : Icons.edit_outlined;
          open = tester
              .widget<AppIconButton>(
                find.ancestor(
                  of: find.byIcon(icon),
                  matching: find.byType(AppIconButton),
                ),
              )
              .onPressed!;
        }
        open();
        open();
        await tester.pumpAndSettle();
        final label = confirm
            ? switch (kind) {
                'text' => 'Save',
                'oauth' => 'Save',
                'delete' => 'Delete',
                _ => 'Confirm changes',
              }
            : 'Cancel';
        final finish = tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, label),
            )
            .onPressed!;
        finish();
        finish();
        await tester.pumpAndSettle();
        if (kind == 'oauth' && confirm) {
          final confirmRisk = tester
              .widget<AppActionButton>(
                find.widgetWithText(AppActionButton, 'Confirm changes'),
              )
              .onPressed!;
          finish();
          confirmRisk();
          confirmRisk();
          await tester.pumpAndSettle();
        }
        expect(gateway.writes, confirm ? 1 : 0);
        expect(find.byKey(const Key('settings-page')), findsOneWidget);
        expect(find.text('Open settings'), findsNothing);
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('covered editor cannot submit or close another dialog', (
    tester,
  ) async {
    final gateway = _Gateway('text');
    await _open(tester, gateway);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    final save = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Save'))
        .onPressed!;
    final editorContext = tester.element(find.text('Save'));
    showAppDialog<void>(
      context: editorContext,
      builder: (context) => AppDialog(
        body: const Text('Covered'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
    save();
    await tester.pumpAndSettle();
    expect(find.text('Covered'), findsOneWidget);
    expect(gateway.writes, 0);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    save();
    expect(find.byKey(const Key('settings-page')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(WidgetTester tester, _Gateway gateway) async {
  await tester.binding.setSurfaceSize(const Size(1200, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          DependencyScope<AdminGateway>(value: gateway, child: child!),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => const Scaffold(
                  key: Key('settings-page'),
                  body: RuntimeSettingsSectionsTab(),
                ),
              ),
            ),
            child: const Text('Open settings'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open settings'));
  await tester.pumpAndSettle();
}

class _Gateway implements AdminGateway {
  _Gateway(this.kind);
  final String kind;
  var writes = 0;

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      switch (kind) {
        'text' => const RuntimeSettingsSection(
          name: 'test',
          settings: {'alpha': 'original'},
        ),
        'boolean' => const RuntimeSettingsSection(
          name: 'email',
          settings: {'enabled': false},
        ),
        _ => const RuntimeSettingsSection(
          name: 'oauth2',
          settings: {
            'providers': [
              {
                'name': 'apple-main',
                'apple': {
                  'webClientId': 'com.example.web',
                  'nativeClientId': 'com.example.app',
                },
              },
            ],
          },
        ),
      },
    ],
  );

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    writes++;
    return RuntimeSettingsSection(name: section, settings: {key: value});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
