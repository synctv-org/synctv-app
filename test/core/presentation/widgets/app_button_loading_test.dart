import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

Widget _app(Widget child, {bool dark = false, String locale = 'en'}) =>
    MaterialApp(
      theme: dark ? AppTheme.dark : AppTheme.light,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  for (final dark in [false, true]) {
    for (final style in AppActionButtonStyle.values) {
      testWidgets('action $style loading inherits foreground dark=$dark', (
        tester,
      ) async {
        await tester.pumpWidget(
          _app(
            AppActionButton(
              onPressed: () {},
              label: 'Save',
              loading: true,
              style: style,
            ),
            dark: dark,
          ),
        );
        final progress = find.byType(CircularProgressIndicator);
        final expected = DefaultTextStyle.of(tester.element(progress))
            .style
            .color;
        expect(expected, isNotNull);
        expect(
          tester.widget<CircularProgressIndicator>(progress).color,
          expected,
        );
        if (style == AppActionButtonStyle.destructive) {
          final colors = Theme.of(tester.element(progress)).colorScheme;
          final luminances = [
            expected!.computeLuminance(),
            colors.error.computeLuminance(),
          ]..sort();
          expect(
            (luminances.last + .05) / (luminances.first + .05),
            greaterThanOrEqualTo(4.5),
          );
        }
      });
    }
    for (final style in AppIconButtonStyle.values) {
      testWidgets('icon $style loading inherits foreground dark=$dark', (
        tester,
      ) async {
        await tester.pumpWidget(
          _app(
            AppIconButton(
              onPressed: () {},
              icon: Icons.save,
              tooltip: 'Save',
              loading: true,
              style: style,
            ),
            dark: dark,
          ),
        );
        final progress = find.byType(CircularProgressIndicator);
        final expected = IconTheme.of(tester.element(progress)).color;
        expect(expected, isNotNull);
        expect(
          tester.widget<CircularProgressIndicator>(progress).color,
          expected,
        );
      });
    }
  }

  for (final locale in ['en', 'zh']) {
    for (final icon in [false, true]) {
      testWidgets('loading button semantics icon=$icon locale=$locale', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          var presses = 0;
          const key = ValueKey('action');
          await tester.pumpWidget(
            _app(
              icon
                  ? AppIconButton(
                      key: key,
                      onPressed: () => presses++,
                      icon: Icons.save,
                      tooltip: 'Save',
                      loading: true,
                    )
                  : AppActionButton(
                      key: key,
                      onPressed: () => presses++,
                      label: 'Save',
                      loading: true,
                    ),
              locale: locale,
            ),
          );
          final namedButton = find.bySemanticsLabel('Save');
          expect(namedButton, findsOneWidget);
          final data = tester.getSemantics(namedButton).getSemanticsData();
          expect(data.label, 'Save');
          expect(data.value, tester.element(find.byKey(key)).l10n.loading);
          expect(data.flagsCollection.isButton, isTrue);
          expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
          expect(data.hasAction(SemanticsAction.tap), isFalse);
          await tester.tap(find.byKey(key));
          await tester.pump(const Duration(milliseconds: 200));
          expect(presses, 0);
        } finally {
          semantics.dispose();
        }
      });
    }
  }
}
