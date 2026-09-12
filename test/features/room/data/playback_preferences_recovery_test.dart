import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_mode_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_overlay_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_player_volume_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_realtime_event_log_store.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final raw in <Object>[42, '{broken', '[]', 'null', '']) {
    test('mode preferences recover from invalid document $raw', () async {
      SharedPreferences.setMockInitialValues({
        'synctv.playback.free-mode.config': raw,
      });
      final values = await const SharedPreferencesPlaybackModeStore().load();
      expect(values.toJson(), PlaybackModeConfig.defaults.toJson());
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.get('synctv.playback.free-mode.config'), raw);
    });
  }

  test('mode recovery preserves independently valid fields', () async {
    SharedPreferences.setMockInitialValues({
      'synctv.playback.free-mode.config': jsonEncode({
        'autoSeekDriftThresholdSeconds': 'invalid',
        'manualSeekDriftThresholdSeconds': 0.35,
        'freeModeEnabled': true,
      }),
    });
    final values = await const SharedPreferencesPlaybackModeStore().load();
    expect(values.autoSeekDriftThresholdSeconds, 1.2);
    expect(values.manualSeekDriftThresholdSeconds, 0.35);
    expect(values.freeModeEnabled, isTrue);
  });

  test('invalid manual threshold and flag preserve automatic threshold', () {
    final values = PlaybackModeConfig.fromJson({
      'autoSeekDriftThresholdSeconds': 3,
      'manualSeekDriftThresholdSeconds': false,
      'freeModeEnabled': 'false',
    });
    expect(
      values.toJson(),
      const PlaybackModeConfig(autoSeekDriftThresholdSeconds: 3).toJson(),
    );
  });

  for (final value in [double.nan, double.infinity, double.negativeInfinity]) {
    test('nonfinite mode threshold $value uses the default', () {
      final config = PlaybackModeConfig(
        autoSeekDriftThresholdSeconds: value,
        manualSeekDriftThresholdSeconds: value,
      ).normalized();
      expect(config.toJson(), PlaybackModeConfig.defaults.toJson());
      expect(() => jsonEncode(config.toJson()), returnsNormally);
    });
  }

  test('overflowing JSON numbers recover without maximum drift', () async {
    SharedPreferences.setMockInitialValues({
      'synctv.playback.free-mode.config': '{"autoSeekDriftThresholdSeconds":1e999,"manualSeekDriftThresholdSeconds":-1e999,"freeModeEnabled":true}',
    });
    final config = await const SharedPreferencesPlaybackModeStore().load();
    expect(config.autoSeekDriftThresholdSeconds, 1.2);
    expect(config.manualSeekDriftThresholdSeconds, 0.2);
    expect(config.freeModeEnabled, isTrue);
  });

  test('wrong overlay storage type recovers without deleting it', () async {
    SharedPreferences.setMockInitialValues({
      'synctv.playback.overlay.preferences': false,
    });
    final values = await const SharedPreferencesPlaybackOverlayStore().load();
    expect(values.subtitleFontSize, 18);
    expect(values.videoDanmakuEnabled, isTrue);
    expect(
      (await SharedPreferences.getInstance()).get(
        'synctv.playback.overlay.preferences',
      ),
      false,
    );
  });

  for (final invalidVolume in [true, false]) {
    test(
      'volume recovery preserves valid sibling, invalidVolume=$invalidVolume',
      () async {
        SharedPreferences.setMockInitialValues({
          'synctv.player.volume': invalidVolume ? 'invalid' : 0.4,
          'synctv.player.last_audible_volume': invalidVolume ? 0.7 : false,
        });
        final values = await const SharedPreferencesPlayerVolumeStore().load();
        expect(values.volume, invalidVolume ? 1 : 0.4);
        expect(values.lastAudibleVolume, invalidVolume ? 0.7 : 1);
      },
    );
  }

  for (final invalidLimit in [true, false]) {
    test(
      'log recovery preserves valid sibling, invalidLimit=$invalidLimit',
      () async {
        SharedPreferences.setMockInitialValues({
          'realtime_event_log.max_entries': invalidLimit ? 'invalid' : 150,
          'realtime_event_log.grouped': invalidLimit ? true : 1,
        });
        final values = await const SharedPreferencesRealtimeEventLogStore()
            .load();
        expect(values.maxEntries, invalidLimit ? null : 150);
        expect(values.grouped, invalidLimit ? true : null);
      },
    );
  }

  test('valid mode preferences remain writable after recovery', () async {
    SharedPreferences.setMockInitialValues({
      'synctv.playback.free-mode.config': '{broken',
    });
    const store = SharedPreferencesPlaybackModeStore();
    await store.load();
    const next = PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: 2.5,
      manualSeekDriftThresholdSeconds: 0.45,
      freeModeEnabled: true,
    );
    await store.save(next);
    expect((await store.load()).toJson(), next.toJson());
  });
}
