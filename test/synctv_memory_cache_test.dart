import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/services/synctv_memory_cache.dart';

void main() {
  test('cache ttl starts after loader completes', () async {
    final cache = SyncTvMemoryCache();
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

    await Future<void>.delayed(const Duration(milliseconds: 30));
    completer.complete('value');
    expect(await first, 'value');

    await Future<void>.delayed(const Duration(milliseconds: 20));
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
  });
}
