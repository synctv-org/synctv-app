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
    return PlayerVolumePreferenceValues(
      volume: preferences.getDouble(_volumeKey) ?? 1,
      lastAudibleVolume: preferences.getDouble(_lastAudibleVolumeKey) ?? 1,
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
