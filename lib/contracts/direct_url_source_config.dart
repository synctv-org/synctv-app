import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class DirectUrlSourceConfig {
  static const sourceProvider = 'directUrl';

  static const Set<String> _forbiddenHeaderNames = {
    'host',
    'transfer-encoding',
    'content-length',
    'connection',
    'upgrade',
    'proxy-authorization',
    'proxy-connection',
    'te',
    'trailer',
    'x-forwarded-for',
    'x-forwarded-host',
    'x-forwarded-proto',
    'x-real-ip',
    'x-original-url',
    'x-rewrite-url',
    'priority',
  };

  final String url;
  final Map<String, String> headers;
  final source_enum.PlaybackKind playbackKind;
  final bool preferProxy;
  final bool proxyOnly;
  final int? expiresAt;

  const DirectUrlSourceConfig({
    required this.url,
    required this.playbackKind,
    this.headers = const {},
    this.preferProxy = false,
    this.proxyOnly = false,
    this.expiresAt,
  });

  factory DirectUrlSourceConfig.fromUserInput({
    required String url,
    required source_enum.PlaybackKind playbackKind,
    Map<String, String> headers = const {},
    bool preferProxy = false,
    bool proxyOnly = false,
    int? expiresAt,
  }) {
    final normalizedUrl = validateUrl(url);
    validatePlaybackKind(playbackKind);
    validateHeaders(headers);
    if (expiresAt != null && expiresAt <= 0) {
      throw const DirectUrlSourceConfigException('资源过期时间必须是有效的 Unix 时间戳');
    }
    return DirectUrlSourceConfig(
      url: normalizedUrl,
      playbackKind: playbackKind,
      headers: headers,
      preferProxy: preferProxy,
      proxyOnly: proxyOnly,
      expiresAt: expiresAt,
    );
  }

  Map<String, Object> toJson() {
    return {
      'url': url,
      'headers': headers,
      'playbackKind': switch (playbackKind) {
        source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR => 'regular',
        source_enum.PlaybackKind.PLAYBACK_KIND_LIVE => 'live',
        _ => throw ArgumentError.value(
          playbackKind,
          'playbackKind',
          'Direct URL playback kind must be regular or live',
        ),
      },
      if (preferProxy) 'preferProxy': true,
      if (proxyOnly) 'proxyOnly': true,
      'expiresAt': ?expiresAt,
    };
  }

  static String validateUrl(String value) {
    final url = normalizeUrlInput(value);
    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw const DirectUrlSourceConfigException('请输入有效的 http/https 链接');
    }
    return url;
  }

  static void validatePlaybackKind(source_enum.PlaybackKind playbackKind) {
    if (playbackKind != source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR &&
        playbackKind != source_enum.PlaybackKind.PLAYBACK_KIND_LIVE) {
      throw ArgumentError.value(
        playbackKind,
        'playbackKind',
        'Direct URL playback kind must be regular or live',
      );
    }
  }

  static String normalizeUrlInput(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('http//')) {
      return 'http://${trimmed.substring('http//'.length)}';
    }
    if (trimmed.startsWith('https//')) {
      return 'https://${trimmed.substring('https//'.length)}';
    }
    return trimmed;
  }

  static Map<String, String> parseHeaderLines(String input) {
    final headers = <String, String>{};
    for (final rawLine in input.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;
      final separator = line.indexOf(':');
      if (separator <= 0) {
        throw const DirectUrlSourceConfigException(
          '请求头格式应为 Header-Name: value',
        );
      }
      final name = line.substring(0, separator).trim();
      final value = line.substring(separator + 1).trim();
      validateHeaderName(name);
      headers[name] = value;
    }
    return headers;
  }

  static void validateHeaders(Map<String, String> headers) {
    for (final name in headers.keys) {
      validateHeaderName(name);
    }
  }

  static void validateHeaderName(String name) {
    final normalized = _normalizeName(name);
    if (normalized.isEmpty || normalized.contains(RegExp(r'[\r\n:]'))) {
      throw const DirectUrlSourceConfigException('请求头名称无效');
    }
    if (_forbiddenHeaderNames.contains(normalized) ||
        normalized.startsWith('sec-')) {
      throw DirectUrlSourceConfigException('请求头 $name 不允许用于直链媒体');
    }
  }

  static String _normalizeName(String name) => name.trim().toLowerCase();
}

class DirectUrlSourceConfigException implements Exception {
  final String message;

  const DirectUrlSourceConfigException(this.message);

  @override
  String toString() => message;
}
