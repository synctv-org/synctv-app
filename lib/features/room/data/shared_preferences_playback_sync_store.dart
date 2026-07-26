import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/application/playback_sync_preferences_controller.dart';
import 'package:synctv_app/features/room/domain/playback_sync_config.dart';

final class SharedPreferencesPlaybackSyncStore
    implements PlaybackSyncPreferencesStore {
  const SharedPreferencesPlaybackSyncStore();

  static const _key = 'synctv.playback.sync.config';

  @override
  Future<PlaybackSyncConfig> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null || raw.isEmpty) return PlaybackSyncConfig.defaults;
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, Object?>) {
      return PlaybackSyncConfig.defaults;
    }
    return PlaybackSyncConfig.fromJson(decoded);
  }

  @override
  Future<void> save(PlaybackSyncConfig config) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(config.normalized().toJson()));
  }
}
