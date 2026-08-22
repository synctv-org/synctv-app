import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'synctv_opaque_api.dart' as api;

const _assetId = 'package:synctv_opaque/src/synctv_opaque_native.dart';

final class _NativeBuffer extends Struct {
  external Pointer<Uint8> ptr;

  @Size()
  external int len;
}

final class _NativeResult extends Struct {
  @Int32()
  external int status;

  external _NativeBuffer error;
  external _NativeBuffer first;
  external _NativeBuffer second;
}

typedef _StartNative =
    _NativeResult Function(Pointer<Uint8> password, Size passwordLen);
typedef _StartDart =
    _NativeResult Function(Pointer<Uint8> password, int passwordLen);

typedef _FinishNative =
    _NativeResult Function(
      Pointer<Uint8> password,
      Size passwordLen,
      Pointer<Uint8> state,
      Size stateLen,
      Pointer<Uint8> response,
      Size responseLen,
    );
typedef _FinishDart =
    _NativeResult Function(
      Pointer<Uint8> password,
      int passwordLen,
      Pointer<Uint8> state,
      int stateLen,
      Pointer<Uint8> response,
      int responseLen,
    );

typedef _FreeBufferNative = Void Function(_NativeBuffer buffer);

class SyncTvOpaqueClient implements api.SyncTvOpaqueClient {
  SyncTvOpaqueClient() : _bindings = const _NativeSyncTvOpaqueBindings();

  final _SyncTvOpaqueBindings _bindings;

  @override
  Future<api.OpaqueRegistrationStart> startRegistration(String password) async {
    final result = _startRegistrationSync(password);
    return api.OpaqueRegistrationStart(
      registrationRequest: result.registrationRequest,
      state: result.state,
    );
  }

  api.OpaqueRegistrationStart _startRegistrationSync(String password) {
    final result = _callStart(_bindings.registrationStart, password);
    return api.OpaqueRegistrationStart(
      registrationRequest: result.first,
      state: result.second,
    );
  }

  @override
  Future<api.OpaqueRegistrationFinish> finishRegistration({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  }) async {
    final result = _finishRegistrationSync(
      password: password,
      state: state,
      registrationResponse: registrationResponse,
    );
    return api.OpaqueRegistrationFinish(
      registrationUpload: result.registrationUpload,
    );
  }

  api.OpaqueRegistrationFinish _finishRegistrationSync({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  }) {
    final result = _callFinish(
      _bindings.registrationFinish,
      password,
      state,
      registrationResponse,
    );
    return api.OpaqueRegistrationFinish(registrationUpload: result.first);
  }

  @override
  Future<api.OpaqueLoginStart> startLogin(String password) async {
    final result = _startLoginSync(password);
    return api.OpaqueLoginStart(
      credentialRequest: result.credentialRequest,
      state: result.state,
    );
  }

  api.OpaqueLoginStart _startLoginSync(String password) {
    final result = _callStart(_bindings.loginStart, password);
    return api.OpaqueLoginStart(
      credentialRequest: result.first,
      state: result.second,
    );
  }

  @override
  Future<api.OpaqueLoginFinish> finishLogin({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  }) async {
    final result = _finishLoginSync(
      password: password,
      state: state,
      credentialResponse: credentialResponse,
    );
    return api.OpaqueLoginFinish(
      credentialFinalization: result.credentialFinalization,
      sessionKey: result.sessionKey,
    );
  }

  api.OpaqueLoginFinish _finishLoginSync({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  }) {
    final result = _callFinish(
      _bindings.loginFinish,
      password,
      state,
      credentialResponse,
    );
    return api.OpaqueLoginFinish(
      credentialFinalization: result.first,
      sessionKey: result.second,
    );
  }

  _OpaquePair _callStart(_StartDart function, String password) {
    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    return using((arena) {
      final passwordPtr = arena.allocate<Uint8>(passwordBytes.length);
      passwordPtr.asTypedList(passwordBytes.length).setAll(0, passwordBytes);
      final result = function(passwordPtr, passwordBytes.length);
      return _decodeResult(result);
    });
  }

  _OpaquePair _callFinish(
    _FinishDart function,
    String password,
    Uint8List state,
    Uint8List response,
  ) {
    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    return using((arena) {
      final passwordPtr = arena.allocate<Uint8>(passwordBytes.length);
      passwordPtr.asTypedList(passwordBytes.length).setAll(0, passwordBytes);
      final statePtr = arena.allocate<Uint8>(state.length);
      statePtr.asTypedList(state.length).setAll(0, state);
      final responsePtr = arena.allocate<Uint8>(response.length);
      responsePtr.asTypedList(response.length).setAll(0, response);
      final result = function(
        passwordPtr,
        passwordBytes.length,
        statePtr,
        state.length,
        responsePtr,
        response.length,
      );
      return _decodeResult(result);
    });
  }

  _OpaquePair _decodeResult(_NativeResult result) {
    try {
      if (result.status != 0) {
        final message = String.fromCharCodes(_copyBuffer(result.error));
        throw api.OpaqueOperationException(message);
      }
      return _OpaquePair(
        first: _copyBuffer(result.first),
        second: _copyBuffer(result.second),
      );
    } finally {
      _bindings.freeBuffer(result.error);
      _bindings.freeBuffer(result.first);
      _bindings.freeBuffer(result.second);
    }
  }

  Uint8List _copyBuffer(_NativeBuffer buffer) {
    if (buffer.ptr == nullptr || buffer.len == 0) return Uint8List(0);
    return Uint8List.fromList(buffer.ptr.asTypedList(buffer.len));
  }
}

class _OpaquePair {
  const _OpaquePair({required this.first, required this.second});

  final Uint8List first;
  final Uint8List second;
}

abstract interface class _SyncTvOpaqueBindings {
  _NativeResult registrationStart(Pointer<Uint8> password, int passwordLen);

  _NativeResult registrationFinish(
    Pointer<Uint8> password,
    int passwordLen,
    Pointer<Uint8> state,
    int stateLen,
    Pointer<Uint8> response,
    int responseLen,
  );

  _NativeResult loginStart(Pointer<Uint8> password, int passwordLen);

  _NativeResult loginFinish(
    Pointer<Uint8> password,
    int passwordLen,
    Pointer<Uint8> state,
    int stateLen,
    Pointer<Uint8> response,
    int responseLen,
  );

  void freeBuffer(_NativeBuffer buffer);
}

class _NativeSyncTvOpaqueBindings implements _SyncTvOpaqueBindings {
  const _NativeSyncTvOpaqueBindings();

  @override
  _NativeResult registrationStart(Pointer<Uint8> password, int passwordLen) =>
      _registrationStart(password, passwordLen);

  @override
  _NativeResult registrationFinish(
    Pointer<Uint8> password,
    int passwordLen,
    Pointer<Uint8> state,
    int stateLen,
    Pointer<Uint8> response,
    int responseLen,
  ) => _registrationFinish(
    password,
    passwordLen,
    state,
    stateLen,
    response,
    responseLen,
  );

  @override
  _NativeResult loginStart(Pointer<Uint8> password, int passwordLen) =>
      _loginStart(password, passwordLen);

  @override
  _NativeResult loginFinish(
    Pointer<Uint8> password,
    int passwordLen,
    Pointer<Uint8> state,
    int stateLen,
    Pointer<Uint8> response,
    int responseLen,
  ) => _loginFinish(
    password,
    passwordLen,
    state,
    stateLen,
    response,
    responseLen,
  );

  @override
  void freeBuffer(_NativeBuffer buffer) => _freeBuffer(buffer);
}

@Native<_StartNative>(
  symbol: 'synctv_opaque_registration_start',
  assetId: _assetId,
)
external _NativeResult _registrationStart(
  Pointer<Uint8> password,
  int passwordLen,
);

@Native<_FinishNative>(
  symbol: 'synctv_opaque_registration_finish',
  assetId: _assetId,
)
external _NativeResult _registrationFinish(
  Pointer<Uint8> password,
  int passwordLen,
  Pointer<Uint8> state,
  int stateLen,
  Pointer<Uint8> response,
  int responseLen,
);

@Native<_StartNative>(symbol: 'synctv_opaque_login_start', assetId: _assetId)
external _NativeResult _loginStart(Pointer<Uint8> password, int passwordLen);

@Native<_FinishNative>(symbol: 'synctv_opaque_login_finish', assetId: _assetId)
external _NativeResult _loginFinish(
  Pointer<Uint8> password,
  int passwordLen,
  Pointer<Uint8> state,
  int stateLen,
  Pointer<Uint8> response,
  int responseLen,
);

@Native<_FreeBufferNative>(
  symbol: 'synctv_opaque_free_buffer',
  assetId: _assetId,
)
external void _freeBuffer(_NativeBuffer buffer);
