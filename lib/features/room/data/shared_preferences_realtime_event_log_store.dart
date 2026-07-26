import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';

final class SharedPreferencesRealtimeEventLogStore
    implements RealtimeEventLogPreferencesStore {
  const SharedPreferencesRealtimeEventLogStore();

  static const String _maxEntriesKey = 'realtime_event_log.max_entries';
  static const String _groupedKey = 'realtime_event_log.grouped';

  @override
  Future<RealtimeEventLogPreferenceValues> load() async {
    final preferences = await SharedPreferences.getInstance();
    return RealtimeEventLogPreferenceValues(
      maxEntries: preferences.getInt(_maxEntriesKey),
      grouped: preferences.getBool(_groupedKey),
    );
  }

  @override
  Future<void> saveGrouped(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_groupedKey, value);
  }

  @override
  Future<void> saveMaxEntries(int value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_maxEntriesKey, value);
  }
}
