import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';

final class SharedPreferencesPlayerVolumeStore
    implements PlayerVolumePreferencesStore {
  const SharedPreferencesPlayerVolumeStore();

  static const String _volumeKey = 'synctv.player.volume';
  static const String _lastAudibleVolumeKey =
      'synctv.player.last_audible_volume';

  @override
  Future<PlayerVolumePreferenceValues> load() async {
    final preferences = await SharedPreferences.getInstance();
    final volume = preferences.get(_volumeKey);
    final lastAudibleVolume = preferences.get(_lastAudibleVolumeKey);
    return PlayerVolumePreferenceValues(
      volume: volume is num ? volume.toDouble() : 1,
      lastAudibleVolume: lastAudibleVolume is num
          ? lastAudibleVolume.toDouble()
          : 1,
    );
  }

  @override
  Future<void> save(PlayerVolumePreferenceValues values) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setDouble(_volumeKey, values.volume),
      preferences.setDouble(_lastAudibleVolumeKey, values.lastAudibleVolume),
    ]);
  }
}
