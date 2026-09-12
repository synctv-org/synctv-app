import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_instance_selector.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../../test_app.dart';

void main() {
  final changes = <String>[];
  Future<void> render(
    WidgetTester tester, {
    List<String> instances = const ['Remote'],
    String value = '',
    bool enabled = true,
    String locale = 'en',
    double scale = 1,
  }) => tester.pumpWidget(
    MaterialApp(
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => buildThemedTestApp(
        context,
        MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: ProviderInstanceSelector(
            instances: instances,
            value: value,
            enabled: enabled,
            onChanged: changes.add,
          ),
        ),
      ),
    ),
  );
  setUp(changes.clear);

  testWidgets(
    'default, duplicate and default-named instances remain distinct',
    (tester) async {
      await render(tester, instances: ['', 'Default', 'Remote', 'Remote']);
      final select = tester.widget<AppSelect<String?>>(
        find.byType(AppSelect<String?>),
      );
      expect(select.options.values, [null, 'Default', 'Remote']);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Default (Default)').last);
      await tester.pumpAndSettle();
      expect(changes, ['Default']);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(MenuItemButton, 'Default'));
      await tester.pumpAndSettle();
      expect(changes, ['Default', '']);
    },
  );

  for (final disabled in [false, true]) {
    testWidgets(
      'open instance menu rejects ${disabled ? 'disabled' : 'removed'} commands',
      (tester) async {
        await render(tester);
        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();
        final old = tester
            .widget<MenuItemButton>(
              find.widgetWithText(MenuItemButton, 'Remote'),
            )
            .onPressed!;
        await render(
          tester,
          enabled: !disabled,
          instances: disabled ? ['Remote'] : [],
        );
        old();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(changes, isEmpty);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('removed external selection falls back without a user command', (
    tester,
  ) async {
    await render(tester, value: 'Remote');
    await render(tester, value: 'Remote', instances: []);
    expect(
      tester.widget<AppSelect<String?>>(find.byType(AppSelect<String?>)).value,
      isNull,
    );
    expect(changes, isEmpty);
  });

  for (final locale in ['en', 'zh']) {
    for (final width in [320.0, 900.0]) {
      testWidgets('selected long instance wraps at $locale $width 3x', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const name =
            'International live broadcast and shared family streaming instance';
        await render(
          tester,
          instances: [name],
          value: name,
          locale: locale,
          scale: 3,
        );
        expect(tester.takeException(), isNull);
        final label = tester.widget<Text>(find.text(name));
        expect(label.maxLines, isNull);
        expect(label.overflow, isNot(TextOverflow.ellipsis));
        final arrow = find.byIcon(Icons.arrow_drop_down);
        await tester.ensureVisible(arrow);
        await tester.tap(arrow);
        await tester.pumpAndSettle();
        expect(find.text(name), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
