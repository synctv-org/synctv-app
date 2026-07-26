import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Canonical client-side identity for a SyncTV server.
///
/// A server-provided ID is descriptive metadata. The normalized endpoint is
/// the trust, session, cache, and persistence boundary controlled by the user.
abstract final class ServerEndpointIdentity {
  static String normalize(String input) {
    var value = input.trim();
    if (value.isEmpty) {
      throw const FormatException('Server address is empty');
    }
    if (!value.contains('://')) value = 'https://$value';

    final parsed = Uri.parse(value);
    final scheme = parsed.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      throw FormatException('Unsupported server scheme: ${parsed.scheme}');
    }
    if (parsed.host.isEmpty) {
      throw const FormatException('Server address has no host');
    }
    if (parsed.userInfo.isNotEmpty) {
      throw const FormatException('Server address cannot contain credentials');
    }
    if (parsed.hasQuery || parsed.hasFragment) {
      throw const FormatException(
        'Server address cannot contain a query or fragment',
      );
    }

    var path = parsed.path;
    while (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path.endsWith('/api')) {
      path = path.substring(0, path.length - 4);
    }
    if (path == '/') path = '';

    final defaultPort =
        (scheme == 'https' && parsed.port == 443) ||
        (scheme == 'http' && parsed.port == 80);
    return Uri(
      scheme: scheme,
      host: parsed.host.toLowerCase(),
      port: defaultPort
          ? null
          : parsed.hasPort
          ? parsed.port
          : null,
      path: path,
    ).toString();
  }

  static String storageNamespace(String endpoint) {
    final normalized = normalize(endpoint);
    return sha256.convert(utf8.encode(normalized)).toString();
  }
}
