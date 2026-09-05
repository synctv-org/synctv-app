import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_length_metadata.dart';

void main() {
  test('length metadata round-trips portable unsigned values', () {
    for (final length in const [
      0,
      1,
      0xffffffff,
      0x100000000,
      9007199254740991,
    ]) {
      final encoded = encodeP2pResourceLength(length, acceptsRanges: true);
      expect(encoded, hasLength(9));
      expect(decodeP2pResourceLength(encoded), length);
      expect(decodeP2pRangeCapability(encoded), isTrue);
    }
  });

  test('length metadata preserves range capability', () {
    final unsupported = encodeP2pResourceLength(42, acceptsRanges: false);
    expect(decodeP2pRangeCapability(unsupported), isFalse);

    final unknown = encodeP2pResourceLength(42);
    expect(decodeP2pRangeCapability(unknown), isNull);
  });

  test('length metadata rejects incomplete and oversized records', () {
    expect(decodeP2pResourceLength(null), isNull);
    for (final size in [0, 7, 8, 10]) {
      final metadata = Uint8List(size);
      expect(decodeP2pResourceLength(metadata), isNull);
      expect(decodeP2pRangeCapability(metadata), isNull);
    }
  });
}
