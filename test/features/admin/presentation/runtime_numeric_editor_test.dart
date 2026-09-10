import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/application/runtime_setting_number.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as proto;

void main() {
  testWidgets('backend rejection retains numeric draft for correction', (
    tester,
  ) async {
    final gateway = _Gateway('playbackHistory', 'maxEntriesPerRoom', 1000)
      ..rejectNext = true;
    await _open(tester, gateway);
    await tester.enterText(find.byType(TextField), '-1');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(gateway.values, ['-1']);
    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '-1',
    );
    await tester.enterText(find.byType(TextField), '1001');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(gateway.values, ['-1', '1001']);
    expect(find.byType(TextField), findsNothing);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('runtime integer boundaries preserve their protobuf wire values', () {
    for (final raw in ['0', '4294967295']) {
      final value = parseRuntimeSettingNumber('email', 'smtpPort', raw);
      final patch = proto.EmailSettingsPatch()
        ..mergeFromProto3Json({'smtpPort': value});
      expect(patch.smtpPort.toString(), raw);
    }
    for (final raw in ['0', '9007199254740993', '18446744073709551615']) {
      final value = parseRuntimeSettingNumber(
        'chat',
        'maxMessagesPerRoom',
        raw,
      );
      final patch = proto.ChatSettingsPatch()
        ..mergeFromProto3Json({'maxMessagesPerRoom': value});
      expect((patch.toProto3Json() as Map)['maxMessagesPerRoom'], raw);
    }
    for (final raw in ['-9223372036854775808', '-1', '9223372036854775807']) {
      final value = parseRuntimeSettingNumber(
        'roomDefaults',
        'defaultMaxMembers',
        raw,
      );
      final patch = proto.RoomDefaultsSettingsPatch()
        ..mergeFromProto3Json({'defaultMaxMembers': value});
      expect((patch.toProto3Json() as Map)['defaultMaxMembers'], raw);
    }
    expect(parseRuntimeSettingNumber('email', 'smtpPort', '-1'), isNull);
    expect(
      parseRuntimeSettingNumber('email', 'smtpPort', '4294967296'),
      isNull,
    );
    expect(
      parseRuntimeSettingNumber(
        'chat',
        'maxMessagesPerRoom',
        '18446744073709551616',
      ),
      isNull,
    );
    expect(
      parseRuntimeSettingNumber(
        'roomDefaults',
        'defaultMaxMembers',
        '-9223372036854775809',
      ),
      isNull,
    );
    expect(
      parseRuntimeSettingNumber(
        'roomDefaults',
        'defaultMaxMembers',
        '9223372036854775808',
      ),
      isNull,
    );
  });

  test('unknown numeric fields preserve fractional exponents and reject nonfinite values', () {
    expect(parseRuntimeSettingNumber('test', 'number', '1e-3'), 0.001);
    expect(parseRuntimeSettingNumber('test', 'number', '-2.5'), -2.5);
    for (final value in ['NaN', 'Infinity', '-Infinity', '1e309', 'bad']) {
      expect(parseRuntimeSettingNumber('test', 'number', value), isNull);
    }
  });

  for (final input in ['NaN', 'Infinity', '1e-3', '-1', '4294967296', '2.5']) {
    testWidgets('integer editor rejects $input without writing', (
      tester,
    ) async {
      final gateway = _Gateway('email', 'smtpPort', 587);
      await _open(tester, gateway);
      await tester.enterText(find.byType(TextField), input);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter an integer within the supported range'),
        findsOneWidget,
      );
      expect(gateway.values, isEmpty);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final entry in [
    (
      'chat',
      'maxMessagesPerRoom',
      '18446744073709551615',
      '18446744073709551615',
    ),
    ('test', 'number', 0.5, 0.001),
  ]) {
    testWidgets(
      'numeric editor saves ${entry.$1}.${entry.$2} without precision loss',
      (tester) async {
        final gateway = _Gateway(entry.$1, entry.$2, entry.$3);
        await _open(tester, gateway);
        if (entry.$1 == 'test') {
          await tester.enterText(find.byType(TextField), '1e-3');
        }
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(gateway.values, [entry.$4]);
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      },
    );
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
  _Gateway(this.section, this.key, this.value);
  final String section;
  final String key;
  final Object value;
  final values = <dynamic>[];
  bool rejectNext = false;

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(name: section, settings: {key: value}),
    ],
  );

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) async {
    values.add(value);
    if (rejectNext) {
      rejectNext = false;
      throw StateError('Value outside server limits');
    }
    return RuntimeSettingsSection(name: section, settings: {key: value});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
