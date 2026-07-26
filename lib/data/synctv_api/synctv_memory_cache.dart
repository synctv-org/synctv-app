class SyncTvMemoryCache {
  SyncTvMemoryCache({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<String, _CacheEntry<Object?>> _entries = {};
  final Map<String, Future<Object?>> _inFlight = {};

  Future<T> get<T>(
    String key, {
    required Duration ttl,
    required Future<T> Function() loader,
    bool refresh = false,
  }) async {
    final now = _clock();
    if (!refresh) {
      final cached = _entries[key];
      if (cached != null && cached.expiresAt.isAfter(now)) {
        return cached.value as T;
      }
      final pending = _inFlight[key];
      if (pending != null) return await pending as T;
    }

    final future = loader().then<Object?>((value) {
      _entries[key] = _CacheEntry<Object?>(value, _clock().add(ttl));
      return value;
    });
    _inFlight[key] = future;
    try {
      return await future as T;
    } finally {
      if (identical(_inFlight[key], future)) {
        _inFlight.remove(key);
      }
    }
  }

  void put<T>(String key, T value, {required Duration ttl}) {
    _entries[key] = _CacheEntry<Object?>(value, _clock().add(ttl));
  }

  void invalidate(String key) {
    _entries.remove(key);
    _inFlight.remove(key);
  }

  void invalidatePrefix(String prefix) {
    _entries.removeWhere((key, _) => key.startsWith(prefix));
    _inFlight.removeWhere((key, _) => key.startsWith(prefix));
  }

  void clear() {
    _entries.clear();
    _inFlight.clear();
  }
}

class _CacheEntry<T> {
  final T value;
  final DateTime expiresAt;

  const _CacheEntry(this.value, this.expiresAt);
}
