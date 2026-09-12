import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../test_app.dart';

void main() {
  Future<void> render(
    WidgetTester tester,
    int count,
    ValueChanged<int?> changed,
  ) => tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: buildThemedTestApp,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 280,
            child: AppSelect<int>(
              value: count,
              wrapText: true,
              useAnchoredMenu: true,
              options: {
                for (var index = 0; index < count; index++)
                  'International cinema and shared family collection $index':
                      index,
                'Selected account': count,
              },
              onChanged: changed,
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets(
    'anchored menu preserves manual scrolling and reveals on reopen',
    (tester) async {
      final changes = <int?>[];
      await render(tester, 40, changes.add);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      final selected = find.widgetWithText(MenuItemButton, 'Selected account');
      final scrollable = Scrollable.of(tester.element(selected));
      expect(scrollable.position.pixels, greaterThan(0));
      scrollable.position.jumpTo(0);
      await tester.pumpAndSettle();
      expect(scrollable.position.pixels, 0);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(MenuItemButton), findsNothing);
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.focusNode!.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected.hitTestable(), findsOneWidget);
      expect(changes, isEmpty);
    },
  );

  testWidgets('anchored menu supports keyboard selection and disposal', (
    tester,
  ) async {
    final changes = <int?>[];
    await render(tester, 4, changes.add);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(changes, [3]);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(changes, [3]);
  });

  testWidgets(
    'anchored menu marks the selected account independently of focus',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await render(tester, 4, (_) {});
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        final selected = find.widgetWithText(
          MenuItemButton,
          'Selected account',
        );
        final selectedSemantics = find
            .ancestor(of: selected, matching: find.byType(MergeSemantics))
            .first;
        expect(
          tester
              .getSemantics(selectedSemantics)
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          ui.Tristate.isTrue,
        );
        expect(
          find.descendant(
            of: selected,
            matching: find.byIcon(Icons.check_rounded),
          ),
          findsOneWidget,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
        expect(
          tester
              .getSemantics(selectedSemantics)
              .getSemanticsData()
              .flagsCollection
              .isSelected,
          ui.Tristate.isTrue,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final size in [const Size(320, 568), const Size(900, 420)]) {
    for (final count in [4, 40]) {
      testWidgets('multiline menu reveals selected account $size/$count', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 3;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final changes = <int?>[];
        await render(tester, count, changes.add);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        final selected = find
            .widgetWithText(MenuItemButton, 'Selected account')
            .last;
        expect(selected.hitTestable(), findsOneWidget);
        final itemRect = tester.getRect(selected);
        final listRect = tester.getRect(find.byType(SingleChildScrollView));
        expect(itemRect.top, greaterThanOrEqualTo(listRect.top));
        expect(itemRect.bottom, lessThanOrEqualTo(listRect.bottom));
        expect(changes, isEmpty);
        await tester.tap(selected);
        await tester.pumpAndSettle();
        expect(changes, [count]);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
