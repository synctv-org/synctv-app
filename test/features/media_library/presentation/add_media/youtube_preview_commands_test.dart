import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;

import '../../../../test_app.dart';

void main() {
  late List<youtube.ListItem> items;
  var adds = 0;
  var loads = 0;
  Future<void> render(
    WidgetTester tester, {
    bool loading = false,
    bool enabled = true,
    bool callbacks = true,
    bool hasMore = true,
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: YoutubePlaylistPreview(
          items: items,
          loading: loading,
          hasMore: hasMore,
          selectionEnabled: enabled,
          onAddSelected: callbacks ? (_) => adds++ : null,
          onLoadMore: callbacks ? () => loads++ : null,
        ),
      ),
    ),
  );
  VoidCallback command(WidgetTester tester, String name) {
    if (name == 'row') {
      return tester.widget<ListTile>(find.byType(ListTile)).onTap!;
    }
    return tester
        .widget<ButtonStyleButton>(find.byKey(Key('youtube-preview-$name')))
        .onPressed!;
  }

  setUp(() {
    items = [
      youtube.ListItem(
        videoId: 'movie',
        title: 'Movie',
        source: testDiscoveredMediaSource(),
      ),
    ];
    adds = 0;
    loads = 0;
  });

  for (final name in [
    'row',
    'select-all',
    'clear',
    'add-selected',
    'load-more',
  ]) {
    for (final transition in [
      'loading',
      'covered',
      'disposed',
      if (name != 'load-more') 'disabled',
    ]) {
      testWidgets('$name rejects $transition callback', (tester) async {
        await render(tester);
        if (name == 'select-all') {
          command(tester, 'clear')();
          await tester.pump();
        }
        final invoke = command(tester, name);
        if (transition == 'disposed') {
          await tester.pumpWidget(const SizedBox.shrink());
        } else if (transition == 'covered') {
          showDialog<void>(
            context: tester.element(find.byType(YoutubePlaylistPreview)),
            builder: (_) => const AlertDialog(content: Text('Covered')),
          );
          await tester.pumpAndSettle();
        } else {
          await render(
            tester,
            loading: transition == 'loading',
            enabled: transition != 'disabled',
          );
        }
        invoke();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(adds, 0);
        expect(loads, 0);
        if (transition == 'covered') {
          Navigator.of(tester.element(find.byType(AlertDialog))).pop();
          await tester.pumpAndSettle();
        }
        if (transition != 'disposed') {
          await render(tester);
          expect(
            tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value,
            name != 'select-all',
          );
        }
      });
    }
  }

  testWidgets('retained row ignores replacement with the same video ID', (
    tester,
  ) async {
    await render(tester);
    final invoke = command(tester, 'row');
    items = [
      youtube.ListItem(
        videoId: 'movie',
        title: 'Updated movie',
        source: testDiscoveredMediaSource(),
      ),
    ];
    await render(tester);
    invoke();
    await tester.pump();
    expect(tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value, isTrue);
    command(tester, 'row')();
    await tester.pump();
    expect(tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value, isFalse);
  });

  for (final name in ['add-selected', 'load-more']) {
    testWidgets('$name rejects removed callback', (tester) async {
      await render(tester);
      final invoke = command(tester, name);
      await render(tester, callbacks: false);
      invoke();
      expect(adds, 0);
      expect(loads, 0);
    });
  }
  testWidgets('retained load rejects exhausted pagination', (tester) async {
    await render(tester);
    final invoke = command(tester, 'load-more');
    await render(tester, hasMore: false);
    invoke();
    expect(loads, 0);
  });

  for (final locale in ['en', 'zh']) {
    testWidgets('$locale toolbar fits 320px at 3x', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
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
            body: YoutubePlaylistPreview(
              items: items,
              loading: false,
              hasMore: false,
              onAddSelected: (_) => adds++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('youtube-preview-clear')));
      await tester.pump();
      expect(
        tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value,
        isFalse,
      );
      await tester.tap(find.byKey(const Key('youtube-preview-select-all')));
      await tester.pump();
      expect(
        tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value,
        isTrue,
      );
      await tester.tap(find.byKey(const Key('youtube-preview-add-selected')));
      expect(adds, 1);
    });
  }
}
