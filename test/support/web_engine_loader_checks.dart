import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:synctv_video_player_media_kit/src/web_engine_loader.dart';
import 'package:web/web.dart' as web;

const webEngineLoaderChecks = [
  'Stalled loads time out and retry',
  'Concurrent callers share one script and timeout',
  'Script errors clean up and retry',
  'Missing global API cleans up and retries',
  'Successful loads retain the registered API',
  'Existing APIs need no script',
  'Missing document head fails immediately',
];

Future<void> runWebEngineLoaderCheck(String scenario) async {
  final document = web.document.implementation.createHTMLDocument(
    'Loader check',
  );
  final base = document.createElement('base') as web.HTMLBaseElement
    ..href = 'https://fixture.invalid/app/';
  document.head!.append(base);
  final loader = WebEngineLoader(
    document: document,
    timeout: const Duration(milliseconds: 100),
  );
  const name = 'SyncTvLoaderFixture';
  const bundle = WebEngineBundle(
    path: 'playback/fixture.js',
    integrity: 'sha256-fixture',
    globalName: name,
  );
  final api = JSObject();
  web.HTMLScriptElement script() =>
      document.querySelector('script')! as web.HTMLScriptElement;
  Future<Object> result(Future<JSObject> loading) => loading
      .then<Object>((value) => value, onError: (Object error) => error)
      .timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw StateError('Loader remained pending'),
      );
  void expect(bool condition, String message) {
    if (!condition) throw StateError(message);
  }

  try {
    if (scenario == 'Existing APIs need no script') {
      globalContext.setProperty(name.toJS, api);
      expect(await loader.load(bundle) == api, 'Existing API was replaced');
      expect(document.querySelector('script') == null, 'Unexpected script');
      return;
    }
    if (scenario == 'Missing document head fails immediately') {
      document.head!.remove();
      final outcome = await result(loader.load(bundle));
      expect(outcome is StateError, 'Missing head must report a setup error');
      return;
    }

    final loading = loader.load(bundle);
    final outcome = result(loading);
    final firstScript = script();
    expect(
      firstScript.src == 'https://fixture.invalid/app/playback/fixture.js',
      'Asset path did not resolve against the document base',
    );
    expect(firstScript.integrity == bundle.integrity, 'SRI was omitted');
    expect(firstScript.crossOrigin == 'anonymous', 'CORS mode was omitted');
    if (scenario.startsWith('Concurrent')) {
      expect(identical(loading, loader.load(bundle)), 'Loads were not shared');
      expect(
        document.querySelectorAll('script').length == 1,
        'Duplicate script',
      );
    }
    if (scenario.startsWith('Script errors')) {
      firstScript.dispatchEvent(web.Event('error'));
    } else if (scenario.startsWith('Missing global')) {
      firstScript.dispatchEvent(web.Event('load'));
    } else if (scenario.startsWith('Successful')) {
      globalContext.setProperty(name.toJS, api);
      firstScript.dispatchEvent(web.Event('load'));
    }
    final firstResult = await outcome;
    final stalls =
        scenario.startsWith('Stalled') || scenario.startsWith('Concurrent');
    expect(
      stalls
          ? firstResult is TimeoutException
          : scenario.startsWith('Successful')
          ? firstResult == api
          : firstResult is StateError,
      'Unexpected completion: $firstResult',
    );
    expect(document.querySelector('script') == null, 'Settled script leaked');
    if (scenario.startsWith('Successful')) {
      expect(await loader.load(bundle) == api, 'Successful API was not reused');
      expect(
        document.querySelector('script') == null,
        'Successful load repeated',
      );
      return;
    }

    final retry = result(loader.load(bundle));
    final secondScript = script();
    expect(secondScript != firstScript, 'Retry reused the failed script');
    // Events retained by a timed-out attempt cannot settle a newer attempt.
    firstScript.dispatchEvent(web.Event('error'));
    firstScript.dispatchEvent(web.Event('load'));
    globalContext.setProperty(name.toJS, api);
    secondScript.dispatchEvent(web.Event('load'));
    expect(await retry == api, 'Retry did not return the new API');
    expect(document.querySelector('script') == null, 'Retry script leaked');
  } finally {
    globalContext.delete(name.toJS);
    document.documentElement?.remove();
  }
}
