import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/localization/presentation/language_selector_dialog.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../../test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await appLocaleController.setPreference(AppLocalePreference.system);
  });

  testWidgets('language save blocks repeated taps and retries after rollback', (
    tester,
  ) async {
    final writes = <Completer<void>>[];
    final controller = AppLocaleController(
      write: (_) {
        final request = Completer<void>();
        writes.add(request);
        return request.future;
      },
    );
    addTearDown(controller.dispose);
    await _pumpSelector(tester, controller);
    final option = tester.widget<AppInkSurface>(
      find
          .ancestor(
            of: find.text('English'),
            matching: find.byType(AppInkSurface),
          )
          .first,
    );
    option.onTap!();
    option.onTap!();
    await tester.pump();
    expect(writes, hasLength(1));
    expect(find.byType(AppLinearProgress), findsOneWidget);
    expect(controller.preference, AppLocalePreference.english);
    writes.single.completeError(StateError('storage unavailable'));
    await tester.pump();
    expect(controller.preference, AppLocalePreference.system);
    expect(find.textContaining('storage unavailable'), findsWidgets);
    await tester.tap(find.text('English'));
    await tester.pump();
    expect(writes, hasLength(2));
    writes.last.complete();
    await tester.pumpAndSettle();
    expect(find.text('Display language'), findsNothing);
    expect(find.text('Open'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });

  for (final fail in [false, true]) {
    testWidgets('closed language selector ignores late result, failure=$fail', (
      tester,
    ) async {
      final pending = Completer<void>();
      final controller = AppLocaleController(write: (_) => pending.future);
      addTearDown(controller.dispose);
      final navigator = await _pumpSelector(tester, controller);
      await tester.tap(find.text('English'));
      await tester.pump();
      await tester.tap(byAppTooltip('Close'));
      unawaited(
        navigator.currentState!.push<void>(
          MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Next page')),
          ),
        ),
      );
      if (fail) {
        pending.completeError(StateError('late language failure'));
      } else {
        pending.complete();
      }
      await tester.pumpAndSettle();
      expect(find.text('Next page'), findsOneWidget);
      expect(find.textContaining('late language failure'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'covered selector releases saving state without popping the covering route',
    (tester) async {
      final pending = Completer<void>();
      final controller = AppLocaleController(write: (_) => pending.future);
      addTearDown(controller.dispose);
      final navigator = await _pumpSelector(tester, controller);
      await tester.tap(find.text('English'));
      await tester.pump();
      unawaited(
        navigator.currentState!.push<void>(
          MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Next page')),
          ),
        ),
      );
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Next page'), findsOneWidget);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(find.text('Display language'), findsOneWidget);
      expect(find.byType(AppLinearProgress), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('language options expose stable semantic names', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      final controller = AppLocaleController(write: (_) async {});
      addTearDown(controller.dispose);
      await _pumpSelector(tester, controller);
      expect(find.bySemanticsLabel('Simplified Chinese'), findsOneWidget);
      expect(find.bySemanticsLabel('English'), findsOneWidget);
      for (final name in ['Simplified Chinese', 'English']) {
        expect(
          tester
              .getSemantics(find.bySemanticsLabel(name))
              .getSemanticsData()
              .flagsCollection
              .isChecked,
          ui.CheckedState.isFalse,
        );
      }
      expect(
        tester.getSemantics(find.bySemanticsLabel('System default')),
        matchesSemantics(
          label: 'System default',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasCheckedState: true,
          isChecked: true,
          isInMutuallyExclusiveGroup: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('short language sheet keeps options reachable at 3x', (
    tester,
  ) async {
    final controller = AppLocaleController(write: (_) async {});
    addTearDown(controller.dispose);
    await _pumpSelector(
      tester,
      controller,
      size: const Size(320, 300),
      scale: 3,
    );
    expect(tester.takeException(), isNull);
    final english = find.text('English');
    await tester.ensureVisible(english);
    await tester.pumpAndSettle();
    expect(english.hitTestable(), findsOneWidget);
  });

  testWidgets('selects and persists a display language', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showLanguageSelectorDialog(context),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Display language'), findsOneWidget);

    await tester.tap(find.text('Simplified Chinese'));
    // The default controller's persistence queue is created outside fake time.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(
      appLocaleController.preference,
      AppLocalePreference.simplifiedChinese,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(AppLocaleController.preferenceKey),
      AppLocalePreference.simplifiedChinese.name,
    );
  });
}

Future<GlobalKey<NavigatorState>> _pumpSelector(
  WidgetTester tester,
  AppLocaleController controller, {
  Size size = const Size(320, 568),
  double scale = 1.3,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final navigator = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    ListenableBuilder(
      listenable: controller,
      builder: (_, _) => MaterialApp(
        navigatorKey: navigator,
        locale: controller.locale ?? const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  showLanguageSelectorDialog(context, controller: controller),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return navigator;
}
