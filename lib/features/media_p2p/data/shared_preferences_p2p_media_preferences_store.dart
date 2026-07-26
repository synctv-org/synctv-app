import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

class SharedPreferencesP2pMediaPreferencesStore
    implements P2pMediaPreferencesStore {
  const SharedPreferencesP2pMediaPreferencesStore();

  static const _enabledKey = 'playback.p2p_media_enabled';
  static const _securityModeKey = 'playback.p2p_media_security_mode';
  static const _cacheSizeMiBKey = 'playback.p2p_media_cache_size_mib';

  @override
  Future<P2pMediaPreferenceValues> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedCacheSize = preferences.getInt(_cacheSizeMiBKey);
    return P2pMediaPreferenceValues(
      enabled: preferences.getBool(_enabledKey) ?? false,
      securityMode: P2pMediaSecurityMode.values.firstWhere(
        (mode) => mode.name == preferences.getString(_securityModeKey),
        orElse: () => P2pMediaSecurityMode.standard,
      ),
      cacheSizeMiB:
          P2pMediaPreferenceValues.cacheSizeOptionsMiB.contains(storedCacheSize)
          ? storedCacheSize!
          : P2pMediaPreferenceValues.defaultCacheSizeMiB,
    );
  }

  @override
  Future<void> save(P2pMediaPreferenceValues values) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.wait([
      preferences.setBool(_enabledKey, values.enabled),
      preferences.setString(_securityModeKey, values.securityMode.name),
      preferences.setInt(_cacheSizeMiBKey, values.cacheSizeMiB),
    ]);
  }
}
