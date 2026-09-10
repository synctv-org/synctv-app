import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as proto;

void main() {
  for (final raw in [
    '0',
    '4294967296',
    '9007199254740993',
    '18446744073709551615',
  ]) {
    for (final toggle in [false, true]) {
      testWidgets('permissions $raw preserve untouched bits, toggle=$toggle', (
        tester,
      ) async {
        final gateway = _Gateway(raw);
        await _open(tester, gateway);
        if (toggle) {
          await tester.tap(find.text('Send chat messages').last);
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        final expected =
            (BigInt.parse(raw) ^ (toggle ? BigInt.one : BigInt.zero))
                .toString();
        expect(gateway.values, [expected]);
        final patch = proto.PermissionSettingsPatch()
          ..mergeFromProto3Json({
            'adminDefaultPermissions': gateway.values.single,
          });
        expect(
          (patch.toProto3Json() as Map)['adminDefaultPermissions'],
          expected,
        );
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final value in [
    1,
    ['send_chat_messages'],
    '["send_chat_messages"]',
  ]) {
    testWidgets('legacy permission representation $value stays editable', (
      tester,
    ) async {
      final gateway = _Gateway(value);
      await _open(tester, gateway);
      await tester.tap(find.text('Send chat messages').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(gateway.values, ['0']);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }
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
  _Gateway(this.value);
  final Object value;
  final values = <dynamic>[];

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(
        name: 'permissions',
        settings: {'adminDefaultPermissions': value},
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
