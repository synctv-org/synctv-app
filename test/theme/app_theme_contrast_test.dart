import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    test('semantic text color pairs meet AA in $brightness', () {
      final theme = brightness == Brightness.light
          ? AppTheme.light
          : AppTheme.dark;
      final colors = theme.colorScheme;
      final pairs = <String, (Color, Color)>{
        'primary': (colors.onPrimary, colors.primary),
        'secondary': (colors.onSecondary, colors.secondary),
        'tertiary': (colors.onTertiary, colors.tertiary),
        'error': (colors.onError, colors.error),
        'primaryContainer': (
          colors.onPrimaryContainer,
          colors.primaryContainer,
        ),
        'secondaryContainer': (
          colors.onSecondaryContainer,
          colors.secondaryContainer,
        ),
        'tertiaryContainer': (
          colors.onTertiaryContainer,
          colors.tertiaryContainer,
        ),
        'errorContainer': (colors.onErrorContainer, colors.errorContainer),
        'surface': (colors.onSurface, colors.surface),
        'surfaceContainer': (colors.onSurface, colors.surfaceContainer),
        'surfaceContainerHighest': (
          colors.onSurface,
          colors.surfaceContainerHighest,
        ),
        'inverseSurface': (colors.onInverseSurface, colors.inverseSurface),
        'secondary text on surface': (colors.onSurfaceVariant, colors.surface),
        'secondary text on scaffold': (
          colors.onSurfaceVariant,
          theme.scaffoldBackgroundColor,
        ),
        'body text on scaffold': (
          theme.textTheme.bodyMedium!.color!,
          theme.scaffoldBackgroundColor,
        ),
      };
      final failures = <String>[];
      for (final entry in pairs.entries) {
        final (foreground, background) = entry.value;
        final luminances = [
          Color.alphaBlend(foreground, background).computeLuminance(),
          background.computeLuminance(),
        ]..sort();
        final contrast = (luminances.last + .05) / (luminances.first + .05);
        if (contrast < 4.5) {
          failures.add(
            '${entry.key}: ${contrast.toStringAsFixed(2)}:1 '
            '(${foreground.toARGB32().toRadixString(16)} on '
            '${background.toARGB32().toRadixString(16)})',
          );
        }
      }
      expect(failures, isEmpty);
    });
  }
}
