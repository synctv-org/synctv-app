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

  static const Set<String> _credentialHeaderNames = {
    'authorization',
    'cookie',
  };

  final String url;
  final Map<String, String> headers;
  final bool preferProxy;

  const DirectUrlSourceConfig({
    required this.url,
    this.headers = const {},
    this.preferProxy = false,
  });

  factory DirectUrlSourceConfig.fromUserInput({
    required String url,
    Map<String, String> headers = const {},
    bool preferProxy = false,
  }) {
    final normalizedUrl = validateUrl(url);
    validateHeaders(headers);
    return DirectUrlSourceConfig(
      url: normalizedUrl,
      headers: headers,
      preferProxy: preferProxy,
    );
  }

  Map<String, Object> toJson() {
    return {
      'url': url,
      'headers': headers,
      if (preferProxy) 'preferProxy': true,
    };
  }

  static String validateUrl(String value) {
    final url = value.trim();
    final uri = Uri.tryParse(url);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      throw const DirectUrlSourceConfigException('请输入有效的 http/https 链接');
    }
    return url;
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

  static bool hasCredentialHeaders(Map<String, String> headers) {
    return credentialHeaderNames(headers).isNotEmpty;
  }

  static Set<String> credentialHeaderNames(Map<String, String> headers) {
    return headers.keys
        .where((name) => _credentialHeaderNames.contains(name.toLowerCase()))
        .toSet();
  }

  static String credentialHeaderRiskKey(Map<String, String> headers) {
    final names = headers.keys
        .map((name) => name.trim().toLowerCase())
        .where(_credentialHeaderNames.contains)
        .toSet()
        .toList(growable: false)
      ..sort();
    return names.join('|');
  }

  static bool hasCredentialHeaderLines(String input) {
    for (final rawLine in input.split('\n')) {
      final separator = rawLine.indexOf(':');
      final name =
          (separator == -1 ? rawLine : rawLine.substring(0, separator)).trim();
      if (_credentialHeaderNames.contains(name.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  static void validateHeaderName(String name) {
    final normalized = name.trim().toLowerCase();
    if (normalized.isEmpty || normalized.contains(RegExp(r'[\r\n:]'))) {
      throw const DirectUrlSourceConfigException('请求头名称无效');
    }
    if (_forbiddenHeaderNames.contains(normalized) ||
        normalized.startsWith('sec-')) {
      throw DirectUrlSourceConfigException('请求头 $name 不允许用于直链媒体');
    }
  }
}

class DirectUrlSourceConfigException implements Exception {
  final String message;

  const DirectUrlSourceConfigException(this.message);

  @override
  String toString() => message;
}
