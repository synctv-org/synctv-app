import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';

void main() {
  const ttl = Duration(minutes: 1);

  test('bounded cache evicts least recently read entries', () async {
    final cache = SyncTvMemoryCache(maxEntries: 2);
    cache.put('a', 'a', ttl: ttl);
    cache.put('b', 'b', ttl: ttl);
    expect(
      await cache.get('a', ttl: ttl, loader: () async => 'unexpected'),
      'a',
    );
    cache.put('c', 'c', ttl: ttl);
    expect(
      await cache.get('a', ttl: ttl, loader: () async => 'unexpected'),
      'a',
    );
    expect(
      await cache.get('b', ttl: ttl, loader: () async => 'reloaded'),
      'reloaded',
    );
  });

  test(
    'expired recently used entries are removed before live entries',
    () async {
      var now = DateTime.utc(2026);
      final cache = SyncTvMemoryCache(maxEntries: 2, clock: () => now);
      cache.put('live', 'live', ttl: ttl);
      cache.put('short', 'short', ttl: const Duration(seconds: 1));
      now = now.add(const Duration(seconds: 1));
      cache.put('new', 'new', ttl: ttl);
      expect(
        await cache.get('live', ttl: ttl, loader: () async => 'unexpected'),
        'live',
      );
      expect(
        await cache.get('short', ttl: ttl, loader: () async => 'expired'),
        'expired',
      );
    },
  );

  test(
    'completed loaders and replacement puts use the same capacity policy',
    () async {
      final cache = SyncTvMemoryCache(maxEntries: 2);
      cache.put('a', 'old', ttl: ttl);
      cache.put('b', 'b', ttl: ttl);
      cache.put('a', 'updated', ttl: ttl);
      await cache.get('c', ttl: ttl, loader: () async => 'loaded');
      expect(
        await cache.get('a', ttl: ttl, loader: () async => 'unexpected'),
        'updated',
      );
      expect(
        await cache.get('b', ttl: ttl, loader: () async => 'evicted'),
        'evicted',
      );
    },
  );

  test('capacity eviction leaves pending request coalescing intact', () async {
    final cache = SyncTvMemoryCache(maxEntries: 1);
    final pending = Completer<String>();
    var loads = 0;
    Future<String> read() => cache.get(
      'pending',
      ttl: ttl,
      loader: () {
        loads++;
        return pending.future;
      },
    );
    final first = read();
    cache.put('other', 'other', ttl: ttl);
    cache.put('new', 'new', ttl: ttl);
    final second = read();
    pending.complete('result');
    expect(await Future.wait([first, second]), ['result', 'result']);
    expect(loads, 1);
    expect(await read(), 'result');
    expect(loads, 1);
  });

  test('zero or negative TTL never displaces a live cached entry', () async {
    final cache = SyncTvMemoryCache(maxEntries: 1);
    cache.put('live', 'live', ttl: ttl);
    for (final expiry in [Duration.zero, const Duration(seconds: -1)]) {
      cache.put('expired', 'expired', ttl: expiry);
      await cache.get('uncached', ttl: expiry, loader: () async => 'result');
      expect(
        await cache.get('live', ttl: ttl, loader: () async => 'unexpected'),
        'live',
      );
    }
  });

  test('invalid cache capacity is rejected', () {
    for (final capacity in [0, -1]) {
      expect(
        () => SyncTvMemoryCache(maxEntries: capacity),
        throwsArgumentError,
      );
    }
  });

  for (final operation in ['invalidate', 'prefix', 'clear', 'put', 'refresh']) {
    test('late loader cannot overwrite cache after $operation', () async {
      final cache = SyncTvMemoryCache();
      final stale = Completer<String>();
      final pending = cache.get<String>(
        'rooms:one',
        ttl: ttl,
        loader: () => stale.future,
      );

      switch (operation) {
        case 'invalidate':
          cache.invalidate('rooms:one');
        case 'prefix':
          cache.invalidatePrefix('rooms:');
        case 'clear':
          cache.clear();
        case 'put':
          cache.put('rooms:one', 'current', ttl: ttl);
        case 'refresh':
          await cache.get<String>(
            'rooms:one',
            ttl: ttl,
            refresh: true,
            loader: () async => 'current',
          );
      }

      stale.complete('stale');
      expect(await pending, 'stale');
      expect(
        await cache.get<String>(
          'rooms:one',
          ttl: ttl,
          loader: () async => 'current',
        ),
        'current',
      );
    });
  }

  test('concurrent reads share a loader and errors allow a retry', () async {
    final cache = SyncTvMemoryCache();
    final pending = Completer<String>();
    var loads = 0;
    Future<String> read() => cache.get<String>(
      'room',
      ttl: ttl,
      loader: () {
        loads++;
        return pending.future;
      },
    );
    final first = read();
    final second = read();
    final errors = Future.wait([
      expectLater(first, throwsStateError),
      expectLater(second, throwsStateError),
    ]);
    pending.completeError(StateError('failed'));
    await errors;
    expect(loads, 1);
    expect(
      await cache.get<String>('room', ttl: ttl, loader: () async => 'retry'),
      'retry',
    );
  });

  test('cache ttl starts after loader completes', () async {
    var now = DateTime.utc(2026, 7, 13);
    final cache = SyncTvMemoryCache(clock: () => now);
    var loadCount = 0;
    final completer = Completer<String>();

    final first = cache.get<String>(
      'slow',
      ttl: const Duration(milliseconds: 40),
      loader: () {
        loadCount += 1;
        return completer.future;
      },
    );

    now = now.add(const Duration(hours: 1));
    completer.complete('value');
    expect(await first, 'value');

    now = now.add(const Duration(milliseconds: 20));
    expect(
      await cache.get<String>(
        'slow',
        ttl: const Duration(milliseconds: 40),
        loader: () async {
          loadCount += 1;
          return 'fresh';
        },
      ),
      'value',
    );
    expect(loadCount, 1);

    now = now.add(const Duration(milliseconds: 21));
    expect(
      await cache.get<String>(
        'slow',
        ttl: const Duration(milliseconds: 40),
        loader: () async {
          loadCount += 1;
          return 'fresh';
        },
      ),
      'fresh',
    );
    expect(loadCount, 2);
  });
}
