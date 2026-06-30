import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _assetId = 'package:synctv_opaque/synctv_opaque.dart';

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

class SyncTvOpaqueClient {
  SyncTvOpaqueClient() : _bindings = const _NativeSyncTvOpaqueBindings();

  final _SyncTvOpaqueBindings _bindings;

  OpaqueRegistrationStart startRegistration(String password) {
    final result = _callStart(_bindings.registrationStart, password);
    return OpaqueRegistrationStart(
      registrationRequest: result.first,
      state: result.second,
    );
  }

  OpaqueRegistrationFinish finishRegistration({
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
    return OpaqueRegistrationFinish(registrationUpload: result.first);
  }

  OpaqueLoginStart startLogin(String password) {
    final result = _callStart(_bindings.loginStart, password);
    return OpaqueLoginStart(
      credentialRequest: result.first,
      state: result.second,
    );
  }

  OpaqueLoginFinish finishLogin({
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
    return OpaqueLoginFinish(
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
        throw OpaqueOperationException(message);
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
