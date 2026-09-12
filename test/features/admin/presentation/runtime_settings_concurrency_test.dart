import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/features/admin/presentation/widgets/send_test_email_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final dispose in [false, true]) {
    testWidgets(
      'queued runtime write rechecks state before dispatch, disposed=$dispose',
      (tester) async {
        final gateway = _Gateway();
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
        final switches = tester
            .widgetList<AppSwitch>(find.byType(AppSwitch))
            .toList();
        switches[0].onChanged!(true);
        switches[1].onChanged!(true);
        await tester.pump();
        expect(gateway.writes, hasLength(1));
        if (dispose) await tester.pumpWidget(const SizedBox());
        gateway.writes.single.complete(
          const RuntimeSettingsSection(
            name: 'test',
            settings: {'alpha': true, 'beta': true},
          ),
        );
        await tester.pumpAndSettle();
        expect(gateway.writes, hasLength(1));
        if (!dispose) {
          expect(
            find.text(
              'This setting changed while you were editing. Reopen it to review the latest value.',
            ),
            findsOneWidget,
          );
          expect(
            tester
                .widgetList<AppSwitch>(find.byType(AppSwitch))
                .map((widget) => widget.value),
            [true, true],
          );
          await tester.pump(const Duration(seconds: 4));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'test email coalesces dialog opens and reopens after cancellation',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => DependencyScope<AdminGateway>(
            value: _LayoutGateway('email'),
            child: child!,
          ),
          home: const Scaffold(body: RuntimeSettingsSectionsTab()),
        ),
      );
      await tester.pumpAndSettle();
      final open = tester
          .widget<AppActionButton>(
            find.widgetWithText(AppActionButton, 'Send test email'),
          )
          .onPressed!;
      open();
      open();
      await tester.pumpAndSettle();
      expect(find.byType(SendTestEmailDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(SendTestEmailDialog), findsNothing);
      open();
      await tester.pumpAndSettle();
      expect(find.byType(SendTestEmailDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [
    const Size(320, 120),
    const Size(320, 240),
    const Size(740, 320),
  ]) {
    for (final section in ['email', 'oauth2']) {
      testWidgets('runtime $section remains usable at $size with large text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => DependencyScope<AdminGateway>(
              value: _LayoutGateway(section),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: buildThemedTestApp(context, child),
              ),
            ),
            home: const Scaffold(body: RuntimeSettingsSectionsTab()),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final action = find.byType(AppActionButton);
        await tester.scrollUntilVisible(action, 100);
        await tester.pumpAndSettle();
        expect(action.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
        if (section == 'email') {
          final description = find.text(
            'Allow the server to send email binding, password reset, MFA, and notification messages.',
          );
          await tester.scrollUntilVisible(description, 100);
          await tester.pumpAndSettle();
          expect(tester.getSize(description).width, greaterThan(180));
          await tester.scrollUntilVisible(find.byType(AppSwitch), 100);
          await tester.pumpAndSettle();
          expect(find.byType(AppSwitch).hitTestable(), findsOneWidget);
        }
        await tester.scrollUntilVisible(byAppTooltip('Refresh all'), -100);
        await tester.pumpAndSettle();
        expect(byAppTooltip('Refresh all').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'runtime writes are ordered and stale refresh cannot roll them back',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _Gateway();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => DependencyScope<AdminGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: const Scaffold(body: RuntimeSettingsSectionsTab()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(byAppTooltip('Refresh all'));
      await tester.pump();
      expect(gateway.reads, 2);
      final switches = tester
          .widgetList<AppSwitch>(find.byType(AppSwitch))
          .toList();
      expect(switches, hasLength(2));
      switches[0].onChanged!(true);
      switches[1].onChanged!(true);
      await tester.pump();
      expect(gateway.writes, hasLength(1));
      gateway.writes[0].complete(
        const RuntimeSettingsSection(
          name: 'test',
          settings: {'alpha': true, 'beta': false},
        ),
      );
      await tester.pump();
      expect(gateway.writes, hasLength(2));
      gateway.writes[1].complete(
        const RuntimeSettingsSection(
          name: 'test',
          settings: {'alpha': true, 'beta': true},
        ),
      );
      await tester.pump();
      gateway.refresh.complete(_Gateway.initial);
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<AppSwitch>(find.byType(AppSwitch))
            .map((widget) => widget.value),
        [true, true],
      );
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 4));
    },
  );
}

class _Gateway implements AdminGateway {
  static const initial = RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(
        name: 'test',
        settings: {'alpha': false, 'beta': false},
      ),
    ],
  );
  int reads = 0;
  final refresh = Completer<RuntimeSettingsModel>();
  final writes = <Completer<RuntimeSettingsSection>>[];

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({bool refresh = false}) {
    return ++reads == 1 ? Future.value(initial) : this.refresh.future;
  }

  @override
  Future<RuntimeSettingsSection> runtimeUpdateSettingInSection(
    String section,
    String key,
    dynamic value,
  ) {
    final result = Completer<RuntimeSettingsSection>();
    writes.add(result);
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LayoutGateway implements AdminGateway {
  final String section;
  _LayoutGateway(this.section);

  @override
  Future<RuntimeSettingsModel> runtimeGetSettings({
    bool refresh = false,
  }) async => RuntimeSettingsModel(
    sections: [
      RuntimeSettingsSection(
        name: section,
        settings: section == 'email'
            ? {'enabled': false, 'host': 'smtp.example.com'}
            : {'providers': <String, dynamic>{}},
      ),
    ],
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
