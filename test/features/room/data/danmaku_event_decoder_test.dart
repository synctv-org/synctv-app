import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/danmaku_event_decoder.dart';

Future<List<String>> decode(String text) => decodeDanmakuEvents(
  Stream.fromIterable(utf8.encode(text).map((byte) => [byte])),
).toList();

void main() {
  test(
    'UTF-8 and CRLF split across byte chunks retain complete data',
    () async {
      expect(
        await decode(
          '\uFEFF: heartbeat\r\nevent: danmaku\r\n'
          'data:{"message":\r\ndata: "你好 👋"}\r\n\r\n',
        ),
        ['{"message":\n"你好 👋"}'],
      );
    },
  );

  test('error type is scoped to its event and may follow its data', () async {
    expect(
      await decode(
        'data: hidden\nevent: error\n\n'
        'data: visible\n\n',
      ),
      ['visible'],
    );
  });

  test('one optional space is removed and empty data is retained', () async {
    expect(await decode('data:  padded \ndata\ndata:\n\n'), [' padded \n\n']);
  });

  test('comments and metadata cannot dispatch empty events', () async {
    expect(await decode(': heartbeat\nid: 3\nretry: 100\n\n'), isEmpty);
  });

  test('unterminated data is discarded at end of stream', () async {
    expect(await decode('data: complete\n\ndata: incomplete\n'), ['complete']);
  });
}
