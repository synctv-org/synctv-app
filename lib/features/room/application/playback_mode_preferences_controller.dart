import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';

abstract interface class PlaybackModePreferencesStore {
  Future<PlaybackModeConfig> load();

  Future<void> save(PlaybackModeConfig config);
}

final class PlaybackModePreferencesController extends ChangeNotifier {
  PlaybackModePreferencesController({required this._store});

  final PlaybackModePreferencesStore _store;
  PlaybackModeConfig _value = PlaybackModeConfig.defaults;
  Future<void>? _loading;
  bool _loaded = false;

  PlaybackModeConfig get value => _value;

  Future<void> load() {
    if (_loaded) return Future.value();
    return _loading ??= _store
        .load()
        .then((value) {
          _value = value.normalized();
          _loaded = true;
          notifyListeners();
        })
        .whenComplete(() => _loading = null);
  }

  Future<void> update(PlaybackModeConfig config) async {
    final previous = _value;
    _value = config.normalized();
    _loaded = true;
    notifyListeners();
    try {
      await _store.save(_value);
    } catch (_) {
      _value = previous;
      notifyListeners();
      rethrow;
    }
  }
}
