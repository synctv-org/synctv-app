import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final size in [
      const Size(320, 568),
      const Size(320, 160),
      const Size(1200, 400),
    ]) {
      testWidgets('$locale $size can leave an empty last page at 3x', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var page = 2;
        var requests = 0;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            builder: (context, child) => buildThemedTestApp(
              context,
              MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(3)),
                child: child!,
              ),
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => DiscoveryBrowser(
                  items: [
                    if (page == 1)
                      DiscoveryBrowserEntry(
                        key: 'movie',
                        title: 'Movie',
                        source: testDiscoveredMediaSource(),
                        isContainer: false,
                      ),
                  ],
                  loading: false,
                  paginationMode: DiscoveryPaginationMode.page,
                  page: page,
                  hasMore: false,
                  onPreviousPage: () => setState(() {
                    page--;
                    requests++;
                  }),
                  onNextPage: () => requests++,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(AppEmptyState), findsOneWidget);
        expect(find.byType(AppPaginationBar), findsOneWidget);
        final bar = tester.widget<AppPaginationBar>(
          find.byType(AppPaginationBar),
        );
        expect(bar.onNext, isNull);
        final previous = find.byWidgetPredicate(
          (widget) =>
              widget is AppIconButton &&
              widget.icon == Icons.chevron_left_rounded,
        );
        await tester.ensureVisible(previous);
        await tester.tap(previous);
        await tester.pumpAndSettle();
        expect(requests, 1);
        expect(page, 1);
        expect(find.byType(AppEmptyState), findsNothing);
        expect(
          find.byKey(const ValueKey('discovery-item-movie')),
          findsOneWidget,
        );
        expect(
          tester
              .widget<AppPaginationBar>(find.byType(AppPaginationBar))
              .onPrevious,
          isNull,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final loading in [false, true]) {
    testWidgets('empty page retains next navigation loading=$loading', (
      tester,
    ) async {
      var requests = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DiscoveryBrowser(
              items: const [],
              loading: loading,
              paginationMode: DiscoveryPaginationMode.page,
              page: 1,
              hasMore: true,
              onPreviousPage: () => requests++,
              onNextPage: () => requests++,
            ),
          ),
        ),
      );
      expect(find.byType(AppPaginationBar), findsOneWidget);
      final bar = tester.widget<AppPaginationBar>(
        find.byType(AppPaginationBar),
      );
      expect(bar.onPrevious, isNull);
      if (loading) {
        expect(find.byType(AppLoadingIndicator), findsOneWidget);
        expect(bar.onNext, isNull);
      } else {
        bar.onNext!();
        expect(requests, 1);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
