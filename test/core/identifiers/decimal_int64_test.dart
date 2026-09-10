import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/identifiers/decimal_int64.dart';

void main() {
  test(
    'long inputs retain zero padding semantics and reject oversized IDs',
    () {
      final zeroes = '0' * 100000;
      final cases = <String, String?>{
        '${zeroes}9007199254740993': '9007199254740993',
        '${zeroes}9223372036854775807': '9223372036854775807',
        '${zeroes}9223372036854775808': null,
        '${zeroes}x': null,
        '9' * 100000: null,
      };
      for (final entry in cases.entries) {
        expect(normalizeInt64Decimal(entry.key), entry.value);
      }
      expect(normalizeInt64Decimal(zeroes), isNull);
      expect(normalizeInt64Decimal(zeroes, allowZero: true), '0');
    },
  );

  test('fixed-width comparison preserves decimal boundaries', () {
    final maximum = BigInt.parse('9223372036854775807');
    for (var delta = -50; delta <= 50; delta++) {
      final value = maximum + BigInt.from(delta);
      for (final prefix in ['', '000']) {
        expect(
          normalizeInt64Decimal('$prefix$value'),
          delta <= 0 ? '$value' : null,
        );
      }
    }
    for (final value in ['１２３', '١٢٣', '1\u00002', '000x', '0001 2']) {
      expect(normalizeInt64Decimal(value, allowZero: true), isNull);
    }
  });

  test('decimal IDs preserve precision and canonicalize leading zeroes', () {
    expect(normalizeInt64Decimal(' 0009007199254740993 '), '9007199254740993');
    expect(normalizeInt64Decimal('9223372036854775807'), '9223372036854775807');
    expect(normalizeInt64Decimal('000', allowZero: true), '0');
    expect(normalizeInt64Decimal('1'), '1');
  });
  test('invalid or out-of-range decimal IDs are rejected', () {
    for (final value in [
      '',
      ' ',
      '0',
      '-1',
      '+1',
      '0x10',
      '1.0',
      '1e3',
      '9223372036854775808',
      '18446744073709551615',
    ]) {
      expect(normalizeInt64Decimal(value), isNull, reason: value);
    }
  });
}
