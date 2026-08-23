import 'dart:js_interop';

import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:web/web.dart' as web;

final class PlatformOAuth2CallbackDispatcher
    implements OAuth2CallbackDispatcher {
  const PlatformOAuth2CallbackDispatcher();

  @override
  void dispatch() {
    final callbackUrl = web.window.location.href;
    final state = Uri.tryParse(callbackUrl)?.queryParameters['state'];
    final message = {oauth2WebCallbackMessageKey: callbackUrl}.jsify();
    final targetOrigin = web.window.location.origin.toJS;
    final opener = web.window.openerCrossOrigin;

    if (opener != null && !opener.closed) {
      opener.postMessage(message, targetOrigin);
      web.window.close();
      return;
    }

    final parent = web.window.parentCrossOrigin;
    final isEmbedded =
        parent != null && !parent.unsafeWindow.strictEquals(web.window).toDart;
    if (isEmbedded) {
      parent.postMessage(message, targetOrigin);
      return;
    }

    web.window.localStorage.setItem(oauth2WebCallbackMessageKey, callbackUrl);
    if (state != null && state.isNotEmpty) {
      web.window.localStorage.setItem(
        oauth2WebCallbackStorageKey(state),
        callbackUrl,
      );
    }
    web.window.close();
  }
}
