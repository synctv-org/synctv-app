import 'dart:async';
import 'dart:js_interop';

import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:web/web.dart' as web;

const _popupFeatures = 'popup=yes,width=520,height=720';
const _closedWindowPollInterval = Duration(milliseconds: 250);

OAuth2CallbackSession createOAuth2WebCallbackSession({
  required Uri redirectUri,
  required Duration authorizationTimeout,
}) {
  final popup = web.window.open('about:blank', '_blank', _popupFeatures);
  if (popup == null) throw const OAuth2AuthorizationWindowBlocked();

  // The callback can use same-origin storage when the provider cannot access
  // its opener. Retain the WindowProxy so this page can still navigate it.
  popup.opener = null;
  popup.blur();
  web.window.focus();
  return _WebOAuth2CallbackSession(
    popup,
    redirectUri: redirectUri,
    authorizationTimeout: authorizationTimeout,
  );
}

final class _WebOAuth2CallbackSession implements OAuth2CallbackSession {
  _WebOAuth2CallbackSession(
    this._popup, {
    required this.redirectUri,
    required this.authorizationTimeout,
  });

  final web.Window _popup;
  final Uri redirectUri;
  final Duration authorizationTimeout;

  StreamSubscription<web.MessageEvent>? _messageSubscription;
  StreamSubscription<web.StorageEvent>? _storageSubscription;
  Timer? _pollTimer;
  Timer? _timeoutTimer;
  Completer<String>? _pendingCallback;
  bool _closed = false;

  @override
  String get redirectUrl => redirectUri.toString();

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    if (_closed || _popup.closed) {
      throw const OAuth2AuthorizationCanceled();
    }
    if (_pendingCallback != null) {
      throw StateError('This OAuth2 session is already authorizing.');
    }

    final storageKey = oauth2WebCallbackStorageKey(expectedState);
    web.window.localStorage
      ..removeItem(oauth2WebCallbackMessageKey)
      ..removeItem(storageKey);
    final callback = Completer<String>();
    _pendingCallback = callback;

    void complete(String callbackUrl) {
      if (!callback.isCompleted) callback.complete(callbackUrl);
    }

    _messageSubscription = web.window.onMessage.listen((event) {
      if (event.origin != redirectUri.origin) return;
      final data = event.data.dartify();
      final callbackUrl = data is Map
          ? data[oauth2WebCallbackMessageKey]
          : null;
      if (callbackUrl is String) complete(callbackUrl);
    });
    _storageSubscription = web.EventStreamProviders.storageEvent
        .forTarget(web.window)
        .listen((event) {
          if (event.key != storageKey) return;
          final value = event.newValue;
          if (value != null) complete(value);
        });
    _pollTimer = Timer.periodic(_closedWindowPollInterval, (_) {
      final callbackUrl = web.window.localStorage.getItem(storageKey);
      if (callbackUrl != null) {
        complete(callbackUrl);
      } else if (_popup.closed && !callback.isCompleted) {
        callback.completeError(const OAuth2AuthorizationCanceled());
      }
    });
    _timeoutTimer = Timer(authorizationTimeout, () {
      if (!callback.isCompleted) {
        callback.completeError(const OAuth2AuthorizationTimedOut());
      }
    });

    try {
      _popup.focus();
      _popup.location.href = authorizationUrl.toString();
      final callbackUrl = await callback.future;
      return OAuth2CallbackParser.parse(
        Uri.parse(callbackUrl),
        expectedState: expectedState,
        expectedRedirectUri: redirectUri,
      );
    } finally {
      await _clearListeners();
      _pendingCallback = null;
      web.window.localStorage
        ..removeItem(oauth2WebCallbackMessageKey)
        ..removeItem(storageKey);
    }
  }

  Future<void> _clearListeners() async {
    _pollTimer?.cancel();
    _pollTimer = null;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    await _storageSubscription?.cancel();
    _storageSubscription = null;
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    final callback = _pendingCallback;
    if (callback != null && !callback.isCompleted) {
      callback.completeError(const OAuth2AuthorizationCanceled());
    }
    await _clearListeners();
    if (!_popup.closed) _popup.close();
  }
}
