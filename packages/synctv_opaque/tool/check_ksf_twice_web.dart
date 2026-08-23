import 'dart:typed_data';

import 'package:synctv_opaque/src/opaque/ksf.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';

Future<void> main() async {
  final input = Uint8List.fromList(List.generate(64, (i) => i));
  final first = await opaqueKsf(input);
  final second = await opaqueKsf(input);
  print(bytesToHex(first));
  print(bytesToHex(second));
  print(bytesEqual(first, second) ? 'equal' : 'different');
}
