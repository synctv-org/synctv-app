import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/danmaku/acfun_danmaku_codec.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';

void main() {
  group('decodeAcFunDanmakuDocument', () {
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
