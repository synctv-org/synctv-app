import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';

final class SharedPreferencesPlaybackOverlayStore
    implements PlaybackOverlayPreferencesStore {
  const SharedPreferencesPlaybackOverlayStore();

  static const _key = 'synctv.playback.overlay.preferences';

  @override
  Future<PlaybackOverlayPreferenceValues> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const PlaybackOverlayPreferenceValues();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return PlaybackOverlayPreferenceValues.fromJson(decoded);
      }
    } catch (_) {
      // A malformed preference falls back to the defaults.
    }
    return const PlaybackOverlayPreferenceValues();
  }

  @override
  Future<void> save(PlaybackOverlayPreferenceValues values) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(values.normalized().toJson()));
  }
}
