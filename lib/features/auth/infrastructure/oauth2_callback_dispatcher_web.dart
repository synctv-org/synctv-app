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
      _closeAfterDelivery();
      return;
    }

    final parent = web.window.parentCrossOrigin;
    final isEmbedded =
        parent != null && !parent.unsafeWindow.strictEquals(web.window).toDart;
    if (isEmbedded) {
      parent.postMessage(message, targetOrigin);
      return;
    }

    if (state != null && state.isNotEmpty) {
      web.window.localStorage.setItem(
        oauth2WebCallbackStorageKey(state),
        callbackUrl,
      );
      try {
        web.window.localStorage.setItem(
          oauth2WebCallbackMessageKey,
          callbackUrl,
        );
      } catch (_) {
        // The current client already has its state-scoped callback.
      }
    } else {
      web.window.localStorage.setItem(oauth2WebCallbackMessageKey, callbackUrl);
    }
    _closeAfterDelivery();
  }

  void _closeAfterDelivery() {
    try {
      web.window.close();
    } catch (_) {
      // Keep the completion page available when the browser cannot close it.
    }
  }
}
