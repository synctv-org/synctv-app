import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/browser_autoplay_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:video_player/video_player.dart';

final class _MemoryVolumeStore implements PlayerVolumePreferencesStore {
  _MemoryVolumeStore(this.value);

  PlayerVolumePreferenceValues value;
  var saveCalls = 0;

  @override
  Future<PlayerVolumePreferenceValues> load() async => value;

  @override
  Future<void> save(PlayerVolumePreferenceValues values) async {
    saveCalls++;
    value = values;
  }
}

final class _TestVideoController extends VideoPlayerController {
  _TestVideoController({double volume = 0.7})
    : super.networkUrl(Uri.parse('https://example.com/video.mp4')) {
    value = VideoPlayerValue(
      duration: const Duration(minutes: 1),
      isInitialized: true,
      volume: volume,
    );
  }

  final List<Object> playErrors = [];
  final List<double> volumes = [];
  var playCalls = 0;

  @override
  Future<void> play() async {
    playCalls++;
    if (playErrors.isNotEmpty) throw playErrors.removeAt(0);
    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> setVolume(double volume) async {
    volumes.add(volume);
    value = value.copyWith(volume: volume);
  }
}

void main() {
  group('BrowserAutoplayController', () {
    late _MemoryVolumeStore store;
    late PlayerVolumePreferencesController preferences;
    late BrowserAutoplayController autoplay;

    setUp(() async {
      store = _MemoryVolumeStore(
        const PlayerVolumePreferenceValues(volume: 0.7, lastAudibleVolume: 0.7),
      );
      preferences = PlayerVolumePreferencesController(store: store);
      await preferences.load();
      autoplay = BrowserAutoplayController(
        volumePreferences: preferences,
        enabled: true,
      );
    });

    tearDown(() => autoplay.dispose());

    test('retries NotAllowedError once with temporary mute', () async {
      final controller = _TestVideoController()
        ..playErrors.add(
          PlatformException(
            code: 'NotAllowedError',
            message: 'User activation is required.',
          ),
        );

      await autoplay.play(controller);

      expect(controller.playCalls, 2);
      expect(controller.volumes, [0]);
      expect(controller.value.isPlaying, isTrue);
      expect(autoplay.isTemporarilyMuted(controller), isTrue);
      expect(store.saveCalls, 0);
      expect(preferences.value.volume, 0.7);
    });

    test('restores the pre-fallback volume on user interaction', () async {
      final controller = _TestVideoController(volume: 0.42)
        ..playErrors.add(PlatformException(code: 'NotAllowedError'));
      await autoplay.play(controller);

      await autoplay.restoreForUserInteraction(controller);

      expect(controller.volumes, [0, 0.42]);
      expect(autoplay.isTemporarilyMuted(controller), isFalse);
      expect(store.saveCalls, 0);
    });

    test('does not mask media or network failures', () async {
      final controller = _TestVideoController()
        ..playErrors.add(PlatformException(code: 'MEDIA_ERR_NETWORK'));

      await expectLater(
        autoplay.play(controller),
        throwsA(
          isA<PlatformException>().having(
            (error) => error.code,
            'code',
            'MEDIA_ERR_NETWORK',
          ),
        ),
      );

      expect(controller.playCalls, 1);
      expect(controller.volumes, isEmpty);
      expect(autoplay.isTemporarilyMuted(controller), isFalse);
    });

    test('does not retry a denied play that is already muted', () async {
      final controller = _TestVideoController(volume: 0)
        ..playErrors.add(PlatformException(code: 'NotAllowedError'));

      await expectLater(
        autoplay.play(controller),
        throwsA(isA<PlatformException>()),
      );

      expect(controller.playCalls, 1);
      expect(controller.volumes, isEmpty);
    });

    test('detaching clears temporary state for a replaced player', () async {
      final oldController = _TestVideoController()
        ..playErrors.add(PlatformException(code: 'NotAllowedError'));
      final newController = _TestVideoController(volume: 0.35);
      await autoplay.play(oldController);

      autoplay.detach(oldController);
      await autoplay.applyPreferredVolume(newController);

      expect(autoplay.isTemporarilyMuted(oldController), isFalse);
      expect(newController.volumes, [0.7]);
    });
  });

  test('autoplay denial classification requires the browser error code', () {
    expect(
      isBrowserAutoplayDenied(PlatformException(code: 'NotAllowedError')),
      isTrue,
    );
    expect(
      isBrowserAutoplayDenied(
        PlatformException(
          code: 'media_error',
          message: 'NotAllowedError in a nested message',
        ),
      ),
      isFalse,
    );
  });
}
