import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';

void main() {
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
