import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  late DiscoverySelectionController selection;
  late DiscoveryBrowserEntry item;
  var changes = 0;
  var submissions = 0;
  Future<void> Function()? submit;

  Future<void> render(
    WidgetTester tester, {
    bool loading = false,
    bool readonly = false,
    ProviderAddTarget target = ProviderAddTarget.media,
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: DiscoveryBrowser(
          items: [item],
          loading: loading,
          target: target,
          selectionController: selection,
          onSelectionChanged: () => changes++,
          onAddSelected: readonly
              ? null
              : (_) async {
                  submissions++;
                  await submit?.call();
                },
          onAddCurrentList: () async {
            submissions++;
            await submit?.call();
          },
        ),
      ),
    ),
  );

  VoidCallback callback(WidgetTester tester, String command) => tester
      .widget<ButtonStyleButton>(find.byKey(Key('discovery-$command')))
      .onPressed!;

  setUp(() {
    selection = DiscoverySelectionController();
    item = DiscoveryBrowserEntry(
      key: 'movie',
      title: 'Movie',
      source: testDiscoveredPlaylistSource(),
      isContainer: false,
    );
    changes = 0;
    submissions = 0;
    submit = null;
  });

  testWidgets('read-only media preview hides bulk selection controls', (
    tester,
  ) async {
    await render(tester, readonly: true);
    for (final command in ['select-all', 'clear-selection', 'add-selected']) {
      expect(find.byKey(Key('discovery-$command')), findsNothing);
    }
  });

  for (final command in [
    'select-all',
    'clear-selection',
    'add-selected',
    'add-current-list',
  ]) {
    for (final transition in [
      'loading',
      'mode',
      'disposed',
      'covered',
      if (command != 'add-current-list') 'readonly',
    ]) {
      testWidgets('stale $command rejects $transition', (tester) async {
        if (command != 'select-all') selection.selectAll([item]);
        final target = command == 'add-current-list'
            ? ProviderAddTarget.playlist
            : ProviderAddTarget.media;
        await render(tester, target: target);
        final invoke = callback(tester, command);
        final before = selection.entries;
        if (transition == 'disposed') {
          await tester.pumpWidget(const SizedBox.shrink());
        } else if (transition == 'covered') {
          showDialog<void>(
            context: tester.element(find.byType(DiscoveryBrowser)),
            builder: (_) => const AlertDialog(content: Text('Covered')),
          );
          await tester.pumpAndSettle();
        } else {
          await render(
            tester,
            loading: transition == 'loading',
            readonly: transition == 'readonly',
            target: transition == 'mode'
                ? (target == ProviderAddTarget.media
                      ? ProviderAddTarget.playlist
                      : ProviderAddTarget.media)
                : target,
          );
        }
        invoke();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(selection.entries, before);
        expect(changes, 0);
        expect(submissions, 0);
      });
    }
  }

  testWidgets(
    'pending submission freezes row and bulk selection then recovers',
    (tester) async {
      final pending = Completer<void>();
      submit = () => pending.future;
      await render(tester);
      final selectAll = callback(tester, 'select-all');
      selectAll();
      await tester.pump();
      final clear = callback(tester, 'clear-selection');
      final toggle = tester.widget<ListTile>(find.byType(ListTile)).onTap!;
      final request = Function.apply(
        callback(tester, 'add-selected'),
        const [],
      ) as Future<void>;
      clear();
      toggle();
      selectAll();
      expect(selection.entries, [item]);
      expect(changes, 1);
      pending.complete();
      await request;
      await tester.pump();
      callback(tester, 'clear-selection')();
      expect(selection.isEmpty, isTrue);
      expect(changes, 2);
    },
  );

  testWidgets('submission completion after disposal is safe', (tester) async {
    final pending = Completer<void>();
    submit = () => pending.future;
    selection.selectAll([item]);
    await render(tester);
    final request = Function.apply(
      callback(tester, 'add-selected'),
      const [],
    ) as Future<void>;
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete();
    await request;
    expect(tester.takeException(), isNull);
    expect(submissions, 1);
  });

  for (final target in [ProviderAddTarget.media, ProviderAddTarget.playlist]) {
    testWidgets(
      '$target submissions are exclusive and can retry after failure',
      (tester) async {
        selection.selectAll([item]);
        final pending = Completer<void>();
        submit = () => pending.future;
        await render(tester, target: target);
        final command = target == ProviderAddTarget.media
            ? 'add-selected'
            : 'add-current-list';
        final invoke = callback(tester, command);
        final request = Function.apply(invoke, const []) as Future<void>;
        final failure = expectLater(request, throwsStateError);
        invoke();
        await tester.pump();
        expect(submissions, 1);
        expect(
          tester
              .widget<ButtonStyleButton>(find.byKey(Key('discovery-$command')))
              .onPressed,
          isNull,
        );
        pending.completeError(StateError('retry'));
        await failure;
        await tester.pump();
        submit = null;
        callback(tester, command)();
        await tester.pump();
        expect(submissions, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
