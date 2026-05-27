import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/services/oauth2_callback_config.dart';

class OAuth2CallbackParser {
  const OAuth2CallbackParser._();

  static OAuth2CallbackPayload parse(
    Uri uri, {
    String expectedState = '',
  }) {
    if (!_isSupportedCallbackUri(uri)) {
      throw ArgumentError('授权回跳无效，请重新发起授权');
    }

    final params = _parseQuery(uri.query);
    final code = params['code']?.trim() ?? '';
    final state = params['state']?.trim() ?? '';

    if (code.isEmpty) {
      throw ArgumentError('授权回跳无效，请重新发起授权');
    }
    if (state.isEmpty) {
      throw ArgumentError('授权回跳无效，请重新发起授权');
    }
    if (expectedState.isNotEmpty && state != expectedState) {
      throw ArgumentError('授权状态已失效，请重新发起授权');
    }
    return OAuth2CallbackPayload(code: code, state: state);
  }

  static bool _isSupportedCallbackUri(Uri uri) {
    if (uri.path != '/oauth2/callback' || !uri.hasQuery) return false;
    if (uri.scheme == 'http' &&
        (uri.host == '127.0.0.1' ||
            uri.host == 'localhost' ||
            uri.host == '::1')) {
      return true;
    }
    return OAuth2CallbackConfig.isMobileCallbackUri(uri);
  }

  static Map<String, String> _parseQuery(String query) {
    final params = <String, String>{};
    for (final part in query.split('&')) {
      if (part.isEmpty) continue;
      final separator = part.indexOf('=');
      final key = separator < 0 ? part : part.substring(0, separator);
      final value = separator < 0 ? '' : part.substring(separator + 1);
      params[Uri.decodeComponent(key)] = Uri.decodeComponent(value);
    }
    return params;
  }
}
