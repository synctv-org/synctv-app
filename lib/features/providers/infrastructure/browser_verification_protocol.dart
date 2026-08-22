import 'dart:convert';

/// Validates the envelope returned by an opaque-origin browser verification
/// iframe. The iframe's source is checked by the platform client before this
/// parser is called; the token and bridge checks prevent stale or cross-flow
/// messages from being accepted.
Map<String, Object?>? parseBrowserVerificationMessage(
  Object? data, {
  required String expectedBridge,
  required String expectedToken,
}) {
  final envelope = _asStringKeyedMap(data);
  if (envelope == null ||
      envelope['type'] != 'synctv-provider-verification' ||
      envelope['bridge'] != expectedBridge ||
      envelope['token'] != expectedToken) {
    return null;
  }
  final payload = _asStringKeyedMap(envelope['payload']);
  if (payload == null) {
    throw const FormatException('浏览器安全验证消息格式无效');
  }
  return payload;
}

Map<String, Object?>? _asStringKeyedMap(Object? value) {
  if (value is! Map<Object?, Object?>) return null;
  return {
    for (final entry in value.entries)
      if (entry.key is String) entry.key! as String: entry.value,
  };
}

String encodeBrowserVerificationMessage({
  required String bridge,
  required String token,
  required Map<String, Object?> payload,
}) {
  return jsonEncode({
    'type': 'synctv-provider-verification',
    'bridge': bridge,
    'token': token,
    'payload': payload,
  });
}
