import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';

void main() {
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
      final controller = DanmakuController();
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
}

Future<void> _waitFor(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (predicate()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('Condition was not met before timeout');
}
