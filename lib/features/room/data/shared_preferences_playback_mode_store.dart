import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';

final class SharedPreferencesPlaybackModeStore
    implements PlaybackModePreferencesStore {
  const SharedPreferencesPlaybackModeStore();

  static const _key = 'synctv.playback.free-mode.config';

  @override
  Future<PlaybackModeConfig> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null || raw.isEmpty) return PlaybackModeConfig.defaults;
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      return PlaybackModeConfig.defaults;
    }
    return PlaybackModeConfig.fromJson(decoded);
  }

  @override
  Future<void> save(PlaybackModeConfig config) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(config.normalized().toJson()));
  }
}
