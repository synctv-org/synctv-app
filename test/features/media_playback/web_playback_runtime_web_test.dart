@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';

const _mediaBaseUrl = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_BASE');
const _onlyFixture = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_ONLY');

void main() {
  SyncTvVideoPlayerMediaKit.ensureInitialized(web: true);

  for (final source in const [
    _WebPlaybackFixture('progressive MP4', 'sample.mp4', 'mp4'),
    _WebPlaybackFixture('HLS', 'hls/master.m3u8', 'hls'),
    _WebPlaybackFixture('DASH', 'dash/manifest.mpd', 'dash'),
    _WebPlaybackFixture('HTTP FLV', 'sample.flv', 'flv'),
    _WebPlaybackFixture('MPEG-TS', 'sample.ts', 'mpeg-ts'),
  ].where((source) => _onlyFixture.isEmpty || source.format == _onlyFixture)) {
    testWidgets(
      'initializes ${source.name} through the production Web runtime',
      (tester) async {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse('$_mediaBaseUrl/${source.path}'),
          httpHeaders: {syncTvVideoFormatHeader: source.format},
        );
        addTearDown(controller.dispose);

        await tester.runAsync(
          () => controller.initialize().timeout(const Duration(seconds: 20)),
        );
        expect(controller.value.isInitialized, isTrue);
        await tester.pumpWidget(
          MaterialApp(home: Center(child: VideoPlayer(controller))),
        );
        await tester.pump();
      },
      skip: _mediaBaseUrl.isEmpty,
    );
  }
}

class _WebPlaybackFixture {
  const _WebPlaybackFixture(this.name, this.path, this.format);

  final String name;
  final String path;
  final String format;
}
