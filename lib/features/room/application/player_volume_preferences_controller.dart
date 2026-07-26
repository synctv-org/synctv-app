import 'package:flutter/foundation.dart';

abstract interface class PlayerVolumePreferencesStore {
  Future<PlayerVolumePreferenceValues> load();

  Future<void> save(PlayerVolumePreferenceValues values);
}

@immutable
final class PlayerVolumePreferenceValues {
  const PlayerVolumePreferenceValues({
    this.volume = 1,
    this.lastAudibleVolume = 1,
  });

  final double volume;
  final double lastAudibleVolume;

  PlayerVolumePreferenceValues normalized() {
    final normalizedVolume = volume.isFinite
        ? volume.clamp(0.0, 1.0).toDouble()
        : 1.0;
    final normalizedAudible =
        lastAudibleVolume.isFinite && lastAudibleVolume > 0.01
        ? lastAudibleVolume.clamp(0.0, 1.0).toDouble()
        : 1.0;
    return PlayerVolumePreferenceValues(
      volume: normalizedVolume,
      lastAudibleVolume: normalizedAudible,
    );
  }
}

final class PlayerVolumePreferencesController extends ChangeNotifier {
  PlayerVolumePreferencesController({required this.store});

  final PlayerVolumePreferencesStore store;
  PlayerVolumePreferenceValues _value = const PlayerVolumePreferenceValues();

  PlayerVolumePreferenceValues get value => _value;

  Future<void> load() async {
    _value = (await store.load()).normalized();
    notifyListeners();
  }

  Future<void> save({
    required double volume,
    required double lastAudibleVolume,
  }) async {
    final previous = _value;
    final next = PlayerVolumePreferenceValues(
      volume: volume,
      lastAudibleVolume: lastAudibleVolume,
    ).normalized();
    _value = next;
    notifyListeners();
    try {
      await store.save(next);
    } catch (_) {
      _value = previous;
      notifyListeners();
      rethrow;
    }
  }
}
