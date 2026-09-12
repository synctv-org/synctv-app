class SyncTvMemoryCache {
  SyncTvMemoryCache({DateTime Function()? clock, int maxEntries = 256})
    : _clock = clock ?? DateTime.now,
      _maxEntries = maxEntries {
    if (maxEntries < 1) {
      throw ArgumentError.value(maxEntries, 'maxEntries', 'Must be positive');
    }
  }

  final DateTime Function() _clock;
  final int _maxEntries;
  final Map<String, _CacheEntry<Object?>> _entries = {};
  final Map<String, Future<Object?>> _inFlight = {};

  Future<T> get<T>(
    String key, {
    required Duration ttl,
    required Future<T> Function() loader,
    bool refresh = false,
  }) async {
    final now = _clock();
    _removeExpired(now);
    if (!refresh) {
      final cached = _entries.remove(key);
      if (cached != null) {
        _entries[key] = cached;
        return cached.value as T;
      }
      final pending = _inFlight[key];
      if (pending != null) return await pending as T;
    }

    late final Future<Object?> future;
    future = Future<T>.sync(loader).then<Object?>((value) {
      // Invalidated or superseded requests still resolve for their callers,
      // but must not repopulate the current cache.
      if (identical(_inFlight[key], future)) {
        _store(key, value, ttl);
      }
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
    _inFlight.remove(key);
    _store(key, value, ttl);
  }

  void _removeExpired(DateTime now) {
    _entries.removeWhere((_, entry) => !entry.expiresAt.isAfter(now));
  }

  void _store(String key, Object? value, Duration ttl) {
    final now = _clock();
    _removeExpired(now);
    _entries.remove(key);
    if (ttl <= Duration.zero) return;
    while (_entries.length >= _maxEntries) {
      _entries.remove(_entries.keys.first);
    }
    _entries[key] = _CacheEntry<Object?>(value, now.add(ttl));
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
