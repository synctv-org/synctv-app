import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'ksf.dart';
import 'opaque_crypto.dart';
import 'oprf.dart';
import 'serialization.dart';
import 'triple_dh.dart';

const _maskingKey = 'MaskingKey';
const _authKey = 'AuthKey';
const _privateKey = 'PrivateKey';
const _credentialResponsePad = 'CredentialResponsePad';

typedef OpaqueKsf = Future<Uint8List> Function(Uint8List input);

class OpaqueRegistrationStart {
  const OpaqueRegistrationStart({
    required this.registrationRequest,
    required this.state,
  });

  final Uint8List registrationRequest;
  final Uint8List state;
}

class OpaqueRegistrationFinish {
  const OpaqueRegistrationFinish({required this.registrationUpload});

  final Uint8List registrationUpload;
}

class OpaqueLoginStart {
  const OpaqueLoginStart({
    required this.credentialRequest,
    required this.state,
  });

  final Uint8List credentialRequest;
  final Uint8List state;
}

class OpaqueLoginFinish {
  const OpaqueLoginFinish({
    required this.credentialFinalization,
    required this.sessionKey,
  });

  final Uint8List credentialFinalization;
  final Uint8List sessionKey;
}

class OpaqueProtocolClient {
  OpaqueProtocolClient({OpaqueKsf? ksf}) : _ksf = ksf ?? opaqueKsf;

  final OpaqueKsf _ksf;

  Future<OpaqueRegistrationStart> startRegistration(
    Uint8List password, {
    Uint8List? blindScalar,
  }) async {
    final result = await blindElement(password, blindScalar: blindScalar);
    return OpaqueRegistrationStart(
      registrationRequest: result.blindedElement,
      state: concat([result.blind, result.blindedElement]),
    );
  }

  Future<OpaqueRegistrationFinish> finishRegistration({
    required Uint8List password,
    required Uint8List state,
    required Uint8List registrationResponse,
    Uint8List? envelopeNonce,
  }) async {
    final blind = takeBytes(state, 32);
    final blindedElement = takeBytes(state, 32, offset: 32);
    final evaluationElement = takeBytes(registrationResponse, 32);
    final serverStaticPublicKey = takeBytes(
      registrationResponse,
      32,
      offset: 32,
    );
    if (bytesEqual(blindedElement, evaluationElement)) {
      throw StateError('reflected OPRF evaluation element');
    }

    final oprfOutput = await unblindEvaluation(
      input: password,
      evaluationElement: evaluationElement,
      blind: blind,
    );
    final hardened = await _ksf(oprfOutput);
    final prk = await hkdfExtract(
      salt: Uint8List(0),
      ikm: concat([oprfOutput, hardened]),
    );
    final maskingKey = await hkdfExpandMultiInfo(
      prk: prk,
      infos: [utf8.encode(_maskingKey)],
      length: 64,
    );

    final nonce = envelopeNonce ?? randomBytes(32);
    final clientStaticSecret = await _deriveClientStaticSecret(prk, nonce);
    final clientStaticPublicKey = publicKeyFromSecret(clientStaticSecret);
    final hmacKey = await hkdfExpandMultiInfo(
      prk: prk,
      infos: [nonce, utf8.encode(_authKey)],
      length: 64,
    );
    final aad = _registrationAad(serverStaticPublicKey, clientStaticPublicKey);
    final hmac = await hmacSha512.calculateMac(
      concat([nonce, aad]),
      secretKey: SecretKey(hmacKey),
    );
    final envelope = concat([nonce, hmac.bytes]);

    return OpaqueRegistrationFinish(
      registrationUpload: concat([clientStaticPublicKey, maskingKey, envelope]),
    );
  }

  Future<OpaqueLoginStart> startLogin(
    Uint8List password, {
    Uint8List? blindScalar,
    Uint8List? clientEphemeralSeed,
    Uint8List? clientNonce,
  }) async {
    final blind = await blindElement(password, blindScalar: blindScalar);
    final dh = TripleDhClient();
    final ke1 = await dh.generateKe1(
      clientEphemeralSeed: clientEphemeralSeed,
      clientNonce: clientNonce,
    );
    return OpaqueLoginStart(
      credentialRequest: concat([
        blind.blindedElement,
        ke1.message.serialize(),
      ]),
      state: concat([blind.blind, blind.blindedElement, ke1.state]),
    );
  }

  Future<OpaqueLoginFinish> finishLogin({
    required Uint8List password,
    required Uint8List state,
    required Uint8List credentialResponse,
    List<int>? clientIdentifier,
    List<int>? serverIdentifier,
    List<int>? context,
  }) async {
    final blind = takeBytes(state, 32);
    final blindedElement = takeBytes(state, 32, offset: 32);
    final clientEphemeralSecret = takeBytes(state, 32, offset: 64);
    final clientNonce = takeBytes(state, 32, offset: 96);
    final evaluationElement = takeBytes(credentialResponse, 32);
    if (bytesEqual(blindedElement, evaluationElement)) {
      throw StateError('reflected OPRF evaluation element');
    }

    final oprfOutput = await unblindEvaluation(
      input: password,
      evaluationElement: evaluationElement,
      blind: blind,
    );
    final hardened = await _ksf(oprfOutput);
    final prk = await hkdfExtract(
      salt: Uint8List(0),
      ikm: concat([oprfOutput, hardened]),
    );
    final maskingKey = await hkdfExpandMultiInfo(
      prk: prk,
      infos: [utf8.encode(_maskingKey)],
      length: 64,
    );
    final maskingNonce = takeBytes(credentialResponse, 32, offset: 32);
    final maskedResponse = takeBytes(credentialResponse, 128, offset: 64);
    final cleartext = await _unmaskResponse(
      maskingKey: maskingKey,
      maskingNonce: maskingNonce,
      maskedResponse: maskedResponse,
    );
    final serverStaticPublicKey = takeBytes(cleartext, 32);
    final envelope = takeBytes(cleartext, 96, offset: 32);
    final clientStaticSecret = await _openEnvelope(
      prk: prk,
      envelope: envelope,
      serverStaticPublicKey: serverStaticPublicKey,
    );

    final result = await TripleDhClient().generateKe3(
      blindedElement: blindedElement,
      ke1: Ke1(
        clientNonce: clientNonce,
        clientEphemeralPublicKey: publicKeyFromSecret(clientEphemeralSecret),
      ),
      clientEphemeralSecret: clientEphemeralSecret,
      serverEphemeralPublicKey: takeBytes(credentialResponse, 32, offset: 224),
      serverNonce: takeBytes(credentialResponse, 32, offset: 192),
      serverMac: takeBytes(credentialResponse, 64, offset: 256),
      clientStaticSecret: clientStaticSecret,
      serverStaticPublicKey: serverStaticPublicKey,
      evaluationElement: evaluationElement,
      maskingNonce: maskingNonce,
      maskedResponse: maskedResponse,
      clientIdentifier: clientIdentifier,
      serverIdentifier: serverIdentifier,
      context: context,
    );
    return OpaqueLoginFinish(
      credentialFinalization: result.clientMac,
      sessionKey: result.sessionKey,
    );
  }
}

Future<Uint8List> _deriveClientStaticSecret(
  Uint8List prk,
  Uint8List envelopeNonce,
) async {
  final keypairSeed = await hkdfExpandMultiInfo(
    prk: prk,
    infos: [envelopeNonce, utf8.encode(_privateKey)],
    length: 32,
  );
  return (await deriveKeyPair(keypairSeed)).secret;
}

Future<Uint8List> _unmaskResponse({
  required Uint8List maskingKey,
  required Uint8List maskingNonce,
  required Uint8List maskedResponse,
}) async {
  final pad = await hkdfExpandMultiInfo(
    prk: maskingKey,
    infos: [maskingNonce, utf8.encode(_credentialResponsePad)],
    length: maskedResponse.length,
  );
  return xorBytes(pad, maskedResponse);
}

Future<Uint8List> _openEnvelope({
  required Uint8List prk,
  required Uint8List envelope,
  required Uint8List serverStaticPublicKey,
}) async {
  final nonce = takeBytes(envelope, 32);
  final authTag = takeBytes(envelope, 64, offset: 32);
  final clientStaticSecret = await _deriveClientStaticSecret(prk, nonce);
  final aad = _registrationAad(
    serverStaticPublicKey,
    publicKeyFromSecret(clientStaticSecret),
  );
  final authKey = await hkdfExpandMultiInfo(
    prk: prk,
    infos: [nonce, utf8.encode(_authKey)],
    length: 64,
  );
  final expected = await hmacSha512.calculateMac(
    concat([nonce, aad]),
    secretKey: SecretKey(authKey),
  );
  if (!bytesEqual(expected.bytes, authTag)) {
    throw StateError('invalid envelope MAC');
  }
  return clientStaticSecret;
}

Uint8List _registrationAad(
  Uint8List serverStaticPublicKey,
  Uint8List clientStaticPublicKey,
) {
  return concat([
    serverStaticPublicKey,
    _serializedIdentifier(serverStaticPublicKey),
    _serializedIdentifier(clientStaticPublicKey),
  ]);
}

Uint8List _serializedIdentifier(Uint8List identifier) {
  return concat([
    [identifier.length ~/ 256, identifier.length % 256],
    identifier,
  ]);
}
