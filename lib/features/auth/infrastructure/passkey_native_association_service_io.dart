import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:synctv_app/core/network/server_endpoint_identity.dart';

class PasskeyNativeAssociationService {
  static const _identityChannel = MethodChannel(
    'org.synctv.app/passkey_identity',
  );
  static const _requestTimeout = Duration(seconds: 2);
  static const _maxAssociationFileBytes = 256 * 1024;
  static const _successTtl = Duration(minutes: 10);
  static const _failureTtl = Duration(minutes: 1);
  static const _configuredRpIdsValue = String.fromEnvironment(
    'SYNCTV_PASSKEY_RP_IDS',
  );
  static final Set<String> _configuredAppleRpIds = _configuredRpIdsValue
      .split(';')
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();
  static final Map<String, _AssociationCacheEntry> _cache = {};
  static final Map<String, Future<bool>> _inFlight = {};

  static Future<bool> isAssociated({
    required String serverBaseUrl,
    required String rpId,
  }) async {
    final endpoint = ServerEndpointIdentity.normalize(serverBaseUrl);
    final cacheKey = '${defaultTargetPlatform.name}:$endpoint:$rpId';
    final now = DateTime.now();
    final cached = _cache[cacheKey];
    if (cached != null && cached.expiresAt.isAfter(now)) return cached.value;
    return _inFlight.putIfAbsent(cacheKey, () async {
      try {
        final value = await _checkAssociation(rpId);
        _cache[cacheKey] = _AssociationCacheEntry(
          value: value,
          expiresAt: DateTime.now().add(value ? _successTtl : _failureTtl),
        );
        return value;
      } finally {
        _inFlight.remove(cacheKey);
      }
    });
  }

  static Future<bool> _checkAssociation(String rpId) async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _isAndroidAssociated(rpId);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _isAppleAssociated(rpId);
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  static Future<bool> _isAndroidAssociated(String rpId) async {
    final identity = await _identityChannel.invokeMapMethod<String, dynamic>(
      'getAndroidIdentity',
    );
    final packageName = identity?['packageName'] as String? ?? '';
    final fingerprints =
        (identity?['certificateSha256'] as List?)
            ?.whereType<String>()
            .map(_normalizeFingerprint)
            .toSet() ??
        const <String>{};
    if (packageName.isEmpty || fingerprints.isEmpty) return false;

    final document = await _readJson(
      Uri.https(rpId, '/.well-known/assetlinks.json'),
    );
    return androidDocumentMatches(
      document: document,
      packageName: packageName,
      certificateSha256: fingerprints,
    );
  }

  @visibleForTesting
  static bool androidDocumentMatches({
    required Object? document,
    required String packageName,
    required Set<String> certificateSha256,
  }) {
    if (document is! List) return false;
    final fingerprints = certificateSha256.map(_normalizeFingerprint).toSet();
    for (final statement in document.whereType<Map>()) {
      final relations = statement['relation'];
      final target = statement['target'];
      if (relations is! List || target is! Map) continue;
      if (!relations.contains('delegate_permission/common.get_login_creds')) {
        continue;
      }
      if (target['namespace'] != 'android_app' ||
          target['package_name'] != packageName) {
        continue;
      }
      final configured =
          (target['sha256_cert_fingerprints'] as List?)
              ?.whereType<String>()
              .map(_normalizeFingerprint)
              .toSet() ??
          const <String>{};
      if (configured.intersection(fingerprints).isNotEmpty) return true;
    }
    return false;
  }

  static Future<bool> _isAppleAssociated(String rpId) async {
    if (!_configuredAppleRpIds.contains(rpId.toLowerCase())) return false;
    final identity = await _identityChannel.invokeMapMethod<String, dynamic>(
      'getAppleIdentity',
    );
    final applicationIdentifier =
        identity?['applicationIdentifier'] as String? ?? '';
    if (applicationIdentifier.isEmpty) return false;

    final document = await _readJson(
      Uri.https(rpId, '/.well-known/apple-app-site-association'),
    );
    return appleDocumentMatches(
      document: document,
      applicationIdentifier: applicationIdentifier,
    );
  }

  @visibleForTesting
  static bool appleDocumentMatches({
    required Object? document,
    required String applicationIdentifier,
  }) {
    if (document is! Map) return false;
    final webcredentials = document['webcredentials'];
    if (webcredentials is! Map) return false;
    final apps = webcredentials['apps'];
    return apps is List && apps.contains(applicationIdentifier);
  }

  static Future<Object?> _readJson(Uri uri) async {
    final client = http.Client();
    try {
      final response = await client
          .send(http.Request('GET', uri))
          .timeout(_requestTimeout);
      if (response.statusCode != 200) return null;
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.stream.timeout(_requestTimeout)) {
        bytes.add(chunk);
        if (bytes.length > _maxAssociationFileBytes) return null;
      }
      return jsonDecode(utf8.decode(bytes.takeBytes()));
    } on Object {
      return null;
    } finally {
      client.close();
    }
  }

  static String _normalizeFingerprint(String value) =>
      value.replaceAll(':', '').trim().toUpperCase();
}

class _AssociationCacheEntry {
  const _AssociationCacheEntry({required this.value, required this.expiresAt});

  final bool value;
  final DateTime expiresAt;
}
