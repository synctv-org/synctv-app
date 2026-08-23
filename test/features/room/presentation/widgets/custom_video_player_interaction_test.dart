import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/gestures.dart'
    show PointerScrollEvent, kSecondaryMouseButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/features/room/presentation/widgets/custom_video_player.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/browser_autoplay_controller.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/application/subtitle_source.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/domain/playback_resource_localizer.dart';
import 'package:synctv_app/features/room/infrastructure/picture_in_picture_service.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/features/room/presentation/widgets/danmaku_overlay.dart';

import '../../../../test_app.dart';

final class _EmptyDanmakuSource implements DanmakuSource {
  const _EmptyDanmakuSource();

  @override
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async => null;

  @override
  Stream<String> openEventStream(
    Uri uri, {
    Map<String, String> headers = const {},
  }) => const Stream.empty();
}

final class _EmptySubtitleSource implements SubtitleSource {
  const _EmptySubtitleSource();

  @override
  Future<Uint8List?> load(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async => null;
}

final class _RecordingSubtitleSource implements SubtitleSource {
  final List<Uri> requests = [];
  final List<Map<String, String>> requestHeaders = [];

  @override
  Future<Uint8List?> load(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async {
    requests.add(uri);
    requestHeaders.add(Map<String, String>.from(headers));
    return Uint8List.fromList(
      'WEBVTT\n\n00:00:00.000 --> 00:00:10.000\nSubtitle'.codeUnits,
    );
  }
}

final class _BilibiliJsonSubtitleSource implements SubtitleSource {
  const _BilibiliJsonSubtitleSource();

  @override
  Future<Uint8List?> load(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async => Uint8List.fromList(
    '{"body":[{"from":1.0,"to":3.0,"content":"Bilibili subtitle"}]}'.codeUnits,
  );
}

final class _ControlledSubtitleSource implements SubtitleSource {
  final requests = <Uri>[];
  final documents = <Uri, Completer<Uint8List?>>{};

  @override
  Future<Uint8List?> load(Uri uri, {Map<String, String> headers = const {}}) {
    requests.add(uri);
    return documents.putIfAbsent(uri, Completer<Uint8List?>.new).future;
  }
}

final class _MemoryPlayerVolumeStore implements PlayerVolumePreferencesStore {
  PlayerVolumePreferenceValues values = const PlayerVolumePreferenceValues();

  @override
  Future<PlayerVolumePreferenceValues> load() async => values;

  @override
  Future<void> save(PlayerVolumePreferenceValues values) async {
    this.values = values;
  }
}

PlayerVolumePreferencesController _volumePreferences() =>
    PlayerVolumePreferencesController(store: _MemoryPlayerVolumeStore());

final class _MemoryP2pPreferencesStore implements P2pMediaPreferencesStore {
  P2pMediaPreferenceValues value = const P2pMediaPreferenceValues();

  @override
  Future<P2pMediaPreferenceValues> load() async => value;

  @override
  Future<void> save(P2pMediaPreferenceValues values) async {
    value = values;
  }
}

final class _MemoryOverlayPreferencesStore
    implements PlaybackOverlayPreferencesStore {
  PlaybackOverlayPreferenceValues value =
      const PlaybackOverlayPreferenceValues();

  @override
  Future<PlaybackOverlayPreferenceValues> load() async => value;

  @override
  Future<void> save(PlaybackOverlayPreferenceValues values) async {
    value = values;
  }
}

P2pMediaPreferencesController _p2pPreferences() =>
    P2pMediaPreferencesController(store: _MemoryP2pPreferencesStore());

PlaybackOverlayPreferencesController _overlayPreferences() =>
    PlaybackOverlayPreferencesController(
      store: _MemoryOverlayPreferencesStore(),
    );

class _RecordingVideoPlayerController extends VideoPlayerController {
  _RecordingVideoPlayerController(VideoPlayerValue initialValue)
    : super.networkUrl(Uri.parse('https://example.com/video.mp4')) {
    value = initialValue;
  }

  final List<Duration> seekPositions = [];
  var playCalls = 0;
  var pauseCalls = 0;
  Object? nextPlayError;
  final List<double> volumes = [];
  final List<double> playbackSpeeds = [];

  @override
  Future<void> seekTo(Duration position) async {
    seekPositions.add(position);
    value = value.copyWith(position: position, isCompleted: false);
  }

  @override
  Future<void> play() async {
    playCalls++;
    if (nextPlayError case final error?) {
      nextPlayError = null;
      throw error;
    }
    value = value.copyWith(isPlaying: true, isCompleted: false);
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    value = value.copyWith(isPlaying: false);
  }

  @override
  Future<void> setVolume(double volume) async {
    volumes.add(volume);
    value = value.copyWith(volume: volume);
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    playbackSpeeds.add(speed);
    value = value.copyWith(playbackSpeed: speed);
  }
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('player controls stay visible in ${brightness.name} theme', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
          size: Size(1920, 1080),
        ),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 560,
              child: CustomVideoPlayer(
                volumePreferences: _volumePreferences(),
                subtitleSource: const _EmptySubtitleSource(),
                controller: controller,
                title: 'Video',
                interactionMode: VideoPlayerInteractionMode.desktop,
                subtitles: const {
                  'en': {'name': 'English'},
                },
                onSync: () {},
                onToggleFullScreen: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      for (final key in [
        const Key('desktop_volume_button'),
        const Key('playback_sync_button'),
        const Key('playback_subtitles_button'),
        const Key('playback_fullscreen_button'),
      ]) {
        final iconButton = tester.widget<IconButton>(
          find.descendant(
            of: find.byKey(key),
            matching: find.byType(IconButton),
          ),
        );
        expect(
          iconButton.style?.foregroundColor?.resolve(const {}),
          Colors.white,
        );
      }
    });
  }

  testWidgets('fullscreen changes orientation and restores system defaults', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
      ),
    );
    addTearDown(controller.dispose);

    Widget player(bool fullscreen) => MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CustomVideoPlayer(
        key: const Key('player'),
        volumePreferences: _volumePreferences(),
        subtitleSource: const _EmptySubtitleSource(),
        controller: controller,
        title: 'Video',
        isFullScreen: fullscreen,
      ),
    );

    await tester.pumpWidget(player(false));
    calls.clear();
    await tester.pumpWidget(player(true));
    await tester.pump();

    expect(
      calls.where(
        (call) => call.method == 'SystemChrome.setPreferredOrientations',
      ),
      isNotEmpty,
    );
    expect(
      calls.any(
        (call) =>
            call.method == 'SystemChrome.setPreferredOrientations' &&
            (call.arguments as List).contains(
              'DeviceOrientation.landscapeLeft',
            ),
      ),
      isTrue,
    );

    calls.clear();
    await tester.pumpWidget(player(false));
    await tester.pump();
    expect(
      calls.any(
        (call) =>
            call.method == 'SystemChrome.setPreferredOrientations' &&
            (call.arguments as List).isEmpty,
      ),
      isTrue,
    );
  });

  test('picture-in-picture selects a supported platform backend', () {
    expect(
      pictureInPictureBackendForPlatform(TargetPlatform.android),
      PictureInPictureBackend.android,
    );
    expect(
      pictureInPictureBackendForPlatform(TargetPlatform.iOS),
      PictureInPictureBackend.unavailable,
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
      PictureInPictureBackend.web,
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
    expect(visibility.showFullscreen, isTrue);
    expect(visibility.showVolume, isFalse);
    expect(visibility.showSync, isFalse);
    expect(visibility.showPlaybackRoute, isFalse);
    expect(visibility.showSpeed, isFalse);
    expect(visibility.showVideoDanmaku, isFalse);
    expect(visibility.showChatDanmaku, isFalse);
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
    expect(visibility.showVideoDanmaku, isTrue);
    expect(visibility.showChatDanmaku, isFalse);
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
    expect(
      livePlaybackPosition(
        playerPosition: const Duration(seconds: 12),
        liveStartedAt: 1785919599,
        now: DateTime.fromMillisecondsSinceEpoch(
          1785937599 * 1000,
          isUtc: true,
        ),
      ),
      const Duration(hours: 5),
    );
    expect(
      livePlaybackPosition(
        playerPosition: const Duration(seconds: 12),
        liveStartedAt: null,
        now: DateTime.fromMillisecondsSinceEpoch(1785937599 * 1000),
      ),
      const Duration(seconds: 12),
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

  testWidgets('progress slider seeks and reports the same millisecond target', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(seconds: 100),
        position: Duration(seconds: 10),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final reportedSeeks = <Duration>[];

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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              onUserSeek: reportedSeeks.add,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final slider = tester.widget<Slider>(
      find.descendant(
        of: find.byKey(const Key('playback_progress_slider')),
        matching: find.byType(Slider),
      ),
    );
    const targetMilliseconds = 73250.0;
    slider.onChangeStart!(targetMilliseconds);
    slider.onChanged!(targetMilliseconds);
    slider.onChangeEnd!(targetMilliseconds);
    await tester.pump();

    const target = Duration(milliseconds: 73250);
    expect(controller.seekPositions, [target]);
    expect(reportedSeeks, [target]);
  });

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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Live',
              isLive: true,
              canControlPlayback: true,
            ),
          ),
        ),
      ),
    );

    expect(byAppTooltip('Playback speed'), findsNothing);
  });

  testWidgets('autoplay mute is visible and clears on player interaction', (
    tester,
  ) async {
    final volumePreferences = _volumePreferences();
    final autoplay = BrowserAutoplayController(
      volumePreferences: volumePreferences,
      enabled: true,
    );
    addTearDown(autoplay.dispose);
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 12),
        isInitialized: true,
        size: Size(1920, 1080),
        volume: 0.65,
      ),
    )..nextPlayError = PlatformException(code: 'NotAllowedError');
    addTearDown(controller.dispose);
    await autoplay.play(controller);

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
              volumePreferences: volumePreferences,
              browserAutoplay: autoplay,
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('playback_autoplay_unmute')), findsOneWidget);
    expect(controller.value.volume, 0);

    await tester.tapAt(tester.getCenter(find.byType(CustomVideoPlayer)));
    await tester.pump();

    expect(find.byKey(const Key('playback_autoplay_unmute')), findsNothing);
    expect(controller.value.volume, 0.65);
  });

  testWidgets('desktop secondary click opens playback context menu', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 12),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    var loopEnabled = false;

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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              canChangePlayMode: true,
              onLoopPlaybackChanged: (enabled) async {
                loopEnabled = enabled;
                return true;
              },
              onShufflePlaybackChanged: (_) async => true,
              onReloadPlayback: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    Future<void> openMenu() async {
      final center = tester.getCenter(find.byType(CustomVideoPlayer));
      final mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      await mouse.addPointer(location: center);
      await mouse.down(center);
      await mouse.up();
      await mouse.removePointer();
      await tester.pumpAndSettle();
    }

    await openMenu();
    expect(find.text('Loop video'), findsOneWidget);
    expect(find.text('Shuffle playlist'), findsOneWidget);
    expect(find.text('Reload playback source'), findsOneWidget);
    expect(find.text('Copy debug information'), findsOneWidget);
    expect(find.text('Detailed playback statistics'), findsOneWidget);

    await tester.tap(find.text('Loop video'));
    await tester.pumpAndSettle();
    expect(loopEnabled, isTrue);

    await openMenu();
    await tester.tap(find.text('Detailed playback statistics'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('playback_detailed_statistics')),
      findsOneWidget,
    );
    expect(
      tester
          .getRect(find.byKey(const Key('playback_detailed_statistics')))
          .bottom,
      lessThanOrEqualTo(
        tester.getRect(find.byKey(const Key('playback_progress_slider'))).top,
      ),
    );

    await tester.tap(
      find.byKey(const Key('close_playback_detailed_statistics')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('playback_detailed_statistics')), findsNothing);
  });

  testWidgets('live playback context menu omits queue ordering actions', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration.zero,
        isInitialized: true,
        size: Size(1920, 1080),
      ),
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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Live',
              isLive: true,
              interactionMode: VideoPlayerInteractionMode.desktop,
              canChangePlayMode: true,
              onLoopPlaybackChanged: (_) async => true,
              onShufflePlaybackChanged: (_) async => true,
              onSync: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final center = tester.getCenter(find.byType(CustomVideoPlayer));
    final mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await mouse.addPointer(location: center);
    await mouse.down(center);
    await mouse.up();
    await mouse.removePointer();
    await tester.pumpAndSettle();

    expect(find.text('Loop video'), findsNothing);
    expect(find.text('Shuffle playlist'), findsNothing);
    expect(find.text('Reload live stream'), findsOneWidget);
    expect(find.text('Copy debug information'), findsOneWidget);
  });

  testWidgets(
    'playback context menu hides play mode actions without permission',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 12),
          isInitialized: true,
          size: Size(1920, 1080),
        ),
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
                volumePreferences: _volumePreferences(),
                subtitleSource: const _EmptySubtitleSource(),
                controller: controller,
                title: 'Video',
                interactionMode: VideoPlayerInteractionMode.desktop,
                canChangePlayMode: false,
                onLoopPlaybackChanged: (_) async => true,
                onShufflePlaybackChanged: (_) async => true,
                onReloadPlayback: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final center = tester.getCenter(find.byType(CustomVideoPlayer));
      final mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      await mouse.addPointer(location: center);
      await mouse.down(center);
      await mouse.up();
      await mouse.removePointer();
      await tester.pumpAndSettle();

      expect(find.text('Loop video'), findsNothing);
      expect(find.text('Shuffle playlist'), findsNothing);
      expect(find.text('Reload playback source'), findsOneWidget);
      expect(find.text('Copy debug information'), findsOneWidget);
      expect(find.text('Detailed playback statistics'), findsOneWidget);
    },
  );

  testWidgets('desktop volume slider stays interactive while hovered', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        volume: 0.5,
      ),
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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('desktop_volume_button'))),
    );
    await tester.pump();

    final slider = find.byKey(const Key('desktop_volume_slider'));
    expect(slider, findsOneWidget);
    expect(find.byType(Scrollbar), findsNothing);
    await mouse.moveTo(tester.getCenter(slider));
    await tester.pump(const Duration(seconds: 2));
    expect(slider, findsOneWidget);
    expect(find.byType(Scrollbar), findsNothing);

    await tester.tapAt(tester.getCenter(slider) - const Offset(0, 30));
    await tester.pump();

    expect(controller.volumes, isNotEmpty);
    expect(controller.value.volume, greaterThan(0.5));
    expect(tester.widget<Slider>(slider).value, greaterThan(0.5));
    expect(controller.seekPositions, isEmpty);

    final volumeBeforeDrag = controller.value.volume;
    await tester.drag(slider, const Offset(0, -24));
    await tester.pump();
    expect(controller.value.volume, isNot(closeTo(volumeBeforeDrag, 0.01)));
    expect(
      tester.widget<Slider>(slider).value,
      closeTo(controller.value.volume, 0.001),
    );

    await mouse.moveTo(const Offset(20, 20));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(slider, findsNothing);
  });

  testWidgets(
    'more actions open upward without moving the control bar and keep fullscreen last',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
          size: Size(1920, 1080),
        ),
      );
      addTearDown(controller.dispose);
      var freeModeEnabled = false;
      final pictureInPictureActive = ValueNotifier(false);
      addTearDown(pictureInPictureActive.dispose);
      final pictureInPictureChanges = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 400,
              child: CustomVideoPlayer(
                volumePreferences: _volumePreferences(),
                subtitleSource: const _EmptySubtitleSource(),
                controller: controller,
                title: 'Video',
                interactionMode: VideoPlayerInteractionMode.desktop,
                onFreeModeChanged: (enabled) => freeModeEnabled = enabled,
                pictureInPictureActive: pictureInPictureActive,
                onPictureInPictureChanged: (active) {
                  pictureInPictureChanges.add(active);
                  pictureInPictureActive.value = active;
                },
                onToggleFullScreen: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final overflow = find.byKey(const Key('playback_overflow_button'));
      final fullscreen = find.byKey(const Key('playback_fullscreen_button'));
      expect(overflow, findsOneWidget);
      expect(fullscreen, findsOneWidget);
      expect(
        tester.getRect(overflow).right,
        lessThanOrEqualTo(tester.getRect(fullscreen).left),
      );
      expect(
        tester
            .widget<Icon>(
              find.descendant(of: overflow, matching: find.byType(Icon)),
            )
            .icon,
        Icons.settings_rounded,
      );
      expect(find.byKey(const Key('free_mode_settings_button')), findsNothing);

      final progressTop = tester
          .getRect(find.byKey(const Key('playback_progress_slider')))
          .top;
      await tester.tap(overflow);
      await tester.pumpAndSettle();

      final menu = find.byKey(const Key('playback_overflow_controls'));
      expect(menu, findsOneWidget);
      expect(find.byKey(const Key('free_mode_toggle')), findsOneWidget);
      expect(tester.getRect(menu).bottom, lessThanOrEqualTo(progressTop));
      expect(
        tester.getRect(find.byKey(const Key('playback_progress_slider'))).top,
        progressTop,
      );

      final videoDanmakuRow = find.byKey(
        const ValueKey('playback_overflow_control_slot_2'),
      );
      final chatDanmakuRow = find.byKey(
        const ValueKey('playback_overflow_control_slot_3'),
      );
      final pictureInPictureRow = find.byKey(
        const ValueKey('playback_overflow_control_slot_4'),
      );
      Switch switchIn(Finder row) => tester.widget<Switch>(
        find.descendant(of: row, matching: find.byType(Switch)),
      );

      expect(find.text('Video danmaku'), findsOneWidget);
      expect(find.text('Chat danmaku'), findsOneWidget);
      expect(switchIn(videoDanmakuRow).value, isTrue);
      expect(switchIn(chatDanmakuRow).value, isTrue);
      expect(
        find.descendant(of: pictureInPictureRow, matching: find.byType(Switch)),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('free_mode_toggle')));
      await tester.pump();
      expect(freeModeEnabled, isTrue);

      await tester.tap(find.text('Video danmaku'));
      await tester.pump();
      expect(menu, findsOneWidget);
      expect(switchIn(videoDanmakuRow).value, isFalse);
      expect(switchIn(chatDanmakuRow).value, isTrue);

      await tester.tap(find.text('Picture in picture'));
      await tester.pumpAndSettle();
      expect(pictureInPictureChanges, [isTrue]);
      expect(menu, findsNothing);

      await tester.tap(overflow);
      await tester.pumpAndSettle();
      expect(switchIn(pictureInPictureRow).value, isTrue);
      await tester.tap(find.text('Picture in picture'));
      await tester.pumpAndSettle();
      expect(pictureInPictureChanges, [isTrue, isFalse]);
      expect(menu, findsNothing);
    },
  );

  testWidgets('more actions stack hidden controls into labeled rows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 400,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              onFreeModeChanged: (_) {},
              onPictureInPictureChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('playback_overflow_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mute'), findsOneWidget);
    expect(find.text('Playback speed'), findsOneWidget);
    expect(find.text('Video danmaku'), findsOneWidget);
    expect(find.text('Chat danmaku'), findsOneWidget);
    expect(find.text('Picture in picture'), findsOneWidget);

    final rows = [
      for (var index = 0; index < 5; index++)
        tester.getRect(
          find.byKey(ValueKey('playback_overflow_control_slot_$index')),
        ),
    ];
    expect(rows.map((row) => row.left).toSet(), hasLength(1));
    expect(rows[2].height, 52);
    expect(rows[3].height, 52);
    expect(rows[4].height, 52);
    final iconLefts = [
      for (var index = 0; index < rows.length; index++)
        tester
            .getRect(
              find
                  .descendant(
                    of: find.byKey(
                      ValueKey('playback_overflow_control_slot_$index'),
                    ),
                    matching: find.byType(Icon),
                  )
                  .first,
            )
            .left,
    ];
    expect(iconLefts.toSet(), hasLength(1));
    for (var index = 1; index < rows.length; index++) {
      expect(rows[index].top, greaterThan(rows[index - 1].bottom));
    }
  });

  testWidgets('subtitle selection and subtitle style are separate controls', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final overlay = _overlayPreferences();

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 400,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              overlayPreferences: overlay,
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              subtitles: const {
                'en': {'name': 'English'},
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('playback_overflow_button')));
    await tester.pumpAndSettle();

    expect(find.text('Subtitles'), findsOneWidget);
    expect(find.text('Subtitle settings'), findsOneWidget);
    expect(find.text('Video danmaku settings'), findsNothing);
    expect(find.text('Chat danmaku settings'), findsNothing);

    await tester.tap(find.text('Subtitle settings'));
    await tester.pumpAndSettle();
    expect(find.text('Subtitle style'), findsOneWidget);
    expect(find.text('Video danmaku style'), findsNothing);
    expect(find.text('Chat danmaku style'), findsNothing);
  });

  testWidgets('danmaku settings expose independent controls', (tester) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final overlay = _overlayPreferences();
    final danmaku = DanmakuController(const _EmptyDanmakuSource())
      ..videoController = controller;
    addTearDown(danmaku.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 400,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              overlayPreferences: overlay,
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              danmakuController: danmaku,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('playback_overflow_button')));
    await tester.pumpAndSettle();

    expect(find.text('Video danmaku settings'), findsOneWidget);
    expect(find.text('Chat danmaku settings'), findsOneWidget);
    await tester.tap(find.text('Video danmaku settings'));
    await tester.pumpAndSettle();
    expect(find.text('Video danmaku style'), findsOneWidget);
    expect(find.text('Chat danmaku style'), findsNothing);
    expect(find.text('Danmaku size'), findsOneWidget);
    expect(find.text('Danmaku opacity'), findsOneWidget);
    expect(find.text('Danmaku speed'), findsOneWidget);
    expect(find.text('Danmaku area'), findsOneWidget);
    expect(find.text('Massive danmaku'), findsOneWidget);
  });

  testWidgets('danmaku layers keep a stable shared item list', (tester) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final danmaku = DanmakuController(const _EmptyDanmakuSource())
      ..videoController = controller
      ..addItems(const [
        DanmakuItem(
          text: 'video comment',
          startTime: Duration.zero,
          endTime: Duration(seconds: 8),
          color: Colors.white,
        ),
        DanmakuItem(
          text: 'room chat',
          startTime: Duration.zero,
          endTime: Duration(seconds: 8),
          color: Colors.white,
          origin: DanmakuOrigin.chat,
        ),
      ]);
    addTearDown(danmaku.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CustomVideoPlayer(
            volumePreferences: _volumePreferences(),
            overlayPreferences: _overlayPreferences(),
            subtitleSource: const _EmptySubtitleSource(),
            controller: controller,
            title: 'Video',
            interactionMode: VideoPlayerInteractionMode.desktop,
            danmakuController: danmaku,
          ),
        ),
      ),
    );
    await tester.pump();

    Iterable<DanmakuOverlay> layers() =>
        tester.widgetList<DanmakuOverlay>(find.byType(DanmakuOverlay));
    expect(layers().map((layer) => layer.origin), {
      DanmakuOrigin.video,
      DanmakuOrigin.chat,
    });
    expect(
      layers().every((layer) => identical(layer.danmakuList, danmaku.items)),
      isTrue,
    );

    controller.value = controller.value.copyWith(
      position: const Duration(seconds: 1),
    );
    await tester.pump();

    expect(
      layers().every((layer) => identical(layer.danmakuList, danmaku.items)),
      isTrue,
    );
  });

  testWidgets('P2P media toggle lives in more actions and persists changes', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final p2p = _p2pPreferences();

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 400,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              p2pMediaPreferences: p2p,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('playback_p2p_media_button')), findsNothing);
    await tester.tap(find.byKey(const Key('playback_overflow_button')));
    await tester.pumpAndSettle();

    final row = find.byKey(const ValueKey('playback_overflow_control_slot_4'));
    expect(find.text('P2P media delivery'), findsOneWidget);
    expect(
      find.descendant(of: row, matching: find.byType(Switch)),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Switch>(
            find.descendant(of: row, matching: find.byType(Switch)),
          )
          .value,
      isFalse,
    );

    await tester.tap(find.text('P2P media delivery'));
    await tester.pumpAndSettle();
    expect(p2p.enabled, isTrue);
    expect(find.byKey(const Key('playback_overflow_controls')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('P2P toggle closes more actions before the player is removed', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);
    final p2p = _p2pPreferences();
    final showPlayer = ValueNotifier(true);
    p2p.addListener(() => showPlayer.value = false);
    addTearDown(showPlayer.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: showPlayer,
            builder: (context, visible, _) => SizedBox(
              width: 300,
              height: 400,
              child: visible
                  ? CustomVideoPlayer(
                      volumePreferences: _volumePreferences(),
                      subtitleSource: const _EmptySubtitleSource(),
                      controller: controller,
                      title: 'Video',
                      interactionMode: VideoPlayerInteractionMode.desktop,
                      p2pMediaPreferences: p2p,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('playback_overflow_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('P2P media delivery'));
    await tester.pumpAndSettle();

    expect(p2p.enabled, isTrue);
    expect(find.byKey(const Key('playback_overflow_controls')), findsNothing);
    expect(find.byKey(const Key('playback_overflow_button')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('playback route and more actions use shared control spacing', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
      ),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 680,
            height: 400,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              extraBottomWidget: const SizedBox.square(
                key: Key('playback_route_stub'),
                dimension: 40,
                child: Icon(Icons.route_rounded),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final route = tester.getRect(find.byKey(const Key('playback_route_stub')));
    final moreActions = tester.getRect(
      find.byKey(const Key('playback_overflow_button')),
    );
    expect(moreActions.left - route.right, closeTo(4, 0.01));
  });

  testWidgets('playback speed menu opens upward on desktop hover', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        isPlaying: true,
        size: Size(1920, 1080),
      ),
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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final speed = byAppTooltip('Playback speed 1.00x');
    expect(speed, findsOneWidget);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(speed));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    final option = find.byKey(const ValueKey('playback_speed_option_2.0'));
    final menu = find.byKey(const Key('playback_speed_menu_hover_region'));
    expect(option, findsOneWidget);
    expect(menu, findsOneWidget);
    expect(tester.getRect(option).bottom, lessThan(tester.getRect(speed).top));
    expect(
      tester.getRect(menu).bottom,
      closeTo(tester.getRect(speed).top, 0.01),
    );

    await mouse.moveTo(
      Offset(tester.getCenter(menu).dx, tester.getRect(menu).bottom - 1),
    );
    await tester.pump(const Duration(milliseconds: 1200));
    expect(option, findsOneWidget);

    for (var second = 1; second <= 3; second++) {
      controller.value = controller.value.copyWith(
        position: Duration(seconds: second),
      );
      await tester.pump(const Duration(milliseconds: 16));
      expect(option, findsOneWidget);
    }

    await mouse.moveTo(const Offset(10, 10));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(option, findsNothing);

    await tester.tap(speed);
    await tester.pump();
    expect(option, findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    expect(option, findsNothing);
  });

  testWidgets(
    'playback speed stays open while the pointer remains on the button',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
          size: Size(1920, 1080),
        ),
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
                volumePreferences: _volumePreferences(),
                subtitleSource: const _EmptySubtitleSource(),
                controller: controller,
                title: 'Video',
                interactionMode: VideoPlayerInteractionMode.desktop,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final speed = byAppTooltip('Playback speed 1.00x');
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);
      await mouse.addPointer();
      final speedCenter = tester.getCenter(speed);
      await mouse.moveTo(speedCenter);
      await tester.pump(const Duration(milliseconds: 120));
      final option = find.byKey(const ValueKey('playback_speed_option_2.0'));
      expect(option, findsOneWidget);

      await mouse.moveTo(speedCenter);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));
      expect(option, findsOneWidget);

      await mouse.moveTo(const Offset(10, 10));
      await tester.pump(const Duration(milliseconds: 350));
      expect(option, findsNothing);
    },
  );

  testWidgets('volume stays open while the pointer remains on the button', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        volume: 0.5,
      ),
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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _EmptySubtitleSource(),
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final button = find.byKey(const Key('desktop_volume_button'));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    final buttonCenter = tester.getCenter(button);
    await mouse.moveTo(buttonCenter);
    await tester.pump();
    final slider = find.byKey(const Key('desktop_volume_slider'));
    expect(slider, findsOneWidget);

    await mouse.moveTo(buttonCenter);
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 350));
    expect(slider, findsOneWidget);

    await mouse.moveTo(const Offset(10, 10));
    await tester.pump(const Duration(milliseconds: 350));
    expect(slider, findsNothing);
  });

  testWidgets(
    'playback refresh keeps downloaded subtitles and source changes use the latest URL',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
        ),
      );
      final source = _RecordingSubtitleSource();
      addTearDown(controller.dispose);

      Widget player(
        String subtitleUrl, {
        String identity = 'media-1|direct|0',
      }) => MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 900,
            height: 500,
            child: CustomVideoPlayer(
              volumePreferences: _volumePreferences(),
              subtitleSource: source,
              controller: controller,
              title: 'Video',
              interactionMode: VideoPlayerInteractionMode.desktop,
              playbackResourceIdentity: identity,
              subtitles: {
                'sub_0': {'name': 'English', 'url': subtitleUrl},
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(player('https://example.com/old.vtt'));
      await tester.pump();
      expect(source.requests, [Uri.parse('https://example.com/old.vtt')]);

      await tester.pumpWidget(player('https://example.com/refreshed.vtt'));
      await tester.pump();
      expect(source.requests, [Uri.parse('https://example.com/old.vtt')]);

      await tester.pumpWidget(
        player(
          'https://example.com/refreshed.vtt',
          identity: 'media-1|proxy|0',
        ),
      );
      await tester.pump();

      expect(source.requests, [
        Uri.parse('https://example.com/old.vtt'),
        Uri.parse('https://example.com/refreshed.vtt'),
      ]);
    },
  );

  testWidgets('renders Bilibili JSON subtitles', (tester) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
      ),
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
              volumePreferences: _volumePreferences(),
              subtitleSource: const _BilibiliJsonSubtitleSource(),
              controller: controller,
              title: 'Bilibili',
              interactionMode: VideoPlayerInteractionMode.desktop,
              subtitles: const {
                'sub_0': {
                  'name': 'Chinese',
                  'url': 'https://example.com/subtitle.json',
                  'format': 'json',
                },
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    controller.value = controller.value.copyWith(
      position: const Duration(seconds: 2),
    );
    await tester.pump();

    expect(find.text('Bilibili subtitle'), findsOneWidget);
  });

  testWidgets(
    'subtitle localization uses its own delivery and only reloads for a new swarm',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
        ),
      );
      final source = _RecordingSubtitleSource();
      addTearDown(controller.dispose);
      final localized = Uri.parse('http://127.0.0.1:43123/root');
      final deliveries = <P2pResourceDelivery>[];

      Widget player({required String url, required String swarmId}) =>
          MaterialApp(
            builder: buildThemedTestApp,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: CustomVideoPlayer(
                volumePreferences: _volumePreferences(),
                subtitleSource: source,
                controller: controller,
                title: 'Video',
                playbackResourceIdentity: 'media-1|direct|0',
                subtitles: {
                  'sub_0': {
                    'name': 'English',
                    'url': url,
                    'headers': {'Authorization': 'Bearer origin'},
                    'p2pDelivery': P2pResourceDelivery(
                      swarmId: swarmId,
                      swarmTicket: 'ticket-$url',
                    ),
                  },
                },
                resolveSubtitleResource: (url, headers, delivery) async {
                  deliveries.add(delivery);
                  return LocalizedPlaybackResource(uri: localized);
                },
              ),
            ),
          );

      await tester.pumpWidget(
        player(url: 'https://origin.example/first.vtt', swarmId: 'sm3_first'),
      );
      await tester.pump();
      expect(source.requests, [localized]);
      expect(source.requestHeaders.single, isEmpty);
      expect(deliveries.single.swarmId, 'sm3_first');

      await tester.pumpWidget(
        player(
          url: 'https://origin.example/refreshed.vtt',
          swarmId: 'sm3_first',
        ),
      );
      await tester.pump();
      expect(source.requests, [localized]);

      await tester.pumpWidget(
        player(
          url: 'https://origin.example/replaced.vtt',
          swarmId: 'sm3_second',
        ),
      );
      await tester.pump();
      expect(source.requests, [localized, localized]);
      expect(deliveries.last.swarmId, 'sm3_second');
    },
  );

  testWidgets('subtitle without P2P delivery loads its origin directly', (
    tester,
  ) async {
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
      ),
    );
    final source = _RecordingSubtitleSource();
    addTearDown(controller.dispose);
    var localizedCalls = 0;
    var p2pDeactivations = 0;
    final origin = Uri.parse('https://origin.example/subtitle.vtt');
    const originHeaders = {'Authorization': 'Bearer origin'};

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CustomVideoPlayer(
            volumePreferences: _volumePreferences(),
            subtitleSource: source,
            controller: controller,
            title: 'Video',
            playbackResourceIdentity: 'media-1|direct|0',
            subtitles: {
              'sub_0': {
                'name': 'English',
                'url': origin.toString(),
                'headers': originHeaders,
              },
            },
            resolveSubtitleResource: (url, headers, delivery) async {
              localizedCalls++;
              return LocalizedPlaybackResource(uri: Uri.parse(url));
            },
            onSubtitleP2pDeactivated: () => p2pDeactivations++,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(localizedCalls, 0);
    expect(p2pDeactivations, 1);
    expect(source.requests, [origin]);
    expect(source.requestHeaders, [originHeaders]);
  });

  testWidgets(
    'playback refresh replaces an in-flight subtitle request with the latest URL',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
        ),
      );
      final source = _ControlledSubtitleSource();
      addTearDown(controller.dispose);

      Widget player(String subtitleUrl) => MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CustomVideoPlayer(
            volumePreferences: _volumePreferences(),
            subtitleSource: source,
            controller: controller,
            title: 'Video',
            playbackResourceIdentity: 'media-1|direct|0',
            subtitles: {
              'sub_0': {'name': 'English', 'url': subtitleUrl},
            },
          ),
        ),
      );

      final oldUrl = Uri.parse('https://example.com/old.vtt');
      final latestUrl = Uri.parse('https://example.com/latest.vtt');
      await tester.pumpWidget(player(oldUrl.toString()));
      await tester.pump();
      await tester.pumpWidget(player(latestUrl.toString()));
      await tester.pump();

      expect(source.requests, [oldUrl, latestUrl]);
      source.documents[latestUrl]!.complete(
        Uint8List.fromList(
          'WEBVTT\n\n00:00:00.000 --> 00:00:10.000\nLatest'.codeUnits,
        ),
      );
      await tester.pump();
      source.documents[oldUrl]!.complete(
        Uint8List.fromList(
          'WEBVTT\n\n00:00:00.000 --> 00:00:10.000\nOld'.codeUnits,
        ),
      );
      await tester.pump();

      await tester.pumpWidget(player('https://example.com/newer-snapshot.vtt'));
      await tester.pump();
      expect(source.requests, [oldUrl, latestUrl]);
    },
  );

  testWidgets(
    'playback refresh retries a failed subtitle with the latest URL',
    (tester) async {
      final controller = _RecordingVideoPlayerController(
        const VideoPlayerValue(
          duration: Duration(minutes: 1),
          isInitialized: true,
        ),
      );
      final source = _ControlledSubtitleSource();
      addTearDown(controller.dispose);

      Widget player(String subtitleUrl) => MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CustomVideoPlayer(
            volumePreferences: _volumePreferences(),
            subtitleSource: source,
            controller: controller,
            title: 'Video',
            playbackResourceIdentity: 'media-1|direct|0',
            subtitles: {
              'sub_0': {'name': 'English', 'url': subtitleUrl},
            },
          ),
        ),
      );

      final failedUrl = Uri.parse('https://example.com/failed.vtt');
      final latestUrl = Uri.parse('https://example.com/latest.vtt');
      await tester.pumpWidget(player(failedUrl.toString()));
      await tester.pump();
      source.documents[failedUrl]!.complete(null);
      await tester.pump();

      await tester.pumpWidget(player(latestUrl.toString()));
      await tester.pump();
      expect(source.requests, [failedUrl, latestUrl]);
    },
  );

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
            volumePreferences: _volumePreferences(),
            subtitleSource: const _EmptySubtitleSource(),
            controller: controller,
            title: 'Video',
            interactionMode: VideoPlayerInteractionMode.desktop,
            onPictureInPictureChanged: (active) {
              expect(active, isTrue);
              invocationCount++;
            },
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

  testWidgets('picture-in-picture exposes volume and playback speed controls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 202));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = _RecordingVideoPlayerController(
      const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        size: Size(1920, 1080),
        volume: 0.25,
      ),
    );
    final danmakuController = DanmakuController(const _EmptyDanmakuSource());
    double? selectedSpeed;
    addTearDown(controller.dispose);
    addTearDown(danmakuController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PictureInPicturePlaybackSurface(
          controller: controller,
          danmakuController: danmakuController,
          emptyState: const SizedBox.shrink(),
          canControlPlayback: true,
          onPlaybackSpeedChanged: (speed) => selectedSpeed = speed,
        ),
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('picture_in_picture_surface'))),
    );
    await tester.pump();

    final volumeButton = find.byKey(
      const Key('picture_in_picture_volume_button'),
    );
    final speedButton = find.byKey(
      const Key('picture_in_picture_playback_speed_button'),
    );
    expect(volumeButton, findsOneWidget);
    expect(speedButton, findsOneWidget);

    await tester.tap(volumeButton);
    await tester.pumpAndSettle();
    final volumeSlider = find.byKey(
      const Key('picture_in_picture_volume_slider'),
    );
    expect(volumeSlider, findsOneWidget);
    await tester.tap(volumeSlider);
    await tester.pump();
    expect(controller.volumes, isNotEmpty);

    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('picture_in_picture_surface'))),
    );
    await tester.pump();
    await tester.tap(speedButton);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('picture_in_picture_speed_options_list')),
      findsOneWidget,
    );
    expect(find.byType(Scrollbar), findsNothing);
    await tester.tap(
      find.byKey(const ValueKey('picture_in_picture_speed_option_1.5')),
    );
    await tester.pumpAndSettle();

    expect(controller.playbackSpeeds, [1.5]);
    expect(selectedSpeed, 1.5);

    await mouse.moveTo(
      tester.getCenter(find.byKey(const Key('picture_in_picture_surface'))),
    );
    await tester.pump();
    await tester.tap(speedButton);
    await tester.pumpAndSettle();
    final speedList = find.byKey(
      const Key('picture_in_picture_speed_options_list'),
    );
    final speedListCenter = tester.getCenter(speedList);
    await tester.sendEventToBinding(
      PointerScrollEvent(
        position: speedListCenter,
        scrollDelta: const Offset(0, 100),
      ),
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('picture_in_picture_speed_option_0.5')),
      findsOneWidget,
    );
  });

  testWidgets('picture-in-picture keeps an empty playback surface mounted', (
    tester,
  ) async {
    final danmakuController = DanmakuController(const _EmptyDanmakuSource());
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
