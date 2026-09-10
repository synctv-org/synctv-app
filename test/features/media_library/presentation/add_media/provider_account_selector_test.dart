import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

typedef _Account = ({String id, String label});

void main() {
  Future<void> pumpSelector(
    WidgetTester tester, {
    required List<_Account> accounts,
    required ValueChanged<_Account?> onChanged,
    String? selectedId,
    bool enabled = true,
    bool includeDefault = true,
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
          padding: const EdgeInsets.all(16),
          child: ProviderAccountSelector<_Account>(
            accounts: accounts,
            selectedId: selectedId,
            idOf: (account) => account.id,
            labelOf: (account) => account.label,
            onChanged: onChanged,
            enabled: enabled,
            includeDefault: includeDefault,
          ),
        ),
      ),
    ),
  );

  final dropdown = find.byType(TextButton);

  testWidgets('default source cannot collide with an account identifier', (
    tester,
  ) async {
    const account = (id: '__default_media_source__', label: 'Personal');
    final changes = <_Account?>[];
    await pumpSelector(tester, accounts: [account], onChanged: changes.add);
    expect(tester.takeException(), isNull);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personal').last);
    await tester.pumpAndSettle();
    expect(changes, [account]);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Default media source').last);
    await tester.pumpAndSettle();
    expect(changes, [account, null]);
  });

  for (final disable in [false, true]) {
    testWidgets(
      'open account menu rejects ${disable ? 'disabled' : 'removed'} selection',
      (tester) async {
        const account = (id: 'account', label: 'Personal');
        final changes = <_Account?>[];
        await pumpSelector(tester, accounts: [account], onChanged: changes.add);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        final staleChoice = tester
            .widget<MenuItemButton>(
              find.widgetWithText(MenuItemButton, 'Personal'),
            )
            .onPressed!;
        await pumpSelector(
          tester,
          accounts: disable ? [account] : [],
          onChanged: changes.add,
          enabled: !disable,
        );
        staleChoice();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(changes, isEmpty);
      },
    );
  }

  testWidgets(
    'same labels and fallback-looking labels preserve every account',
    (tester) async {
      const accounts = [
        (id: 'a', label: 'Shared'),
        (id: 'b', label: 'Shared'),
        (id: 'c', label: 'Shared (a)'),
        (id: 'd', label: 'Shared (a) 2'),
        (id: 'e', label: 'Default media source'),
      ];
      final changes = <_Account?>[];
      await pumpSelector(tester, accounts: accounts, onChanged: changes.add);
      final widget = tester.widget<AppSelect<String?>>(
        find.byType(AppSelect<String?>),
      );
      expect(widget.options.values, [null, 'a', 'b', 'c', 'd', 'e']);
      for (final (index, label) in [
        'Shared (a) 3',
        'Shared (b)',
        'Shared (a)',
        'Shared (a) 2',
        'Default media source (e)',
      ].indexed) {
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(changes.last, accounts[index]);
      }
    },
  );

  testWidgets('open menu resolves refreshed account from current snapshot', (
    tester,
  ) async {
    const oldAccount = (id: 'a', label: 'Old label');
    const newAccount = (id: 'a', label: 'New label');
    final changes = <_Account?>[];
    await pumpSelector(tester, accounts: [oldAccount], onChanged: changes.add);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    final staleChoice = tester
        .widget<MenuItemButton>(
          find.widgetWithText(MenuItemButton, 'Old label'),
        )
        .onPressed!;
    await pumpSelector(tester, accounts: [newAccount], onChanged: changes.add);
    staleChoice();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(changes, [newAccount]);
  });

  testWidgets('external selection updates without issuing a user command', (
    tester,
  ) async {
    const accounts = [(id: 'a', label: 'Personal'), (id: 'b', label: 'Family')];
    final changes = <_Account?>[];
    for (final selected in ['a', 'b', 'missing']) {
      await pumpSelector(
        tester,
        accounts: accounts,
        selectedId: selected,
        onChanged: changes.add,
      );
      expect(
        tester
            .widget<AppSelect<String?>>(find.byType(AppSelect<String?>))
            .value,
        selected == 'missing' ? null : selected,
      );
      expect(changes, isEmpty);
    }
  });

  for (final scale in [1.0, 3.0]) {
    testWidgets('unselected long accounts do not inflate field at ${scale}x', (
      tester,
    ) async {
      const short = (id: 'short', label: 'Personal');
      const long = (
        id: 'long',
        label: 'International cinema collection and shared family account',
      );
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Future<void> render(List<_Account> accounts, String selectedId) =>
          pumpSelector(
            tester,
            accounts: accounts,
            selectedId: selectedId,
            onChanged: (_) {},
            scale: scale,
          );
      await render([short], short.id);
      final shortSize = tester.getSize(dropdown);
      await render([short, long], short.id);
      expect(tester.getSize(dropdown), shortSize);
      await render([short, long], long.id);
      expect(tester.getSize(dropdown).height, greaterThan(shortSize.height));
      await render([short, long], short.id);
      expect(tester.getSize(dropdown), shortSize);
    });
  }

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(900, 420)]) {
      testWidgets('account selector wraps at 3x $locale $size', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const account = (
          id: 'account',
          label: 'International cinema collection and shared family account',
        );
        await pumpSelector(
          tester,
          accounts: [account],
          selectedId: account.id,
          onChanged: (_) {},
          locale: locale,
          scale: 3,
        );
        expect(tester.takeException(), isNull);
        for (final text in tester.widgetList<Text>(find.text(account.label))) {
          expect(text.overflow, isNot(TextOverflow.ellipsis));
          expect(text.maxLines, isNull);
        }
        final arrow = find.byIcon(Icons.arrow_drop_down);
        await tester.ensureVisible(arrow);
        await tester.tap(arrow);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text(account.label), findsNWidgets(2));
      });
    }
  }
}
