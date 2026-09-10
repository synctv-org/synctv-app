import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/home/presentation/room_label_filter_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

const labels = [
  RoomLabelInfo(
    id: 'one',
    key: 'fallback-key',
    name: '',
    description: '',
    color: '#227744',
    categoryId: '',
    sortOrder: 0,
    isEnabled: true,
  ),
  RoomLabelInfo(
    id: 'two',
    key: 'two',
    name:
        'International screenings and discussions with a very long film label',
    description: '',
    color: 'invalid',
    categoryId: '',
    sortOrder: 1,
    isEnabled: true,
  ),
];

void main() {
  for (final hasCategory in [false, true]) {
    testWidgets(
      'same label names retain category context and distinct IDs, scoped=$hasCategory',
      (tester) async {
        late BuildContext page;
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Builder(
              builder: (context) {
                page = context;
                return const Scaffold();
              },
            ),
          ),
        );
        final result = showRoomLabelFilterDialog(
          context: page,
          categories: const [
            RoomCategoryInfo(
              id: 'film',
              key: 'film-key',
              name: '  ',
              description: '',
              sortOrder: 0,
              isEnabled: true,
            ),
            RoomCategoryInfo(
              id: 'music',
              key: 'music',
              name: 'Music',
              description: '',
              sortOrder: 1,
              isEnabled: true,
            ),
          ],
          labels: [
            for (final id in ['film', 'music', '', 'missing'])
              RoomLabelInfo(
                id: 'label-$id',
                key: 'weekly',
                name: 'Weekly Pick',
                description: '',
                color: '',
                categoryId: id,
                sortOrder: 0,
                isEnabled: true,
              ),
          ],
          selectedIds: {},
          hasCategory: hasCategory,
        );
        await tester.pumpAndSettle();
        final tiles = tester
            .widgetList<AppCheckboxTile>(find.byType(AppCheckboxTile))
            .toList();
        expect(
          tiles.map((tile) => (tile.title as Text).data),
          everyElement('Weekly Pick'),
        );
        if (hasCategory) {
          expect(tiles.map((tile) => tile.subtitle), everyElement(isNull));
        } else {
          expect(tiles.map((tile) => (tile.subtitle as Text).data), [
            'film-key',
            'Music',
            'No category',
            'Unknown category',
          ]);
        }
        tiles[1].onChanged!(true);
        await tester.pump();
        await tester.tap(find.text('Apply'));
        await tester.pumpAndSettle();
        expect(await result, {'label-music'});
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 360)]) {
      testWidgets('label layout $locale $size at 3x retains selection', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        late BuildContext page;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(3)),
              child: child!,
            ),
            home: Builder(
              builder: (context) {
                page = context;
                return const Scaffold();
              },
            ),
          ),
        );
        final result = showRoomLabelFilterDialog(
          context: page,
          categories: const [],
          labels: labels,
          selectedIds: {'one', 'obsolete'},
          hasCategory: false,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('fallback-key'), findsOneWidget);
        final tiles = tester
            .widgetList<AppCheckboxTile>(find.byType(AppCheckboxTile))
            .toList();
        expect(tiles.first.value, isTrue);
        expect(
          tester.widget<Text>(find.text(labels.last.name)).maxLines,
          isNull,
        );
        tiles.last.onChanged!(true);
        await tester.pumpAndSettle();
        final apply = find.text(page.l10n.apply);
        await tester.ensureVisible(apply);
        await tester.tap(apply);
        await tester.pumpAndSettle();
        expect(await result, {'one', 'two'});
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final action in ['Cancel', 'Clear', 'Apply']) {
    testWidgets('$action returns snapshot and ignores late callbacks', (
      tester,
    ) async {
      late BuildContext page;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              page = context;
              return const Scaffold(body: Text('Home'));
            },
          ),
        ),
      );
      final original = {'one'};
      final result = showRoomLabelFilterDialog(
        context: page,
        categories: const [],
        labels: labels,
        selectedIds: original,
        hasCategory: false,
      );
      await tester.pumpAndSettle();
      final toggle = tester
          .widgetList<AppCheckboxTile>(find.byType(AppCheckboxTile))
          .last
          .onChanged!;
      toggle(true);
      await tester.pump();
      final finish = tester
          .widget<AppActionButton>(find.widgetWithText(AppActionButton, action))
          .onPressed!;
      finish();
      finish();
      await tester.pumpAndSettle();
      expect(
        await result,
        action == 'Cancel'
            ? isNull
            : action == 'Clear'
            ? isEmpty
            : {'one', 'two'},
      );
      expect(original, {'one'});
      unawaited(
        showDialog<void>(
          context: page,
          builder: (_) => const AlertDialog(content: Text('New dialog')),
        ),
      );
      await tester.pumpAndSettle();
      finish();
      toggle(false);
      await tester.pumpAndSettle();
      expect(find.text('New dialog'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
