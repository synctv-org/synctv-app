import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';

class OAuth2CallbackParser {
  const OAuth2CallbackParser._();

  // Identify the session before interpreting successful or failed callbacks.
  static bool belongsToSession(
    String callbackUrl, {
    required String expectedState,
    required Uri expectedRedirectUri,
  }) {
    if (expectedState.isEmpty) return false;
    try {
      final uri = Uri.tryParse(callbackUrl);
      if (uri == null || !_matchesRedirectUri(uri, expectedRedirectUri)) {
        return false;
      }
      final states = uri.queryParametersAll['state'];
      return states != null &&
          states.length == 1 &&
          states.single.trim() == expectedState;
    } on FormatException {
      return false;
    }
  }

  static OAuth2CallbackPayload parse(
    Uri uri, {
    String expectedState = '',
    Uri? expectedRedirectUri,
  }) {
    if (expectedRedirectUri == null
        ? !_isSupportedCallbackUri(uri)
        : !_matchesRedirectUri(uri, expectedRedirectUri)) {
      throw ArgumentError('授权回跳无效，请重新发起授权');
    }

    final params = uri.queryParametersAll;
    final codes = params['code'];
    final states = params['state'];
    if (codes == null ||
        codes.length != 1 ||
        states == null ||
        states.length != 1) {
      throw ArgumentError('授权回跳无效，请重新发起授权');
    }
    final code = codes.single.trim();
    final state = states.single.trim();

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

  static bool _matchesRedirectUri(Uri uri, Uri expected) {
    return uri.scheme.toLowerCase() == expected.scheme.toLowerCase() &&
        uri.host.toLowerCase() == expected.host.toLowerCase() &&
        uri.port == expected.port &&
        uri.path == expected.path &&
        uri.hasQuery;
  }
}
