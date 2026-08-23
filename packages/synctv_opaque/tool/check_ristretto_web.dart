import 'package:synctv_opaque/src/opaque/oprf.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';

void main() {
  final public = publicKeyFromSecret(
    hexToBytes(
      '6c6562fbd0dd0b74ae36123914d923e6aeea1de70fe715f2c88ad5e950a3dc0f',
    ),
  );
  print(bytesToHex(public));
}
