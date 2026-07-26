import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

abstract interface class P2pMediaPreferencesStore {
  Future<P2pMediaPreferenceValues> load();
  Future<void> save(P2pMediaPreferenceValues values);
}

class P2pMediaPreferencesController extends ChangeNotifier {
  P2pMediaPreferencesController({required this._store});

  final P2pMediaPreferencesStore _store;
  P2pMediaPreferenceValues _values = const P2pMediaPreferenceValues();
  Future<void>? _loading;
  bool _loaded = false;

  P2pMediaPreferenceValues get values => _values;
  bool get enabled => _values.enabled;
  P2pMediaSecurityMode get securityMode => _values.securityMode;
  int get cacheSizeMiB => _values.cacheSizeMiB;

  Future<void> load() {
    if (_loaded) return Future.value();
    return _loading ??= _store
        .load()
        .then((values) {
          _values = values;
          _loaded = true;
          notifyListeners();
        })
        .whenComplete(() => _loading = null);
  }

  Future<void> setEnabled(bool value) {
    return _update(_values.copyWith(enabled: value));
  }

  Future<void> setSecurityMode(P2pMediaSecurityMode value) {
    return _update(_values.copyWith(securityMode: value));
  }

  Future<void> setCacheSizeMiB(int value) {
    if (!P2pMediaPreferenceValues.cacheSizeOptionsMiB.contains(value)) {
      throw ArgumentError.value(value, 'value', 'Unsupported cache size');
    }
    return _update(_values.copyWith(cacheSizeMiB: value));
  }

  Future<void> _update(P2pMediaPreferenceValues values) async {
    final previous = _values;
    _values = values;
    _loaded = true;
    notifyListeners();
    try {
      await _store.save(values);
    } catch (_) {
      _values = previous;
      notifyListeners();
      rethrow;
    }
  }
}
