import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _assetId =
    'package:synctv_webtransport/src/synctv_webtransport_native.dart';

typedef _ConnectNative = Int64 Function(
  Pointer<Uint8> url,
  Size urlLen,
  Pointer<Uint8> certHash,
  Size certHashLen,
);
typedef _SendNative = Int32 Function(Int64, Pointer<Uint8>, Size);
typedef _RecvNative = Int32 Function(Int64, Pointer<Uint8>, Size);
typedef _CloseNative = Void Function(Int64);
typedef _LastErrorNative = Int32 Function(Pointer<Uint8>, Size);
@Native<_ConnectNative>(symbol: 'synctv_wt_connect', assetId: _assetId)
external int _connect(
  Pointer<Uint8> url,
  int urlLen,
  Pointer<Uint8> certHash,
  int certHashLen,
);

@Native<_SendNative>(symbol: 'synctv_wt_send', assetId: _assetId)
external int _send(int handle, Pointer<Uint8> buf, int len);

@Native<_RecvNative>(symbol: 'synctv_wt_recv', assetId: _assetId)
external int _recv(int handle, Pointer<Uint8> buf, int cap);

@Native<_CloseNative>(symbol: 'synctv_wt_close', assetId: _assetId)
external void _closeHandle(int handle);

@Native<_LastErrorNative>(symbol: 'synctv_wt_last_error', assetId: _assetId)
external int _lastError(Pointer<Uint8> buf, int cap);

/// Runs [body] with [bytes] copied into native memory and frees it after.
T _withBytes<T>(Uint8List bytes, T Function(Pointer<Uint8>) body) {
  final pointer = calloc<Uint8>(bytes.length);
  try {
    pointer.asTypedList(bytes.length).setAll(0, bytes);
    return body(pointer);
  } finally {
    calloc.free(pointer);
  }
}

/// Connects a session; returns the handle or throws with the native error.
int nativeWebTransportConnect(String url, Uint8List? certHash) {
  final urlBytes = Uint8List.fromList(utf8.encode(url));
  final hashBytes = certHash;
  final handle = _withBytes(urlBytes, (urlPointer) {
    if (hashBytes == null) {
      return _connect(urlPointer, urlBytes.length, nullptr, 0);
    }
    return _withBytes(hashBytes, (hashPointer) {
      return _connect(
        urlPointer,
        urlBytes.length,
        hashPointer,
        hashBytes.length,
      );
    });
  });
  if (handle <= 0) {
    throw StateError(nativeWebTransportLastError());
  }
  return handle;
}

/// Sends one frame payload (length prefix added natively). Throws on error.
void nativeWebTransportSend(int handle, Uint8List payload) {
  final result = _withBytes(
    payload,
    (pointer) => _send(handle, pointer, payload.length),
  );
  if (result != 0) {
    throw StateError(nativeWebTransportLastError());
  }
}

/// Receives the next frame payload, blocking until it arrives. Returns null
/// when the session closed.
Uint8List? nativeWebTransportRecv(int handle, {int capacity = 64 * 1024}) {
  var cap = capacity;
  while (true) {
    final buffer = calloc<Uint8>(cap);
    try {
      final length = _recv(handle, buffer, cap);
      if (length > 0) {
        return Uint8List.fromList(buffer.asTypedList(length));
      }
      if (length == -2) {
        // Frames are capped server-side, so doubling terminates.
        cap *= 2;
        continue;
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }
}

/// Closes a session handle; safe on unknown handles.
void nativeWebTransportClose(int handle) => _closeHandle(handle);

/// The last error message produced by a failed call.
String nativeWebTransportLastError() {
  final length = _lastError(nullptr, 0);
  if (length <= 0) return 'unknown native WebTransport error';
  final buffer = calloc<Uint8>(length);
  try {
    final copied = _lastError(buffer, length);
    return String.fromCharCodes(buffer.asTypedList(copied));
  } finally {
    calloc.free(buffer);
  }
}
