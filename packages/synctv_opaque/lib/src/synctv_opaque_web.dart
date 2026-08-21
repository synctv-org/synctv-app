import 'dart:convert';
import 'dart:typed_data';

import 'opaque/opaque_client.dart' as protocol;
import 'synctv_opaque_api.dart' as api;

class SyncTvOpaqueClient implements api.SyncTvOpaqueClient {
  SyncTvOpaqueClient();

  final protocol.OpaqueProtocolClient _client = protocol.OpaqueProtocolClient();

  @override
  Future<api.OpaqueRegistrationStart> startRegistration(String password) {
    return _run(() async {
      final result = await _client.startRegistration(
        Uint8List.fromList(utf8.encode(password)),
      );
      return api.OpaqueRegistrationStart(
        registrationRequest: result.registrationRequest,
        state: result.state,
      );
    });
  }

  @override
  Future<api.OpaqueRegistrationFinish> finishRegistration({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  }) {
    return _run(() async {
      final result = await _client.finishRegistration(
        password: Uint8List.fromList(utf8.encode(password)),
        state: state,
        registrationResponse: registrationResponse,
      );
      return api.OpaqueRegistrationFinish(
        registrationUpload: result.registrationUpload,
      );
    });
  }

  @override
  Future<api.OpaqueLoginStart> startLogin(String password) {
    return _run(() async {
      final result = await _client.startLogin(
        Uint8List.fromList(utf8.encode(password)),
      );
      return api.OpaqueLoginStart(
        credentialRequest: result.credentialRequest,
        state: result.state,
      );
    });
  }

  @override
  Future<api.OpaqueLoginFinish> finishLogin({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  }) {
    return _run(() async {
      final result = await _client.finishLogin(
        password: Uint8List.fromList(utf8.encode(password)),
        state: state,
        credentialResponse: credentialResponse,
      );
      return api.OpaqueLoginFinish(
        credentialFinalization: result.credentialFinalization,
        sessionKey: result.sessionKey,
      );
    });
  }
}

Future<T> _run<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on api.OpaqueOperationException {
    rethrow;
  } catch (error) {
    throw api.OpaqueOperationException(error.toString());
  }
}
