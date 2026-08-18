import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/features/room/application/danmaku_source.dart';
import 'package:synctv_app/features/room/data/http_danmaku_source.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/domain/playback_resource_localizer.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/features/room/presentation/widgets/custom_video_player.dart';

final class _ControlledDanmakuSource implements DanmakuSource {
  final documents = <Uri, Completer<String?>>{};
  final documentHeaders = <Uri, Map<String, String>>{};
  final eventStreams = <Uri>[];
  final eventHeaders = <Map<String, String>>[];

  @override
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  }) {
    documentHeaders[uri] = Map<String, String>.from(headers);
    return documents.putIfAbsent(uri, Completer<String?>.new).future;
  }

  @override
  Stream<String> openEventStream(
    Uri uri, {
    Map<String, String> headers = const {},
  }) {
    eventStreams.add(uri);
    eventHeaders.add(Map<String, String>.from(headers));
    return const Stream.empty();
  }
}

final class _EventDanmakuSource implements DanmakuSource {
  final events = StreamController<String>();

  @override
  Future<String?> loadDocument(
    Uri uri, {
    Map<String, String> headers = const {},
  }) async => null;

  @override
  Stream<String> openEventStream(
    Uri uri, {
    Map<String, String> headers = const {},
  }) => events.stream;
}

void main() {
  test('clearing a media timeline removes video and chat danmaku', () {
    final controller = DanmakuController(_ControlledDanmakuSource());
    addTearDown(controller.dispose);
    controller.addItems(const [
      DanmakuItem(
        text: 'video comment',
        startTime: Duration.zero,
        endTime: Duration(seconds: 8),
        color: Color(0xFFFFFFFF),
      ),
      DanmakuItem(
        text: 'room chat',
        startTime: Duration.zero,
        endTime: Duration(seconds: 8),
        color: Color(0xFFFFFFFF),
        origin: DanmakuOrigin.chat,
      ),
    ]);

    controller.clear();

    expect(controller.items, isEmpty);
  });

  test(
    'static video danmaku loading preserves concurrent chat danmaku',
    () async {
      final source = _ControlledDanmakuSource();
      final controller = DanmakuController(source);
      addTearDown(controller.dispose);
      final uri = Uri.parse('https://example.com/video.xml');

      controller.updateConfig(danmakuUrl: uri.toString());
      await Future<void>.delayed(Duration.zero);
      controller.add(
        const DanmakuItem(
          text: 'room chat',
          startTime: Duration(seconds: 1),
          endTime: Duration(seconds: 9),
          color: Color(0xFFFFFFFF),
          origin: DanmakuOrigin.chat,
        ),
      );
      source.documents[uri]!.complete(
        '<i><d p="2,1,25,16777215">video comment</d></i>',
      );

      await _waitFor(() => controller.items.length == 2);
      expect(
        controller.items.map((item) => (item.text, item.origin)),
        containsAll([
          ('room chat', DanmakuOrigin.chat),
          ('video comment', DanmakuOrigin.video),
        ]),
      );
    },
  );

  test('a completed old document cannot replace the current source', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);

    controller.updateConfig(danmakuUrl: 'https://example.com/old.xml');
    controller.updateConfig(danmakuUrl: 'https://example.com/current.xml');
    await Future<void>.delayed(Duration.zero);

    source.documents[Uri.parse('https://example.com/current.xml')]!.complete(
      '<i><d p="2,1,25,16777215">current</d></i>',
    );
    await _waitFor(() => controller.items.singleOrNull?.text == 'current');
    source.documents[Uri.parse('https://example.com/old.xml')]!.complete(
      '<i><d p="1,1,25,16777215">old</d></i>',
    );
    await Future<void>.delayed(Duration.zero);

    expect(controller.items.single.text, 'current');
  });

  test(
    'a refreshed static document waits for the next resource selection',
    () async {
      final source = _ControlledDanmakuSource();
      final controller = DanmakuController(source);
      addTearDown(controller.dispose);

      controller.updateConfig(danmakuUrl: 'https://example.com/old.xml');
      await Future<void>.delayed(Duration.zero);
      source.documents[Uri.parse('https://example.com/old.xml')]!.complete(
        '<i><d p="1,1,25,16777215">downloaded</d></i>',
      );
      await _waitFor(() => controller.items.singleOrNull?.text == 'downloaded');

      controller.updateConfig(
        danmakuUrl: 'https://example.com/refreshed.xml',
        preserveLoadedDocument: true,
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        source.documents,
        isNot(contains(Uri.parse('https://example.com/refreshed.xml'))),
      );
      expect(controller.items.single.text, 'downloaded');

      controller.updateConfig(danmakuUrl: 'https://example.com/refreshed.xml');
      await Future<void>.delayed(Duration.zero);
      source.documents[Uri.parse('https://example.com/refreshed.xml')]!
          .complete('<i><d p="1,1,25,16777215">refreshed</d></i>');
      await _waitFor(() => controller.items.singleOrNull?.text == 'refreshed');
    },
  );

  test('a refresh replaces an in-flight static document request', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);

    final oldUrl = Uri.parse('https://example.com/old.xml');
    final latestUrl = Uri.parse('https://example.com/latest.xml');
    controller.updateConfig(danmakuUrl: oldUrl.toString());
    await Future<void>.delayed(Duration.zero);
    controller.updateConfig(
      danmakuUrl: latestUrl.toString(),
      preserveLoadedDocument: true,
    );
    await Future<void>.delayed(Duration.zero);

    expect(source.documents, containsPair(oldUrl, isA<Completer<String?>>()));
    expect(
      source.documents,
      containsPair(latestUrl, isA<Completer<String?>>()),
    );
    source.documents[latestUrl]!.complete(
      '<i><d p="2,1,25,16777215">latest</d></i>',
    );
    await _waitFor(() => controller.items.singleOrNull?.text == 'latest');
    source.documents[oldUrl]!.complete('<i><d p="1,1,25,16777215">old</d></i>');
    await Future<void>.delayed(Duration.zero);

    expect(controller.items.single.text, 'latest');
  });

  test(
    'a refresh retries a failed static document with its latest URL',
    () async {
      final source = _ControlledDanmakuSource();
      final controller = DanmakuController(source);
      addTearDown(controller.dispose);

      final failedUrl = Uri.parse('https://example.com/failed.xml');
      final latestUrl = Uri.parse('https://example.com/latest.xml');
      controller.updateConfig(danmakuUrl: failedUrl.toString());
      await Future<void>.delayed(Duration.zero);
      source.documents[failedUrl]!.complete(null);
      await Future<void>.delayed(Duration.zero);

      controller.updateConfig(
        danmakuUrl: latestUrl.toString(),
        preserveLoadedDocument: true,
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        source.documents,
        containsPair(latestUrl, isA<Completer<String?>>()),
      );
    },
  );

  test('static danmaku uses its server-approved P2P delivery', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);
    const delivery = P2pResourceDelivery(
      swarmId: 'sm3_danmaku',
      swarmTicket: 'ticket',
    );
    var localizedCalls = 0;
    P2pResourceDelivery? localizedDelivery;
    final localizedUri = Uri.parse('http://127.0.0.1:43210/root');

    controller.updateConfig(
      danmakuUrl: 'https://origin.example/danmaku.xml',
      danmakuHeaders: const {'Authorization': 'Bearer origin'},
      danmakuP2pDelivery: delivery,
      localizeStaticResource: (url, headers, candidate) async {
        localizedCalls++;
        localizedDelivery = candidate;
        return LocalizedPlaybackResource(uri: localizedUri);
      },
    );
    await _waitFor(() => source.documents.containsKey(localizedUri));

    expect(localizedCalls, 1);
    expect(localizedDelivery, same(delivery));
    expect(source.documentHeaders[localizedUri], isEmpty);
    source.documents[localizedUri]!.complete(
      '<i><d p="1,1,25,16777215">localized</d></i>',
    );
    await _waitFor(() => controller.items.singleOrNull?.text == 'localized');
  });

  test('static danmaku without P2P delivery loads from its origin', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);
    var localizedCalls = 0;
    final originUri = Uri.parse('https://origin.example/danmaku.xml');
    const originHeaders = {'Authorization': 'Bearer origin'};

    controller.updateConfig(
      danmakuUrl: originUri.toString(),
      danmakuHeaders: originHeaders,
      localizeStaticResource: (url, headers, delivery) async {
        localizedCalls++;
        return LocalizedPlaybackResource(uri: Uri.parse(url));
      },
    );
    await _waitFor(() => source.documents.containsKey(originUri));

    expect(localizedCalls, 0);
    expect(source.documentHeaders[originUri], originHeaders);
    source.documents[originUri]!.complete(
      '<i><d p="1,1,25,16777215">origin</d></i>',
    );
    await _waitFor(() => controller.items.singleOrNull?.text == 'origin');
  });

  test('loads labelled and unlabelled compressed danmaku documents', () async {
    const document = '<i><d p="1,1,25,16777215">compressed</d></i>';
    final compressedDocuments = <String, List<int>>{
      '/gzip': gzip.encode(utf8.encode(document)),
      '/zlib': ZLibEncoder().convert(utf8.encode(document)),
      '/raw-deflate': ZLibEncoder(raw: true).convert(utf8.encode(document)),
      '/unlabelled-raw-deflate': ZLibEncoder(
        raw: true,
      ).convert(utf8.encode(document)),
    };
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final serverSubscription = server.listen((request) async {
      request.response.headers.set(
        HttpHeaders.contentTypeHeader,
        'text/xml; charset=utf-8',
      );
      final contentEncoding = switch (request.uri.path) {
        '/gzip' => 'gzip',
        '/unlabelled-raw-deflate' => null,
        _ => 'deflate',
      };
      if (contentEncoding != null) {
        request.response.headers.set(
          HttpHeaders.contentEncodingHeader,
          contentEncoding,
        );
      }
      request.response.add(compressedDocuments[request.uri.path]!);
      await request.response.close();
    });
    addTearDown(() async {
      await serverSubscription.cancel();
      await server.close(force: true);
    });

    for (final path in compressedDocuments.keys) {
      final result = await const HttpDanmakuSource().loadDocument(
        Uri.parse('http://127.0.0.1:${server.port}$path'),
      );

      expect(result, document);
    }
  });

  test('real-time danmaku bypasses static P2P localization', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);
    var localizedCalls = 0;

    controller.updateConfig(
      streamDanmakuUrl: 'https://origin.example/live-danmaku',
      localizeStaticResource: (url, headers, delivery) async {
        localizedCalls++;
        return LocalizedPlaybackResource(uri: Uri.parse(url));
      },
    );
    await Future<void>.delayed(Duration.zero);

    expect(localizedCalls, 0);
    expect(source.eventStreams, [
      Uri.parse('https://origin.example/live-danmaku'),
    ]);
  });

  test('Bilibili live SSE message events become danmaku', () async {
    final source = _EventDanmakuSource();
    final controller = DanmakuController(source);
    final videoController =
        VideoPlayerController.networkUrl(
            Uri.parse('https://example.com/live.m3u8'),
          )
          ..value = const VideoPlayerValue(
            duration: Duration.zero,
            isInitialized: true,
            position: Duration(seconds: 12),
          );
    addTearDown(() async {
      controller.dispose();
      await source.events.close();
      await videoController.dispose();
    });

    controller.updateConfig(
      streamDanmakuUrl: 'https://example.com/bilibili-live-danmaku',
      controller: videoController,
    );
    await Future<void>.delayed(Duration.zero);
    source.events.add('{"message":"Bilibili chat"}');

    await _waitFor(
      () => controller.items.singleOrNull?.text == 'Bilibili chat',
    );
    expect(controller.items.single.startTime, const Duration(seconds: 12));
  });

  test('updated stream credentials reconnect the SSE source', () async {
    final source = _ControlledDanmakuSource();
    final controller = DanmakuController(source);
    addTearDown(controller.dispose);

    const url =
        'https://synctv.example/api/playback-providers/room/bilibili/live-danmaku/media';
    controller.updateConfig(
      streamDanmakuUrl: url,
      streamDanmakuHeaders: const {'authorization': 'Bearer expired'},
    );
    await Future<void>.delayed(Duration.zero);

    controller.updateConfig(
      streamDanmakuUrl: url,
      streamDanmakuHeaders: const {'authorization': 'Bearer refreshed'},
    );
    await Future<void>.delayed(Duration.zero);

    expect(source.eventStreams, [Uri.parse(url), Uri.parse(url)]);
    expect(source.eventHeaders, const [
      {'authorization': 'Bearer expired'},
      {'authorization': 'Bearer refreshed'},
    ]);
  });

  test(
    'replacing an SSE stream ignores completion from the old stream',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final requestCounts = <String, int>{};
      final firstStreamReady = Completer<void>();
      final serverSubscription = server.listen((request) async {
        requestCounts.update(
          request.uri.path,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
        request.response.headers.contentType = ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        );
        request.response.write(': connected\n\n');
        await request.response.flush();
        if (request.uri.path == '/first') {
          firstStreamReady.complete();
          Timer(const Duration(milliseconds: 500), () {
            unawaited(request.response.close());
          });
        }
      });
      final controller = DanmakuController(const HttpDanmakuSource());
      addTearDown(() async {
        controller.dispose();
        await server.close(force: true);
        await serverSubscription.cancel();
      });

      controller.updateConfig(
        streamDanmakuUrl: 'http://127.0.0.1:${server.port}/first',
      );
      await firstStreamReady.future.timeout(const Duration(seconds: 2));

      controller.updateConfig(
        streamDanmakuUrl: 'http://127.0.0.1:${server.port}/second',
      );
      await _waitFor(() => requestCounts['/second'] == 1);
      await Future<void>.delayed(const Duration(milliseconds: 3500));

      expect(requestCounts['/first'], 1);
      expect(requestCounts['/second'], 1);
    },
  );

  test('an expired SSE signature requests fresh playback once', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var requestCount = 0;
    final serverSubscription = server.listen((request) async {
      requestCount++;
      request.response.statusCode = HttpStatus.unauthorized;
      await request.response.close();
    });
    final accessExpired = Completer<void>();
    final controller = DanmakuController(
      const HttpDanmakuSource(),
      onStreamAccessExpired: () {
        if (!accessExpired.isCompleted) accessExpired.complete();
      },
    );
    addTearDown(() async {
      controller.dispose();
      await serverSubscription.cancel();
      await server.close(force: true);
    });

    controller.updateConfig(
      streamDanmakuUrl: 'http://127.0.0.1:${server.port}/expired',
    );
    await accessExpired.future.timeout(const Duration(seconds: 2));
    await Future<void>.delayed(const Duration(milliseconds: 3500));

    expect(requestCount, 1);
  });

  test(
    'a forbidden SSE stream stops without refreshing or reconnecting',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var requestCount = 0;
      var accessRefreshCount = 0;
      final serverSubscription = server.listen((request) async {
        requestCount++;
        request.response.statusCode = HttpStatus.forbidden;
        await request.response.close();
      });
      final controller = DanmakuController(
        const HttpDanmakuSource(),
        onStreamAccessExpired: () {
          accessRefreshCount++;
        },
      );
      addTearDown(() async {
        controller.dispose();
        await serverSubscription.cancel();
        await server.close(force: true);
      });

      controller.updateConfig(
        streamDanmakuUrl: 'http://127.0.0.1:${server.port}/forbidden',
      );
      await _waitFor(() => requestCount == 1);
      await Future<void>.delayed(const Duration(milliseconds: 3500));

      expect(accessRefreshCount, 0);
      expect(requestCount, 1);
    },
  );
}

Future<void> _waitFor(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (predicate()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('Condition was not met before timeout');
}
