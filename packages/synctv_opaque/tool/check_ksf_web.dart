import 'dart:typed_data';

import 'package:synctv_opaque/src/opaque/ksf.dart';

Future<void> main() async {
  final out = await opaqueKsf(Uint8List.fromList(List.generate(64, (i) => i)));
  print(out.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join());
}
