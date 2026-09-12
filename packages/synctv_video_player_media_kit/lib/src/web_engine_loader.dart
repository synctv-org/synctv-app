import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

const _engineAssetBase = String.fromEnvironment(
  'SYNCTV_WEB_PLAYBACK_ENGINE_ASSET_BASE',
);

class WebEngineBundle {
  const WebEngineBundle({
    required this.path,
    required this.integrity,
    required this.globalName,
  });

  final String path;
  final String integrity;
  final String globalName;
}

class WebEngineLoader {
  WebEngineLoader({
    web.Document? document,
    this.timeout = const Duration(seconds: 15),
  }) : _document = document ?? web.document;

  final web.Document _document;
  final Duration timeout;

  final Map<String, Future<JSObject>> _loads = {};

  Future<JSObject> load(WebEngineBundle bundle) {
    final existing = globalContext.getProperty<JSObject?>(
      bundle.globalName.toJS,
    );
    if (existing != null) return Future.value(existing);
    return _loads.putIfAbsent(bundle.globalName, () async {
      try {
        return await _load(bundle);
      } on Object {
        _loads.remove(bundle.globalName);
        rethrow;
      }
    });
  }

  Future<JSObject> _load(WebEngineBundle bundle) async {
    final head = _document.head;
    if (head == null) {
      throw StateError(
        'Cannot load ${bundle.globalName} without a document head',
      );
    }
    final baseUri = _engineAssetBase.isEmpty
        ? Uri.parse(_document.baseURI)
        : Uri.parse(
            _engineAssetBase.endsWith('/')
                ? _engineAssetBase
                : '$_engineAssetBase/',
          );
    final script = web.HTMLScriptElement()
      ..src = baseUri.resolve(bundle.path).toString()
      ..async = true
      ..integrity = bundle.integrity
      ..crossOrigin = 'anonymous'
      ..dataset['synctvPlaybackEngine'] = bundle.globalName;
    final completer = Completer<void>();
    final loadSubscription = script.onLoad.listen((_) {
      if (!completer.isCompleted) completer.complete();
    });
    final errorSubscription = script.onError.listen((_) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Unable to load ${bundle.globalName} from ${bundle.path}'),
        );
      }
    });
    try {
      head.append(script);
      // Media initialization begins after this shared script load. Bound this
      // earlier wait too, so a stalled request cannot poison every later retry.
      await completer.future.timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          'Timed out loading ${bundle.globalName} from ${bundle.path}',
          timeout,
        ),
      );
    } finally {
      await loadSubscription.cancel();
      await errorSubscription.cancel();
      script.remove();
    }
    final global = globalContext.getProperty<JSObject?>(bundle.globalName.toJS);
    if (global == null) {
      throw StateError('${bundle.globalName} did not register its global API');
    }
    return global;
  }
}
