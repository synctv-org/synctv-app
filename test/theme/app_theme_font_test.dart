import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('button text retains theme fonts in $brightness', (
      tester,
    ) async {
      final theme = brightness == Brightness.light
          ? AppTheme.light
          : AppTheme.dark;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Column(
              children: [
                for (final style in AppActionButtonStyle.values)
                  AppActionButton(
                    onPressed: () {},
                    label: style.name,
                    style: style,
                  ),
                ElevatedButton(onPressed: () {}, child: const Text('elevated')),
              ],
            ),
          ),
        ),
      );
      for (final label in [
        ...AppActionButtonStyle.values.map((s) => s.name),
        'elevated',
      ]) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        final style = paragraph.text.style!;
        expect(style.fontFamilyFallback, contains('SyncTV UI CJK'));
        expect(style.fontFamily, theme.textTheme.labelLarge!.fontFamily);
        expect(style.fontSize, theme.textTheme.labelLarge!.fontSize);
        expect(style.fontWeight, FontWeight.w700);
      }
    });
  }
}
