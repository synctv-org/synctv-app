import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'player_volume_preferences_controller.dart';

bool isBrowserAutoplayDenied(Object error) =>
    error is PlatformException && error.code == 'NotAllowedError';

final class BrowserAutoplayController extends ChangeNotifier {
  BrowserAutoplayController({required this.volumePreferences, bool? enabled})
    : enabled = enabled ?? kIsWeb;

  final PlayerVolumePreferencesController volumePreferences;
  final bool enabled;

  VideoPlayerController? _mutedController;
  double _restoreVolume = 1;
  int _generation = 0;

  bool isTemporarilyMuted(VideoPlayerController controller) =>
      identical(_mutedController, controller);

  Future<void> applyPreferredVolume(VideoPlayerController controller) =>
      controller.setVolume(
        isTemporarilyMuted(controller) ? 0 : volumePreferences.value.volume,
      );

  Future<void> play(VideoPlayerController controller) async {
    try {
      await controller.play();
      return;
    } on Object catch (error) {
      final volume = controller.value.volume;
      if (!enabled ||
          !isBrowserAutoplayDenied(error) ||
          !volume.isFinite ||
          volume <= 0.01) {
        rethrow;
      }

      final generation = ++_generation;
      _mutedController = controller;
      _restoreVolume = volume.clamp(0.0, 1.0).toDouble();
      notifyListeners();
      try {
        await controller.setVolume(0);
        if (!_isCurrent(controller, generation)) return;
        await controller.play();
      } on Object {
        if (_isCurrent(controller, generation)) {
          _clearTemporaryMute();
          try {
            await controller.setVolume(_restoreVolume);
          } on Object {
            // The controller may have been replaced while the retry failed.
          }
        }
        rethrow;
      }
    }
  }

  Future<void> restoreForUserInteraction(
    VideoPlayerController controller,
  ) async {
    if (!isTemporarilyMuted(controller)) return;
    final volume = _restoreVolume;
    _clearTemporaryMute();
    await controller.setVolume(volume);
  }

  void detach(VideoPlayerController controller) {
    if (isTemporarilyMuted(controller)) _clearTemporaryMute();
  }

  bool _isCurrent(VideoPlayerController controller, int generation) =>
      identical(_mutedController, controller) && _generation == generation;

  void _clearTemporaryMute() {
    _generation++;
    _mutedController = null;
    notifyListeners();
  }
}
