import 'dart:convert';
import 'dart:typed_data';

import 'package:synctv_opaque/src/opaque/opaque_client.dart';
import 'package:synctv_opaque/src/opaque/opaque_crypto.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';

Future<void> main() async {
  final client = OpaqueProtocolClient();
  final password = Uint8List.fromList(
    utf8.encode('correct horse battery staple'),
  );
  final registrationBlind = hexToBytes(
    '76cfbfe758db884bebb33582331ba9f159720ca8784a2a070a265d9c2d6abe01',
  );
  final serverStaticPublicKey = hexToBytes(
    'b2fe7af9f48cc502d016729d2fe25cdd433f2c4bc904660b2a382c9b79df1a78',
  );
  final registrationResponse = hexToBytes(
    '7408a268083e03abc7097fc05b587834539065e86fb0c7b6342fcf5e01e5b019'
    'b2fe7af9f48cc502d016729d2fe25cdd433f2c4bc904660b2a382c9b79df1a78',
  );
  final registrationStart = await client.startRegistration(
    password,
    blindScalar: registrationBlind,
  );
  final registrationFinish = await client.finishRegistration(
    password: password,
    state: registrationStart.state,
    registrationResponse: registrationResponse,
    envelopeNonce: hexToBytes(
      'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec',
    ),
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
  final maskingNonce = Uint8List.fromList(List.generate(32, (i) => i));
  final pad = await hkdfExpandMultiInfo(
    prk: maskingKey,
    infos: [maskingNonce, utf8.encode('CredentialResponsePad')],
    length: 128,
  );
  final maskedResponse = xorBytes(
    pad,
    concat([serverStaticPublicKey, envelope]),
  );
  final credentialResponse = concat([
    hexToBytes(
      '7408a268083e03abc7097fc05b587834539065e86fb0c7b6342fcf5e01e5b019',
    ),
    maskingNonce,
    maskedResponse,
    hexToBytes(
      '71cd9960ecef2fe0d0f7494986fa3d8b2bb01963537e60efb13981e138e3d4a1',
    ),
    hexToBytes(
      'c4f62198a9d6fa9170c42c3c71f1971b29eb1d5d0bd733e40816c91f7912cc4a',
    ),
    Uint8List(64),
  ]);
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
  try {
    await client.finishLogin(
      password: password,
      state: loginStart.state,
      credentialResponse: credentialResponse,
    );
    print('unexpected success');
  } on StateError catch (error) {
    print('envelope check result: ${error.message}');
  }
}
