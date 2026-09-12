import 'package:flutter/foundation.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';

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
  final _operations = SerialAsyncOperationCoordinator();
  bool _loaded = false;
  int _maxEntriesRevision = 0;
  int _groupedRevision = 0;
  int _persistedMaxEntries = defaultMaxEntries;
  bool _persistedGrouped = false;

  Future<void> load() {
    if (_loaded) return Future.value();
    final maxEntriesRevision = _maxEntriesRevision;
    final groupedRevision = _groupedRevision;
    return _loading ??= _operations
        .run(() async {
          final values = await store.load();
          _persistedMaxEntries = normalizeMaxEntries(
            values.maxEntries ?? defaultMaxEntries,
          );
          _persistedGrouped = values.grouped ?? false;
          _loaded = true;
          if (maxEntriesRevision == _maxEntriesRevision) {
            maxEntries.value = _persistedMaxEntries;
          }
          if (groupedRevision == _groupedRevision) {
            grouped.value = _persistedGrouped;
          }
        })
        .whenComplete(() => _loading = null);
  }

  int normalizeMaxEntries(int value) {
    return value.clamp(minMaxEntries, maxMaxEntries).toInt();
  }

  Future<void> setMaxEntries(int value) {
    final revision = ++_maxEntriesRevision;
    final normalized = normalizeMaxEntries(value);
    maxEntries.value = normalized;
    return _operations.run(() async {
      try {
        await store.saveMaxEntries(normalized);
        _persistedMaxEntries = normalized;
      } catch (_) {
        if (revision == _maxEntriesRevision) {
          maxEntries.value = _persistedMaxEntries;
        }
        rethrow;
      }
    });
  }

  Future<void> setGrouped(bool value) {
    final revision = ++_groupedRevision;
    grouped.value = value;
    return _operations.run(() async {
      try {
        await store.saveGrouped(value);
        _persistedGrouped = value;
      } catch (_) {
        if (revision == _groupedRevision) grouped.value = _persistedGrouped;
        rethrow;
      }
    });
  }
}
