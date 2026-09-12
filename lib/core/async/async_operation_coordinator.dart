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
  ) {
    final activeOperation = _activeOperation;
    if (activeOperation != null && _activeKey == key) {
      return activeOperation;
    }

    final generation = ++_generation;
    final completion = Completer<void>();
    // Register before invoking callbacks, which may synchronously reenter.
    _activeOperation = completion.future;
    _activeKey = key;
    unawaited(_run(generation, completion, operation));
    return completion.future;
  }

  Future<void> _run(
    int generation,
    Completer<void> completion,
    Future<void> Function(IsLatestOperation isLatest) operation,
  ) async {
    try {
      await operation(() => generation == _generation);
      completion.complete();
    } catch (error, stackTrace) {
      completion.completeError(error, stackTrace);
    } finally {
      if (identical(_activeOperation, completion.future)) {
        _activeOperation = null;
        _activeKey = null;
      }
    }
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

class KeyedAsyncOperationCoordinator {
  final _active = <String, Completer<void>>{};

  Future<void> run(
    String key,
    Future<void> Function(IsLatestOperation isCurrent) operation,
  ) {
    final active = _active[key];
    if (active != null) return active.future;
    final completion = Completer<void>();
    _active[key] = completion;
    unawaited(_run(key, completion, operation));
    return completion.future;
  }

  Future<void> _run(
    String key,
    Completer<void> completion,
    Future<void> Function(IsLatestOperation isCurrent) operation,
  ) async {
    bool isCurrent() => identical(_active[key], completion);
    try {
      await operation(isCurrent);
      completion.complete();
    } catch (error, stackTrace) {
      completion.completeError(error, stackTrace);
    } finally {
      if (isCurrent()) _active.remove(key);
    }
  }

  void invalidate({String? key}) {
    if (key == null) {
      _active.clear();
    } else {
      _active.remove(key);
    }
  }
}
