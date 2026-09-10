import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/application/runtime_smtp_proxy.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  test('SOCKS5 endpoints follow server address rules', () {
    for (final value in [
      'socks5://proxy.example.com',
      'socks5://127.0.0.1:1080/',
      'socks5://[::1]:65535',
      'socks5://proxy.example.com:0',
      ' SOCKS5://proxy.example.com:1080 ',
    ]) {
      expect(isValidRuntimeSmtpProxyUrl(value), isTrue, reason: value);
    }
    for (final value in [
      '',
      'socks5://',
      'http://proxy.example.com',
      'socks5://user:secret@proxy.example.com',
      'socks5://proxy.example.com:65536',
      'socks5://proxy.example.com:-1',
      'socks5://proxy.example.com:invalid',
      'socks5://proxy.example.com:99999999999999999999',
      'socks5://proxy.example.com/path',
      'socks5://proxy.example.com?',
      'socks5://proxy.example.com#',
      'socks5://bad host:1080',
      'socks5://[invalid]:1080',
    ]) {
      expect(isValidRuntimeSmtpProxyUrl(value), isFalse, reason: value);
    }
  });

  for (final key in ['smtpCredentials', 'smtpProxy']) {
    testWidgets('$key preserves omitted passwords and clears explicitly', (
      tester,
    ) async {
      final gateway = _Gateway(key);
      await _open(tester, gateway);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await _confirm(tester);
      expect(
        gateway.values.single,
        key == 'smtpCredentials'
            ? {'username': 'sender'}
            : {
                'url': 'socks5://proxy.example.com:1080',
                'credentials': {'username': 'sender'},
              },
      );
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      tester
          .widgetList<AppSwitchTile>(find.byType(AppSwitchTile))
          .first
          .onChanged!(false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await _confirm(tester);
      expect(gateway.values.last, isNull);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('$key requires a password after changing username', (
      tester,
    ) async {
      final gateway = _Gateway(key);
      await _open(tester, gateway);
      await tester.enterText(
        find.byType(TextField).at(key == 'smtpProxy' ? 1 : 0),
        'new-user',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(gateway.values, isEmpty);
      expect(find.byType(Dialog), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, ' new secret ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await _confirm(tester);
      final value = gateway.values.single as Map;
      final credentials = key == 'smtpProxy'
          ? value['credentials'] as Map
          : value;
      expect(credentials, {'username': 'new-user', 'password': ' new secret '});
      await tester.pump(const Duration(seconds: 4));
    });
  }

  testWidgets('invalid proxy endpoint stays in editor without writing', (
    tester,
  ) async {
    final gateway = _Gateway('smtpProxy');
    await _open(tester, gateway);
    await tester.enterText(find.byType(TextField).first, 'socks5://');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(gateway.values, isEmpty);
    expect(
      find.text(
        'Enter a SOCKS5 host and optional port (0-65535), without credentials, path, query, or fragment.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  for (final field in [1, 2]) {
    testWidgets(
      'proxy field $field enforces bytes instead of character count',
      (tester) async {
        final gateway = _Gateway('smtpProxy');
        await _open(tester, gateway);
        await tester.enterText(find.byType(TextField).at(field), '\u4e2d' * 86);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(gateway.values, isEmpty);
        expect(
          find.text(
            'SOCKS5 credentials must be at most 255 UTF-8 bytes per field.',
          ),
          findsOneWidget,
        );
        await tester.enterText(find.byType(TextField).at(field), '\u4e2d' * 85);
        if (field == 1) {
          await tester.enterText(find.byType(TextField).last, 'secret');
        }
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        await _confirm(tester);
        expect(gateway.values, hasLength(1));
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<void> _confirm(WidgetTester tester) async {
  await tester.tap(find.text('Confirm changes').last);
  await tester.pumpAndSettle();
}

Future<void> _open(WidgetTester tester, _Gateway gateway) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          DependencyScope<AdminGateway>(value: gateway, child: child!),
      home: const Scaffold(body: RuntimeSettingsSectionsTab()),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(Icons.edit_outlined));
  await tester.pumpAndSettle();
}

class _Gateway implements AdminGateway {
  _Gateway(this.key);
  final String key;
  final values = <dynamic>[];
  static const credentials = {'username': 'sender'};

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(
        name: 'email',
        settings: {
          key: key == 'smtpCredentials'
              ? credentials
              : {
                  'url': 'socks5://proxy.example.com:1080',
                  'credentials': credentials,
                },
        },
      ),
    ],
  );

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    values.add(value);
    return RuntimeSettingsSection(name: section, settings: {key: value});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
