import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_cache.dart';

void main() {
  group('P2pMediaPersistentCache', () {
    late Directory directory;
    late DateTime now;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('synctv-p2p-cache-');
      now = DateTime.utc(2026, 7, 21);
    });

    tearDown(() async {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    });

    P2pMediaPersistentCache createCache({int maxBytes = 1024}) {
      return P2pMediaPersistentCache(
        directory: directory,
        maxBytes: maxBytes,
        cleanupInterval: Duration.zero,
        clock: () => now,
      );
    }

    test('reuses entries across cache instances', () async {
      final first = createCache();
      await first.put('swarm|piece:0', Uint8List.fromList([1, 2, 3]));
      await first.close();

      final second = createCache();
      expect(await second.get('swarm|piece:0'), [1, 2, 3]);
      expect(second.totalBytes, 3);
      await second.close();
    });

    test(
      'concurrent cache initialization uses independent temp files',
      () async {
        final first = createCache();
        final second = createCache();

        await Future.wait([first.initialize(), second.initialize()]);

        expect(await File('${directory.path}/index.json').exists(), isTrue);
        await first.close();
        await second.close();
      },
    );

    test('expires entries ten minutes after their latest access', () async {
      final cache = createCache();
      await cache.put('swarm|piece:0', Uint8List.fromList([1, 2, 3]));

      now = now.add(const Duration(minutes: 9));
      expect(await cache.get('swarm|piece:0'), [1, 2, 3]);
      now = now.add(const Duration(minutes: 9));
      expect(await cache.get('swarm|piece:0'), [1, 2, 3]);
      now = now.add(const Duration(minutes: 10));
      expect(await cache.get('swarm|piece:0'), isNull);
      expect(cache.totalBytes, 0);
      await cache.close();
    });

    test('evicts the least recently used entry at capacity', () async {
      final cache = createCache(maxBytes: 6);
      await cache.put('a', Uint8List.fromList([1, 1, 1]));
      now = now.add(const Duration(seconds: 1));
      await cache.put('b', Uint8List.fromList([2, 2, 2]));
      now = now.add(const Duration(seconds: 1));
      expect(await cache.get('a'), [1, 1, 1]);
      now = now.add(const Duration(seconds: 1));
      await cache.put('c', Uint8List.fromList([3, 3, 3]));

      expect(await cache.get('a'), [1, 1, 1]);
      expect(await cache.get('b'), isNull);
      expect(await cache.get('c'), [3, 3, 3]);
      expect(cache.totalBytes, 6);
      await cache.close();
    });

    test('resize immediately applies the smaller capacity', () async {
      final cache = createCache(maxBytes: 9);
      await cache.put('a', Uint8List.fromList([1, 1, 1]));
      now = now.add(const Duration(seconds: 1));
      await cache.put('b', Uint8List.fromList([2, 2, 2]));
      now = now.add(const Duration(seconds: 1));
      await cache.put('c', Uint8List.fromList([3, 3, 3]));

      await cache.resize(3);

      expect(await cache.get('a'), isNull);
      expect(await cache.get('b'), isNull);
      expect(await cache.get('c'), [3, 3, 3]);
      expect(cache.totalBytes, 3);
      await cache.close();
    });
  });
}
