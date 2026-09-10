import 'package:flutter/foundation.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';

/// Optimistic preferences with ordered persistence and durable rollback.
abstract class PersistedValueController<T> extends ChangeNotifier {
  PersistedValueController({
    required T initialValue,
    required this._read,
    required this._write,
    T Function(T)? normalize,
  }) : _value = initialValue,
       _persisted = initialValue,
       _normalize = normalize ?? ((value) => value);

  final Future<T> Function() _read;
  final Future<void> Function(T) _write;
  final T Function(T) _normalize;
  final _operations = SerialAsyncOperationCoordinator();
  T _value;
  T _persisted;
  Future<void>? _loading;
  int _revision = 0;
  bool _loaded = false;
  bool _disposed = false;

  T get value => _value;

  Future<void> load() {
    if (_loaded) return Future.value();
    final revision = _revision;
    return _loading ??= _operations
        .run(() async {
          final loaded = _normalize(await _read());
          _persisted = loaded;
          _loaded = true;
          if (revision == _revision) {
            _value = loaded;
            _notify();
          }
        })
        .whenComplete(() => _loading = null);
  }

  @protected
  Future<void> persist(T value) {
    final next = _normalize(value);
    final revision = ++_revision;
    _value = next;
    final result = _operations.run(() async {
      try {
        await _write(next);
        _persisted = next;
        _loaded = true;
      } catch (_) {
        if (revision == _revision) {
          _value = _persisted;
          _notify();
        }
        rethrow;
      }
    });
    _notify();
    return result;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
