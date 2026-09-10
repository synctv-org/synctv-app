import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

const _cases = <(String, String, dynamic)>[
  ('test', 'text', 'sample'),
  ('email', 'smtpPort', 587),
  ('email', 'smtpHost', 'smtp.example.com'),
  ('roomCreation', 'passwordPolicy', 'ROOM_PASSWORD_POLICY_OPTIONAL'),
  ('email', 'whitelistDomains', ['example.com']),
  ('permissions', 'guestDefaultPermissions', 0),
  ('email', 'smtpCredentials', {'username': 'sender', 'password': 'sample'}),
  ('email', 'smtpProxy', {'host': 'proxy.example.com', 'port': 1080}),
  (
    'webrtc',
    'externalIceServers',
    [
      {
        'urls': ['stun:example.com:3478'],
      },
    ],
  ),
  (
    'test',
    'structured',
    {
      'nested': {'name': 'sample'},
    },
  ),
  (
    'oauth2',
    'providers',
    [
      {
        'name': 'apple-main',
        'apple': {
          'webClientId': 'com.example.web',
          'nativeClientId': 'com.example.app',
        },
      },
    ],
  ),
];

void main() {
  for (final entry in _cases) {
    for (final viewport in [
      (size: const Size(320, 568), keyboard: 0.0),
      (size: const Size(740, 320), keyboard: 0.0),
      (size: const Size(320, 568), keyboard: 220.0),
    ]) {
      final size = viewport.size;
      testWidgets(
        '${entry.$1}.${entry.$2} editor fits $viewport with 2x text',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetViewInsets);
          await tester.binding.setSurfaceSize(const Size(1200, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => DependencyScope<AdminGateway>(
                value: _Gateway(entry),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(2)),
                  child: child!,
                ),
              ),
              home: const Scaffold(body: RuntimeSettingsSectionsTab()),
            ),
          );
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.byIcon(Icons.edit_outlined),
            200,
            scrollable: find.byType(Scrollable).last,
          );
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.edit_outlined));
          await tester.pumpAndSettle();
          if (entry.$1 == 'test' && entry.$2 == 'text') {
            await tester.enterText(find.byType(TextField), 'unsaved draft');
          }
          await tester.binding.setSurfaceSize(size);
          tester.view.viewInsets = FakeViewPadding(bottom: viewport.keyboard);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (entry.$1 == 'test' && entry.$2 == 'text') {
            expect(
              tester.widget<TextField>(find.byType(TextField)).controller!.text,
              'unsaved draft',
            );
          }
          final fields = find.descendant(
            of: find.byType(Form),
            matching: find.byType(AppTextField),
          );
          if (fields.evaluate().isNotEmpty) {
            await tester.ensureVisible(fields.last);
            await tester.pumpAndSettle();
            expect(fields.last.hitTestable(), findsOneWidget);
          }
          final save = find.widgetWithText(AppActionButton, 'Save');
          await tester.ensureVisible(save);
          await tester.pumpAndSettle();
          expect(save.hitTestable(), findsOneWidget);
          final label = find.descendant(of: save, matching: find.text('Save'));
          expect(
            tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
            isFalse,
          );
          final cancel = find.widgetWithText(AppActionButton, 'Cancel');
          await tester.ensureVisible(cancel);
          await tester.pumpAndSettle();
          await tester.tap(cancel);
          await tester.pumpAndSettle();
          expect(find.byType(Form), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

class _Gateway implements AdminGateway {
  _Gateway(this.entry);
  final (String, String, dynamic) entry;

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(name: entry.$1, settings: {entry.$2: entry.$3}),
    ],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
