import 'dart:typed_data';

import 'synctv_opaque_native.dart'
    if (dart.library.js_interop) 'synctv_opaque_web.dart'
    as platform;

class OpaqueOperationException implements Exception {
  const OpaqueOperationException(this.message);

  final String message;

  @override
  String toString() => 'OpaqueOperationException: $message';
}

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

abstract interface class SyncTvOpaqueClient {
  factory SyncTvOpaqueClient() = platform.SyncTvOpaqueClient;

  Future<OpaqueRegistrationStart> startRegistration(String password);

  Future<OpaqueRegistrationFinish> finishRegistration({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  });

  Future<OpaqueLoginStart> startLogin(String password);

  Future<OpaqueLoginFinish> finishLogin({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  });
}
