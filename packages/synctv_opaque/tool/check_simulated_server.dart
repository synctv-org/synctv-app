import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ristretto255/ristretto255.dart';
import 'package:synctv_opaque/src/opaque/opaque_client.dart';
import 'package:synctv_opaque/src/opaque/opaque_crypto.dart';
import 'package:synctv_opaque/src/opaque/oprf.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';
import 'package:synctv_opaque/src/opaque/triple_dh.dart';

Future<void> main() async {
  final client = OpaqueProtocolClient();
  final password = Uint8List.fromList(
    utf8.encode('correct horse battery staple'),
  );
  final oprfSeed = Uint8List.fromList(List.generate(64, (i) => i));
  final serverStaticKeyPair = await deriveKeyPair(
    Uint8List.fromList(List.generate(32, (i) => 100 + i)),
  );
  final oprfKeyMaterial = await hkdfExpandMultiInfo(
    prk: oprfSeed,
    infos: [utf8.encode('credIdentifier'), utf8.encode('OprfKey')],
    length: 32,
  );
  final oprfKey = await deriveKeyPair(
    oprfKeyMaterial,
    info: utf8.encode('OPAQUE-DeriveKeyPair'),
  );

  final registrationBlind = hexToBytes(
    '76cfbfe758db884bebb33582331ba9f159720ca8784a2a070a265d9c2d6abe01',
  );
  final registrationStart = await client.startRegistration(
    password,
    blindScalar: registrationBlind,
  );
  final registrationEvaluation = await _serverEvaluate(
    oprfKey.secret,
    registrationStart.registrationRequest,
  );
  final registrationResponse = concat([
    registrationEvaluation,
    serverStaticKeyPair.public,
  ]);
  final registrationFinish = await client.finishRegistration(
    password: password,
    state: registrationStart.state,
    registrationResponse: registrationResponse,
    envelopeNonce: hexToBytes(
      'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec',
    ),
  );
  final clientStaticPublicKey = takeBytes(
    registrationFinish.registrationUpload,
    32,
  );
  final maskingKey = takeBytes(
    registrationFinish.registrationUpload,
    64,
    offset: 32,
  );
  final envelope = takeBytes(
    registrationFinish.registrationUpload,
    96,
    offset: 96,
  );

  final loginStart = await client.startLogin(
    password,
    blindScalar: hexToBytes(
      '6ecc102d2e7a7cf49617aad7bbe188556792d4acd60a1a8a8d2b65d4b0790308',
    ),
    clientEphemeralSeed: hexToBytes(
      '82850a697b42a505f5b68fcdafce8c31f0af2b581f063cf1091933541936304b',
    ),
    clientNonce: hexToBytes(
      'da7e07376d6d6f034cfa9bb537d11b8c6b4238c334333d1f0aebb380cae6a6cc',
    ),
  );
  final loginBlinded = takeBytes(loginStart.credentialRequest, 32);
  final loginEvaluation = await _serverEvaluate(oprfKey.secret, loginBlinded);
  final maskingNonce = Uint8List.fromList(List.generate(32, (i) => 50 + i));
  final pad = await hkdfExpandMultiInfo(
    prk: maskingKey,
    infos: [maskingNonce, utf8.encode('CredentialResponsePad')],
    length: 128,
  );
  final maskedResponse = xorBytes(
    pad,
    concat([serverStaticKeyPair.public, envelope]),
  );
  final serverKeyshare = await deriveKeyPair(
    Uint8List.fromList(List.generate(32, (i) => 200 + i)),
  );
  final serverNonce = Uint8List.fromList(List.generate(32, (i) => 150 + i));

  final ke1 = Ke1(
    clientNonce: takeBytes(loginStart.credentialRequest, 32, offset: 32),
    clientEphemeralPublicKey: takeBytes(
      loginStart.credentialRequest,
      32,
      offset: 64,
    ),
  );
  final credentialResponseWithoutKe2 = concat([
    loginEvaluation,
    maskingNonce,
    maskedResponse,
  ]);
  final transcriptInput = concat([
    _context(),
    _identifier(clientStaticPublicKey),
    loginBlinded,
    ke1.clientNonce,
    ke1.clientEphemeralPublicKey,
    _identifier(serverStaticKeyPair.public),
    loginEvaluation,
    maskingNonce,
    maskedResponse,
    serverNonce,
    serverKeyshare.public,
  ]);
  final transcriptHash = await sha512Hash(transcriptInput);
  final derived = await _serverDeriveKeys(
    sharedSecrets: [
      _dh(serverKeyshare.secret, ke1.clientEphemeralPublicKey),
      _dh(serverStaticKeyPair.secret, ke1.clientEphemeralPublicKey),
      _dh(serverKeyshare.secret, clientStaticPublicKey),
    ],
    transcriptHash: transcriptHash,
  );
  final serverMac = await hmacSha512.calculateMac(
    transcriptHash,
    secretKey: SecretKey(derived.km2),
  );
  final credentialResponse = concat([
    credentialResponseWithoutKe2,
    serverNonce,
    serverKeyshare.public,
    serverMac.bytes,
  ]);

  try {
    final finish = await client.finishLogin(
      password: password,
      state: loginStart.state,
      credentialResponse: credentialResponse,
    );
    print('simulated server login ok');
    print(
      'session match ${bytesToHex(finish.sessionKey) == bytesToHex(derived.sessionKey)}',
    );
  } catch (error) {
    print('simulated server login failed: $error');
  }
}

Future<Uint8List> _serverEvaluate(
  Uint8List scalarBytes,
  Uint8List blindedElement,
) async {
  final scalar = Scalar()..setCanonicalBytes(scalarBytes);
  final point = Element.newIdentityElement()..setCanonicalBytes(blindedElement);
  final output = Element.newIdentityElement()..scalarMult(scalar, point);
  return Uint8List.fromList(output.encode());
}

Future<_ServerKeys> _serverDeriveKeys({
  required List<Uint8List> sharedSecrets,
  required Uint8List transcriptHash,
}) async {
  final prk = await hkdfExtract(salt: Uint8List(0), ikm: concat(sharedSecrets));
  final handshakeSecret = await _expandLabel(
    prk,
    'HandshakeSecret',
    transcriptHash,
  );
  final sessionKey = await _expandLabel(prk, 'SessionKey', transcriptHash);
  final km2 = await _expandLabel(handshakeSecret, 'ServerMAC', Uint8List(0));
  return _ServerKeys(sessionKey: sessionKey, km2: km2);
}

Future<Uint8List> _expandLabel(
  Uint8List prk,
  String label,
  Uint8List context,
) async {
  final labelBytes = utf8.encode('OPAQUE-$label');
  const length = 64;
  return hkdfExpandMultiInfo(
    prk: prk,
    infos: [
      [length ~/ 256, length % 256],
      [labelBytes.length],
      labelBytes,
      [context.length],
      context,
    ],
    length: length,
  );
}

Uint8List _context() {
  return concat([
    utf8.encode('OPAQUEv1-'),
    [0, 0],
  ]);
}

Uint8List _identifier(Uint8List value) {
  return concat([
    [value.length ~/ 256, value.length % 256],
    value,
  ]);
}

Uint8List _dh(Uint8List secret, Uint8List public) {
  final scalar = Scalar()..setCanonicalBytes(secret);
  final point = Element.newIdentityElement()..setCanonicalBytes(public);
  final output = Element.newIdentityElement()..scalarMult(scalar, point);
  return Uint8List.fromList(output.encode());
}

class _ServerKeys {
  const _ServerKeys({required this.sessionKey, required this.km2});

  final Uint8List sessionKey;
  final Uint8List km2;
}
