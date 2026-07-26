import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/room/domain/playback_sync_config.dart';

abstract interface class PlaybackSyncPreferencesStore {
  Future<PlaybackSyncConfig> load();

  Future<void> save(PlaybackSyncConfig config);
}

final class PlaybackSyncPreferencesController extends ChangeNotifier {
  PlaybackSyncPreferencesController({required this._store});

  final PlaybackSyncPreferencesStore _store;
  PlaybackSyncConfig _value = PlaybackSyncConfig.defaults;
  Future<void>? _loading;
  bool _loaded = false;

  PlaybackSyncConfig get value => _value;

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

  Future<void> update(PlaybackSyncConfig config) async {
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
