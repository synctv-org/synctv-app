class PlaybackOperationResolution<T> {
  const PlaybackOperationResolution._({
    required this.handled,
    this.stateToApply,
  });

  const PlaybackOperationResolution.unhandled() : this._(handled: false);

  const PlaybackOperationResolution.handled([T? stateToApply])
    : this._(handled: true, stateToApply: stateToApply);

  final bool handled;
  final T? stateToApply;
}

class PlaybackOperationTracker<T> {
  PlaybackOperationTracker({this.retention = const Duration(minutes: 1)});

  final Duration retention;
  final Map<String, _PlaybackOperation<T>> _operations = {};
  String? _activeOperationId;

  void remember(String operationId, T previousState, {DateTime? now}) {
    final createdAt = now ?? DateTime.now();
    _removeExpired(createdAt);
    _operations[operationId] = _PlaybackOperation<T>(
      previousState: previousState,
      previousOperationId: _activeOperationId,
      createdAt: createdAt,
    );
    _activeOperationId = operationId;
  }

  PlaybackOperationResolution<T> acknowledge(
    String operationId,
    T authoritativeState, {
    DateTime? now,
  }) {
    _removeExpired(now ?? DateTime.now());
    final operation = _operations[operationId];
    if (operation == null) {
      return const PlaybackOperationResolution.unhandled();
    }
    if (operation.acknowledged) {
      return const PlaybackOperationResolution.handled();
    }
    operation.acknowledged = true;
    if (_activeOperationId == operationId) {
      _activeOperationId = null;
      return PlaybackOperationResolution.handled(authoritativeState);
    }
    final dependent = _dependentOperation(operationId);
    if (dependent != null) {
      dependent
        ..previousState = authoritativeState
        ..previousOperationId = operation.previousOperationId;
    }
    return const PlaybackOperationResolution.handled();
  }

  PlaybackOperationResolution<T> reject(String operationId, {DateTime? now}) {
    _removeExpired(now ?? DateTime.now());
    final operation = _operations.remove(operationId);
    if (operation == null || operation.acknowledged) {
      return const PlaybackOperationResolution.unhandled();
    }
    if (_activeOperationId == operationId) {
      _activeOperationId = operation.previousOperationId;
      return PlaybackOperationResolution.handled(operation.previousState);
    }
    final dependent = _dependentOperation(operationId);
    if (dependent != null) {
      dependent
        ..previousState = operation.previousState
        ..previousOperationId = operation.previousOperationId;
    }
    return const PlaybackOperationResolution.handled();
  }

  _PlaybackOperation<T>? _dependentOperation(String operationId) {
    for (final operation in _operations.values) {
      if (operation.previousOperationId == operationId) return operation;
    }
    return null;
  }

  void _removeExpired(DateTime now) {
    final expiredIds = _operations.entries
        .where((entry) => now.difference(entry.value.createdAt) > retention)
        .map((entry) => entry.key)
        .toSet();
    for (final operationId in expiredIds) {
      _operations.remove(operationId);
      if (_activeOperationId == operationId) _activeOperationId = null;
    }
  }
}

class _PlaybackOperation<T> {
  _PlaybackOperation({
    required this.previousState,
    required this.previousOperationId,
    required this.createdAt,
  });

  T previousState;
  String? previousOperationId;
  final DateTime createdAt;
  bool acknowledged = false;
}
