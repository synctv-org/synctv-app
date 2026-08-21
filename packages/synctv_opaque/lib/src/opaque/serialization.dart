import 'dart:typed_data';

Uint8List takeBytes(List<int> data, int length, {int offset = 0}) {
  if (offset < 0) {
    throw ArgumentError.value(offset, 'offset', 'must not be negative');
  }
  if (length < 0) {
    throw ArgumentError.value(length, 'length', 'must not be negative');
  }
  if (offset + length > data.length) {
    throw ArgumentError('short read');
  }
  return Uint8List.fromList(data.sublist(offset, offset + length));
}

Uint8List xorBytes(Uint8List left, Uint8List right) {
  if (left.length != right.length) {
    throw ArgumentError('length mismatch');
  }
  final output = Uint8List(left.length);
  for (var i = 0; i < left.length; i++) {
    output[i] = left[i] ^ right[i];
  }
  return output;
}

bool bytesEqual(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  var difference = 0;
  for (var i = 0; i < left.length; i++) {
    difference |= left[i] ^ right[i];
  }
  return difference == 0;
}

String bytesToHex(List<int> bytes) =>
    bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

Uint8List hexToBytes(String hex) {
  final clean = hex.replaceAll(RegExp(r'\s+'), '');
  if (clean.length.isOdd) {
    throw ArgumentError('odd hex');
  }
  if (!RegExp(r'^[0-9a-fA-F]*$').hasMatch(clean)) {
    throw FormatException('invalid hex');
  }
  final output = Uint8List(clean.length ~/ 2);
  for (var i = 0; i < output.length; i++) {
    output[i] = int.parse(clean.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return output;
}
