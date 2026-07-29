class OAuth2CallbackConfig {
  static const String mobileOrigin = String.fromEnvironment(
    'SYNCTV_OAUTH2_APP_LINK_ORIGIN',
    defaultValue: '',
  );

  static bool get hasMobileOrigin => mobileOrigin.trim().isNotEmpty;

  static Uri get mobileOriginUri {
    if (!hasMobileOrigin) {
      throw StateError(
        'SYNCTV_OAUTH2_APP_LINK_ORIGIN must be configured for mobile OAuth2 callbacks',
      );
    }
    return parseMobileOrigin(mobileOrigin);
  }

  static Uri parseMobileOrigin(String value) {
    final uri = Uri.parse(value);
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'https' ||
        uri.host.isEmpty ||
        uri.hasPort ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw StateError(
        'SYNCTV_OAUTH2_APP_LINK_ORIGIN must be an https origin without port, query, or fragment',
      );
    }
    return uri.replace(path: '', query: null, fragment: null);
  }

  static String get mobileCallbackUrl {
    return mobileOriginUri.replace(path: '/oauth2/callback').toString();
  }

  static bool isMobileCallbackUri(Uri uri) {
    if (!hasMobileOrigin) return false;
    return isMobileCallbackUriForOrigin(uri, mobileOriginUri);
  }

  static bool isMobileCallbackUriForOrigin(Uri uri, Uri origin) {
    return uri.scheme == origin.scheme &&
        uri.host == origin.host &&
        uri.port == origin.port &&
        uri.path == '/oauth2/callback';
  }
}
