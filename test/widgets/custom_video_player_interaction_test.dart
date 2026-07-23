import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';
import 'package:synctv_app/services/picture_in_picture_service.dart';
import 'package:video_player/video_player.dart';

import '../test_app.dart';

class _RecordingVideoPlayerController extends VideoPlayerController {
  _RecordingVideoPlayerController(VideoPlayerValue initialValue)
    : super.networkUrl(Uri.parse('https://example.com/video.mp4')) {
    value = initialValue;
  }

  final List<Duration> seekPositions = [];
  var playCalls = 0;
  var pauseCalls = 0;

  @override
  Future<void> seekTo(Duration position) async {
    seekPositions.add(position);
    value = value.copyWith(position: position, isCompleted: false);
  }

  @override
  Future<void> play() async {
    playCalls++;
    value = value.copyWith(isPlaying: true, isCompleted: false);
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    value = value.copyWith(isPlaying: false);
  }
}

void main() {
  test('picture-in-picture selects the native or desktop platform backend', () {
    expect(
      pictureInPictureBackendForPlatform(TargetPlatform.android),
      PictureInPictureBackend.android,
    );
    expect(
      pictureInPictureBackendForPlatform(TargetPlatform.iOS),
      PictureInPictureBackend.ios,
    );
    for (final platform in [
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    ]) {
      expect(
        pictureInPictureBackendForPlatform(platform),
        PictureInPictureBackend.desktopWindow,
      );
    }
    expect(
      pictureInPictureBackendForPlatform(TargetPlatform.android, isWeb: true),
      PictureInPictureBackend.unavailable,
    );
  });

  test('mobile platforms use gesture-only player interaction', () {
    expect(
      videoPlayerInteractionModeForPlatform(TargetPlatform.android),
      VideoPlayerInteractionMode.mobile,
    );
    expect(
      videoPlayerInteractionModeForPlatform(TargetPlatform.iOS),
      VideoPlayerInteractionMode.mobile,
    );
  });

  test('desktop platforms use pointer player interaction', () {
    for (final platform in [
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      expect(
        videoPlayerInteractionModeForPlatform(platform),
        VideoPlayerInteractionMode.desktop,
      );
    }
  });

  test('playback speed menu orders slower speeds toward the bottom', () {
    expect(playerPlaybackSpeedOptions, [2.0, 1.5, 1.25, 1.0, 0.75, 0.5]);
  });

  test('narrow playback controls retain only essential visible actions', () {
    final visibility = PlayerControlVisibility.forWidth(300, desktop: true);

    expect(visibility.showTime, isFalse);
    expect(visibility.showFullscreen, isFalse);
    expect(visibility.showVolume, isFalse);
    expect(visibility.showSync, isFalse);
    expect(visibility.showPlaybackRoute, isFalse);
    expect(visibility.showSpeed, isFalse);
    expect(visibility.showDanmaku, isFalse);
    expect(visibility.showSubtitles, isFalse);
    expect(visibility.showPictureInPicture, isFalse);
    expect(visibility.showSettings, isFalse);
  });

  test('medium playback controls prioritize fullscreen volume and sync', () {
    final visibility = PlayerControlVisibility.forWidth(550, desktop: true);

    expect(visibility.showTime, isTrue);
    expect(visibility.showFullscreen, isTrue);
    expect(visibility.showVolume, isTrue);
    expect(visibility.showSync, isTrue);
    expect(visibility.showPlaybackRoute, isFalse);
    expect(visibility.showSpeed, isFalse);
    expect(visibility.showSettings, isTrue);
  });

  test('wide playback controls expose all secondary actions', () {
    final visibility = PlayerControlVisibility.forWidth(1000, desktop: true);

    expect(visibility.showTime, isTrue);
    expect(visibility.showFullscreen, isTrue);
    expect(visibility.showVolume, isTrue);
    expect(visibility.showSync, isTrue);
    expect(visibility.showPlaybackRoute, isTrue);
    expect(visibility.showSpeed, isTrue);
    expect(visibility.showDanmaku, isTrue);
    expect(visibility.showSubtitles, isTrue);
    expect(visibility.showPictureInPicture, isTrue);
    expect(visibility.showSendDanmaku, isTrue);
    expect(visibility.showSettings, isTrue);
  });

  test('subtitle text removes WebVTT inline timing and style tags', () {
    expect(
      sanitizeSubtitleText(
        'comes out of the box\noff<00:23:35.919><c> industry</c>'
        '<00:23:36.480><c> adoption</c>',
      ),
      'comes out of the box\noff industry adoption',
    );
  });

  test('subtitle labels prefer user-facing metadata over internal keys', () {
    expect(
      subtitleDisplayLabel('sub_0', {
        'name': 'English (auto-generated)',
        'language': 'en',
      }),
      'English (auto-generated)',
    );
    expect(
      subtitleDisplayLabel('sub_1', {'name': '', 'language': 'zh-Hans'}),
      'zh-Hans',
    );
    expect(subtitleDisplayLabel('sub_2', const {}), 'sub_2');
  });

  test('live playback position includes elapsed time without a duration', () {
    expect(
      playbackPositionLabel(
        isLive: true,
        position: const Duration(hours: 1, minutes: 2, seconds: 3),
        liveLabel: 'Live',
      ),
      'Live · 01:02:03',
    );
  });

  test('completed VOD playback restarts within the EOF tolerance', () {
    final value = VideoPlayerValue(
      duration: const Duration(seconds: 30),
      position: const Duration(milliseconds: 29900),
      isInitialized: true,
    );

    expect(shouldRestartCompletedPlayback(value, isLive: false), isTrue);
    expect(shouldRestartCompletedPlayback(value, isLive: true), isFalse);
  });

  test('active VOD playback resumes from its current position', () {
    final value = VideoPlayerValue(
      duration: const Duration(seconds: 30),
      position: const Duration(seconds: 20),
      isInitialized: true,
    );

    expect(shouldRestartCompletedPlayback(value, isLive: false), isFalse);
  });

  test(
    'seek resumes an EOF-stopped player when room playback is active',
    () async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(seconds: 30),
          position: Duration(seconds: 30),
          isInitialized: true,
          isCompleted: true,
        ),
      );

      await seekVideoPlayback(
        controller,
        position: const Duration(seconds: 10),
        expectedToBePlaying: true,
      );

      expect(controller.seekPositions, [const Duration(seconds: 10)]);
      expect(controller.playCalls, 1);
      expect(controller.pauseCalls, 0);
      expect(controller.value.isPlaying, isTrue);
    },
  );

  test(
    'seek keeps local playback paused when room playback is paused',
    () async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(seconds: 30),
          position: Duration(seconds: 5),
          isInitialized: true,
          isPlaying: true,
        ),
      );

      await seekVideoPlayback(
        controller,
        position: const Duration(seconds: 10),
        expectedToBePlaying: false,
      );

      expect(controller.seekPositions, [const Duration(seconds: 10)]);
      expect(controller.playCalls, 0);
      expect(controller.pauseCalls, 1);
      expect(controller.value.isPlaying, isFalse);
    },
  );

  testWidgets('live playback hides playback speed control', (tester) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse('https://example.com/live.m3u8'),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 900,
            height: 500,
            child: CustomVideoPlayer(
              controller: controller,
              title: 'Live',
              isLive: true,
              canControlPlayback: true,
            ),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Playback speed'), findsNothing);
  });

  testWidgets('picture-in-picture control invokes its callback', (
    tester,
  ) async {
    var invocationCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PictureInPictureControl(
            tooltip: 'Picture in picture',
            onPressed: () => invocationCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('picture_in_picture_button')));
    await tester.pump(const Duration(milliseconds: 200));

    expect(invocationCount, 1);
  });

  testWidgets('desktop P shortcut enters picture-in-picture', (tester) async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse('https://example.com/video.mp4'),
    );
    var invocationCount = 0;
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CustomVideoPlayer(
            controller: controller,
            title: 'Video',
            interactionMode: VideoPlayerInteractionMode.desktop,
            onEnterPictureInPicture: () => invocationCount++,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyP);

    expect(invocationCount, 1);
  });

  testWidgets('picture-in-picture playback options switch source and quality', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: Center(
            child: PictureInPicturePlaybackOptionsControl(
              tooltip: 'Playback route',
              choices: const [
                PictureInPicturePlaybackChoice(
                  value: 'direct|0',
                  groupLabel: 'Direct',
                  label: '360p',
                  selected: true,
                ),
                PictureInPicturePlaybackChoice(
                  value: 'direct|1',
                  groupLabel: 'Direct',
                  label: '1080p',
                  selected: false,
                ),
                PictureInPicturePlaybackChoice(
                  value: 'proxy|0',
                  groupLabel: 'Proxy',
                  label: '360p',
                  selected: false,
                ),
              ],
              onSelected: (value) => selected = value,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Direct'), findsNothing);
    await tester.tap(
      find.byKey(const Key('picture_in_picture_playback_options_toggle')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Direct'), findsOneWidget);
    expect(find.text('Proxy'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('picture_in_picture_playback_option_direct|1')),
    );
    await tester.pumpAndSettle();
    expect(selected, 'direct|1');
  });

  testWidgets('picture-in-picture keeps an empty playback surface mounted', (
    tester,
  ) async {
    final danmakuController = DanmakuController();
    var exitCount = 0;
    var previousCount = 0;
    var nextCount = 0;
    var syncCount = 0;
    var dragCount = 0;
    addTearDown(danmakuController.dispose);
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PictureInPicturePlaybackSurface(
          controller: null,
          danmakuController: danmakuController,
          emptyState: const Text('Waiting for playback'),
          exitTooltip: 'Return to room',
          playbackOptionsControl: const SizedBox(
            key: Key('test_playback_options'),
          ),
          diagnostics: const SizedBox(key: Key('test_playback_diagnostics')),
          onPrevious: () => previousCount++,
          onNext: () => nextCount++,
          onSync: () => syncCount++,
          onDragStart: () => dragCount++,
          onExit: () => exitCount++,
        ),
      ),
    );

    expect(find.byKey(const Key('picture_in_picture_surface')), findsOneWidget);
    expect(find.text('Waiting for playback'), findsOneWidget);
    expect(
      find.byKey(const Key('picture_in_picture_exit_button')),
      findsNothing,
    );
    expect(find.byKey(const Key('test_playback_options')), findsNothing);
    expect(find.byKey(const Key('test_playback_diagnostics')), findsNothing);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('picture_in_picture_surface'))),
    );
    await tester.pump();
    expect(
      find.byKey(const Key('picture_in_picture_exit_button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('test_playback_options')), findsOneWidget);
    expect(
      find.byKey(const Key('picture_in_picture_playback_options_button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('test_playback_diagnostics')), findsOneWidget);
    await tester.tap(
      find.byKey(const Key('picture_in_picture_previous_button')),
    );
    await tester.tap(find.byKey(const Key('picture_in_picture_next_button')));
    await tester.tap(find.byKey(const Key('picture_in_picture_sync_button')));
    expect(previousCount, 1);
    expect(nextCount, 1);
    expect(syncCount, 1);
    final surface = find.byKey(const Key('picture_in_picture_surface'));
    await tester.tap(surface);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.dragFrom(tester.getCenter(surface), const Offset(20, 0));
    expect(dragCount, 1);
    expect(exitCount, 0);
    await tester.tap(find.byKey(const Key('picture_in_picture_exit_button')));
    expect(exitCount, 1);
    await tester.tap(surface);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(surface);
    await tester.pumpAndSettle();
    expect(exitCount, 2);
  });

  testWidgets('playback navigation invokes previous and next callbacks', (
    tester,
  ) async {
    var previousCount = 0;
    var nextCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: PlaybackNavigationControls(
            previousTooltip: 'Previous video',
            nextTooltip: 'Next video',
            onPrevious: () => previousCount++,
            onNext: () => nextCount++,
            center: const SizedBox(
              key: Key('playback_center_control'),
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('playback_previous_button')), findsOneWidget);
    expect(find.byKey(const Key('playback_next_button')), findsOneWidget);
    final previousCenter = tester.getCenter(
      find.byKey(const Key('playback_previous_button')),
    );
    final playbackCenter = tester.getCenter(
      find.byKey(const Key('playback_center_control')),
    );
    final nextCenter = tester.getCenter(
      find.byKey(const Key('playback_next_button')),
    );
    expect(previousCenter.dx, lessThan(playbackCenter.dx));
    expect(playbackCenter.dx, lessThan(nextCenter.dx));
    await tester.tap(find.byKey(const Key('playback_previous_button')));
    await tester.tap(find.byKey(const Key('playback_next_button')));
    await tester.pump(const Duration(milliseconds: 200));

    expect(previousCount, 1);
    expect(nextCount, 1);
  });

  testWidgets('playback navigation keeps disabled boundary buttons visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: PlaybackNavigationControls(
            previousTooltip: 'Previous video',
            nextTooltip: 'Next video',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.skip_previous_rounded), findsOneWidget);
    expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('playback_previous_button'))),
      const Size(40, 40),
    );
    expect(
      tester.getSize(find.byKey(const Key('playback_next_button'))),
      const Size(40, 40),
    );
  });
}
