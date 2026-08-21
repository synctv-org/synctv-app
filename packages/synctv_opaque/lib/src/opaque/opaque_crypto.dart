import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

const sha512 = DartSha512();
final hmacSha512 = DartHmac.sha512();

Uint8List concat(List<List<int>> parts) {
  final total = parts.fold<int>(0, (a, p) => a + p.length);
  final out = Uint8List(total);
  var offset = 0;
  for (final part in parts) {
    out.setRange(offset, offset + part.length, part);
    offset += part.length;
  }
  return out;
}

Future<Uint8List> hkdfExtract({
  required Uint8List salt,
  required Uint8List ikm,
}) async {
  final key = await hmacSha512.calculateMac(ikm, secretKey: SecretKey(salt));
  return Uint8List.fromList(key.bytes);
}

Future<Uint8List> hkdfExpandMultiInfo({
  required Uint8List prk,
  required List<List<int>> infos,
  required int length,
}) async {
  final info = concat(infos);
  const hashLength = 64;
  final blocks = (length + hashLength - 1) ~/ hashLength;
  final output = Uint8List(length);
  Uint8List previous = Uint8List(0);
  for (var index = 1; index <= blocks; index++) {
    final mac = await hmacSha512.calculateMac(
      concat([
        previous,
        info,
        [index],
      ]),
      secretKey: SecretKey(prk),
    );
    previous = Uint8List.fromList(mac.bytes);
    final offset = (index - 1) * hashLength;
    final remaining = length - offset;
    final take = remaining < hashLength ? remaining : hashLength;
    output.setRange(offset, offset + take, previous.take(take));
  }
  return output;
}

Future<Uint8List> sha512Hash(Uint8List input) async =>
    Uint8List.fromList((await sha512.hash(input)).bytes);
