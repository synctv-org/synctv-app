import 'dart:typed_data';

const _uint32Base = 0x100000000;

int? decodeP2pResourceLength(Uint8List? metadata) {
  if (metadata == null || metadata.length != 9) return null;
  final data = ByteData.sublistView(metadata);
  final high = data.getUint32(0);
  final low = data.getUint32(4);
  return high * _uint32Base + low;
}

bool? decodeP2pRangeCapability(Uint8List metadata) {
  if (metadata.length != 9) return null;
  return switch (metadata[8]) {
    1 => true,
    2 => false,
    _ => null,
  };
}

Uint8List encodeP2pResourceLength(int length, {bool? acceptsRanges}) {
  if (length < 0) throw ArgumentError.value(length, 'length');
  final metadata = Uint8List(9);
  final data = ByteData.sublistView(metadata);
  data.setUint32(0, length ~/ _uint32Base);
  data.setUint32(4, length.remainder(_uint32Base));
  metadata[8] = switch (acceptsRanges) {
    true => 1,
    false => 2,
    null => 0,
  };
  return metadata;
}
