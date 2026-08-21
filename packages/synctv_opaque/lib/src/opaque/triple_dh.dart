import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ristretto255/ristretto255.dart';

import 'opaque_crypto.dart';
import 'oprf.dart';
import 'serialization.dart';

const _contextPrefix = 'OPAQUEv1-';
const _opaqueLabel = 'OPAQUE-';
const _handshakeSecret = 'HandshakeSecret';
const _sessionKey = 'SessionKey';
const _serverMac = 'ServerMAC';
const _clientMac = 'ClientMAC';

class Ke1 {
  const Ke1({
    required this.clientNonce,
    required this.clientEphemeralPublicKey,
  });

  final Uint8List clientNonce;
  final Uint8List clientEphemeralPublicKey;

  Uint8List serialize() => concat([clientNonce, clientEphemeralPublicKey]);
}

class Ke1Result {
  const Ke1Result({required this.message, required this.state});

  final Ke1 message;
  final Uint8List state;
}

class Ke3Result {
  const Ke3Result({required this.clientMac, required this.sessionKey});

  final Uint8List clientMac;
  final Uint8List sessionKey;
}

class TripleDhClient {
  Future<Ke1Result> generateKe1({
    Uint8List? clientEphemeralSeed,
    Uint8List? clientNonce,
  }) async {
    final keyPair = await deriveKeyPair(clientEphemeralSeed ?? randomBytes(32));
    final nonce = clientNonce ?? randomBytes(32);
    return Ke1Result(
      message: Ke1(
        clientNonce: nonce,
        clientEphemeralPublicKey: keyPair.public,
      ),
      state: concat([keyPair.secret, nonce]),
    );
  }

  Future<Ke3Result> generateKe3({
    required Uint8List blindedElement,
    required Ke1 ke1,
    required Uint8List clientEphemeralSecret,
    required Uint8List serverEphemeralPublicKey,
    required Uint8List serverNonce,
    required Uint8List serverMac,
    required Uint8List clientStaticSecret,
    required Uint8List serverStaticPublicKey,
    required Uint8List evaluationElement,
    required Uint8List maskingNonce,
    required Uint8List maskedResponse,
    List<int>? clientIdentifier,
    List<int>? serverIdentifier,
    List<int>? context,
  }) async {
    final clientStaticPublicKey = publicKeyFromSecret(clientStaticSecret);
    final clientId = _serializedIdentifier(
      clientIdentifier ?? clientStaticPublicKey,
    );
    final serverId = _serializedIdentifier(
      serverIdentifier ?? serverStaticPublicKey,
    );
    final transcriptInput = concat([
      _serializedContext(context),
      clientId,
      blindedElement,
      ke1.clientNonce,
      ke1.clientEphemeralPublicKey,
      serverId,
      evaluationElement,
      maskingNonce,
      maskedResponse,
      serverNonce,
      serverEphemeralPublicKey,
    ]);
    final transcriptHash = await sha512Hash(transcriptInput);

    final derived = await _deriveKeys(
      sharedSecrets: [
        _diffieHellman(clientEphemeralSecret, serverEphemeralPublicKey),
        _diffieHellman(clientEphemeralSecret, serverStaticPublicKey),
        _diffieHellman(clientStaticSecret, serverEphemeralPublicKey),
      ],
      transcriptHash: transcriptHash,
    );

    final serverMacExpected = await hmacSha512.calculateMac(
      transcriptHash,
      secretKey: SecretKey(derived.km2),
    );
    if (!bytesEqual(serverMacExpected.bytes, serverMac)) {
      throw StateError('invalid server MAC');
    }

    final transcriptWithServerMac = await sha512Hash(
      concat([transcriptInput, serverMac]),
    );
    final clientMac = await hmacSha512.calculateMac(
      transcriptWithServerMac,
      secretKey: SecretKey(derived.km3),
    );
    return Ke3Result(
      clientMac: Uint8List.fromList(clientMac.bytes),
      sessionKey: derived.sessionKey,
    );
  }
}

class _DerivedKeys {
  const _DerivedKeys({
    required this.handshakeSecret,
    required this.sessionKey,
    required this.km2,
    required this.km3,
  });

  final Uint8List handshakeSecret;
  final Uint8List sessionKey;
  final Uint8List km2;
  final Uint8List km3;
}

Future<_DerivedKeys> _deriveKeys({
  required List<Uint8List> sharedSecrets,
  required Uint8List transcriptHash,
}) async {
  final prk = await hkdfExtract(salt: Uint8List(0), ikm: concat(sharedSecrets));
  final handshakeSecret = await _hkdfExpandLabel(
    prk,
    _handshakeSecret,
    transcriptHash,
  );
  final sessionKey = await _hkdfExpandLabel(prk, _sessionKey, transcriptHash);
  final km2 = await _hkdfExpandLabel(handshakeSecret, _serverMac, Uint8List(0));
  final km3 = await _hkdfExpandLabel(handshakeSecret, _clientMac, Uint8List(0));
  return _DerivedKeys(
    handshakeSecret: handshakeSecret,
    sessionKey: sessionKey,
    km2: km2,
    km3: km3,
  );
}

Future<Uint8List> _hkdfExpandLabel(
  Uint8List prk,
  String label,
  Uint8List context,
) async {
  final labelBytes = utf8.encode('$_opaqueLabel$label');
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

Uint8List _serializedContext(List<int>? context) {
  final contextBytes = context ?? const [];
  return concat([
    utf8.encode(_contextPrefix),
    [contextBytes.length ~/ 256, contextBytes.length % 256],
    contextBytes,
  ]);
}

Uint8List _serializedIdentifier(List<int> identifier) {
  return concat([
    [identifier.length ~/ 256, identifier.length % 256],
    identifier,
  ]);
}

Uint8List _diffieHellman(Uint8List secret, Uint8List public) {
  final scalar = Scalar()..setCanonicalBytes(secret);
  final point = Element.newIdentityElement()..setCanonicalBytes(public);
  final output = Element.newIdentityElement()..scalarMult(scalar, point);
  return Uint8List.fromList(output.encode());
}
