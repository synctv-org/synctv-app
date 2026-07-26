import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';

final class _PlayerVolumeStore implements PlayerVolumePreferencesStore {
  _PlayerVolumeStore({this.values = const PlayerVolumePreferenceValues()});

  PlayerVolumePreferenceValues values;
  bool failSave = false;

  @override
  Future<PlayerVolumePreferenceValues> load() async => values;

  @override
  Future<void> save(PlayerVolumePreferenceValues values) async {
    if (failSave) throw StateError('save failed');
    this.values = values;
  }
}

final class _RealtimeLogStore implements RealtimeEventLogPreferencesStore {
  _RealtimeLogStore({this.values = const RealtimeEventLogPreferenceValues()});

  RealtimeEventLogPreferenceValues values;

  @override
  Future<RealtimeEventLogPreferenceValues> load() async => values;

  @override
  Future<void> saveGrouped(bool value) async {
    values = RealtimeEventLogPreferenceValues(
      maxEntries: values.maxEntries,
      grouped: value,
    );
  }

  @override
  Future<void> saveMaxEntries(int value) async {
    values = RealtimeEventLogPreferenceValues(
      maxEntries: value,
      grouped: values.grouped,
    );
  }
}

void main() {
  test('player volume preferences normalize loaded values', () async {
    final store = _PlayerVolumeStore(
      values: const PlayerVolumePreferenceValues(
        volume: 2,
        lastAudibleVolume: 0,
      ),
    );
    final controller = PlayerVolumePreferencesController(store: store);

    await controller.load();

    expect(controller.value.volume, 1);
    expect(controller.value.lastAudibleVolume, 1);
  });

  test('player volume preferences roll back a failed save', () async {
    final store = _PlayerVolumeStore(
      values: const PlayerVolumePreferenceValues(
        volume: 0.8,
        lastAudibleVolume: 0.8,
      ),
    );
    final controller = PlayerVolumePreferencesController(store: store);
    await controller.load();
    store.failSave = true;

    await expectLater(
      controller.save(volume: 0.2, lastAudibleVolume: 0.6),
      throwsStateError,
    );

    expect(controller.value.volume, 0.8);
    expect(controller.value.lastAudibleVolume, 0.8);
  });

  test('realtime log preferences normalize and persist values', () async {
    final store = _RealtimeLogStore(
      values: const RealtimeEventLogPreferenceValues(
        maxEntries: 1,
        grouped: false,
      ),
    );
    final controller = RealtimeEventLogPreferencesController(store: store);

    await controller.load();
    await controller.setMaxEntries(10_000);
    await controller.setGrouped(true);

    expect(
      controller.maxEntries.value,
      RealtimeEventLogPreferencesController.maxMaxEntries,
    );
    expect(controller.grouped.value, isTrue);
    expect(
      store.values.maxEntries,
      RealtimeEventLogPreferencesController.maxMaxEntries,
    );
    expect(store.values.grouped, isTrue);
  });
}
