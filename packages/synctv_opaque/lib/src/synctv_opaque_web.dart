import 'dart:convert';
import 'dart:typed_data';

import 'opaque/opaque_client.dart' as protocol;
import 'opaque/wasm_opaque.dart';
import 'synctv_opaque_api.dart' as api;

class SyncTvOpaqueClient implements api.SyncTvOpaqueClient {
  SyncTvOpaqueClient();

  final protocol.OpaqueProtocolClient _fallback =
      protocol.OpaqueProtocolClient();
  @override
  Future<api.OpaqueRegistrationStart> startRegistration(String password) {
    return _run(() async {
      final bytes = Uint8List.fromList(utf8.encode(password));
      final result = await _wasmOrFallback(
        wasm: (backend) => backend.registrationStart(bytes),
        fallback: () => _fallback
            .startRegistration(bytes)
            .then(
              (value) => OpaqueWasmPair(
                first: value.registrationRequest,
                second: value.state,
              ),
            ),
      );
      return api.OpaqueRegistrationStart(
        registrationRequest: result.first,
        state: result.second,
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
      final bytes = Uint8List.fromList(utf8.encode(password));
      final result = await _wasmOrFallback(
        wasm: (backend) => backend.registrationFinish(
          password: bytes,
          state: state,
          response: registrationResponse,
        ),
        fallback: () => _fallback
            .finishRegistration(
              password: bytes,
              state: state,
              registrationResponse: registrationResponse,
            )
            .then(
              (value) => OpaqueWasmPair(
                first: value.registrationUpload,
                second: Uint8List(0),
              ),
            ),
      );
      return api.OpaqueRegistrationFinish(registrationUpload: result.first);
    });
  }

  @override
  Future<api.OpaqueLoginStart> startLogin(String password) {
    return _run(() async {
      final bytes = Uint8List.fromList(utf8.encode(password));
      final result = await _wasmOrFallback(
        wasm: (backend) => backend.loginStart(bytes),
        fallback: () => _fallback
            .startLogin(bytes)
            .then(
              (value) => OpaqueWasmPair(
                first: value.credentialRequest,
                second: value.state,
              ),
            ),
      );
      return api.OpaqueLoginStart(
        credentialRequest: result.first,
        state: result.second,
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
      final bytes = Uint8List.fromList(utf8.encode(password));
      final result = await _wasmOrFallback(
        wasm: (backend) => backend.loginFinish(
          password: bytes,
          state: state,
          response: credentialResponse,
        ),
        fallback: () => _fallback
            .finishLogin(
              password: bytes,
              state: state,
              credentialResponse: credentialResponse,
            )
            .then(
              (value) => OpaqueWasmPair(
                first: value.credentialFinalization,
                second: value.sessionKey,
              ),
            ),
      );
      return api.OpaqueLoginFinish(
        credentialFinalization: result.first,
        sessionKey: result.second,
      );
    });
  }
}

Future<OpaqueWasmPair> _wasmOrFallback({
  required Future<OpaqueWasmPair> Function(OpaqueWasmBackend backend) wasm,
  required Future<OpaqueWasmPair> Function() fallback,
}) async {
  late final OpaqueWasmBackend backend;
  try {
    backend = await OpaqueWasmBackend.create();
  } on Object {
    return fallback();
  }
  return wasm(backend);
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
