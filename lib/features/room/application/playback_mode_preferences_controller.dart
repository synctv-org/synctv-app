import 'package:synctv_app/core/async/persisted_value_controller.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';

abstract interface class PlaybackModePreferencesStore {
  Future<PlaybackModeConfig> load();

  Future<void> save(PlaybackModeConfig config);
}

final class PlaybackModePreferencesController
    extends PersistedValueController<PlaybackModeConfig> {
  PlaybackModePreferencesController({
    required PlaybackModePreferencesStore store,
  }) : super(
         initialValue: PlaybackModeConfig.defaults,
         read: store.load,
         write: store.save,
         normalize: (value) => value.normalized(),
       );

  Future<void> update(PlaybackModeConfig config) => persist(config);
}
