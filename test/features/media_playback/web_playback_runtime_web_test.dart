@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

const _mediaBaseUrl = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_BASE');
const _onlyFixture = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_ONLY');

void main() {
  SyncTvVideoPlayerMediaKit.ensureInitialized(web: true);

  for (final source in const [
    _WebPlaybackFixture('progressive MP4', 'sample.mp4', 'mp4'),
    _WebPlaybackFixture('HLS', 'hls/master.m3u8', 'hls'),
    _WebPlaybackFixture(
      'HLS with disguised TS segments',
      'hls-png/master.m3u8',
      'hls-png',
      formatHint: 'hls',
    ),
    _WebPlaybackFixture('DASH', 'dash/manifest.mpd', 'dash'),
    _WebPlaybackFixture('HTTP FLV', 'sample.flv', 'flv'),
    _WebPlaybackFixture('MPEG-TS', 'sample.ts', 'mpeg-ts'),
  ].where((source) => _onlyFixture.isEmpty || source.id == _onlyFixture)) {
    testWidgets('initializes ${source.name} through the production Web runtime', (
      tester,
    ) async {
      final mediaUrl = '$_mediaBaseUrl/${source.path}';
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(mediaUrl),
        httpHeaders: {syncTvVideoFormatHeader: source.formatHint},
      );
      String? playerError;
      controller.addListener(() {
        playerError = controller.value.errorDescription ?? playerError;
      });
      addTearDown(controller.dispose);

      try {
        await tester.runAsync(
          () => controller.initialize().timeout(const Duration(seconds: 20)),
        );
      } on Object catch (error, stackTrace) {
        fail(
          '${source.name} initialization failed for $mediaUrl: $error '
          '(player error: $playerError)\n$stackTrace',
        );
      }
      expect(controller.value.isInitialized, isTrue);
      await tester.pumpWidget(
        MaterialApp(home: Center(child: VideoPlayer(controller))),
      );
      await tester.pump();

      final video =
          web.document.querySelector('video') as web.HTMLVideoElement?;
      expect(video, isNotNull);

      await tester.runAsync(() async {
        await controller.setVolume(0);
        await controller.play();
        final deadline = DateTime.now().add(const Duration(seconds: 5));
        while (video!.currentTime <= 0 &&
            playerError == null &&
            DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      });
      await tester.pump();

      final diagnostics =
          'url=$mediaUrl, position=${controller.value.position}, '
          'playing=${controller.value.isPlaying}, '
          'currentTime=${video!.currentTime}, '
          'video=${video.videoWidth}x${video.videoHeight}, '
          'readyState=${video.readyState}, networkState=${video.networkState}, '
          'mediaError=${video.error?.message}, playerError=$playerError';
      expect(playerError, isNull, reason: diagnostics);
      expect(video.currentTime, greaterThan(0), reason: diagnostics);
      expect(video.videoWidth, greaterThan(0), reason: diagnostics);
      expect(video.videoHeight, greaterThan(0), reason: diagnostics);
    }, skip: _mediaBaseUrl.isEmpty);
  }
}

class _WebPlaybackFixture {
  const _WebPlaybackFixture(this.name, this.path, this.id, {String? formatHint})
    : formatHint = formatHint ?? id;

  final String name;
  final String path;
  final String id;
  final String formatHint;
}
