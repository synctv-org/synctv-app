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
  final bool preferProxy;
  final bool proxyOnly;

  const DirectUrlSourceConfig({
    required this.url,
    this.headers = const {},
    this.preferProxy = false,
    this.proxyOnly = false,
  });

  factory DirectUrlSourceConfig.fromUserInput({
    required String url,
    Map<String, String> headers = const {},
    bool preferProxy = false,
    bool proxyOnly = false,
  }) {
    final normalizedUrl = validateUrl(url);
    validateHeaders(headers);
    return DirectUrlSourceConfig(
      url: normalizedUrl,
      headers: headers,
      preferProxy: preferProxy,
      proxyOnly: proxyOnly,
    );
  }

  Map<String, Object> toJson() {
    return {
      'url': url,
      'headers': headers,
      if (preferProxy) 'preferProxy': true,
      if (proxyOnly) 'proxyOnly': true,
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
