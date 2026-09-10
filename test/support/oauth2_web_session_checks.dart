import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_web_callback_session_web.dart';
import 'package:web/web.dart' as web;

const oauth2WebSessionChecks = [
  'Another state does not end the active session',
  'Another callback path does not end the active session',
  'Another callback origin does not end the active session',
  'Malformed callback does not end the active session',
  'Foreign message origin is ignored',
  'Parallel sessions receive only their own callbacks',
  'Matching callback errors still reach the caller',
  'State-scoped storage callback completes authorization',
  'Storage events cannot complete another state',
  'Duplicate states do not end the active session',
  'Unrelated storage does not hide popup cancellation',
  'Storage failure before authorization is actionable',
  'Storage failure when writing callback storage is actionable',
  'Storage failure during polling terminates authorization',
  'Storage failure during cleanup preserves success',
  'Storage failure during cleanup preserves rejection',
  'Storage failure during cleanup preserves cancellation',
  'Storage failure during cleanup preserves timeout',
];

Future<void> runOAuth2WebSessionCheck(String scenario) async {
  final originalOpen = web.window.getProperty<JSAny?>('open'.toJS);
  final popups = <JSObject>[];
  final sessions = <OAuth2CallbackSession>[];
  final redirect = Uri.base.replace(
    path: '/oauth2/callback',
    query: '',
    fragment: '',
  );
  const state = 'fixture-oauth-state';
  const otherState = 'fixture-other-state';
  final storageFailure = scenario.startsWith('Storage failure');
  final object = globalContext.getProperty<JSObject>('Object'.toJS);
  final storageDescriptor = object.callMethod<JSObject>(
    'getOwnPropertyDescriptor'.toJS,
    web.window,
    'localStorage'.toJS,
  );
  var failReads = false;
  var failRemoves = scenario.contains('before authorization');
  var reads = 0;
  final removedKeys = <String>[];
  if (storageFailure) {
    final storage = JSObject();
    storage.setProperty(
      'setItem'.toJS,
      ((JSString key, JSString value) {
        if (scenario.contains('when writing')) {
          throw StateError('Fixture storage quota exceeded');
        }
      }).toJS,
    );
    storage.setProperty(
      'getItem'.toJS,
      ((JSString key) {
        reads++;
        if (failReads) throw StateError('Fixture storage unavailable');
        return null;
      }).toJS,
    );
    storage.setProperty(
      'removeItem'.toJS,
      ((JSString key) {
        removedKeys.add(key.toDart);
        if (failRemoves) {
          throw StateError('Fixture storage cleanup unavailable');
        }
      }).toJS,
    );
    object.callMethod<JSAny?>(
      'defineProperty'.toJS,
      web.window,
      'localStorage'.toJS,
      {'configurable': true, 'value': storage}.jsify(),
    );
  }
  web.window.setProperty(
    'open'.toJS,
    ((JSAny? url, JSAny? target, JSAny? features) {
      final popup = JSObject();
      popup.setProperty('closed'.toJS, false.toJS);
      popup.setProperty('location'.toJS, JSObject());
      popup.setProperty('focus'.toJS, (() {}).toJS);
      popup.setProperty('blur'.toJS, (() {}).toJS);
      popup.setProperty(
        'close'.toJS,
        (() => popup.setProperty('closed'.toJS, true.toJS)).toJS,
      );
      popups.add(popup);
      return popup;
    }).toJS,
  );

  OAuth2CallbackSession createSession() {
    final session = createOAuth2WebCallbackSession(
      redirectUri: redirect,
      authorizationTimeout: scenario.endsWith('timeout')
          ? const Duration(milliseconds: 20)
          : const Duration(seconds: 3),
    );
    sessions.add(session);
    return session;
  }

  String callback(String value) => redirect
      .replace(queryParameters: {'code': 'fixture-code', 'state': value})
      .toString();

  void message(String url, {String? origin}) {
    web.window.dispatchEvent(
      web.MessageEvent(
        'message',
        web.MessageEventInit(
          origin: origin ?? redirect.origin,
          data: {oauth2WebCallbackMessageKey: url}.jsify(),
        ),
      ),
    );
  }

  Future<void> settle() async {
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  try {
    var completed = false;
    final result = createSession()
        .authorize(authorizationUrl: redirect, expectedState: state)
        .then<Object>(
          (value) {
            completed = true;
            return value;
          },
          onError: (Object error) {
            completed = true;
            return error;
          },
        );
    if (storageFailure) {
      if (scenario.endsWith('actionable')) {
        _check(
          await result.timeout(const Duration(seconds: 1))
              is OAuth2CallbackStorageUnavailable,
          'Storage setup failure was not identified',
        );
        _check(
          popups.single
                  .getProperty<JSObject>('location'.toJS)
                  .getProperty<JSAny?>('href'.toJS) ==
              null,
          'Authorization navigated without storage',
        );
      } else if (scenario.contains('during polling')) {
        failReads = true;
        _check(
          await result.timeout(const Duration(seconds: 1))
              is OAuth2CallbackStorageUnavailable,
          'Polling failure did not terminate authorization',
        );
        final completedReads = reads;
        await Future<void>.delayed(const Duration(milliseconds: 300));
        _check(reads == completedReads, 'Storage failure left polling active');
      } else {
        failRemoves = true;
        if (scenario.endsWith('cancellation')) {
          await sessions.single.close();
        } else if (scenario.endsWith('rejection')) {
          message(
            redirect
                .replace(
                  queryParameters: {'state': state, 'error': 'access_denied'},
                )
                .toString(),
          );
        } else if (scenario.endsWith('success')) {
          message(callback(state));
        }
        final outcome = await result.timeout(const Duration(seconds: 1));
        final correct = switch (scenario.split(' ').last) {
          'success' =>
            outcome is OAuth2CallbackPayload && outcome.code == 'fixture-code',
          'rejection' => outcome is ArgumentError,
          'cancellation' => outcome is OAuth2AuthorizationCanceled,
          'timeout' => outcome is OAuth2AuthorizationTimedOut,
          _ => false,
        };
        _check(correct, 'Cleanup replaced authorization outcome: $outcome');
        _check(
          removedKeys.skip(2).contains(oauth2WebCallbackMessageKey) &&
              removedKeys.skip(2).contains(oauth2WebCallbackStorageKey(state)),
          'Cleanup failure skipped the remaining key',
        );
      }
      return;
    }
    if (scenario.startsWith('Parallel')) {
      var otherCompleted = false;
      final other = createSession()
          .authorize(authorizationUrl: redirect, expectedState: otherState)
          .then<Object>(
            (value) {
              otherCompleted = true;
              return value;
            },
            onError: (Object error) {
              otherCompleted = true;
              return error;
            },
          );
      message(callback(state));
      final first = await result;
      _check(
        first is OAuth2CallbackPayload && first.state == state,
        'First session lost callback',
      );
      await settle();
      _check(!otherCompleted, 'First callback ended second session');
      message(callback(otherState));
      final second = await other;
      _check(
        second is OAuth2CallbackPayload && second.state == otherState,
        'Second session lost callback',
      );
      return;
    }
    if (scenario.startsWith('Matching')) {
      message(
        redirect
            .replace(
              queryParameters: {'state': state, 'error': 'access_denied'},
            )
            .toString(),
      );
      _check(
        await result is ArgumentError,
        'Matching invalid callback was swallowed',
      );
      return;
    }
    if (scenario.startsWith('Unrelated storage')) {
      web.window.localStorage.setItem(
        oauth2WebCallbackStorageKey(state),
        callback(otherState),
      );
      popups.single.setProperty('closed'.toJS, true.toJS);
      _check(
        await result.timeout(const Duration(seconds: 1))
            is OAuth2AuthorizationCanceled,
        'Unrelated storage hid popup cancellation',
      );
      return;
    }
    if (scenario.startsWith('State-scoped')) {
      web.window.localStorage.setItem(
        oauth2WebCallbackStorageKey(state),
        callback(state),
      );
    } else {
      switch (scenario) {
        case 'Another state does not end the active session':
          message(callback(otherState));
        case 'Another callback path does not end the active session':
          message(
            Uri.parse(callback(state)).replace(path: '/unrelated').toString(),
          );
        case 'Another callback origin does not end the active session':
          message(
            Uri.parse(callback(state))
                .replace(host: 'other.example.test')
                .toString(),
          );
        case 'Malformed callback does not end the active session':
          message('not a callback URL');
        case 'Duplicate states do not end the active session':
          message('$redirect?code=fixture-code&state=$otherState&state=$state');
        case 'Foreign message origin is ignored':
          message(callback(state), origin: 'https://other.example.test');
        case 'Storage events cannot complete another state':
          web.window.dispatchEvent(
            web.StorageEvent(
              'storage',
              web.StorageEventInit(
                key: oauth2WebCallbackStorageKey(state),
                newValue: callback(otherState),
              ),
            ),
          );
      }
      await settle();
      _check(!completed, 'Unrelated callback ended the active session');
      message(callback(state));
    }
    final payload = await result.timeout(const Duration(seconds: 1));
    _check(
      payload is OAuth2CallbackPayload &&
          payload.code == 'fixture-code' &&
          payload.state == state,
      'Valid callback was lost: $payload',
    );
  } finally {
    if (storageFailure) {
      object.callMethod<JSAny?>(
        'defineProperty'.toJS,
        web.window,
        'localStorage'.toJS,
        storageDescriptor,
      );
    }
    for (final session in sessions) {
      await session.close();
    }
    web.window.setProperty('open'.toJS, originalOpen);
    for (final value in [state, otherState]) {
      web.window.localStorage.removeItem(oauth2WebCallbackStorageKey(value));
    }
    _check(
      popups.every(
        (popup) => popup.getProperty<JSBoolean>('closed'.toJS).toDart,
      ),
      'Popup not closed',
    );
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
