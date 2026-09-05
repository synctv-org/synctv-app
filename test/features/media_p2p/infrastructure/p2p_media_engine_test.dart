import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_length_metadata.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_cache.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:xml/xml.dart';

P2pPeerPiece _peerPiece(List<int> bytes, {String peerId = 'peer-1'}) {
  return P2pPeerPiece(
    bytes: Uint8List.fromList(bytes),
    source: P2pPeerSource(peerId: peerId, swarmId: 'test-swarm'),
  );
}

void main() {
  test('HLS gateway rewrites resources and caches origin segments', () async {
    var segmentRequests = 0;
    final requestedPieces = <String>[];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      expect(request.headers.value('authorization'), 'Bearer room-token');
      if (request.uri.path == '/live') {
        request.response.headers.contentType = ContentType(
          'application',
          'vnd.apple.mpegurl',
        );
        request.response.write('''#EXTM3U
#EXT-X-MEDIA-SEQUENCE:42
#EXT-X-KEY:METHOD=AES-128,URI="key.bin?token=secret"
#EXTINF:4,
segment.ts?token=secret
''');
      } else if (request.uri.path == '/segment.ts') {
        segmentRequests++;
        request.response.add([1, 2, 3, 4]);
      } else if (request.uri.path == '/key.bin') {
        request.response.add([9, 8, 7]);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async {
        requestedPieces.add('$swarm|$key');
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });

    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/live',
      ),
      headers: const {'authorization': 'Bearer room-token'},
      swarmId: 'sm1_room',
      format: 'hls',
    );
    final manifest = await _getText(local);
    expect(manifest, isNot(contains('secret')));
    final segment = Uri.parse(
      manifest
          .split('\n')
          .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
    );
    expect(await _getBytes(segment), [1, 2, 3, 4]);
    expect(await _getBytes(segment), [1, 2, 3, 4]);
    expect(segmentRequests, 1);
    expect(requestedPieces, contains('sm1_room|root:segment:0:42'));
  });

  test(
    'HLS gateway rewrites a nested manifest hidden in a query URL',
    () async {
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        final target = request.uri.queryParameters['targetUrl'];
        if (request.uri.path == '/master') {
          final variant = Uri.encodeQueryComponent(
            'http://${origin.address.address}:${origin.port}/variant.m3u8',
          );
          request.response.write(
            '#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=1000\n'
            '/proxy?targetUrl=$variant\n',
          );
        } else if (target?.endsWith('/variant.m3u8') == true) {
          final segment = Uri.encodeQueryComponent(
            'http://${origin.address.address}:${origin.port}/segment.ts',
          );
          request.response.write(
            '#EXTM3U\n#EXTINF:4,\n/proxy?targetUrl=$segment\n',
          );
        } else if (target?.endsWith('/segment.ts') == true) {
          request.response.add([1, 3, 3, 7]);
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });

      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/master',
        ),
        headers: const {},
        swarmId: 'sm1_nested_proxy',
        format: 'm3u8',
      );
      final master = await _getText(local);
      final variant = Uri.parse(
        master
            .split('\n')
            .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
      );
      final variantManifest = await _getText(variant);
      final segment = Uri.parse(
        variantManifest
            .split('\n')
            .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
      );

      expect(segment.isAbsolute, isTrue);
      final response = await _getResponse(segment);
      expect(response.bytes, [1, 3, 3, 7]);
      expect(response.contentType, 'video/mp2t');
    },
  );

  test('HLS gateway recognizes extensionless playlist references', () async {
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/master') {
        request.response.write('''#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="English",URI="/audio?id=en"
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="English",URI="/subtitle?id=en"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=200000,URI="/iframe?id=720"
#EXT-X-STREAM-INF:BANDWIDTH=4000000,AUDIO="audio",SUBTITLES="subs"
/variant?id=720
''');
      } else if ({
        '/audio',
        '/subtitle',
        '/iframe',
        '/variant',
      }.contains(request.uri.path)) {
        request.response.write(
          '#EXTM3U\n#EXT-X-TARGETDURATION:4\n#EXTINF:4,\n'
          '/segment.ts?from=${request.uri.path.substring(1)}\n',
        );
      } else if (request.uri.path == '/segment.ts') {
        request.response.add([4, 2]);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });

    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/master',
      ),
      headers: const {},
      swarmId: 'sm1_extensionless_hls',
      format: 'hls',
    );
    final master = await _getText(local);
    final references = RegExp(r'https?://[^"\n]+')
        .allMatches(master)
        .map((match) => Uri.parse(match.group(0)!))
        .toList(growable: false);
    expect(references, hasLength(4));

    for (final reference in references) {
      final childManifest = await _getText(reference);
      final segment = Uri.parse(
        childManifest
            .split('\n')
            .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
      );
      expect(segment.isAbsolute, isTrue);
      expect(await _getBytes(segment), [4, 2]);
    }
  });

  test('HLS subresources implement suffix ranges and 416 responses', () async {
    final segmentBytes = Uint8List.fromList(List<int>.generate(10, (i) => i));
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/stream.m3u8') {
        request.response.write('#EXTM3U\n#EXTINF:4,\nsegment.ts\n');
      } else if (request.uri.path == '/segment.ts') {
        if (request.method != 'HEAD') {
          final range = request.headers.value(HttpHeaders.rangeHeader);
          if (range == 'bytes=6-9') {
            request.response.statusCode = HttpStatus.partialContent;
            request.response.headers.contentLength = 4;
            request.response.headers.set(
              HttpHeaders.contentRangeHeader,
              'bytes 6-9/${segmentBytes.length}',
            );
            request.response.add(segmentBytes.sublist(6));
          } else {
            request.response.headers.contentLength = segmentBytes.length;
            request.response.add(segmentBytes);
          }
        } else {
          request.response.headers.contentLength = segmentBytes.length;
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/stream.m3u8',
      ),
      headers: const {},
      swarmId: 'sm1_hls_ranges',
      format: 'hls',
    );
    final manifest = await _getText(local);
    final segment = Uri.parse(
      manifest
          .split('\n')
          .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
    );

    final suffix = await _getResponse(segment, range: 'bytes=-4');
    expect(suffix.statusCode, HttpStatus.partialContent);
    expect(suffix.contentRange, 'bytes 6-9/10');
    expect(suffix.bytes, [6, 7, 8, 9]);

    final outOfBounds = await _getResponse(segment, range: 'bytes=10-12');
    expect(outOfBounds.statusCode, HttpStatus.requestedRangeNotSatisfiable);
    expect(outOfBounds.contentRange, 'bytes */10');
  });

  test('failed HEAD response length is not used as media length', () async {
    final media = Uint8List.fromList(List<int>.generate(10, (index) => index));
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.method == 'HEAD') {
        request.response.statusCode = HttpStatus.methodNotAllowed;
        request.response.headers.contentLength = 512;
      } else if (request.headers.value(HttpHeaders.rangeHeader) ==
          'bytes=0-0') {
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes 0-0/${media.length}',
        );
        request.response.add(media.sublist(0, 1));
      } else if (request.headers.value(HttpHeaders.rangeHeader) ==
          'bytes=0-1048575') {
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes 0-9/${media.length}',
        );
        request.response.add(media);
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      ),
      headers: const {},
      swarmId: 'sm1_failed_head',
      format: 'mp4',
    );

    final suffix = await _getResponse(local, range: 'bytes=-4');
    expect(suffix.contentRange, 'bytes 6-9/10');
    expect(suffix.bytes, [6, 7, 8, 9]);
  });

  test('adaptive manifests are bounded to four MiB', () async {
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.add(Uint8List(4 * 1024 * 1024 + 1));
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/oversized.m3u8',
      ),
      headers: const {},
      swarmId: 'sm1_oversized_manifest',
      format: 'hls',
    );

    expect((await _getResponse(local)).statusCode, HttpStatus.badGateway);
  });

  test('peer segment wins before HTTP fallback', () async {
    var originSegmentRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/stream.m3u8') {
        request.response.write('#EXTM3U\n#EXTINF:4,\npart.m4s\n');
      } else {
        originSegmentRequests++;
        request.response.add([0]);
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async {
        return key == 'root:segment:0:0' ? _peerPiece([5, 6]) : null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/stream.m3u8',
      ),
      headers: const {},
      swarmId: 'sm1_room',
      format: 'application/vnd.apple.mpegurl',
    );
    final manifest = await _getText(local);
    final segment = Uri.parse(
      manifest
          .split('\n')
          .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
    );
    expect(await _getBytes(segment), [5, 6]);
    expect(originSegmentRequests, 0);
    expect(engine.stats.value.p2pBytes, 2);
  });

  test('persistent cache restores a piece for a later engine', () async {
    const bytes = [1, 2, 3, 4];
    final directory = await Directory.systemTemp.createTemp(
      'synctv-p2p-engine-cache-',
    );
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = bytes.length;
      request.response.add(bytes);
      await request.response.close();
    });
    final upstream = Uri.parse(
      'http://${origin.address.address}:${origin.port}/subtitle.vtt',
    );
    final first = P2pMediaEngine(
      persistentCache: P2pMediaPersistentCache(
        directory: directory,
        maxBytes: 1024,
        cleanupInterval: Duration.zero,
      ),
      maxCacheBytes: 1024,
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    P2pMediaEngine? second;
    try {
      final firstLocal = await first.localizeStatic(
        upstream: upstream,
        headers: const {},
        swarmId: 'sm1_persistent',
        logicalKey: 'subtitle:0',
      );
      expect(await _getBytes(firstLocal), bytes);
      await first.dispose();
      await origin.close(force: true);

      var peerRequests = 0;
      second = P2pMediaEngine(
        persistentCache: P2pMediaPersistentCache(
          directory: directory,
          maxBytes: 1024,
          cleanupInterval: Duration.zero,
        ),
        maxCacheBytes: 1024,
        requestPeerPiece: (swarm, key, cancellation) async {
          peerRequests++;
          return null;
        },
      );
      final secondLocal = await second.localizeStatic(
        upstream: upstream,
        headers: const {},
        swarmId: 'sm1_persistent',
        logicalKey: 'subtitle:0',
      );

      expect(await _getBytes(secondLocal), bytes);
      expect(peerRequests, 0);
      expect(second.stats.value.cacheHits, 1);
    } finally {
      await first.dispose();
      await second?.dispose();
      await origin.close(force: true);
      if (await directory.exists()) await directory.delete(recursive: true);
    }
  });

  test('memory cache expires idle pieces without persistent storage', () async {
    var now = DateTime.utc(2026, 1, 1);
    const bytes = [1, 2, 3, 4];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = bytes.length;
      request.response.add(bytes);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
      cacheTtl: const Duration(minutes: 10),
      clock: () => now,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_memory_expiry',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), bytes);
    expect(await engine.cachedPiece('sm1_memory_expiry', 'subtitle:0'), bytes);
    now = now.add(const Duration(minutes: 10));
    expect(await engine.cachedPiece('sm1_memory_expiry', 'subtitle:0'), isNull);
    expect(engine.stats.value.cacheBytes, 0);
  });

  test('progressive length metadata expires with the byte cache', () async {
    var now = DateTime.utc(2026, 1, 1);
    var headRequests = 0;
    const body = [4, 3, 2, 1];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (request.method == 'HEAD') {
        headRequests++;
        request.response.headers.contentLength = body.length;
      } else {
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.contentLength = body.length;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes 0-3/${body.length}',
        );
        request.response.add(body);
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
      cacheTtl: const Duration(minutes: 10),
      clock: () => now,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      ),
      headers: const {},
      swarmId: 'sm1_length_expiry',
      format: 'mp4',
    );

    expect((await _getResponse(local, range: 'bytes=0-3')).bytes, body);
    expect(headRequests, 1);
    now = now.add(const Duration(minutes: 10));
    expect((await _getResponse(local, range: 'bytes=0-3')).bytes, body);
    expect(headRequests, 2);
  });

  test(
    'persistent progressive cache restores the total range length',
    () async {
      final media = Uint8List.fromList(
        List<int>.generate(128 * 1024, (index) => index % 251),
      );
      final directory = await Directory.systemTemp.createTemp(
        'synctv-p2p-progressive-cache-',
      );
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var rangeRequests = 0;
      var headRequests = 0;
      origin.listen((request) async {
        request.response.headers.contentLength = media.length;
        if (request.method == 'HEAD') {
          request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
          headRequests++;
          await request.response.close();
          return;
        }
        rangeRequests++;
        final range = request.headers.value(HttpHeaders.rangeHeader);
        expect(range, 'bytes=0-1048575');
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes 0-${media.length - 1}/${media.length}',
        );
        request.response.add(media);
        await request.response.close();
      });
      final upstream = Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      );
      final first = P2pMediaEngine(
        persistentCache: P2pMediaPersistentCache(
          directory: directory,
          maxBytes: 1024 * 1024,
          cleanupInterval: Duration.zero,
        ),
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      P2pMediaEngine? second;
      try {
        final firstLocal = await first.localize(
          upstream: upstream,
          headers: const {},
          swarmId: 'sm1_persistent_progressive',
          format: 'mp4',
        );
        final initial = await _getResponse(firstLocal, range: 'bytes=0-65535');
        expect(initial.contentRange, 'bytes 0-65535/${media.length}');
        await first.dispose();

        second = P2pMediaEngine(
          persistentCache: P2pMediaPersistentCache(
            directory: directory,
            maxBytes: 1024 * 1024,
            cleanupInterval: Duration.zero,
          ),
          requestPeerPiece: (swarm, key, cancellation) async => null,
        );
        final secondLocal = await second.localize(
          upstream: upstream,
          headers: const {},
          swarmId: 'sm1_persistent_progressive',
          format: 'mp4',
        );
        final restored = await _getResponse(
          secondLocal,
          range: 'bytes=0-65535',
        );

        expect(restored.contentRange, 'bytes 0-65535/${media.length}');
        expect(restored.bytes, media.sublist(0, 65536));
        expect(rangeRequests, 1);
        expect(headRequests, 1);
        expect(second.stats.value.cacheHits, 1);
      } finally {
        await first.dispose();
        await second?.dispose();
        await origin.close(force: true);
        if (await directory.exists()) await directory.delete(recursive: true);
      }
    },
  );

  test(
    'slow origin headers retry peer and cancel the origin request',
    () async {
      const peerBytes = [5, 6, 7, 8];
      var peerRequests = 0;
      var originRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentLength = peerBytes.length;
        if (request.method == 'HEAD') {
          await request.response.close();
          return;
        }
        originRequests++;
        await request.response.flush();
        await Future<void>.delayed(const Duration(milliseconds: 160));
        try {
          request.response.add([1, 2, 3, 4]);
          await request.response.close();
        } catch (_) {
          // The delayed peer won and canceled this body.
        }
      });
      final engine = P2pMediaEngine(
        originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
        requestPeerPiece: (swarm, key, cancellation) async {
          peerRequests++;
          return peerRequests == 1 ? null : _peerPiece(peerBytes);
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/subtitle.vtt',
        ),
        headers: const {},
        swarmId: 'sm1_delayed_peer',
        format: 'vtt',
      );

      expect(await _getBytes(local), peerBytes);
      expect(peerRequests, 2);
      expect(originRequests, 1);
      expect(engine.stats.value.p2pBytes, peerBytes.length);
      expect(engine.stats.value.httpBytes, 0);
      await Future<void>.delayed(const Duration(milliseconds: 180));
    },
  );

  test('origin headers cancel an in-flight header-phase peer query', () async {
    const originBytes = [1, 2, 3, 4];
    var peerRequests = 0;
    var peerCancelled = false;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = originBytes.length;
      await Future<void>.delayed(const Duration(milliseconds: 80));
      try {
        request.response.add(originBytes);
        await request.response.close();
      } catch (_) {
        // The request can be canceled during teardown.
      }
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
      originHeaderTimeout: const Duration(milliseconds: 300),
      peerMissingRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        if (peerRequests == 1) return null;
        await cancellation.whenCancelled;
        peerCancelled = true;
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_header_cancels_peer',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), originBytes);
    expect(peerRequests, 2);
    expect(peerCancelled, isTrue);
  });

  test(
    'slow origin headers repeat peer lookup after a confirmed miss',
    () async {
      const peerBytes = [5, 6, 7, 8];
      var peerRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentLength = peerBytes.length;
        await Future<void>.delayed(const Duration(milliseconds: 200));
        try {
          request.response.add([1, 2, 3, 4]);
          await request.response.close();
        } catch (_) {
          // A later peer lookup wins and cancels the origin request.
        }
      });
      final engine = P2pMediaEngine(
        originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
        originHeaderTimeout: const Duration(milliseconds: 400),
        peerMissingRetryDelay: const Duration(milliseconds: 20),
        requestPeerPiece: (swarm, key, cancellation) async {
          peerRequests++;
          return peerRequests < 3 ? null : _peerPiece(peerBytes);
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localizeStatic(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/subtitle.vtt',
        ),
        headers: const {},
        swarmId: 'sm1_header_retries_peer',
        logicalKey: 'subtitle:0',
      );

      expect(await _getBytes(local), peerBytes);
      expect(peerRequests, 3);
    },
  );

  test('peer can recover a request after the origin header deadline', () async {
    const peerBytes = [5, 6, 7, 8];
    final stopwatch = Stopwatch()..start();
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = peerBytes.length;
      try {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        request.response.add([1, 2, 3, 4]);
        await request.response.close();
      } catch (_) {
        // The peer won while the origin was still waiting to send headers.
      }
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 10),
      originHeaderTimeout: const Duration(milliseconds: 50),
      originHeaderPeerRecoveryTimeout: const Duration(milliseconds: 200),
      peerMissingRetryDelay: const Duration(milliseconds: 10),
      requestPeerPiece: (swarm, key, cancellation) async {
        return stopwatch.elapsed >= const Duration(milliseconds: 100)
            ? _peerPiece(peerBytes)
            : null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_header_deadline_peer_recovery',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), peerBytes);
    expect(
      stopwatch.elapsed,
      greaterThanOrEqualTo(const Duration(milliseconds: 100)),
    );
    expect(engine.stats.value.p2pBytes, peerBytes.length);
    expect(engine.stats.value.httpBytes, 0);
  });

  test('failing origin and peer have a bounded recovery window', () async {
    final unavailableOrigin = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    unavailableOrigin.listen((socket) => socket.destroy());
    final upstream = Uri.parse(
      'http://${unavailableOrigin.address.address}:'
      '${unavailableOrigin.port}/subtitle.vtt',
    );
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 10),
      originHeaderTimeout: const Duration(milliseconds: 40),
      originHeaderPeerRecoveryTimeout: const Duration(milliseconds: 60),
      peerMissingRetryDelay: const Duration(milliseconds: 10),
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await unavailableOrigin.close();
    });
    final local = await engine.localizeStatic(
      upstream: upstream,
      headers: const {},
      swarmId: 'sm1_bounded_header_recovery',
      logicalKey: 'subtitle:0',
    );
    final stopwatch = Stopwatch()..start();

    final client = HttpClient();
    final response = await (await client.getUrl(local)).close();
    await response.drain<void>();
    client.close(force: true);

    expect(response.statusCode, HttpStatus.badGateway);
    expect(
      stopwatch.elapsed,
      greaterThanOrEqualTo(const Duration(milliseconds: 90)),
    );
    expect(stopwatch.elapsed, lessThan(const Duration(milliseconds: 500)));
  });

  test('fast origin completes before the delayed peer retry', () async {
    const originBytes = [1, 2, 3, 4];
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = originBytes.length;
      if (request.method != 'HEAD') request.response.add(originBytes);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 60),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_fast_origin',
      format: 'vtt',
    );

    expect(await _getBytes(local), originBytes);
    await Future<void>.delayed(const Duration(milliseconds: 90));
    expect(peerRequests, 1);
    expect(engine.stats.value.httpBytes, originBytes.length);
    expect(engine.stats.value.p2pBytes, 0);
  });

  test('origin sampling accepts a matching peer piece', () async {
    const bytes = [1, 2, 3, 4];
    final reports = <bool>[];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = bytes.length;
      if (request.method != 'HEAD') request.response.add(bytes);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      securityMode: P2pMediaSecurityMode.sampledOrigin,
      originSampleRate: 1,
      requestPeerPiece: (swarm, key, cancellation) async => _peerPiece(bytes),
      reportPeerIntegrity: (source, valid) async => reports.add(valid),
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_sample_match',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), bytes);
    expect(reports, [true]);
    expect(engine.stats.value.integrityChecks, 1);
    expect(engine.stats.value.integrityMismatches, 0);
    expect(engine.stats.value.httpBytes, bytes.length);
    expect(engine.stats.value.p2pBytes, bytes.length);
  });

  test('origin sampling replaces a conflicting peer piece', () async {
    const originBytes = [1, 2, 3, 4];
    const peerBytes = [9, 8, 7, 6];
    final reports = <bool>[];
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = originBytes.length;
      if (request.method != 'HEAD') request.response.add(originBytes);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      securityMode: P2pMediaSecurityMode.sampledOrigin,
      originSampleRate: 1,
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return _peerPiece(peerBytes, peerId: 'conflicting-peer');
      },
      reportPeerIntegrity: (source, valid) async => reports.add(valid),
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_sample_conflict',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), originBytes);
    expect(await _getBytes(local), originBytes);
    expect(peerRequests, 1);
    expect(reports, [false]);
    expect(engine.stats.value.integrityChecks, 1);
    expect(engine.stats.value.integrityMismatches, 1);
  });

  test(
    'origin sampling preserves playback when origin validation stalls',
    () async {
      const peerBytes = [9, 8, 7, 6];
      final reports = <bool>[];
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentLength = peerBytes.length;
        request.response.add(peerBytes.sublist(0, 1));
        await request.response.flush();
        await Future<void>.delayed(const Duration(milliseconds: 120));
        try {
          request.response.add(peerBytes.sublist(1));
          await request.response.close();
        } catch (_) {
          // The bounded validation read cancels the stalled origin response.
        }
      });
      final engine = P2pMediaEngine(
        securityMode: P2pMediaSecurityMode.sampledOrigin,
        originSampleRate: 1,
        originBodyStallPeerRetryDelay: const Duration(milliseconds: 20),
        requestPeerPiece: (swarm, key, cancellation) async =>
            _peerPiece(peerBytes),
        reportPeerIntegrity: (source, valid) async => reports.add(valid),
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localizeStatic(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/subtitle.vtt',
        ),
        headers: const {},
        swarmId: 'sm1_sample_unavailable',
        logicalKey: 'subtitle:0',
      );

      expect(await _getBytes(local), peerBytes);
      expect(reports, isEmpty);
      expect(engine.stats.value.integrityChecks, 0);
      expect(engine.stats.value.integrityUnavailable, 1);
    },
  );

  test('dispose cancels an in-flight origin sampling validation', () async {
    const peerBytes = [9, 8, 7, 6];
    final validationStarted = Completer<void>();
    late P2pPieceRequestCancellation peerCancellation;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = peerBytes.length;
      request.response.add(peerBytes.sublist(0, 1));
      await request.response.flush();
      if (!validationStarted.isCompleted) validationStarted.complete();
      await Future<void>.delayed(const Duration(seconds: 1));
      try {
        request.response.add(peerBytes.sublist(1));
        await request.response.close();
      } catch (_) {
        // Engine disposal closes the validation response.
      }
    });
    final engine = P2pMediaEngine(
      securityMode: P2pMediaSecurityMode.sampledOrigin,
      originSampleRate: 1,
      originBodyStallPeerRetryDelay: const Duration(seconds: 2),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerCancellation = cancellation;
        return _peerPiece(peerBytes);
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_sample_dispose',
      logicalKey: 'subtitle:0',
    );

    final playback = _getBytes(local);
    await validationStarted.future.timeout(const Duration(seconds: 1));
    expect(peerCancellation.isCancelled, isFalse);
    await engine.dispose();
    expect(peerCancellation.isCancelled, isTrue);
    await expectLater(playback, throwsA(anything));
  });

  test('origin sampling bounds the response-header wait', () async {
    const peerBytes = [9, 8, 7, 6];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = peerBytes.length;
      await Future<void>.delayed(const Duration(milliseconds: 120));
      try {
        request.response.add(peerBytes);
        await request.response.close();
      } catch (_) {
        // The header budget cancels the validation request.
      }
    });
    final engine = P2pMediaEngine(
      securityMode: P2pMediaSecurityMode.sampledOrigin,
      originSampleRate: 1,
      originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async =>
          _peerPiece(peerBytes),
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_sample_header_timeout',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), peerBytes);
    expect(engine.stats.value.integrityChecks, 0);
    expect(engine.stats.value.integrityUnavailable, 1);
  });

  test('stalled origin body retries peer after receiving headers', () async {
    const peerBytes = [6, 7, 8, 9];
    final firstOriginChunk = Uint8List(64 * 1024);
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = firstOriginChunk.length + 3;
      if (request.method == 'HEAD') {
        await request.response.close();
        return;
      }
      request.response.add(firstOriginChunk);
      await request.response.flush();
      await Future<void>.delayed(const Duration(milliseconds: 160));
      try {
        request.response.add([2, 3, 4]);
        await request.response.close();
      } catch (_) {
        // The stalled-body peer retry won and aborted the origin response.
      }
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 500),
      originBodyStallPeerRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return peerRequests == 1 ? null : _peerPiece(peerBytes);
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_stalled_origin_body',
      format: 'vtt',
    );

    expect(await _getBytes(local), peerBytes);
    expect(peerRequests, 2);
    expect(engine.stats.value.httpBytes, firstOriginChunk.length);
    expect(engine.stats.value.p2pBytes, peerBytes.length);
    await Future<void>.delayed(const Duration(milliseconds: 180));
  });

  test(
    'stalled origin body repeats peer lookup after a confirmed miss',
    () async {
      const peerBytes = [6, 7, 8, 9];
      final firstOriginChunk = Uint8List(64 * 1024);
      var peerRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentLength = firstOriginChunk.length + 3;
        request.response.add(firstOriginChunk);
        await request.response.flush();
        await Future<void>.delayed(const Duration(milliseconds: 180));
        try {
          request.response.add([2, 3, 4]);
          await request.response.close();
        } catch (_) {
          // The repeated peer lookup wins and cancels the body.
        }
      });
      final engine = P2pMediaEngine(
        originHeaderPeerRetryDelay: const Duration(milliseconds: 500),
        originBodyStallPeerRetryDelay: const Duration(milliseconds: 20),
        peerMissingRetryDelay: const Duration(milliseconds: 20),
        requestPeerPiece: (swarm, key, cancellation) async {
          peerRequests++;
          return peerRequests < 3 ? null : _peerPiece(peerBytes);
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localizeStatic(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/subtitle.vtt',
        ),
        headers: const {},
        swarmId: 'sm1_body_retries_peer',
        logicalKey: 'subtitle:0',
      );

      expect(await _getBytes(local), peerBytes);
      expect(peerRequests, 3);
    },
  );

  test('stable low-throughput origin body starts a peer hedge', () async {
    const peerBytes = [6, 7, 8, 9];
    final chunk = Uint8List(16 * 1024);
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = chunk.length * 10;
      for (var index = 0; index < 10; index++) {
        try {
          request.response.add(chunk);
          await request.response.flush();
        } catch (_) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 500),
      originBodyStallPeerRetryDelay: const Duration(milliseconds: 100),
      originBodySlowObservation: const Duration(milliseconds: 40),
      originBodyHedgeDelay: const Duration(milliseconds: 500),
      originBodyMinimumRateBytesPerSecond: 10 * 1024 * 1024,
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return peerRequests == 1 ? null : _peerPiece(peerBytes);
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_slow_stream_hedge',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), peerBytes);
    expect(peerRequests, 2);
    expect(engine.stats.value.httpBytes, greaterThan(0));
  });

  test('origin body completion cancels an in-flight body peer query', () async {
    final originBytes = Uint8List(64 * 1024 + 3);
    var peerRequests = 0;
    var peerCancelled = false;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = originBytes.length;
      request.response.add(Uint8List.sublistView(originBytes, 0, 64 * 1024));
      await request.response.flush();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      request.response.add(Uint8List.sublistView(originBytes, 64 * 1024));
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 500),
      originBodyStallPeerRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        if (peerRequests == 1) return null;
        await cancellation.whenCancelled;
        peerCancelled = true;
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localizeStatic(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_body_cancels_peer',
      logicalKey: 'subtitle:0',
    );

    expect(await _getBytes(local), originBytes);
    expect(peerRequests, 2);
    expect(peerCancelled, isTrue);
  });

  test('steadily streaming origin body does not retry peer', () async {
    final originChunks = List<Uint8List>.generate(
      4,
      (index) => Uint8List.fromList(List<int>.filled(64 * 1024, index + 1)),
    );
    final originBytes = Uint8List.fromList(
      originChunks.expand((chunk) => chunk).toList(),
    );
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = originBytes.length;
      if (request.method == 'HEAD') {
        await request.response.close();
        return;
      }
      for (final chunk in originChunks) {
        request.response.add(chunk);
        await request.response.flush();
        await Future<void>.delayed(const Duration(milliseconds: 25));
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 500),
      originBodyStallPeerRetryDelay: const Duration(milliseconds: 200),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/subtitle.vtt',
      ),
      headers: const {},
      swarmId: 'sm1_steady_origin_body',
      format: 'vtt',
    );

    expect(await _getBytes(local), originBytes);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(peerRequests, 1);
    expect(engine.stats.value.httpBytes, originBytes.length);
    expect(engine.stats.value.p2pBytes, 0);
  });

  test('slow progressive range can be taken over by a later peer', () async {
    const peerBytes = [9, 8, 7, 6];
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.method == 'HEAD') {
        request.response.headers.contentLength = peerBytes.length;
        request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        await request.response.close();
        return;
      }
      expect(request.headers.value(HttpHeaders.rangeHeader), 'bytes=0-1048575');
      request.response.statusCode = HttpStatus.partialContent;
      request.response.headers.contentLength = peerBytes.length;
      request.response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes 0-3/4',
      );
      await request.response.flush();
      await Future<void>.delayed(const Duration(milliseconds: 160));
      try {
        request.response.add([1, 2, 3, 4]);
        await request.response.close();
      } catch (_) {
        // The delayed peer won and canceled this body.
      }
    });
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return peerRequests == 1 ? null : _peerPiece(peerBytes);
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      ),
      headers: const {},
      swarmId: 'sm1_delayed_progressive_peer',
      format: 'mp4',
    );

    expect(await _getBytes(local, range: 'bytes=0-3'), peerBytes);
    expect(peerRequests, 2);
    expect(engine.stats.value.p2pBytes, peerBytes.length);
    await Future<void>.delayed(const Duration(milliseconds: 180));
  });

  test('progressive requests use aligned cached ranges', () async {
    const totalLength = 17 * 1024 * 1024;
    final media = Uint8List.fromList(
      List<int>.generate(1024 * 1024, (index) => index % 251),
    );
    var rangeRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.method == 'HEAD') {
        request.response.headers.contentLength = totalLength;
        request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        await request.response.close();
        return;
      }
      final range = request.headers.value(HttpHeaders.rangeHeader);
      expect(range, 'bytes=0-1048575');
      rangeRequests++;
      request.response.statusCode = HttpStatus.partialContent;
      request.response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes 0-1048575/$totalLength',
      );
      request.response.add(Uint8List.sublistView(media, 0, 1024 * 1024));
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      ),
      headers: const {},
      swarmId: 'sm1_room',
      format: 'mp4',
    );
    expect(
      await _getBytes(local, range: 'bytes=100-199'),
      media.sublist(100, 200),
    );
    expect(
      await _getBytes(local, range: 'bytes=300-399'),
      media.sublist(300, 400),
    );
    expect(rangeRequests, 1);
  });

  test(
    'progressive gateway supports origins that ignore range requests',
    () async {
      final media = Uint8List.fromList(
        List<int>.generate(128 * 1024, (index) => index % 251),
      );
      var originRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        originRequests++;
        request.response.headers.contentLength = media.length;
        request.response.headers.contentType = ContentType('video', 'mp4');
        request.response.add(media);
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/video.mp4',
        ),
        headers: const {},
        swarmId: 'sm1_room',
        format: 'video/mp4',
      );

      final first = await _getResponse(local, range: 'bytes=0-');
      expect(first.statusCode, HttpStatus.partialContent);
      expect(first.contentRange, 'bytes 0-${media.length - 1}/${media.length}');
      expect(first.bytes, media);

      final cached = await _getResponse(local, range: 'bytes=100-199');
      expect(cached.contentRange, 'bytes 100-199/${media.length}');
      expect(cached.bytes, media.sublist(100, 200));
      expect(originRequests, 2);
    },
  );

  test(
    'DASH Range-ignoring origins flush initialization data before completion',
    () async {
      final media = Uint8List.fromList(
        List<int>.generate(17 * 1024 * 1024, (index) => index % 251),
      );
      const initializationBytes = 8 * 1024;
      final firstOriginChunk = Completer<void>();
      final allowOriginCompletion = Completer<void>();
      final originRequests = <String>[];
      Socket? sourceSocket;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        originRequests.add('${request.method} ${request.uri.path}');
        if (request.uri.path == '/manifest.mpd') {
          request.response.write(
            '<MPD><Period><AdaptationSet><Representation>'
            '<BaseURL>http://${origin.address.address}:${origin.port}/video.mp4'
            '</BaseURL></Representation></AdaptationSet></Period></MPD>',
          );
          await request.response.close();
          return;
        }
        if (request.uri.path != '/video.mp4') {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
          return;
        }
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentLength = media.length;
        request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        if (request.method == 'HEAD') {
          await request.response.close();
          return;
        }
        sourceSocket = await request.response.detachSocket();
        sourceSocket!.add(Uint8List.sublistView(media, 0, initializationBytes));
        await sourceSocket!.flush();
        if (!firstOriginChunk.isCompleted) firstOriginChunk.complete();
        await allowOriginCompletion.future;
        sourceSocket!.add(Uint8List.sublistView(media, initializationBytes));
        await sourceSocket!.close();
      });
      final engine = P2pMediaEngine(
        canRequestPeer: (_) => false,
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      addTearDown(() async {
        if (!allowOriginCompletion.isCompleted) {
          allowOriginCompletion.complete();
        }
        sourceSocket?.destroy();
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/manifest.mpd',
        ),
        headers: const {},
        swarmId: 'sm1_dash_ignored_range_flush',
        format: 'dash',
      );
      final document = XmlDocument.parse(await _getText(local));
      final mediaUri = Uri.parse(
        document.findAllElements('BaseURL').last.innerText,
      );
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final request = await client.getUrl(mediaUri);
      request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-');
      final response = await request.close().timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw TimeoutException(
          'Gateway did not forward the first DASH initialization chunk; '
          'origin requests: $originRequests, '
          'first chunk: ${firstOriginChunk.isCompleted}',
        ),
      );
      expect(response.statusCode, HttpStatus.partialContent);
      final firstBody = Completer<void>();
      final responseComplete = Completer<void>();
      final received = BytesBuilder(copy: false);
      response.listen(
        (chunk) {
          received.add(chunk);
          if (!firstBody.isCompleted) {
            firstBody.complete();
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!firstBody.isCompleted) {
            firstBody.completeError(error, stackTrace);
          }
          if (!responseComplete.isCompleted) {
            responseComplete.completeError(error, stackTrace);
          }
        },
        onDone: () {
          if (!responseComplete.isCompleted) responseComplete.complete();
        },
      );
      await firstBody.future.timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw TimeoutException(
          'Gateway did not forward the first DASH initialization chunk; '
          'origin requests: $originRequests, '
          'first chunk: ${firstOriginChunk.isCompleted}',
        ),
      );
      await firstOriginChunk.future.timeout(const Duration(seconds: 1));
      allowOriginCompletion.complete();
      await responseComplete.future.timeout(const Duration(seconds: 5));
      expect(received.takeBytes(), media);
    },
  );

  test('small progressive ranges share one complete origin download', () async {
    final media = Uint8List.fromList(
      List<int>.generate(
        P2pMediaEngine.progressivePieceSize * 3 + 123,
        (index) => index % 251,
      ),
    );
    var getRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = media.length;
      request.response.headers.contentType = ContentType('video', 'x-flv');
      if (request.method == 'GET') {
        getRequests++;
        for (
          var start = 0;
          start < media.length;
          start += P2pMediaEngine.progressivePieceSize
        ) {
          final end = min(
            start + P2pMediaEngine.progressivePieceSize,
            media.length,
          );
          request.response.add(Uint8List.sublistView(media, start, end));
          await request.response.flush();
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/archive.flv',
      ),
      headers: const {},
      swarmId: 'sm1_small_complete_origin',
      format: 'flv',
    );

    final responses = await Future.wait([
      _getResponse(local, range: 'bytes=0-1023'),
      _getResponse(
        local,
        range:
            'bytes=${P2pMediaEngine.progressivePieceSize + 321}-'
            '${P2pMediaEngine.progressivePieceSize + 1320}',
      ),
      _getResponse(
        local,
        range:
            'bytes=${P2pMediaEngine.progressivePieceSize * 3}-'
            '${media.length - 1}',
      ),
    ]);

    expect(responses[0].bytes, media.sublist(0, 1024));
    expect(
      responses[1].bytes,
      media.sublist(
        P2pMediaEngine.progressivePieceSize + 321,
        P2pMediaEngine.progressivePieceSize + 1321,
      ),
    );
    expect(
      responses[2].bytes,
      media.sublist(P2pMediaEngine.progressivePieceSize * 3),
    );
    expect(getRequests, 1);
    expect(engine.stats.value.httpBytes, media.length);
  });

  test('ignored Range stays within the configured byte cache', () async {
    const mediaLength = 20 * 1024 * 1024;
    final media = Uint8List.fromList(
      List<int>.generate(mediaLength, (index) => index % 251),
    );
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = media.length;
      request.response.add(media);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
      maxCacheBytes: 2 * 1024 * 1024,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/large.mp4',
      ),
      headers: const {},
      swarmId: 'sm2_bounded_range',
      format: 'mp4',
    );
    const start = 18 * 1024 * 1024 + 321;
    const end = start + 1023;

    final response = await _getResponse(local, range: 'bytes=$start-$end');

    expect(response.statusCode, HttpStatus.partialContent);
    expect(response.bytes, media.sublist(start, end + 1));
    expect(engine.stats.value.cacheBytes, lessThanOrEqualTo(2 * 1024 * 1024));
  });

  test('DASH gateway rewrites BaseURL and shares expanded segments', () async {
    var segmentRequests = 0;
    final requestedPieces = <String>[];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.headers.contentType = ContentType(
          'application',
          'dash+xml',
        );
        request.response.write(
          '<MPD><Period><AdaptationSet><Representation>'
          '<SegmentTemplate media="video/seg-\$Number\$.m4s?deadline=100&amp;sq=\$Number\$" />'
          '</Representation></AdaptationSet></Period></MPD>',
        );
      } else if (request.uri.path == '/video/seg-1.m4s') {
        segmentRequests++;
        request.response.add([7, 8, 9]);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async {
        requestedPieces.add('$swarm|$key');
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash',
      format: 'application/dash+xml',
    );

    final manifest = await _getText(local);
    final document = XmlDocument.parse(manifest);
    final baseUrl = Uri.parse(
      document.findAllElements('BaseURL').first.innerText,
    );
    final template = document
        .findAllElements('SegmentTemplate')
        .single
        .getAttribute('media')!;
    final segment = baseUrl.resolve(template.replaceAll(r'$Number$', '1'));
    expect(await _getBytes(segment), [7, 8, 9]);
    expect(await _getBytes(segment), [7, 8, 9]);
    expect(segmentRequests, 1);
    expect(
      requestedPieces,
      contains('sm2_dash|root:mpd:root-base:video/seg-1.m4s?sq=1'),
    );
  });

  test('DASH manifests always load from origin outside the swarm', () async {
    var originRequests = 0;
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      originRequests++;
      request.response.write('<MPD><Period id="0" /></MPD>');
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async {
        peerRequests++;
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash_manifest_origin',
      format: 'dash',
    );

    expect(await _getText(local), contains('<MPD>'));
    expect(originRequests, 1);
    expect(peerRequests, 0);
  });

  test('DASH segments bypass peer lookup without a connected peer', () async {
    var peerRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.write(
          '<MPD><Period><AdaptationSet><Representation>'
          '<SegmentTemplate media="seg-\$Number\$.m4s" />'
          '</Representation></AdaptationSet></Period></MPD>',
        );
      } else if (request.uri.path == '/seg-1.m4s') {
        request.response.add([4, 2]);
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      canRequestPeer: (_) => false,
      requestPeerPiece: (swarm, key, cancellation) {
        peerRequests++;
        return Completer<P2pPeerPiece?>().future;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash_no_peer',
      format: 'dash',
    );
    final manifest = await _getText(local);
    final baseUrl = RegExp(r'<BaseURL>([^<]+)</BaseURL>')
        .firstMatch(manifest)!
        .group(1)!;

    final segment = await _getBytes(Uri.parse(baseUrl).resolve('seg-1.m4s'))
        .timeout(const Duration(seconds: 1));

    expect(segment, [4, 2]);
    expect(peerRequests, 0);
  });

  test(
    'dynamic DASH segments bypass peer lookup without a connected peer',
    () async {
      var peerRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final originBase = Uri(
        scheme: 'http',
        host: origin.address.address,
        port: origin.port,
      );
      origin.listen((request) async {
        if (request.uri.path == '/manifest.mpd') {
          request.response.write(
            '<MPD type="dynamic" minimumUpdatePeriod="PT2S">'
            '<UTCTiming schemeIdUri="urn:mpeg:dash:utc:http-xsdate:2014" '
            'value="/clock" />'
            '<Period><AdaptationSet><Representation>'
            '<SegmentTemplate media="video/\$Number\$.m4s" '
            'initialization="video/init.mp4" />'
            '</Representation></AdaptationSet></Period></MPD>',
          );
        } else if (request.uri.path == '/clock') {
          request.response.write('2026-08-15T12:00:00Z');
        } else if (request.uri.path == '/video/5.m4s') {
          request.response.add([4, 2]);
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        canRequestPeer: (_) => false,
        requestPeerPiece: (swarm, key, cancellation) {
          peerRequests++;
          return Completer<P2pPeerPiece?>().future;
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: originBase.replace(path: '/manifest.mpd'),
        headers: const {},
        swarmId: 'sm2_dynamic_dash_no_peer',
        format: 'dash',
      );
      final document = XmlDocument.parse(await _getText(local));
      final baseUrl = document.findAllElements('BaseURL').first.innerText;
      final utcTiming = document
          .findAllElements('UTCTiming')
          .single
          .getAttribute('value')!;

      expect(document.rootElement.getAttribute('type'), 'dynamic');
      expect(document.rootElement.getAttribute('minimumUpdatePeriod'), 'PT2S');
      expect(await _getText(Uri.parse(utcTiming)), '2026-08-15T12:00:00Z');
      expect(await _getBytes(Uri.parse(baseUrl).resolve('video/5.m4s')), [
        4,
        2,
      ]);
      expect(peerRequests, 0);
    },
  );

  test(
    'slow DASH segment headers bypass peer lookup without a connected peer',
    () async {
      var peerRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        if (request.uri.path == '/manifest.mpd') {
          request.response.write(
            '<MPD><Period><AdaptationSet><Representation>'
            '<SegmentTemplate media="seg-\$Number\$.m4s" />'
            '</Representation></AdaptationSet></Period></MPD>',
          );
        } else if (request.uri.path == '/seg-1.m4s') {
          await Future<void>.delayed(const Duration(milliseconds: 80));
          request.response.add([4, 2]);
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        canRequestPeer: (_) => false,
        originHeaderTimeout: const Duration(milliseconds: 300),
        originHeaderPeerRetryDelay: const Duration(milliseconds: 5),
        requestPeerPiece: (swarm, key, cancellation) {
          peerRequests++;
          return Completer<P2pPeerPiece?>().future;
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/manifest.mpd',
        ),
        headers: const {},
        swarmId: 'sm2_dash_slow_headers_no_peer',
        format: 'dash',
      );
      final manifest = await _getText(local);
      final baseUrl = RegExp(r'<BaseURL>([^<]+)</BaseURL>')
          .firstMatch(manifest)!
          .group(1)!;

      final segment = await _getBytes(Uri.parse(baseUrl).resolve('seg-1.m4s'))
          .timeout(const Duration(seconds: 1));

      expect(segment, [4, 2]);
      expect(peerRequests, 0);
    },
  );

  test(
    'slow DASH segment bodies bypass peer lookup without a connected peer',
    () async {
      var peerRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        if (request.uri.path == '/manifest.mpd') {
          request.response.write(
            '<MPD><Period><AdaptationSet><Representation>'
            '<SegmentTemplate media="seg-\$Number\$.m4s" />'
            '</Representation></AdaptationSet></Period></MPD>',
          );
        } else if (request.uri.path == '/seg-1.m4s') {
          request.response.headers.contentLength = 2;
          await request.response.flush();
          await Future<void>.delayed(const Duration(milliseconds: 80));
          request.response.add([4, 2]);
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        canRequestPeer: (_) => false,
        originBodyStallPeerRetryDelay: const Duration(milliseconds: 20),
        requestPeerPiece: (swarm, key, cancellation) {
          peerRequests++;
          return Completer<P2pPeerPiece?>().future;
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/manifest.mpd',
        ),
        headers: const {},
        swarmId: 'sm2_dash_slow_body_no_peer',
        format: 'dash',
      );
      final manifest = await _getText(local);
      final baseUrl = RegExp(r'<BaseURL>([^<]+)</BaseURL>')
          .firstMatch(manifest)!
          .group(1)!;

      final segment = await _getBytes(Uri.parse(baseUrl).resolve('seg-1.m4s'))
          .timeout(const Duration(seconds: 1));

      expect(segment, [4, 2]);
      expect(peerRequests, 0);
    },
  );

  test('DASH gateway rewrites nested absolute SegmentBase resources', () async {
    const media = [1, 2, 3, 4];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.headers.contentType = ContentType(
          'application',
          'dash+xml',
        );
        request.response.write(
          '<MPD><Period><AdaptationSet><Representation>'
          '<BaseURL>http://${origin.address.address}:${origin.port}/video.mp4</BaseURL>'
          '<SegmentBase indexRange="1-2"><Initialization range="0-0"/>'
          '</SegmentBase></Representation></AdaptationSet></Period></MPD>',
        );
      } else if (request.uri.path == '/video.mp4') {
        if (request.method == 'HEAD') {
          request.response.headers.contentLength = media.length;
        } else {
          final range = request.headers.value(HttpHeaders.rangeHeader);
          if (range == 'bytes=1-2') {
            request.response.statusCode = HttpStatus.partialContent;
            request.response.headers.contentLength = 2;
            request.response.headers.set(
              HttpHeaders.contentRangeHeader,
              'bytes 1-2/${media.length}',
            );
            request.response.add(media.sublist(1, 3));
          } else {
            request.response.add(media);
          }
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_nested_dash',
      format: 'dash',
    );

    final manifest = await _getText(local);
    final baseUrls = RegExp(r'<BaseURL>([^<]+)</BaseURL>')
        .allMatches(manifest)
        .map((match) => match.group(1)!)
        .toList();
    expect(baseUrls, hasLength(2));
    expect(baseUrls.last, startsWith('http://127.0.0.1:'));
    final response = await _getResponse(
      Uri.parse(baseUrls.last),
      range: 'bytes=1-2',
    );
    expect(response.statusCode, HttpStatus.partialContent);
    expect(response.bytes, [2, 3]);
  });

  test(
    'DASH open ranges stream before the complete resource arrives',
    () async {
      final pieceSize = P2pMediaEngine.progressivePieceSize;
      final media = Uint8List.fromList(
        List<int>.generate(pieceSize * 2 + 37, (index) => index % 251),
      );
      final secondHalfAllowed = Completer<void>();
      final originRanges = <String>[];
      final originRequests = <String>[];
      var secondPieceAttempts = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        originRequests.add('${request.method} ${request.uri.path}');
        if (request.uri.path == '/manifest.mpd') {
          request.response.write(
            '<MPD><Period><AdaptationSet><Representation>'
            '<BaseURL>http://${origin.address.address}:${origin.port}/video.mp4'
            '</BaseURL>'
            '<SegmentBase indexRange="100-199">'
            '<Initialization range="0-99"/>'
            '</SegmentBase></Representation></AdaptationSet></Period></MPD>',
          );
          await request.response.close();
          return;
        }
        if (request.uri.path != '/video.mp4') {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
          return;
        }
        request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
        if (request.method == 'HEAD') {
          request.response.headers.contentLength = media.length;
          await request.response.close();
          return;
        }
        final range = request.headers.value(HttpHeaders.rangeHeader);
        final match = RegExp(r'^bytes=(\d+)-(\d+)$').firstMatch(range ?? '');
        if (match == null) {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
          return;
        }
        originRanges.add(range!);
        final start = int.parse(match.group(1)!);
        final end = min(int.parse(match.group(2)!), media.length - 1);
        if (start == pieceSize) {
          secondPieceAttempts++;
          if (secondPieceAttempts == 1) {
            await secondHalfAllowed.future;
            final bytes = Uint8List.sublistView(
              media,
              start,
              min(start + 128, end + 1),
            );
            request.response.statusCode = HttpStatus.partialContent;
            request.response.headers.contentLength = end - start + 1;
            request.response.headers.set(
              HttpHeaders.contentRangeHeader,
              'bytes $start-$end/${media.length}',
            );
            final socket = await request.response.detachSocket();
            socket.add(bytes);
            await socket.flush();
            socket.destroy();
            return;
          }
        }
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.contentLength = end - start + 1;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes $start-$end/${media.length}',
        );
        final split = min(end + 1, pieceSize);
        if (start < split) {
          request.response.add(Uint8List.sublistView(media, start, split));
        }
        if (end + 1 > pieceSize) {
          await secondHalfAllowed.future;
          request.response.add(
            Uint8List.sublistView(media, max(start, pieceSize), end + 1),
          );
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async => null,
        peerMissingRetryDelay: const Duration(milliseconds: 10),
        progressiveOriginPeerRecoveryTimeout: const Duration(milliseconds: 80),
      );
      addTearDown(() async {
        if (!secondHalfAllowed.isCompleted) secondHalfAllowed.complete();
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/manifest.mpd',
        ),
        headers: const {},
        swarmId: 'sm2_dash_open_range',
        format: 'dash',
      );
      final document = XmlDocument.parse(await _getText(local));
      final mediaUri = Uri.parse(
        document
            .findAllElements('Representation')
            .single
            .childElements
            .singleWhere((element) => element.name.local == 'BaseURL')
            .innerText,
      );
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final request = await client.getUrl(mediaUri);
      request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-');

      final response = await request.close().timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw TimeoutException(
          'Gateway did not stream response headers; origin ranges: '
          '$originRanges, origin requests: $originRequests',
        ),
      );
      expect(response.statusCode, HttpStatus.partialContent);
      expect(
        response.headers.value(HttpHeaders.contentRangeHeader),
        'bytes 0-${media.length - 1}/${media.length}',
      );
      expect(originRanges, contains('bytes=0-${pieceSize - 1}'));
      secondHalfAllowed.complete();
      final builder = BytesBuilder(copy: false);
      await for (final chunk in response) {
        builder.add(chunk);
      }
      expect(builder.takeBytes(), media);
      expect(originRanges, isNot(contains('bytes=0-${media.length - 1}')));
      expect(secondPieceAttempts, 2);
    },
  );

  test('DASH open ranges contain later origin failures', () async {
    final pieceSize = P2pMediaEngine.progressivePieceSize;
    final media = Uint8List.fromList(
      List<int>.generate(pieceSize * 2, (index) => index % 251),
    );
    final secondPieceRequested = Completer<void>();
    final releaseSecondPiece = Completer<void>();
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.write(
          '<MPD><Period><AdaptationSet><Representation>'
          '<BaseURL>http://${origin.address.address}:${origin.port}/video.mp4'
          '</BaseURL>'
          '<SegmentBase indexRange="100-199">'
          '<Initialization range="0-99"/>'
          '</SegmentBase></Representation></AdaptationSet></Period></MPD>',
        );
        await request.response.close();
        return;
      }
      if (request.uri.path != '/video.mp4') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (request.method == 'HEAD') {
        request.response.headers.contentLength = media.length;
        await request.response.close();
        return;
      }
      final match = RegExp(r'^bytes=(\d+)-(\d+)$')
          .firstMatch(request.headers.value(HttpHeaders.rangeHeader) ?? '');
      if (match == null) {
        request.response.statusCode = HttpStatus.badRequest;
        await request.response.close();
        return;
      }
      final start = int.parse(match.group(1)!);
      final end = min(int.parse(match.group(2)!), media.length - 1);
      if (start >= pieceSize) {
        if (!secondPieceRequested.isCompleted) secondPieceRequested.complete();
        await releaseSecondPiece.future;
        request.response.statusCode = HttpStatus.serviceUnavailable;
        await request.response.close();
        return;
      }
      final bytes = Uint8List.sublistView(media, start, end + 1);
      request.response.statusCode = HttpStatus.partialContent;
      request.response.headers.contentLength = bytes.length;
      request.response.headers.set(
        HttpHeaders.contentRangeHeader,
        'bytes $start-$end/${media.length}',
      );
      request.response.add(bytes);
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    final client = HttpClient();
    addTearDown(() async {
      if (!releaseSecondPiece.isCompleted) releaseSecondPiece.complete();
      client.close(force: true);
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash_cancel_open_range',
      format: 'dash',
    );
    final document = XmlDocument.parse(await _getText(local));
    final mediaUri = Uri.parse(
      document
          .findAllElements('Representation')
          .single
          .childElements
          .singleWhere((element) => element.name.local == 'BaseURL')
          .innerText,
    );
    final request = await client.getUrl(mediaUri);
    request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-');
    final response = await request.close();
    final firstBodyBytes = Completer<void>();
    final responseFinished = Completer<Object?>();
    response.listen(
      (chunk) {
        if (chunk.isNotEmpty && !firstBodyBytes.isCompleted) {
          firstBodyBytes.complete();
        }
      },
      onError: (Object error) {
        if (!responseFinished.isCompleted) responseFinished.complete(error);
      },
      onDone: () {
        if (!responseFinished.isCompleted) responseFinished.complete();
      },
    );
    await firstBodyBytes.future.timeout(const Duration(seconds: 2));
    await secondPieceRequested.future.timeout(const Duration(seconds: 2));
    releaseSecondPiece.complete();
    expect(
      await responseFinished.future.timeout(const Duration(seconds: 2)),
      isA<HttpException>(),
    );
  });

  test('DASH open ranges return 502 when the first piece fails', () async {
    final mediaLength = P2pMediaEngine.progressivePieceSize * 2;
    var originAttempts = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.write(
          '<MPD><Period><AdaptationSet><Representation>'
          '<BaseURL>http://${origin.address.address}:${origin.port}/video.mp4'
          '</BaseURL>'
          '<SegmentBase indexRange="100-199">'
          '<Initialization range="0-99"/>'
          '</SegmentBase></Representation></AdaptationSet></Period></MPD>',
        );
        await request.response.close();
        return;
      }
      if (request.uri.path != '/video.mp4') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (request.method == 'HEAD') {
        request.response.headers.contentLength = mediaLength;
        await request.response.close();
        return;
      }
      originAttempts++;
      request.response.statusCode = HttpStatus.serviceUnavailable;
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash_first_piece_failure',
      format: 'dash',
    );
    final document = XmlDocument.parse(await _getText(local));
    final mediaUri = Uri.parse(
      document
          .findAllElements('Representation')
          .single
          .childElements
          .singleWhere((element) => element.name.local == 'BaseURL')
          .innerText,
    );

    final response = await _getResponse(mediaUri, range: 'bytes=0-');

    expect(response.statusCode, HttpStatus.badGateway);
    expect(response.contentRange, isNull);
    expect(response.bytes, isEmpty);
    expect(originAttempts, 3);
  });

  test('DASH gateway rewrites every external MPD URI form', () async {
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final originBase = 'http://${origin.address.address}:${origin.port}';
    origin.listen((request) async {
      if (request.uri.path == '/manifest.mpd') {
        request.response.headers.contentType = ContentType(
          'application',
          'dash+xml',
        );
        request.response.write('''
<MPD xmlns:xlink="http://www.w3.org/1999/xlink">
  <Location>$originBase/next.mpd</Location>
  <Period xlink:href="$originBase/period.xml">
    <AdaptationSet>
      <SegmentTemplate media="$originBase/video/seg-\$Number\$.m4s" initialization="$originBase/video/init.mp4" bitstreamSwitching="$originBase/video/switch.mp4" />
      <Representation>
        <SegmentList>
          <Initialization sourceURL="$originBase/video/list-init.mp4" />
          <SegmentURL media="$originBase/video/list-1.m4s" index="$originBase/video/list-1.idx" />
          <RepresentationIndex sourceURL="$originBase/video/representation.idx" />
          <BitstreamSwitching sourceURL="$originBase/video/bitstream.mp4" />
        </SegmentList>
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>
''');
      } else if (request.uri.path == '/next.mpd' ||
          request.uri.path == '/period.xml') {
        request.response.headers.contentType = ContentType(
          'application',
          'dash+xml',
        );
        request.response.write(
          '<Period><SegmentURL media="$originBase/video/nested.m4s" /></Period>',
        );
      } else {
        request.response.add([1, 2, 3]);
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse('$originBase/manifest.mpd'),
      headers: const {},
      swarmId: 'sm2_dash_uri_forms',
      format: 'dash',
    );

    final document = XmlDocument.parse(await _getText(local));
    final externalValues = <String>[
      document.findAllElements('Location').single.innerText,
      document.findAllElements('Period').single.getAttribute('xlink:href')!,
      for (final element in document.descendants.whereType<XmlElement>())
        for (final attribute in element.attributes)
          if (const {
            'media',
            'initialization',
            'bitstreamSwitching',
            'index',
            'sourceURL',
          }.contains(attribute.name.local))
            attribute.value,
    ];
    expect(externalValues, isNotEmpty);
    for (final value in externalValues) {
      expect(value, startsWith('http://127.0.0.1:'));
      expect(Uri.parse(value).port, isNot(origin.port));
    }

    final template = document
        .findAllElements('SegmentTemplate')
        .single
        .getAttribute('media')!;
    expect(template, contains(r'$Number$'));
    expect(
      await _getBytes(Uri.parse(template.replaceFirst(r'$Number$', '1'))),
      [1, 2, 3],
    );
    final nested = XmlDocument.parse(
      await _getText(
        Uri.parse(document.findAllElements('Location').single.innerText),
      ),
    );
    final nestedMedia = nested
        .findAllElements('SegmentURL')
        .single
        .getAttribute('media')!;
    expect(nestedMedia, startsWith('http://127.0.0.1:'));
    expect(Uri.parse(nestedMedia).port, isNot(origin.port));
  });

  test('DASH gateway preserves relative nested BaseURL candidates', () async {
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.write(
        '<MPD><BaseURL>primary/</BaseURL><BaseURL>backup/</BaseURL>'
        '<Period><BaseURL>video/</BaseURL><BaseURL>audio/</BaseURL>'
        '</Period></MPD>',
      );
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/root/manifest.mpd',
      ),
      headers: const {},
      swarmId: 'sm2_dash_base_candidates',
      format: 'dash',
    );

    final document = XmlDocument.parse(await _getText(local));
    final periodBaseUrls = document
        .findAllElements('Period')
        .single
        .childElements
        .where((element) => element.name.local == 'BaseURL')
        .map((element) => element.innerText)
        .toList();
    expect(periodBaseUrls, ['video/', 'audio/']);
  });

  test('progressive length metadata can arrive from a peer first', () async {
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      // Keep the origin header phase pending; the peer owns both metadata and data.
    });
    final lengthBytes = encodeP2pResourceLength(4);
    final requestedPieces = <String>[];
    final engine = P2pMediaEngine(
      originHeaderPeerRetryDelay: const Duration(milliseconds: 20),
      requestPeerPiece: (swarm, key, cancellation) async {
        requestedPieces.add(key);
        if (key == 'root:length') return _peerPiece(lengthBytes);
        if (key == 'root:piece:0') return _peerPiece([4, 3, 2, 1]);
        return null;
      },
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/slow.mp4',
      ),
      headers: const {},
      swarmId: 'sm2_peer_length',
      format: 'mp4',
    );

    final response = await _getResponse(local, range: 'bytes=0-3');

    expect(response.statusCode, HttpStatus.partialContent);
    expect(response.bytes, [4, 3, 2, 1]);
    expect(requestedPieces, containsAll(['root:length', 'root:piece:0']));
  });

  test('progressive length metadata survives piece LRU pressure', () async {
    const body = [4, 3, 2, 1];
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      if (request.method == 'HEAD') {
        request.response.headers.contentLength = body.length;
      } else {
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.contentLength = body.length;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes 0-3/${body.length}',
        );
        request.response.add(body);
      }
      await request.response.close();
    });
    final cacheDirectory = await Directory.systemTemp.createTemp(
      'synctv-p2p-length-cache-',
    );
    final cache = P2pMediaPersistentCache(
      directory: cacheDirectory,
      maxBytes: 9,
      cleanupInterval: Duration.zero,
    );
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
      persistentCache: cache,
      maxCacheBytes: 9,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
      await cacheDirectory.delete(recursive: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/video.mp4',
      ),
      headers: const {},
      swarmId: 'sm2_length_recovery',
      format: 'mp4',
    );

    expect((await _getResponse(local, range: 'bytes=0-3')).bytes, body);
    final restored = await engine.cachedPiece(
      'sm2_length_recovery',
      'root:length',
    );
    expect(restored, isNotNull);
    expect(ByteData.sublistView(restored!).getUint64(0), body.length);
    expect(restored[8], 1);
  });

  test(
    'offline origin waits for a cold peer and serves progressive HEAD',
    () async {
      final unavailableOrigin = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      unavailableOrigin.listen((socket) => socket.destroy());
      final upstream = Uri.parse(
        'http://${unavailableOrigin.address.address}:'
        '${unavailableOrigin.port}/video.mp4',
      );

      final body = Uint8List.fromList([4, 3, 2, 1]);
      final lengthBytes = encodeP2pResourceLength(body.length);
      var lengthRequests = 0;
      final engine = P2pMediaEngine(
        originHeaderPeerRetryDelay: const Duration(milliseconds: 10),
        originHeaderTimeout: const Duration(milliseconds: 250),
        peerMissingRetryDelay: const Duration(milliseconds: 10),
        requestPeerPiece: (swarm, key, cancellation) async {
          if (key == 'root:length') {
            lengthRequests++;
            return lengthRequests == 1 ? null : _peerPiece(lengthBytes);
          }
          if (key == 'root') return _peerPiece(body);
          return null;
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await unavailableOrigin.close();
      });
      final local = await engine.localize(
        upstream: upstream,
        headers: const {},
        swarmId: 'sm2_cold_peer',
        format: 'mp4',
      );

      final head = await _headResponse(local);
      expect(head.statusCode, HttpStatus.ok);
      expect(head.contentLength, body.length);
      expect(head.acceptRanges, 'bytes');
      expect(await _getBytes(local), body);
      expect(lengthRequests, 2);
      expect(engine.stats.value.p2pBytes, body.length + lengthBytes.length);
    },
  );

  test(
    'large HLS segments stream from origin beyond the cache piece limit',
    () async {
      final segment = Uint8List(16 * 1024 * 1024 + 1);
      segment[segment.length - 1] = 7;
      var segmentRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        if (request.uri.path == '/manifest.m3u8') {
          request.response.write('#EXTM3U\n#EXTINF:10,\nsegment.ts\n');
        } else if (request.uri.path == '/segment.ts') {
          segmentRequests++;
          request.response.headers.contentLength = segment.length;
          request.response.add(segment);
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/manifest.m3u8',
        ),
        headers: const {},
        swarmId: 'sm2_large_hls_segment',
        format: 'hls',
      );
      final manifest = await _getText(local);
      final segmentUrl = Uri.parse(
        manifest
            .split('\n')
            .firstWhere((line) => line.isNotEmpty && !line.startsWith('#')),
      );

      final bytes = await _getBytes(segmentUrl);

      expect(bytes, hasLength(segment.length));
      expect(bytes.last, 7);
      expect(segmentRequests, 2);
    },
  );

  test(
    'small static resources are shared when the origin ignores Range',
    () async {
      const body = [1, 3, 3, 7];
      var getRequests = 0;
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentLength = body.length;
        if (request.method == 'GET') {
          getRequests++;
          request.response.add(body);
        }
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async => null,
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/subtitle.vtt',
        ),
        headers: const {},
        swarmId: 'sm2_static',
        format: 'vtt',
      );

      expect(await _getBytes(local), body);
      expect(await _getBytes(local), body);
      expect(getRequests, 1);
      expect(engine.stats.value.cacheHits, greaterThan(0));
    },
  );

  test('large progressive GET responses use shareable pieces', () async {
    final body = Uint8List.fromList(
      List<int>.generate(16 * 1024 * 1024 + 1, (index) => index % 251),
    );
    var getRequests = 0;
    final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    origin.listen((request) async {
      request.response.headers.contentLength = body.length;
      request.response.headers.contentType = ContentType('video', 'x-flv');
      if (request.method == 'GET') {
        getRequests++;
        request.response.add(body);
      }
      await request.response.close();
    });
    final engine = P2pMediaEngine(
      requestPeerPiece: (swarm, key, cancellation) async => null,
    );
    addTearDown(() async {
      await engine.dispose();
      await origin.close(force: true);
    });
    final local = await engine.localize(
      upstream: Uri.parse(
        'http://${origin.address.address}:${origin.port}/archive.flv',
      ),
      headers: const {},
      swarmId: 'sm2_flv',
      format: 'flv',
    );

    expect(await _getBytes(local), body);
    expect(await _getBytes(local), body);
    expect(getRequests, 1);
    expect(engine.stats.value.cacheBytes, body.length + 9);
  });

  test(
    'progressive playback prefetches the next two pieces from peers',
    () async {
      final body = Uint8List.fromList(
        List<int>.generate(16 * 1024 * 1024 + 1, (index) => index % 251),
      );
      final peerPieces = <String>[];
      final originRangeStarts = <int>[];
      final origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      origin.listen((request) async {
        request.response.headers.contentType = ContentType('video', 'mp4');
        if (request.method == 'HEAD') {
          request.response.headers.contentLength = body.length;
          await request.response.close();
          return;
        }
        final range = request.headers.value(HttpHeaders.rangeHeader);
        final match = RegExp(r'^bytes=(\d+)-(\d+)$').firstMatch(range ?? '');
        if (match == null) {
          request.response.statusCode = HttpStatus.badRequest;
          await request.response.close();
          return;
        }
        final start = int.parse(match.group(1)!);
        final requestedEnd = int.parse(match.group(2)!);
        final end = min(requestedEnd, body.length - 1);
        final bytes = Uint8List.sublistView(body, start, end + 1);
        originRangeStarts.add(start);
        request.response.statusCode = HttpStatus.partialContent;
        request.response.headers.contentLength = bytes.length;
        request.response.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes $start-$end/${body.length}',
        );
        request.response.add(bytes);
        await request.response.close();
      });
      final engine = P2pMediaEngine(
        requestPeerPiece: (swarm, key, cancellation) async {
          peerPieces.add(key);
          final match = RegExp(r':piece:(\d+)$').firstMatch(key);
          final index = int.tryParse(match?.group(1) ?? '') ?? -1;
          if (index != 1 && index != 2) return null;
          final start = index * P2pMediaEngine.progressivePieceSize;
          final end = min(
            start + P2pMediaEngine.progressivePieceSize,
            body.length,
          );
          return _peerPiece(Uint8List.sublistView(body, start, end));
        },
      );
      addTearDown(() async {
        await engine.dispose();
        await origin.close(force: true);
      });
      final local = await engine.localize(
        upstream: Uri.parse(
          'http://${origin.address.address}:${origin.port}/video.mp4',
        ),
        headers: const {},
        swarmId: 'sm1_progressive_prefetch',
        format: 'mp4',
      );

      expect(await _getBytes(local), body);
      expect(peerPieces, contains('root:piece:1'));
      expect(peerPieces, contains('root:piece:2'));
      expect(
        peerPieces.where(
          (key) => key == 'root:piece:1' || key == 'root:piece:2',
        ),
        ['root:piece:1', 'root:piece:2'],
      );
      expect(
        originRangeStarts,
        isNot(contains(P2pMediaEngine.progressivePieceSize)),
      );
      expect(
        originRangeStarts,
        isNot(contains(P2pMediaEngine.progressivePieceSize * 2)),
      );
      expect(
        engine.stats.value.p2pBytes,
        P2pMediaEngine.progressivePieceSize * 2,
      );
    },
  );
}

Future<String> _getText(Uri uri) async => utf8.decode(await _getBytes(uri));

Future<Uint8List> _getBytes(Uri uri, {String? range}) async {
  return (await _getResponse(uri, range: range)).bytes;
}

Future<
  ({int statusCode, String? contentRange, String? contentType, Uint8List bytes})
>
_getResponse(Uri uri, {String? range}) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    if (range != null) request.headers.set(HttpHeaders.rangeHeader, range);
    final response = await request.close();
    final builder = BytesBuilder(copy: false);
    await for (final chunk in response) {
      builder.add(chunk);
    }
    return (
      statusCode: response.statusCode,
      contentRange: response.headers.value(HttpHeaders.contentRangeHeader),
      contentType: response.headers.contentType?.mimeType,
      bytes: builder.takeBytes(),
    );
  } finally {
    client.close(force: true);
  }
}

Future<({int statusCode, int contentLength, String? acceptRanges})>
_headResponse(Uri uri) async {
  final client = HttpClient();
  try {
    final request = await client.headUrl(uri);
    final response = await request.close();
    await response.drain<void>();
    return (
      statusCode: response.statusCode,
      contentLength: response.contentLength,
      acceptRanges: response.headers.value(HttpHeaders.acceptRangesHeader),
    );
  } finally {
    client.close(force: true);
  }
}
