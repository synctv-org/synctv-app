@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:synctv_app/features/room/application/browser_autoplay_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player/video_player.dart';
import 'package:web/web.dart' as web;

const _mediaBaseUrl = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_BASE');
const _onlyFixture = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_ONLY');
const _verifyDashTrackSelection = bool.fromEnvironment(
  'SYNCTV_WEB_DASH_TRACK_SELECTION_E2E',
);
const _liveMediaUrl = String.fromEnvironment('SYNCTV_WEB_LIVE_MEDIA_TEST_URL');
const _liveMediaFormat = String.fromEnvironment(
  'SYNCTV_WEB_LIVE_MEDIA_TEST_FORMAT',
  defaultValue: 'hls',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
            '${source.name} initialization failed: $error '
            '(player error: $playerError)\n$stackTrace',
          );
        }
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(controller.value.isInitialized, isTrue);
        expect(controller.value.size.width, greaterThan(0));
        expect(controller.value.size.height, greaterThan(0));

        if (source.format == 'dash' && _verifyDashTrackSelection) {
          await tester.runAsync(() => _verifyAdaptiveDashTracks(controller));
        }
      },
      skip: _mediaBaseUrl.isEmpty,
    );
  }

  testWidgets(
    'plays a live stream after browser autoplay falls back to mute',
    (tester) async {
      final volumePreferences = PlayerVolumePreferencesController(
        store: _MemoryVolumeStore(),
      );
      await volumePreferences.load();
      final autoplay = BrowserAutoplayController(
        volumePreferences: volumePreferences,
        enabled: true,
      );
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(_liveMediaUrl),
        httpHeaders: {syncTvVideoFormatHeader: _liveMediaFormat},
      );
      String? playerError;
      controller.addListener(() {
        playerError = controller.value.errorDescription ?? playerError;
      });
      addTearDown(() async {
        autoplay.dispose();
        await controller.dispose();
      });

      await tester.runAsync(
        () => controller.initialize().timeout(const Duration(seconds: 20)),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.runAsync(() async {
        await autoplay.applyPreferredVolume(controller);
        await autoplay.play(controller);
        final deadline = DateTime.now().add(const Duration(seconds: 10));
        final video =
            web.document.querySelector('video') as web.HTMLVideoElement?;
        while ((video == null || video.currentTime <= 0) &&
            playerError == null &&
            DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      });
      await tester.pump();

      final video =
          web.document.querySelector('video') as web.HTMLVideoElement?;
      final diagnostics =
          'controllerPosition=${controller.value.position}, '
          'controllerPlaying=${controller.value.isPlaying}, '
          'temporarilyMuted=${autoplay.isTemporarilyMuted(controller)}, '
          'videoPaused=${video?.paused}, currentTime=${video?.currentTime}, '
          'readyState=${video?.readyState}, networkState=${video?.networkState}, '
          'buffered=${video?.buffered.length}, mediaError=${video?.error?.message}, '
          'playerError=$playerError';
      expect(playerError, isNull);
      expect(controller.value.isInitialized, isTrue);
      expect(controller.value.isPlaying, isTrue, reason: diagnostics);
      expect(video, isNotNull, reason: diagnostics);
      expect(video!.paused, isFalse, reason: diagnostics);
      expect(video.currentTime, greaterThan(0), reason: diagnostics);
      expect(autoplay.isTemporarilyMuted(controller), isTrue);
      expect(controller.value.volume, 0);
    },
    skip: _liveMediaUrl.isEmpty,
  );
}

Future<void> _verifyAdaptiveDashTracks(VideoPlayerController controller) async {
  final video = await controller.adaptiveVideoTracks
      .firstWhere((snapshot) => snapshot.tracks.length >= 2)
      .timeout(const Duration(seconds: 10));
  final audio = await controller.adaptiveAudioTracks
      .firstWhere((snapshot) => snapshot.tracks.length >= 2)
      .timeout(const Duration(seconds: 10));

  expect(
    video.tracks.map((track) => track.codec?.toLowerCase()),
    containsAll(<String>['avc1.64001e', 'vp09.00.21.08']),
  );
  expect(
    audio.tracks.map((track) => track.codec?.toLowerCase()),
    containsAll(<String>['mp4a.40.2', 'opus']),
  );

  final vp9 = video.tracks.firstWhere(
    (track) => track.codec?.toLowerCase().startsWith('vp09') == true,
  );
  await controller.selectAdaptiveVideoTrack(vp9.id);
  expect(
    await controller.adaptiveVideoTracks
        .firstWhere((snapshot) => snapshot.selectedTrackId == vp9.id)
        .timeout(const Duration(seconds: 10)),
    isNotNull,
  );

  final opus = audio.tracks.firstWhere(
    (track) => track.codec?.toLowerCase() == 'opus',
  );
  await controller.selectAdaptiveAudioTrack(opus.id);
  expect(
    await controller.adaptiveAudioTracks
        .firstWhere((snapshot) => snapshot.selectedTrackId == opus.id)
        .timeout(const Duration(seconds: 10)),
    isNotNull,
  );

  await controller.selectAdaptiveVideoTrack('auto');
  expect(
    await controller.adaptiveVideoTracks
        .firstWhere((snapshot) => snapshot.selectedTrackId == 'auto')
        .timeout(const Duration(seconds: 10)),
    isNotNull,
  );
}

class _WebPlaybackFixture {
  const _WebPlaybackFixture(this.name, this.path, this.format);

  final String name;
  final String path;
  final String format;
}

final class _MemoryVolumeStore implements PlayerVolumePreferencesStore {
  PlayerVolumePreferenceValues value = const PlayerVolumePreferenceValues(
    volume: 0.7,
    lastAudibleVolume: 0.7,
  );

  @override
  Future<PlayerVolumePreferenceValues> load() async => value;

  @override
  Future<void> save(PlayerVolumePreferenceValues values) async {
    value = values;
  }
}
