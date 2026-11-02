import 'dart:io' show Platform;

import 'package:cupertino_http/cupertino_http.dart';
import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart' as http;

/// Native OS network stacks for the server API client.
///
/// - Android: Cronet (HTTP/2 + QUIC/HTTP/3 when the server advertises it,
///   shared connection pool);
/// - iOS/macOS: NSURLSession via cupertino_http.
///
/// Neither stack exposes a per-host bad-certificate override, so callers
/// that allow insecure TLS (self-signed servers) keep the IOClient path —
/// see [createServerHttpClient]'s fallback in `server_http_client_io.dart`.
http.Client? createNativeServerHttpClient() {
  try {
    if (Platform.isAndroid) {
      // The engine outlives individual clients (creating one is expensive);
      // closeEngine stays false so closing a client keeps the pool warm.
      return CronetClient.fromCronetEngine(_cronetEngine, closeEngine: false);
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoClient.defaultSessionConfiguration();
    }
  } catch (_) {
    // The native stack failed to initialize (missing provider, unusual
    // embedding); the caller falls back to the dart:io client.
  }
  return null;
}

CronetEngine? _cachedCronetEngine;

CronetEngine get _cronetEngine => _cachedCronetEngine ??= CronetEngine.build(
  enableBrotli: true,
  enableHttp2: true,
  enableQuic: true,
);

/// Whether the current platform has a native stack worth using.
bool get hasNativeHttpStack =>
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
