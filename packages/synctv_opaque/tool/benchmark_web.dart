import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ristretto255/ristretto255.dart';
import 'package:synctv_opaque/src/opaque/opaque_client.dart';
import 'package:synctv_opaque/src/opaque/opaque_crypto.dart';
import 'package:synctv_opaque/src/opaque/oprf.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';
import 'package:synctv_opaque/src/opaque/triple_dh.dart';
import 'package:synctv_opaque/src/opaque/wasm_opaque.dart';

const _iterations = 5;

final _password = Uint8List.fromList(
  utf8.encode('correct horse battery staple'),
);

Future<void> main() async {
  final dart = await _prepareDart();
  final wasm = await _prepareWasm();

  final dartRegistration = await _measure(() async {
    final result = await dart.client.finishRegistration(
      password: _password,
      state: dart.registrationState,
      registrationResponse: dart.registrationResponse,
    );
    _checkRegistration(result.registrationUpload);
  });
  final wasmRegistration = await _measure(() async {
    final result = await wasm.backend.registrationFinish(
      password: _password,
      state: wasm.registrationState,
      response: wasm.registrationResponse,
    );
    _checkRegistration(result.first);
  });

  final dartLoginStart = await _measure(() async {
    final result = await dart.client.startLogin(_password);
    if (result.credentialRequest.length != 128) {
      throw StateError('invalid Dart login request');
    }
  });
  final wasmLoginStart = await _measure(() async {
    final result = await wasm.backend.loginStart(_password);
    if (result.first.length != 128) {
      throw StateError('invalid WASM login request');
    }
  });

  final dartLogin = await _measure(() async {
    final result = await dart.client.finishLogin(
      password: _password,
      state: dart.loginState,
      credentialResponse: dart.credentialResponse,
    );
    _checkLogin(result.credentialFinalization, result.sessionKey);
  });
  final wasmLogin = await _measure(() async {
    final result = await wasm.backend.loginFinish(
      password: _password,
      state: wasm.loginState,
      response: wasm.credentialResponse,
    );
    _checkLogin(result.first, result.second);
  });

  print('iterations: $_iterations');
  _printResult('registration_finish', dartRegistration, wasmRegistration);
  _printResult('login_start', dartLoginStart, wasmLoginStart);
  _printResult('login_finish', dartLogin, wasmLogin);
}

Future<_DartFixture> _prepareDart() async {
  final client = OpaqueProtocolClient();
  final registrationStart = await client.startRegistration(_password);
  final registrationResponse = await _registrationResponse(
    registrationStart.registrationRequest,
  );
  final registrationFinish = await client.finishRegistration(
    password: _password,
    state: registrationStart.state,
    registrationResponse: registrationResponse,
  );
  final loginStart = await client.startLogin(_password);
  final credentialResponse = await _credentialResponse(
    registrationFinish.registrationUpload,
    loginStart.credentialRequest,
  );
  return _DartFixture(
    client: client,
    registrationState: registrationStart.state,
    registrationResponse: registrationResponse,
    loginState: loginStart.state,
    credentialResponse: credentialResponse,
  );
}

Future<_WasmFixture> _prepareWasm() async {
  final backend = await OpaqueWasmBackend.create();
  final registrationStart = await backend.registrationStart(_password);
  final registrationResponse = await _registrationResponse(
    registrationStart.first,
  );
  final registrationFinish = await backend.registrationFinish(
    password: _password,
    state: registrationStart.second,
    response: registrationResponse,
  );
  final loginStart = await backend.loginStart(_password);
  final credentialResponse = await _credentialResponse(
    registrationFinish.first,
    loginStart.first,
  );
  return _WasmFixture(
    backend: backend,
    registrationState: registrationStart.second,
    registrationResponse: registrationResponse,
    loginState: loginStart.second,
    credentialResponse: credentialResponse,
  );
}

Future<Uint8List> _registrationResponse(Uint8List request) async {
  final serverStaticKeyPair = await _serverStaticKeyPair();
  final oprfKey = await _oprfKeyPair();
  return concat([
    _serverEvaluate(oprfKey.secret, request),
    serverStaticKeyPair.public,
  ]);
}

Future<Uint8List> _credentialResponse(
  Uint8List registrationUpload,
  Uint8List loginRequest,
) async {
  final serverStaticKeyPair = await _serverStaticKeyPair();
  final oprfKey = await _oprfKeyPair();
  final clientStaticPublicKey = takeBytes(registrationUpload, 32);
  final maskingKey = takeBytes(registrationUpload, 64, offset: 32);
  final envelope = takeBytes(registrationUpload, 96, offset: 96);
  final loginBlinded = takeBytes(loginRequest, 32);
  final loginEvaluation = _serverEvaluate(oprfKey.secret, loginBlinded);
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
    clientNonce: takeBytes(loginRequest, 32, offset: 32),
    clientEphemeralPublicKey: takeBytes(loginRequest, 32, offset: 64),
  );
  final responseWithoutKe2 = concat([
    loginEvaluation,
    maskingNonce,
    maskedResponse,
  ]);
  final transcriptHash = await sha512Hash(
    concat([
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
    ]),
  );
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
  return concat([
    responseWithoutKe2,
    serverNonce,
    serverKeyshare.public,
    serverMac.bytes,
  ]);
}

Future<OpaqueKeyPair> _serverStaticKeyPair() =>
    deriveKeyPair(Uint8List.fromList(List.generate(32, (i) => 100 + i)));

Future<OpaqueKeyPair> _oprfKeyPair() async {
  final material = await hkdfExpandMultiInfo(
    prk: Uint8List.fromList(List.generate(64, (i) => i)),
    infos: [utf8.encode('credIdentifier'), utf8.encode('OprfKey')],
    length: 32,
  );
  return deriveKeyPair(material, info: utf8.encode('OPAQUE-DeriveKeyPair'));
}

Uint8List _serverEvaluate(Uint8List scalarBytes, Uint8List blindedElement) {
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
) => hkdfExpandMultiInfo(
  prk: prk,
  infos: [
    [0, 64],
    [label.length + 7],
    utf8.encode('OPAQUE-$label'),
    [context.length],
    context,
  ],
  length: 64,
);

Uint8List _context() => concat([
  utf8.encode('OPAQUEv1-'),
  [0, 0],
]);

Uint8List _identifier(Uint8List value) => concat([
  [value.length ~/ 256, value.length % 256],
  value,
]);

Uint8List _dh(Uint8List secret, Uint8List public) {
  final scalar = Scalar()..setCanonicalBytes(secret);
  final point = Element.newIdentityElement()..setCanonicalBytes(public);
  final output = Element.newIdentityElement()..scalarMult(scalar, point);
  return Uint8List.fromList(output.encode());
}

Future<Duration> _measure(Future<void> Function() operation) async {
  for (var i = 0; i < 2; i++) {
    await operation();
  }
  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < _iterations; i++) {
    await operation();
  }
  stopwatch.stop();
  return stopwatch.elapsed;
}

void _checkRegistration(Uint8List upload) {
  if (upload.length != 192) {
    throw StateError('invalid registration upload');
  }
}

void _checkLogin(Uint8List finalization, Uint8List sessionKey) {
  if (finalization.length != 64 || sessionKey.length != 64) {
    throw StateError('invalid login result');
  }
}

void _printResult(String operation, Duration dart, Duration wasm) {
  final dartMicros = dart.inMicroseconds / _iterations;
  final wasmMicros = wasm.inMicroseconds / _iterations;
  final speedup = dartMicros / wasmMicros;
  print(
    '$operation: dart=${dartMicros.toStringAsFixed(1)}us avg, '
    'wasm=${wasmMicros.toStringAsFixed(1)}us avg, '
    'speedup=${speedup.toStringAsFixed(2)}x',
  );
}

class _DartFixture {
  const _DartFixture({
    required this.client,
    required this.registrationState,
    required this.registrationResponse,
    required this.loginState,
    required this.credentialResponse,
  });

  final OpaqueProtocolClient client;
  final Uint8List registrationState;
  final Uint8List registrationResponse;
  final Uint8List loginState;
  final Uint8List credentialResponse;
}

class _WasmFixture {
  const _WasmFixture({
    required this.backend,
    required this.registrationState,
    required this.registrationResponse,
    required this.loginState,
    required this.credentialResponse,
  });

  final OpaqueWasmBackend backend;
  final Uint8List registrationState;
  final Uint8List registrationResponse;
  final Uint8List loginState;
  final Uint8List credentialResponse;
}

class _ServerKeys {
  const _ServerKeys({required this.sessionKey, required this.km2});

  final Uint8List sessionKey;
  final Uint8List km2;
}
