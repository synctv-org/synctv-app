import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('keeps media selection and dynamic playlist actions exclusive', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 500,
            child: DiscoveryBrowser(
              items: [
                DiscoveryBrowserEntry(
                  key: 'folder',
                  title: '目录',
                  source: testDiscoveredPlaylistSource(),
                  isContainer: true,
                ),
              ],
              loading: false,
              onOpen: (_) => opened = true,
              onAddSelected: (_) async {},
              onAddCurrentList: () async {},
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('discovery-add-selected')), findsOneWidget);
    expect(find.byKey(const Key('discovery-add-current-list')), findsNothing);
    expect(find.byType(AppCheckbox), findsOneWidget);

    await tester.tap(find.byKey(const Key('discovery-open-folder')));
    expect(opened, isTrue);

    await tester.tap(find.text('动态播放列表'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discovery-add-selected')), findsNothing);
    expect(find.byKey(const Key('discovery-add-current-list')), findsOneWidget);
    expect(find.byType(AppCheckbox), findsNothing);
  });

  testWidgets('keeps selections while browsing across folders', (tester) async {
    final controller = DiscoverySelectionController();
    List<DiscoveryBrowserEntry> submitted = const [];

    Future<void> pumpBrowser(
      String location,
      List<DiscoveryBrowserEntry> items,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              height: 500,
              child: DiscoveryBrowser(
                key: ValueKey(location),
                items: items,
                loading: false,
                selectionController: controller,
                selectionScope: 'account-a',
                onAddSelected: (items) async => submitted = items,
              ),
            ),
          ),
        ),
      );
    }

    final rootItem = DiscoveryBrowserEntry(
      key: '/root.mp4',
      title: '根目录视频',
      source: testDiscoveredMediaSource(),
      isContainer: false,
    );
    final childItem = DiscoveryBrowserEntry(
      key: '/folder/child.mp4',
      title: '子目录视频',
      source: testDiscoveredMediaSource(),
      isContainer: false,
    );

    await pumpBrowser('root', [rootItem]);
    await tester.tap(find.byKey(const ValueKey('discovery-item-/root.mp4')));
    await tester.pump();
    expect(find.text('已选 1'), findsOneWidget);

    await pumpBrowser('child', [childItem]);
    expect(find.text('已选 1'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('discovery-item-/folder/child.mp4')),
    );
    await tester.pump();
    expect(find.text('已选 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('discovery-add-selected')));
    await tester.pump();
    expect(submitted.map((item) => item.key).toSet(), {
      '/root.mp4',
      '/folder/child.mp4',
    });

    await pumpBrowser('root-again', [rootItem]);
    expect(find.text('已选 2'), findsOneWidget);
    expect(tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value, isTrue);
  });

  testWidgets('keeps an empty state scrollable in a compact viewport', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SizedBox(
            height: 40,
            child: DiscoveryBrowser(items: [], loading: false),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(AppSingleChildScrollView), findsOneWidget);
  });

  testWidgets('compresses selection actions in a narrow provider panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 220,
            child: DiscoveryBrowser(
              items: [
                DiscoveryBrowserEntry(
                  key: 'folder',
                  title: '根目录',
                  source: testDiscoveredPlaylistSource(),
                  isContainer: true,
                ),
              ],
              loading: false,
              onAddSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('discovery-select-all')), findsOneWidget);
    expect(find.byKey(const Key('discovery-clear-selection')), findsOneWidget);
    expect(find.byKey(const Key('discovery-add-selected')), findsOneWidget);
  });

  testWidgets('keeps selection actions below the media list', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 420,
            child: DiscoveryBrowser(
              loading: false,
              items: [
                DiscoveryBrowserEntry(
                  key: 'movie',
                  title: 'Movie',
                  source: testDiscoveredMediaSource(name: 'Movie'),
                  isContainer: false,
                ),
              ],
              onAddSelected: (_) async {},
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getRect(find.byKey(const Key('discovery-item-movie'))).top,
      lessThan(
        tester.getRect(find.byKey(const Key('discovery-add-selected'))).top,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses explicit page navigation without scroll loading', (
    tester,
  ) async {
    var previousCalls = 0;
    var nextCalls = 0;
    var loadMoreCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 260,
            child: DiscoveryBrowser(
              items: [
                for (var index = 0; index < 20; index++)
                  DiscoveryBrowserEntry(
                    key: 'item-$index',
                    title: 'Item $index',
                    source: testDiscoveredMediaSource(),
                    isContainer: false,
                  ),
              ],
              loading: false,
              paginationMode: DiscoveryPaginationMode.page,
              page: 2,
              pageSize: 20,
              total: 60,
              hasMore: true,
              onLoadMore: () async => loadMoreCalls++,
              onPreviousPage: () => previousCalls++,
              onNextPage: () => nextCalls++,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AppPaginationBar), findsOneWidget);
    expect(find.byType(AppLoadMoreFooter), findsNothing);
    await tester.drag(
      find.byType(AppSingleChildScrollView),
      const Offset(0, -2000),
    );
    await tester.pump();
    expect(loadMoreCalls, 0);

    final pagination = find.byType(AppPaginationBar);
    await tester.tap(
      find.descendant(
        of: pagination,
        matching: find.byIcon(Icons.chevron_left_rounded),
      ),
    );
    await tester.tap(
      find.descendant(
        of: pagination,
        matching: find.byIcon(Icons.chevron_right_rounded),
      ),
    );
    expect(previousCalls, 1);
    expect(nextCalls, 1);
  });

  testWidgets('keeps cursor pagination as append-style loading', (
    tester,
  ) async {
    var loadMoreCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            height: 260,
            child: DiscoveryBrowser(
              items: [
                DiscoveryBrowserEntry(
                  key: 'item',
                  title: 'Item',
                  source: testDiscoveredMediaSource(),
                  isContainer: false,
                ),
              ],
              loading: false,
              hasMore: true,
              onLoadMore: () async => loadMoreCalls++,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AppPaginationBar), findsNothing);
    expect(find.byType(AppLoadMoreFooter), findsOneWidget);
    await tester.tap(find.text('加载更多'));
    await tester.pump();
    expect(loadMoreCalls, 1);
  });
}
