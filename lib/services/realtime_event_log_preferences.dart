import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealtimeEventLogPreferences {
  static const int defaultMaxEntries = 100;
  static const int minMaxEntries = 20;
  static const int maxMaxEntries = 2000;
  static const String _maxEntriesKey = 'realtime_event_log.max_entries';
  static const String _groupedKey = 'realtime_event_log.grouped';

  static final ValueNotifier<int> maxEntries = ValueNotifier<int>(
    defaultMaxEntries,
  );
  static final ValueNotifier<bool> grouped = ValueNotifier<bool>(false);

  static bool _loaded = false;
  static Future<void>? _loading;

  static Future<void> load() {
    final loading = _loading;
    if (_loaded && loading == null) return Future.value();
    if (loading != null) return loading;

    _loading = SharedPreferences.getInstance()
        .then((prefs) {
          maxEntries.value = normalizeMaxEntries(
            prefs.getInt(_maxEntriesKey) ?? defaultMaxEntries,
          );
          grouped.value = prefs.getBool(_groupedKey) ?? false;
          _loaded = true;
        })
        .whenComplete(() => _loading = null);

    return _loading!;
  }

  static int normalizeMaxEntries(int value) {
    return value.clamp(minMaxEntries, maxMaxEntries).toInt();
  }

  static Future<void> setMaxEntries(int value) async {
    final normalized = normalizeMaxEntries(value);
    maxEntries.value = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxEntriesKey, normalized);
  }

  static Future<void> setGrouped(bool value) async {
    grouped.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_groupedKey, value);
  }
}
