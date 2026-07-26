import 'package:flutter/foundation.dart';

abstract interface class RealtimeEventLogPreferencesStore {
  Future<RealtimeEventLogPreferenceValues> load();

  Future<void> saveMaxEntries(int value);

  Future<void> saveGrouped(bool value);
}

@immutable
final class RealtimeEventLogPreferenceValues {
  const RealtimeEventLogPreferenceValues({this.maxEntries, this.grouped});

  final int? maxEntries;
  final bool? grouped;
}

final class RealtimeEventLogPreferencesController {
  RealtimeEventLogPreferencesController({required this.store});

  static const int defaultMaxEntries = 100;
  static const int minMaxEntries = 20;
  static const int maxMaxEntries = 2000;

  final RealtimeEventLogPreferencesStore store;
  final ValueNotifier<int> maxEntries = ValueNotifier<int>(defaultMaxEntries);
  final ValueNotifier<bool> grouped = ValueNotifier<bool>(false);

  Future<void>? _loading;

  Future<void> load() {
    return _loading ??= store.load().then((values) {
      maxEntries.value = normalizeMaxEntries(
        values.maxEntries ?? defaultMaxEntries,
      );
      grouped.value = values.grouped ?? false;
    });
  }

  int normalizeMaxEntries(int value) {
    return value.clamp(minMaxEntries, maxMaxEntries).toInt();
  }

  Future<void> setMaxEntries(int value) async {
    final normalized = normalizeMaxEntries(value);
    maxEntries.value = normalized;
    await store.saveMaxEntries(normalized);
  }

  Future<void> setGrouped(bool value) async {
    grouped.value = value;
    await store.saveGrouped(value);
  }
}
