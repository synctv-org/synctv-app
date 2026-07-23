import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum P2pMediaSecurityMode { standard, sampledOrigin }

class P2pMediaPreferences {
  static const String _enabledKey = 'playback.p2p_media_enabled';
  static const String _securityModeKey = 'playback.p2p_media_security_mode';
  static const String _cacheSizeMiBKey = 'playback.p2p_media_cache_size_mib';
  static const int defaultCacheSizeMiB = 128;
  static const List<int> cacheSizeOptionsMiB = [64, 128, 256, 512, 1024];
  static final ValueNotifier<bool> enabled = ValueNotifier(false);
  static final ValueNotifier<P2pMediaSecurityMode> securityMode = ValueNotifier(
    P2pMediaSecurityMode.standard,
  );
  static final ValueNotifier<int> cacheSizeMiB = ValueNotifier(
    defaultCacheSizeMiB,
  );
  static Future<void>? _loading;
  static bool _loaded = false;

  static Future<void> load() {
    if (_loaded) return Future.value();
    return _loading ??= SharedPreferences.getInstance()
        .then((preferences) {
          enabled.value = preferences.getBool(_enabledKey) ?? false;
          securityMode.value = P2pMediaSecurityMode.values.firstWhere(
            (mode) => mode.name == preferences.getString(_securityModeKey),
            orElse: () => P2pMediaSecurityMode.standard,
          );
          final storedCacheSize = preferences.getInt(_cacheSizeMiBKey);
          cacheSizeMiB.value = cacheSizeOptionsMiB.contains(storedCacheSize)
              ? storedCacheSize!
              : defaultCacheSizeMiB;
          _loaded = true;
        })
        .whenComplete(() => _loading = null);
  }

  static Future<void> setEnabled(bool value) async {
    enabled.value = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_enabledKey, value);
    _loaded = true;
  }

  static Future<void> setSecurityMode(P2pMediaSecurityMode value) async {
    securityMode.value = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_securityModeKey, value.name);
    _loaded = true;
  }

  static Future<void> setCacheSizeMiB(int value) async {
    if (!cacheSizeOptionsMiB.contains(value)) {
      throw ArgumentError.value(value, 'value', 'Unsupported cache size');
    }
    cacheSizeMiB.value = value;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_cacheSizeMiBKey, value);
    _loaded = true;
  }
}
