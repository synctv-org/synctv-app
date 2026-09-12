import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/danmaku/acfun_danmaku_codec.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';

void main() {
  group('decodeAcFunDanmakuDocument', () {
    test('invalid numeric fields do not discard valid sibling comments', () {
      final items = decodeAcFunDanmakuDocument('''{"comments":[
        {"text":"before","positionMs":0},
        {"text":"overflow position","positionMs":1e999},
        {"text":"invalid optional fields","positionMs":1000,"mode":1e999,"size":-1e999},
        {"text":"after","positionMs":2000}
      ]}''');
      expect(items!.map((item) => item.text), [
        'before',
        'invalid optional fields',
        'after',
      ]);
      expect(items[1].type, DanmakuType.floating);
      expect(items[1].fontSize, 25);
    });

    test('rejects timestamps that cannot form a portable duration', () {
      final items = decodeAcFunDanmakuDocument('''{"comments":[
        {"text":"native overflow","positionMs":"9223372036854775807"},
        {"text":"web precision loss","positionMs":9007199254740991},
        {"text":"normal","positionMs":"3600000"}
      ]}''');
      expect(items!.map((item) => item.text), ['normal']);
      expect(items.single.startTime, const Duration(hours: 1));
    });

    test('maps timing, color, size and fixed modes', () {
      final items = decodeAcFunDanmakuDocument('''
        {
          "version": 1,
          "comments": [
            {"text":"floating","positionMs":1500,"color":"#12ABEF","mode":1,"size":30},
            {"text":"top","positionMs":2500,"color":"FFFFFF","mode":5,"size":25}
          ]
        }
      ''');

      expect(items, hasLength(2));
      expect(items![0].startTime, const Duration(milliseconds: 1500));
      expect(items[0].color.toARGB32(), 0xFF12ABEF);
      expect(items[0].fontSize, 30);
      expect(items[0].type, DanmakuType.floating);
      expect(items[1].type, DanmakuType.top);
      expect(items[1].endTime - items[1].startTime, const Duration(seconds: 4));
    });

    test('returns null for unrelated formats', () {
      expect(decodeAcFunDanmakuDocument('<i><d p="1">text</d></i>'), isNull);
      expect(decodeAcFunDanmakuDocument('{"items":[]}'), isNull);
    });

    test('skips malformed comments', () {
      final items = decodeAcFunDanmakuDocument(
        '{"comments":[{"text":""},{"text":"ok","positionMs":0}]}',
      );
      expect(items, hasLength(1));
      expect(items!.single.text, 'ok');
    });

    test('returns a mutable list for controller lifecycle updates', () {
      final items = decodeAcFunDanmakuDocument(
        '{"comments":[{"text":"first","positionMs":0}]}',
      );

      expect(items, hasLength(1));
      items!.clear();
      expect(items, isEmpty);
    });
  });
}
