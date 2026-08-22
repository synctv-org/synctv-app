import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

// Matches opaque-ke 4.0.1's argon2::Argon2::default(): Argon2id v19,
// m=19456 KiB, t=2, p=1, 64-byte output, zero 16-byte salt.
const _argon2 = DartArgon2id(
  parallelism: 1,
  memory: 19456,
  iterations: 2,
  hashLength: 64,
);

Future<Uint8List> opaqueKsf(Uint8List input) async {
  if (input.length != 64) {
    throw ArgumentError.value(input.length, 'input', 'must be 64 bytes');
  }
  final salt = Uint8List(16);
  final key = await _argon2.deriveKey(secretKey: SecretKey(input), nonce: salt);
  return Uint8List.fromList(await key.extractBytes());
}
