import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  var previous = 0;
  var next = 0;
  Future<void> Function()? submit;
  Future<void> render(
    WidgetTester tester, {
    bool loading = false,
    bool callbacks = true,
    bool hasMore = true,
    int page = 2,
    Object? scope = 'first',
    DiscoveryPaginationMode mode = DiscoveryPaginationMode.page,
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: DiscoveryBrowser(
          items: [
            DiscoveryBrowserEntry(
              key: 'movie',
              title: 'Movie',
              source: testDiscoveredMediaSource(),
              isContainer: false,
            ),
          ],
          loading: loading,
          hasMore: hasMore,
          page: page,
          paginationMode: mode,
          selectionScope: scope,
          onPreviousPage: callbacks ? () => previous++ : null,
          onNextPage: callbacks ? () => next++ : null,
          onAddCurrentList: submit,
        ),
      ),
    ),
  );
  AppPaginationBar bar(WidgetTester tester) =>
      tester.widget<AppPaginationBar>(find.byType(AppPaginationBar));
  setUp(() {
    previous = 0;
    next = 0;
    submit = null;
  });

  for (final direction in ['previous', 'next']) {
    for (final transition in [
      'loading',
      'cursor',
      'removed',
      'page',
      'scope',
      'boundary',
      'covered',
      'disposed',
    ]) {
      testWidgets('stale $direction rejects $transition', (tester) async {
        await render(tester);
        final invoke = direction == 'previous'
            ? bar(tester).onPrevious!
            : bar(tester).onNext!;
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
            callbacks: transition != 'removed',
            page: transition == 'page'
                ? 3
                : transition == 'boundary' && direction == 'previous'
                ? 1
                : 2,
            hasMore: !(transition == 'boundary' && direction == 'next'),
            scope: transition == 'scope' ? 'second' : 'first',
            mode: transition == 'cursor'
                ? DiscoveryPaginationMode.cursor
                : DiscoveryPaginationMode.page,
          );
        }
        invoke();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(previous, 0);
        expect(next, 0);
      });
    }
  }

  testWidgets(
    'boundaries and loading disable page buttons independently of parent callbacks',
    (tester) async {
      await render(tester, page: 1, hasMore: false);
      expect(bar(tester).onPrevious, isNull);
      expect(bar(tester).onNext, isNull);
      await render(tester, loading: true);
      expect(bar(tester).onPrevious, isNull);
      expect(bar(tester).onNext, isNull);
      await render(tester);
      bar(tester).onPrevious!();
      bar(tester).onNext!();
      expect(previous, 1);
      expect(next, 1);
    },
  );

  testWidgets('submission blocks retained page commands and recovers', (
    tester,
  ) async {
    final pending = Completer<void>();
    submit = () => pending.future;
    await render(tester);
    final old = bar(tester);
    final add = tester
        .widget<FilledButton>(
          find.byKey(const Key('discovery-add-current-list')),
        )
        .onPressed!;
    final request = Function.apply(add, const []) as Future<void>;
    try {
      old.onPrevious!();
      old.onNext!();
      await tester.pump();
      expect(previous, 0);
      expect(next, 0);
      expect(bar(tester).onPrevious, isNull);
      expect(bar(tester).onNext, isNull);
    } finally {
      pending.complete();
      await request;
    }
    await tester.pump();
    bar(tester).onNext!();
    expect(next, 1);
  });
}
