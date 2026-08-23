import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'ksf_default.dart' as fallback;

const _assetPath = 'assets/packages/synctv_opaque/assets/argon2_wasm.wasm';

Future<void>? _ready;
_Argon2Wasm? _instance;
Future<void>? _derivation;

@JS('fetch')
external JSPromise<web.Response> _fetch(JSString url);

Future<void> _initialize() async {
  try {
    final url = Uri.base.resolve(_assetPath).toString();
    final response = await _fetch(url.toJS).toDart;
    if (!response.ok) {
      throw StateError('argon2 wasm HTTP ${response.status}');
    }
    final bytes = (await response.arrayBuffer().toDart).toDart.asUint8List();
    final module = await web.WebAssembly.compile(bytes.toJS).toDart;
    final instance = web.Instance(module);
    final wasm = _Argon2Wasm._(instance.exports);
    if (!wasm.validate()) {
      throw StateError('argon2 wasm exports are incompatible');
    }
    _instance = wasm;
  } on Object {
    _instance = null;
    rethrow;
  }
}

Future<bool> _ensureWasm() async {
  if (_instance != null) return true;
  final ready = _ready ??= _initialize();
  try {
    await ready;
    return true;
  } on Object {
    _ready = null;
    return false;
  }
}

Future<Uint8List> opaqueKsf(Uint8List input) async {
  if (input.length != 64) {
    throw ArgumentError.value(input.length, 'input', 'must be 64 bytes');
  }
  if (!await _ensureWasm()) {
    return fallback.opaqueKsf(input);
  }

  // Argon2 writes into a shared linear-memory allocation. Serialize calls so
  // overlapping derivations cannot race while retaining one expensive module.
  var previous = _derivation;
  final operation = () async {
    if (previous != null) {
      await previous;
    }
    final instance = _instance!;
    final inputPtr = instance.alloc(input.length);
    final outputPtr = instance.alloc(64);
    if (inputPtr == 0 || outputPtr == 0) {
      throw StateError('failed to allocate argon2 wasm buffers');
    }
    try {
      instance.writeInput(inputPtr, input);
      if (instance.deriveBytes(inputPtr, input.length, outputPtr) != 0) {
        throw StateError('argon2 wasm derivation failed');
      }
      return instance.readOutput(outputPtr);
    } finally {
      instance.dealloc(inputPtr, input.length);
      instance.dealloc(outputPtr, 64);
    }
  }();
  _derivation = operation;
  try {
    return await operation;
  } finally {
    if (identical(_derivation, operation)) {
      _derivation = null;
    }
  }
}

extension type _Argon2Wasm._(JSObject _) implements JSObject {
  bool validate() {
    try {
      final probe = alloc(1);
      dealloc(probe, 1);
      return true;
    } on Object {
      return false;
    }
  }

  external JSNumber allocate(JSNumber length);

  external void deallocate(JSNumber pointer, JSNumber length);

  external JSNumber derive(
    JSNumber inputPointer,
    JSNumber inputLength,
    JSNumber outputPointer,
  );

  external web.Memory get memory;

  int alloc(int length) => allocate(length.toJS).toDartInt;

  void dealloc(int pointer, int length) {
    deallocate(pointer.toJS, length.toJS);
  }

  int deriveBytes(int inputPtr, int inputLength, int outputPtr) => derive(
        inputPtr.toJS,
        inputLength.toJS,
        outputPtr.toJS,
      ).toDartInt;

  Uint8List readOutput(int pointer) {
    final bytes = memory.buffer.toDart.asUint8List(pointer, 64);
    return Uint8List.fromList(bytes);
  }

  void writeInput(int pointer, Uint8List bytes) {
    final destination = memory.buffer.toDart.asUint8List(
      pointer,
      bytes.length,
    );
    destination.setAll(0, bytes);
  }

}
