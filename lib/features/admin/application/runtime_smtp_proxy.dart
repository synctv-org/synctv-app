bool isValidRuntimeSmtpProxyUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null ||
      uri.scheme != 'socks5' ||
      uri.host.isEmpty ||
      RegExp(r'[\x00-\x20\x7f]').hasMatch(value.trim()) ||
      uri.userInfo.isNotEmpty ||
      (uri.path.isNotEmpty && uri.path != '/') ||
      uri.hasQuery ||
      uri.hasFragment) {
    return false;
  }
  try {
    return !uri.hasPort || uri.port >= 0 && uri.port <= 65535;
  } on FormatException {
    return false;
  }
}
