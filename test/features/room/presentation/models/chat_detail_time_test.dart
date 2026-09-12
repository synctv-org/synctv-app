import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/models/chat_detail_time.dart';

void main() {
  test('formats a valid timestamp using local time with zero padding', () {
    final seconds = DateTime(2024, 3, 4, 5, 6).millisecondsSinceEpoch ~/ 1000;
    expect(formatChatDetailTime(seconds), '03-04 05:06');
  });

  for (final seconds in [0, -1, 8640000000001, 9007199254740991]) {
    test('omits unsupported timestamp $seconds', () {
      expect(formatChatDetailTime(seconds), isNull);
    });
  }

  test(
    'supports the positive DateTime boundary without multiplication overflow',
    () {
      expect(formatChatDetailTime(8640000000000), isNotNull);
    },
  );
}
