import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/format/formatters.dart';

void main() {
  group('formatBytes', () {
    test('keeps whole numbers for the byte unit', () {
      expect(formatBytes(0), '0 B');
      expect(formatBytes(512), '512 B');
      expect(formatBytes(1023), '1023 B');
    });

    test('uses one decimal below 100 of the active unit', () {
      expect(formatBytes(1024), '1.0 KiB');
      expect(formatBytes(1536), '1.5 KiB');
      expect(formatBytes(1024 * 1024 * 1.5), '1.5 MiB');
    });

    test('drops the decimal at 100 and above of the active unit', () {
      expect(formatBytes(1024 * 512), '512 KiB');
      expect(formatBytes(1024 * 1024 * 123), '123 MiB');
    });

    test('caps at the highest unit', () {
      final fiveTiB = 1024.0 * 1024 * 1024 * 1024 * 5;
      expect(formatBytes(fiveTiB), '5.0 TiB');
      final hugeTiB = 1024.0 * 1024 * 1024 * 1024 * 1234;
      expect(formatBytes(hugeTiB), '1234 TiB');
    });
  });

  group('formatTimestampSeconds', () {
    test('renders non-positive values as a dash', () {
      expect(formatTimestampSeconds(0), '-');
      expect(formatTimestampSeconds(-5), '-');
    });

    test('formats epoch seconds as yyyy-MM-dd HH:mm in the local zone', () {
      final date = DateTime(2026, 11, 18, 9, 5);
      final seconds = date.millisecondsSinceEpoch ~/ 1000;
      expect(formatTimestampSeconds(seconds), '2026-11-18 09:05');
    });

    test('zero-pads single digit components', () {
      final date = DateTime(2026, 1, 2, 3, 4);
      final seconds = date.millisecondsSinceEpoch ~/ 1000;
      expect(formatTimestampSeconds(seconds), '2026-01-02 03:04');
    });
  });
}
