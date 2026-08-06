import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';

void main() {
  testWidgets('submits only selected YouTube preview media', (tester) async {
    List<RoomDynamicMediaEntry>? submitted;
    final items = [_item('first'), _item('second')];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YoutubePlaylistPreview(
            items: items,
            loading: false,
            hasMore: false,
            onAddSelected: (items) => submitted = items,
          ),
        ),
      ),
    );

    expect(find.text('2 / 2 selected'), findsOneWidget);
    await tester.tap(find.byKey(const Key('youtube-preview-item-second')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('youtube-preview-add-selected')));

    expect(submitted?.map((item) => item.id), ['first']);
  });
}

RoomDynamicMediaEntry _item(String id) => RoomDynamicMediaEntry(
  id: id,
  name: id,
  parentId: '',
  subPath: id,
  isPlaylist: false,
  mediaSourceConfig: source.MediaSourceConfig(
    youtube: source.YoutubeMediaSourceConfig(videoId: 'abcdefghijk'),
  ),
);
