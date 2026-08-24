import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

const _wasmAssetPath =
    'assets/packages/synctv_opaque/assets/synctv_opaque.wasm';
const _resultSize = 28;

@JS('fetch')
external JSPromise<web.Response> _fetch(JSString url);

@JS('crypto')
external web.Crypto get _crypto;

Future<Uint8List> _randomSeed() async {
  final seed = Uint8List(32);
  _crypto.getRandomValues(seed.toJS);
  return seed;
}

class OpaqueWasmPair {
  const OpaqueWasmPair({required this.first, required this.second});

  final Uint8List first;
  final Uint8List second;
}

class OpaqueWasmBackend {
  OpaqueWasmBackend._(this._wasm);

  final _OpaqueWasm _wasm;

  static Future<OpaqueWasmBackend>? _instance;

  static Future<OpaqueWasmBackend> create() {
    return _instance ??= _load().catchError((Object error) {
      _instance = null;
      throw error;
    });
  }

  static Future<OpaqueWasmBackend> _load() async {
    final url = Uri.base.resolve(_wasmAssetPath).toString();
    final response = await _fetch(url.toJS).toDart;
    if (!response.ok) {
      throw StateError('opaque wasm HTTP ' + response.status.toString());
    }
    final bytes = await response.arrayBuffer().toDart;
    final module = await web.WebAssembly.compile(bytes).toDart;
    final instance = web.Instance(module);
    final wasm = _OpaqueWasm._(instance.exports);
    if (!wasm.validate()) {
      throw StateError('opaque wasm exports are incompatible');
    }
    return OpaqueWasmBackend._(wasm);
  }

  Future<OpaqueWasmPair> registrationStart(Uint8List password) =>
      _callStart(_StartKind.registration, password);

  Future<OpaqueWasmPair> registrationFinish({
    required Uint8List password,
    required Uint8List state,
    required Uint8List response,
  }) => _callFinish(
    _FinishKind.registration,
    password: password,
    state: state,
    response: response,
  );

  Future<OpaqueWasmPair> loginStart(Uint8List password) =>
      _callStart(_StartKind.login, password);

  Future<OpaqueWasmPair> loginFinish({
    required Uint8List password,
    required Uint8List state,
    required Uint8List response,
  }) => _callFinish(
    _FinishKind.login,
    password: password,
    state: state,
    response: response,
  );

  Future<OpaqueWasmPair> _callStart(_StartKind kind, Uint8List password) async {
    final seed = await _randomSeed();
    final passwordPointer = _allocAndWrite(password);
    final seedPointer = _allocAndWrite(seed);
    try {
      final resultPointer = switch (kind) {
        _StartKind.registration =>
          _wasm
              .registrationStart(
                passwordPointer.toJS,
                password.length.toJS,
                seedPointer.toJS,
                seed.length.toJS,
              )
              .toDartInt,
        _StartKind.login =>
          _wasm
              .loginStart(
                passwordPointer.toJS,
                password.length.toJS,
                seedPointer.toJS,
                seed.length.toJS,
              )
              .toDartInt,
      };
      return _decodeResult(resultPointer);
    } finally {
      _free(passwordPointer, password.length);
      _free(seedPointer, seed.length);
    }
  }

  Future<OpaqueWasmPair> _callFinish(
    _FinishKind kind, {
    required Uint8List password,
    required Uint8List state,
    required Uint8List response,
  }) async {
    final seed = await _randomSeed();
    final passwordPointer = _allocAndWrite(password);
    final statePointer = _allocAndWrite(state);
    final responsePointer = _allocAndWrite(response);
    final seedPointer = _allocAndWrite(seed);
    try {
      final resultPointer = switch (kind) {
        _FinishKind.registration =>
          _wasm
              .registrationFinish(
                passwordPointer.toJS,
                password.length.toJS,
                statePointer.toJS,
                state.length.toJS,
                responsePointer.toJS,
                response.length.toJS,
                seedPointer.toJS,
                seed.length.toJS,
              )
              .toDartInt,
        _FinishKind.login =>
          _wasm
              .loginFinish(
                passwordPointer.toJS,
                password.length.toJS,
                statePointer.toJS,
                state.length.toJS,
                responsePointer.toJS,
                response.length.toJS,
                seedPointer.toJS,
                seed.length.toJS,
              )
              .toDartInt,
      };
      return _decodeResult(resultPointer);
    } finally {
      _free(passwordPointer, password.length);
      _free(statePointer, state.length);
      _free(responsePointer, response.length);
      _free(seedPointer, seed.length);
    }
  }

  int _allocAndWrite(Uint8List bytes) {
    if (bytes.isEmpty) return 0;
    final pointer = _wasm.allocate(bytes.length.toJS).toDartInt;
    if (pointer == 0) throw StateError('opaque wasm allocation failed');
    _wasm.write(pointer, bytes);
    return pointer;
  }

  void _free(int pointer, int length) {
    if (pointer != 0 && length != 0) {
      _wasm.deallocate(pointer.toJS, length.toJS);
    }
  }

  OpaqueWasmPair _decodeResult(int resultPointer) {
    if (resultPointer == 0) {
      throw StateError('opaque wasm returned null result');
    }
    final header = _wasm.read(resultPointer, _resultSize);
    final status = _readU32(header, 0);
    final errorPointer = _readU32(header, 4);
    final errorLength = _readU32(header, 8);
    final firstPointer = _readU32(header, 12);
    final firstLength = _readU32(header, 16);
    final secondPointer = _readU32(header, 20);
    final secondLength = _readU32(header, 24);
    try {
      if (status != 0) {
        throw StateError(
          utf8.decode(
            _wasm.read(errorPointer, errorLength),
            allowMalformed: true,
          ),
        );
      }
      return OpaqueWasmPair(
        first: _wasm.read(firstPointer, firstLength),
        second: _wasm.read(secondPointer, secondLength),
      );
    } finally {
      _wasm.freeResult(resultPointer.toJS);
    }
  }
}

enum _StartKind { registration, login }

enum _FinishKind { registration, login }

extension type _OpaqueWasm._(JSObject _) implements JSObject {
  @JS('synctv_wasm_alloc')
  external JSNumber allocate(JSNumber length);

  @JS('synctv_wasm_dealloc')
  external void deallocate(JSNumber pointer, JSNumber length);

  @JS('synctv_wasm_free_result')
  external void freeResult(JSNumber pointer);

  @JS('synctv_wasm_registration_start')
  external JSNumber registrationStart(
    JSNumber passwordPointer,
    JSNumber passwordLength,
    JSNumber seedPointer,
    JSNumber seedLength,
  );

  @JS('synctv_wasm_registration_finish')
  external JSNumber registrationFinish(
    JSNumber passwordPointer,
    JSNumber passwordLength,
    JSNumber statePointer,
    JSNumber stateLength,
    JSNumber responsePointer,
    JSNumber responseLength,
    JSNumber seedPointer,
    JSNumber seedLength,
  );

  @JS('synctv_wasm_login_start')
  external JSNumber loginStart(
    JSNumber passwordPointer,
    JSNumber passwordLength,
    JSNumber seedPointer,
    JSNumber seedLength,
  );

  @JS('synctv_wasm_login_finish')
  external JSNumber loginFinish(
    JSNumber passwordPointer,
    JSNumber passwordLength,
    JSNumber statePointer,
    JSNumber stateLength,
    JSNumber responsePointer,
    JSNumber responseLength,
    JSNumber seedPointer,
    JSNumber seedLength,
  );

  external web.Memory get memory;

  bool validate() {
    final pointer = allocate(1.toJS).toDartInt;
    if (pointer == 0) return false;
    deallocate(pointer.toJS, 1.toJS);
    return true;
  }

  void write(int pointer, Uint8List bytes) {
    memory.buffer.toDart.asUint8List(pointer, bytes.length).setAll(0, bytes);
  }

  Uint8List read(int pointer, int length) {
    if (length == 0) return Uint8List(0);
    if (pointer == 0) throw StateError('opaque wasm returned null buffer');
    return Uint8List.fromList(
      memory.buffer.toDart.asUint8List(pointer, length),
    );
  }
}

int _readU32(Uint8List bytes, int offset) =>
    bytes[offset] |
    (bytes[offset + 1] << 8) |
    (bytes[offset + 2] << 16) |
    (bytes[offset + 3] << 24);
