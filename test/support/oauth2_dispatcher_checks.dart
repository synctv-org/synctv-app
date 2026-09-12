import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_dispatcher_web.dart';
import 'package:web/web.dart' as web;

const oauth2DispatcherChecks = [
  'Scoped delivery survives legacy storage failure',
  'Scoped storage failure remains retryable',
  'Storage delivery survives window close failure',
  'Opener delivery survives window close failure',
  'Opener delivery preserves origin and callback URL',
  'Legacy callback without state still delivers',
  'Legacy callback storage failure remains retryable',
];

void runOAuth2DispatcherCheck(String scenario) {
  final object = globalContext.getProperty<JSObject>('Object'.toJS);
  final descriptors = <String, JSAny?>{};
  final originalUrl = web.window.location.href;
  final written = <String, String>{};
  final legacy = scenario.startsWith('Legacy');
  final openerCase = scenario.startsWith('Opener');
  final expectedFailure = scenario.contains('remains retryable');
  const state = 'dispatcher-fixture-state';
  final stateKey = oauth2WebCallbackStorageKey(state);
  var closeCount = 0;
  JSAny? posted;
  String? postedOrigin;

  void replace(String name, JSAny? value) {
    descriptors[name] = object.callMethod<JSAny?>(
      'getOwnPropertyDescriptor'.toJS,
      web.window,
      name.toJS,
    );
    object.callMethod<JSAny?>(
      'defineProperty'.toJS,
      web.window,
      name.toJS,
      {'configurable': true, 'value': value}.jsify(),
    );
  }

  try {
    web.window.history.replaceState(
      null,
      '',
      Uri.parse(originalUrl)
          .replace(
            queryParameters: {
              'code': 'fixture-code',
              if (!legacy) 'state': state,
            },
          )
          .toString(),
    );
    final callbackUrl = web.window.location.href;
    final storage = JSObject();
    storage.setProperty(
      'setItem'.toJS,
      ((JSString key, JSString value) {
        final name = key.toDart;
        if ((scenario.contains('legacy storage failure') ||
                    legacy && expectedFailure) &&
                name == oauth2WebCallbackMessageKey ||
            scenario == 'Scoped storage failure remains retryable' &&
                name == stateKey) {
          throw StateError('Injected storage failure');
        }
        written[name] = value.toDart;
      }).toJS,
    );
    final opener = JSObject();
    opener.setProperty('closed'.toJS, false.toJS);
    opener.setProperty(
      'postMessage'.toJS,
      ((JSAny? message, JSString origin) {
        posted = message;
        postedOrigin = origin.toDart;
      }).toJS,
    );
    replace('opener', openerCase ? opener : null);
    replace('parent', web.window);
    replace('localStorage', storage);
    replace(
      'close',
      (() {
        closeCount++;
        if (scenario.contains('close failure')) {
          throw StateError('Injected close failure');
        }
      }).toJS,
    );
    Object? failure;
    try {
      const PlatformOAuth2CallbackDispatcher().dispatch();
    } catch (error) {
      failure = error;
    }
    if (expectedFailure) {
      _check(failure != null, 'Required delivery failure was swallowed');
      _check(closeCount == 0, 'Failed delivery closed the retry window');
      return;
    }
    _check(failure == null, 'Successful delivery reported failure');
    _check(closeCount == 1, 'Successful delivery did not attempt close once');
    if (openerCase) {
      final data = posted.dartify() as Map;
      _check(
        data[oauth2WebCallbackMessageKey] == callbackUrl,
        'Callback URL changed',
      );
      _check(
        postedOrigin == web.window.location.origin,
        'Target origin changed',
      );
      _check(written.isEmpty, 'Opener delivery unexpectedly wrote storage');
    } else {
      _check(
        written[legacy ? oauth2WebCallbackMessageKey : stateKey] == callbackUrl,
        'Required callback storage was not written',
      );
    }
  } finally {
    for (final entry in descriptors.entries.toList().reversed) {
      if (entry.value == null) {
        web.window.delete(entry.key.toJS);
      } else {
        object.callMethod<JSAny?>(
          'defineProperty'.toJS,
          web.window,
          entry.key.toJS,
          entry.value,
        );
      }
    }
    web.window.history.replaceState(null, '', originalUrl);
  }
}

void _check(bool value, String message) {
  if (!value) throw StateError(message);
}
