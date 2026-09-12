import 'package:synctv_app/core/async/persisted_value_controller.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

abstract interface class P2pMediaPreferencesStore {
  Future<P2pMediaPreferenceValues> load();
  Future<void> save(P2pMediaPreferenceValues values);
}

class P2pMediaPreferencesController
    extends PersistedValueController<P2pMediaPreferenceValues> {
  P2pMediaPreferencesController({required P2pMediaPreferencesStore store})
    : super(
        initialValue: const P2pMediaPreferenceValues(),
        read: store.load,
        write: store.save,
      );

  P2pMediaPreferenceValues get values => value;
  bool get enabled => value.enabled;
  P2pMediaSecurityMode get securityMode => value.securityMode;
  int get cacheSizeMiB => value.cacheSizeMiB;

  Future<void> setEnabled(bool value) {
    return persist(values.copyWith(enabled: value));
  }

  Future<void> setSecurityMode(P2pMediaSecurityMode value) {
    return persist(values.copyWith(securityMode: value));
  }

  Future<void> setCacheSizeMiB(int value) {
    if (!P2pMediaPreferenceValues.cacheSizeOptionsMiB.contains(value)) {
      throw ArgumentError.value(value, 'value', 'Unsupported cache size');
    }
    return persist(values.copyWith(cacheSizeMiB: value));
  }
}
