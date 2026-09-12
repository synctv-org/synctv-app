import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  Future<void> render(
    WidgetTester tester,
    Future<void> Function()? load, {
    bool loading = false,
    bool hasMore = true,
    DiscoveryPaginationMode mode = DiscoveryPaginationMode.cursor,
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
          onLoadMore: load,
          paginationMode: mode,
        ),
      ),
    ),
  );

  testWidgets('scroll and footer share one pending load', (tester) async {
    var requests = 0;
    final pending = Completer<void>();
    await render(tester, () {
      requests++;
      return pending.future;
    });
    final footer = tester.widget<AppLoadMoreFooter>(
      find.byType(AppLoadMoreFooter),
    );
    final listener = tester.widget<NotificationListener<ScrollNotification>>(
      find.byType(NotificationListener<ScrollNotification>).first,
    );
    final update = ScrollUpdateNotification(
      metrics: FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 100,
        pixels: 100,
        viewportDimension: 200,
        axisDirection: AxisDirection.down,
        devicePixelRatio: 1,
      ),
      context: tester.element(find.byType(AppLoadMoreFooter)),
      scrollDelta: 1,
    );
    footer.onPressed!();
    footer.onPressed!();
    listener.onNotification!(update);
    listener.onNotification!(update);
    expect(requests, 1);
    await tester.pump();
    expect(
      tester.widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter)).loading,
      isTrue,
    );
    pending.complete();
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter)).loading,
      isFalse,
    );
  });

  testWidgets('nested scroll updates do not load an outer page', (
    tester,
  ) async {
    var requests = 0;
    await render(tester, () async => requests++);
    final listener = tester.widget<NotificationListener<ScrollNotification>>(
      find.byType(NotificationListener<ScrollNotification>).first,
    );
    listener.onNotification!(
      ScrollUpdateNotification(
        metrics: FixedScrollMetrics(
          minScrollExtent: 0,
          maxScrollExtent: 100,
          pixels: 100,
          viewportDimension: 200,
          axisDirection: AxisDirection.down,
          devicePixelRatio: 1,
        ),
        context: tester.element(find.byType(AppLoadMoreFooter)),
        scrollDelta: 1,
        depth: 1,
      ),
    );
    await tester.pump();
    expect(requests, 0);
  });

  testWidgets('failed load releases the lock and permits retry', (
    tester,
  ) async {
    var requests = 0;
    await render(tester, () async {
      if (++requests == 1) throw StateError('Page unavailable');
    });
    final callback = tester
        .widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter))
        .onPressed!;
    await expectLater(
      Function.apply(callback, const []) as Future<void>,
      throwsStateError,
    );
    await tester.pump();
    expect(
      tester.widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter)).loading,
      isFalse,
    );
    await (Function.apply(callback, const []) as Future<void>);
    await tester.pump();
    expect(requests, 2);
  });

  testWidgets('pending load completion is safe after disposal', (tester) async {
    final pending = Completer<void>();
    await render(tester, () => pending.future);
    tester
        .widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter))
        .onPressed!();
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final state in [
    'loading',
    'exhausted',
    'page',
    'removed',
    'disposed',
    'covered',
  ]) {
    testWidgets('stale load-more callback ignores $state state', (
      tester,
    ) async {
      var requests = 0;
      Future<void> load() async => requests++;
      await render(tester, load);
      final callback = tester
          .widget<AppLoadMoreFooter>(find.byType(AppLoadMoreFooter))
          .onPressed!;
      if (state == 'disposed') {
        await tester.pumpWidget(const SizedBox.shrink());
      } else if (state == 'covered') {
        showDialog<void>(
          context: tester.element(find.byType(AppLoadMoreFooter)),
          builder: (_) => const AlertDialog(content: Text('Account settings')),
        );
        await tester.pumpAndSettle();
      } else {
        await render(
          tester,
          state == 'removed' ? null : load,
          loading: state == 'loading',
          hasMore: state != 'exhausted',
          mode: state == 'page'
              ? DiscoveryPaginationMode.page
              : DiscoveryPaginationMode.cursor,
        );
      }
      callback();
      await tester.pump();
      expect(requests, 0);
      expect(tester.takeException(), isNull);
    });
  }
}
