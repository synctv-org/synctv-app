import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:ristretto255/ristretto255.dart';

import 'opaque_crypto.dart';
import 'serialization.dart';

const _oprfContext = [0x4f, 0x50, 0x52, 0x46, 0x56, 0x31, 0x2d, 0x00, 0x2d];
const _hashToGroup = 'HashToGroup-';
const _deriveKeyPair = 'DeriveKeyPair';
const _ciphersuite = 'ristretto255-SHA512';
const _finalize = 'Finalize';
const _deriveDiffieHellmanKeyPair = 'OPAQUE-DeriveDiffieHellmanKeyPair';

class OpaqueKeyPair {
  const OpaqueKeyPair({required this.secret, required this.public});

  final Uint8List secret;
  final Uint8List public;
}

class OprfBlindResult {
  const OprfBlindResult({required this.blindedElement, required this.blind});

  final Uint8List blindedElement;
  final Uint8List blind;
}

Future<OprfBlindResult> blindElement(
  Uint8List input, {
  Uint8List? blindScalar,
}) async {
  final blind = blindScalar ?? randomScalar();
  final scalar = Scalar()..setCanonicalBytes(blind);
  final hashedPoint = Element.newIdentityElement()
    ..setUniformBytes(
      await expandMessageXmdSha512(
        messages: [input],
        dst: concat([
          utf8.encode(_hashToGroup),
          _oprfContext,
          utf8.encode(_ciphersuite),
        ]),
        lengthInBytes: 64,
      ),
    );
  final blinded = Element.newIdentityElement()..scalarMult(scalar, hashedPoint);
  return OprfBlindResult(
    blindedElement: Uint8List.fromList(blinded.encode()),
    blind: blind,
  );
}

Future<Uint8List> unblindEvaluation({
  required Uint8List input,
  required Uint8List evaluationElement,
  required Uint8List blind,
}) async {
  final blindScalar = Scalar()..setCanonicalBytes(blind);
  final inverse = Scalar()..invert(blindScalar);
  final evaluated = Element.newIdentityElement()
    ..setCanonicalBytes(evaluationElement);
  final unblinded = Element.newIdentityElement()
    ..scalarMult(inverse, evaluated);
  final unblindedBytes = Uint8List.fromList(unblinded.encode());
  final inputLength = [input.length ~/ 256, input.length % 256];
  return sha512Hash(
    concat([
      inputLength,
      input,
      const [0, 32],
      unblindedBytes,
      utf8.encode(_finalize),
    ]),
  );
}

Uint8List randomScalar() {
  final random = Random.secure();
  while (true) {
    final bytes = Uint8List(64);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(256);
    }
    final scalar = Scalar()..setUniformBytes(bytes);
    final encoded = Uint8List.fromList(scalar.encode());
    if (!encoded.every((byte) => byte == 0)) {
      return encoded;
    }
  }
}

Uint8List randomBytes(int length) {
  final random = Random.secure();
  final output = Uint8List(length);
  for (var i = 0; i < output.length; i++) {
    output[i] = random.nextInt(256);
  }
  return output;
}

Future<OpaqueKeyPair> deriveKeyPair(Uint8List seed, {List<int>? info}) async {
  final infoBytes = info ?? utf8.encode(_deriveDiffieHellmanKeyPair);
  final dst = concat([
    utf8.encode(_deriveKeyPair),
    _oprfContext,
    utf8.encode(_ciphersuite),
  ]);
  for (var counter = 0; counter < 256; counter++) {
    final deriveInput = concat([
      seed,
      [infoBytes.length ~/ 256, infoBytes.length % 256],
      infoBytes,
      [counter],
    ]);
    final uniform = await expandMessageXmdSha512(
      messages: [deriveInput],
      dst: dst,
      lengthInBytes: 64,
    );
    final scalar = Scalar()..setUniformBytes(uniform);
    final secret = Uint8List.fromList(scalar.encode());
    if (!secret.every((byte) => byte == 0)) {
      return OpaqueKeyPair(secret: secret, public: publicKeyFromSecret(secret));
    }
  }
  throw StateError('failed to derive a non-zero OPAQUE key pair');
}

Uint8List publicKeyFromSecret(Uint8List secret) {
  final scalar = Scalar()..setCanonicalBytes(secret);
  final point = Element.newIdentityElement()..scalarBaseMult(scalar);
  return Uint8List.fromList(point.encode());
}

Future<Uint8List> expandMessageXmdSha512({
  required List<List<int>> messages,
  required List<int> dst,
  required int lengthInBytes,
}) async {
  const hashLength = 64;
  const blockLength = 128;
  final blocks = (lengthInBytes + hashLength - 1) ~/ hashLength;
  if (blocks > 255) {
    throw ArgumentError('lengthInBytes is too large for expand_message_xmd');
  }

  final dstPrime = concat([
    dst,
    [dst.length % 256],
  ]);
  final lengthBytes = [lengthInBytes ~/ 256, lengthInBytes % 256];
  final zeroPad = Uint8List(blockLength);
  final b0 = await sha512Hash(
    concat([
      zeroPad,
      ...messages,
      lengthBytes,
      const [0],
      dstPrime,
    ]),
  );
  var previous = await sha512Hash(
    concat([
      b0,
      const [1],
      dstPrime,
    ]),
  );
  final output = Uint8List(lengthInBytes);
  final firstLength = lengthInBytes < hashLength ? lengthInBytes : hashLength;
  output.setRange(0, firstLength, previous.take(firstLength));

  for (var index = 2; index <= blocks; index++) {
    final xored = xorBytes(b0, previous);
    previous = await sha512Hash(
      concat([
        xored,
        [index],
        dstPrime,
      ]),
    );
    final offset = (index - 1) * hashLength;
    final remaining = lengthInBytes - offset;
    final take = remaining < hashLength ? remaining : hashLength;
    output.setRange(offset, offset + take, previous.take(take));
  }
  return output;
}
