import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_preview.dart';

void main() {
  testWidgets('selects preview media and submits only checked entries', (
    tester,
  ) async {
    List<RoomDynamicMediaEntry>? submitted;
    var playlistCreates = 0;
    final items = [
      _entry('first', 'First'),
      _entry('second', 'Second'),
      _entry('folder', 'Nested', media: false),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BilibiliPlaylistPreview(
            items: items,
            loading: false,
            hasMore: false,
            onAddSelected: (items) => submitted = items,
            onCreatePlaylist: () => playlistCreates += 1,
          ),
        ),
      ),
    );

    expect(find.text('2 / 2 selected'), findsOneWidget);
    await tester.tap(find.byKey(const Key('bilibili-preview-item-second')));
    await tester.pump();
    expect(find.text('1 / 2 selected'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-preview-add-selected')));
    expect(submitted?.map((item) => item.id), ['first']);

    await tester.tap(find.byKey(const Key('bilibili-preview-create-playlist')));
    expect(playlistCreates, 1);
  });

  testWidgets('selects newly loaded media and supports clear and select all', (
    tester,
  ) async {
    var items = [_entry('first', 'First')];
    late StateSetter update;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return BilibiliPlaylistPreview(
                items: items,
                loading: false,
                hasMore: true,
                onAddSelected: (_) {},
                onCreatePlaylist: () {},
                onLoadMore: () {
                  update(() => items = [...items, _entry('second', 'Second')]);
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('bilibili-preview-load-more')));
    await tester.pump();
    expect(find.text('2 / 2 selected'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-preview-clear')));
    await tester.pump();
    expect(find.text('0 / 2 selected'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bilibili-preview-select-all')));
    await tester.pump();
    expect(find.text('2 / 2 selected'), findsOneWidget);
  });
}

RoomDynamicMediaEntry _entry(String id, String name, {bool media = true}) {
  return RoomDynamicMediaEntry(
    id: id,
    name: name,
    parentId: '',
    subPath: id,
    isPlaylist: !media,
    mediaSourceConfig: media
        ? source.MediaSourceConfig(
            bilibili: source.BilibiliMediaSourceConfig(
              video: source.BilibiliVideoSourceConfig(bvid: id),
            ),
          )
        : null,
    playlistSourceConfig: media
        ? null
        : source.PlaylistSourceConfig(
            bilibili: source.BilibiliPlaylistSourceConfig(
              popular: source.BilibiliPopularPlaylistSource(),
            ),
          ),
  );
}
