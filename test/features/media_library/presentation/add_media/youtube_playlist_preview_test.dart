import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('submits only selected YouTube preview media', (tester) async {
    List<youtube.ListItem>? submitted;
    final items = [_item('first'), _item('second')];
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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

    expect(find.text('Selected 2 / 2'), findsOneWidget);
    await tester.tap(find.byKey(const Key('youtube-preview-item-second')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('youtube-preview-add-selected')));

    expect(submitted?.map((item) => item.videoId), ['first']);
  });

  testWidgets('hides selection controls for a dynamic playlist preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubePlaylistPreview(
            items: [_item('first')],
            loading: false,
            hasMore: false,
            selectionEnabled: false,
          ),
        ),
      ),
    );

    expect(find.byType(Checkbox), findsNothing);
    expect(find.byKey(const Key('youtube-preview-add-selected')), findsNothing);
  });
}

youtube.ListItem _item(String id) => youtube.ListItem(
  videoId: id,
  title: id,
  source: provider_common.DiscoveredSource(
    media: source.MediaSourceConfig(
      youtube: source.YoutubeMediaSourceConfig(videoId: 'abcdefghijk'),
    ),
  ),
);
