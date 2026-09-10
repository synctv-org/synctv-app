import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  final selected = DiscoverySelectionController();
  var changes = 0;
  final opened = <DiscoveryBrowserEntry>[];
  DiscoveryBrowserEntry item() => DiscoveryBrowserEntry(
    key: 'folder',
    title: 'Folder',
    isContainer: true,
    source: testDiscoveredPlaylistSource(),
  );
  Future<void> render(
    WidgetTester tester,
    List<DiscoveryBrowserEntry> items, {
    bool loading = false,
    bool canSelect = true,
    ProviderAddTarget target = ProviderAddTarget.media,
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: DiscoveryBrowser(
          items: items,
          loading: loading,
          target: target,
          selectionController: selected,
          onAddSelected: canSelect ? (_) async {} : null,
          onOpen: opened.add,
          onSelectionChanged: () => changes++,
        ),
      ),
    ),
  );
  setUp(() {
    selected.clear();
    changes = 0;
    opened.clear();
  });

  for (final target in [ProviderAddTarget.parse, ProviderAddTarget.playlist]) {
    testWidgets('non-media target $target cannot change hidden selection', (
      tester,
    ) async {
      final current = item();
      await render(tester, [current]);
      await tester.tap(find.byType(ListTile));
      await tester.pump();
      expect(selected.entries, [current]);
      await render(tester, [current], target: target);
      await tester.tap(find.text('Folder'));
      await tester.pump();
      expect(selected.entries, [current]);
      expect(changes, 1);
      expect(tester.widget<ListTile>(find.byType(ListTile)).onTap, isNull);
      await tester.tap(find.byKey(const ValueKey('discovery-open-folder')));
      expect(opened, [current]);
    });
  }

  testWidgets('read-only browser does not expose row selection', (
    tester,
  ) async {
    await render(tester, [item()], canSelect: false);
    await tester.tap(find.text('Folder'));
    expect(selected.isEmpty, isTrue);
    expect(changes, 0);
    expect(tester.widget<ListTile>(find.byType(ListTile)).onTap, isNull);
  });

  for (final command in ['toggle', 'open']) {
    for (final transition in [
      'loading',
      'removed',
      'replaced',
      'disposed',
      'covered',
      if (command == 'toggle') 'playlist',
    ]) {
      testWidgets('stale $command ignores $transition row', (tester) async {
        final old = item();
        await render(tester, [old]);
        final callback = command == 'toggle'
            ? tester.widget<ListTile>(find.byType(ListTile)).onTap!
            : tester
                  .widget<AppIconButton>(
                    find.byKey(const ValueKey('discovery-open-folder')),
                  )
                  .onPressed!;
        final replacement = item();
        if (transition == 'disposed') {
          await tester.pumpWidget(const SizedBox.shrink());
        } else if (transition == 'covered') {
          showDialog<void>(
            context: tester.element(find.byType(ListTile)),
            builder: (_) =>
                const AlertDialog(content: Text('Account settings')),
          );
          await tester.pumpAndSettle();
        } else {
          await render(
            tester,
            transition == 'removed'
                ? []
                : [transition == 'replaced' ? replacement : old],
            loading: transition == 'loading',
            target: transition == 'playlist'
                ? ProviderAddTarget.playlist
                : ProviderAddTarget.media,
          );
        }
        callback();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(selected.isEmpty, isTrue);
        expect(changes, 0);
        expect(opened, isEmpty);
        if (transition == 'replaced') {
          if (command == 'toggle') {
            await tester.tap(find.byType(ListTile));
            expect(selected.entries, [replacement]);
          } else {
            await tester.tap(
              find.byKey(const ValueKey('discovery-open-folder')),
            );
            expect(opened, [replacement]);
          }
        }
      });
    }
  }
}
