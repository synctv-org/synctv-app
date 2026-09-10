import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/http_danmaku_source.dart';

void main() {
  test(
    'HTTP danmaku dispatches complete chat events without provider errors',
    () async {
      final payload = await File('tool/fixtures/danmaku-events.txt')
          .readAsString();
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final subscription = server.listen((request) async {
        expect(request.headers.value('accept'), 'text/event-stream');
        request.response.headers.contentType = ContentType(
          'text',
          'event-stream',
        );
        request.response.write(payload);
        await request.response.close();
      });
      addTearDown(() async {
        await server.close(force: true);
        await subscription.cancel();
      });
      final messages = await const HttpDanmakuSource()
          .openEventStream(Uri.parse('http://127.0.0.1:${server.port}/events'))
          .toList();
      expect(messages, [
        '{"message":"First chat"}',
        '{"message":"Compact chat"}',
        '{"message":\n"Multiline chat"}',
      ]);
    },
  );
}
