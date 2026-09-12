import 'package:flutter/foundation.dart';
import 'package:synctv_app/core/async/persisted_value_controller.dart';

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

final class PlayerVolumePreferencesController
    extends PersistedValueController<PlayerVolumePreferenceValues> {
  PlayerVolumePreferencesController({required this.store})
    : super(
        initialValue: const PlayerVolumePreferenceValues(),
        read: store.load,
        write: store.save,
        normalize: (value) => value.normalized(),
      );

  final PlayerVolumePreferencesStore store;

  Future<void> save({
    required double volume,
    required double lastAudibleVolume,
  }) => persist(
    PlayerVolumePreferenceValues(
      volume: volume,
      lastAudibleVolume: lastAudibleVolume,
    ),
  );
}
