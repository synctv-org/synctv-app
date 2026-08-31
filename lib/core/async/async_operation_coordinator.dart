import 'dart:async';

typedef IsLatestOperation = bool Function();

class AsyncStateEpoch {
  Object _current = Object();

  Object capture() => _current;

  bool isCurrent(Object epoch) => identical(epoch, _current);

  void advance() {
    _current = Object();
  }
}

class LatestAsyncOperationCoordinator {
  int _generation = 0;
  Future<void>? _activeOperation;
  String? _activeKey;

  Future<void> run(
    String key,
    Future<void> Function(IsLatestOperation isLatest) operation,
  ) async {
    final activeOperation = _activeOperation;
    if (activeOperation != null && _activeKey == key) {
      await activeOperation;
      return;
    }

    final generation = ++_generation;
    late final Future<void> trackedOperation;
    trackedOperation =
        Future<void>.sync(() => operation(() => generation == _generation))
            .whenComplete(() {
              if (identical(_activeOperation, trackedOperation)) {
                _activeOperation = null;
                _activeKey = null;
              }
            });
    _activeOperation = trackedOperation;
    _activeKey = key;
    await trackedOperation;
  }

  void invalidate() {
    _generation++;
    _activeOperation = null;
    _activeKey = null;
  }
}

class SerialAsyncOperationCoordinator {
  Future<void> _tail = Future.value();

  Future<T> run<T>(Future<T> Function() operation) {
    final result = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        result.complete(await operation());
      } catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    });
    return result.future;
  }
}
