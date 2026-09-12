import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine_web.dart';

const p2pWebRequestChecks = [
  'Late cache hit does not update disposed stats',
  'Late cache miss does not update disposed stats',
  'Invalid worker request closes its port',
  'Completed cached request closes its port',
  'Cancelled cache miss starts no peer request',
  'Cancelled cache hit sends no response',
  'Disposed engine rejects a retained callback',
];

Future<void> runP2pWebRequestCheck(String scenario) async {
  final name = 'SyncTvP2pBridge'.toJS;
  final original = globalContext.getProperty<JSAny?>(name);
  final bridge = JSObject();
  final cache = Completer<JSAny?>();
  final cacheStarted = Completer<void>();
  JSFunction? handler;
  var peerRequests = 0;
  bridge.setProperty(
    'ready'.toJS,
    (() => Future<JSAny?>.value(true.toJS).toJS).toJS,
  );
  bridge.setProperty(
    'setRequestHandler'.toJS,
    ((JSFunction? value) => handler = value).toJS,
  );
  bridge.setProperty(
    'clearRequestHandler'.toJS,
    ((JSFunction? value) {
      if (identical(handler, value)) handler = null;
    }).toJS,
  );
  bridge.setProperty(
    'cacheGet'.toJS,
    ((JSAny? namespace, JSAny? key, JSAny? ttl) {
      if (!cacheStarted.isCompleted) cacheStarted.complete();
      return cache.future.toJS;
    }).toJS,
  );
  globalContext.setProperty(name, bridge);
  final engine = P2pMediaEngine(
    requestPeerPiece: (_, _, _) async {
      peerRequests++;
      return null;
    },
    maxCacheBytes: 1024,
    securityMode: P2pMediaSecurityMode.values.first,
    serverBaseUrl: 'https://example.com',
  );
  final port = JSObject();
  final messages = <Object?>[];
  var closes = 0;
  port.setProperty('start'.toJS, (() {}).toJS);
  port.setProperty('close'.toJS, (() => closes++).toJS);
  port.setProperty(
    'postMessage'.toJS,
    ((JSAny? value) => messages.add(value?.dartify())).toJS,
  );
  void event(String type) {
    port
        .getProperty<JSFunction?>('onmessage'.toJS)
        ?.callAsFunction(
          port,
          {
            'data': {'type': type},
          }.jsify(),
        );
  }

  Future<void> settle() async {
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  try {
    await engine.initialize();
    final retained = handler!;
    if (scenario.startsWith('Late cache')) {
      final before = engine.stats.value;
      final result = engine.cachedPiece('swarm', 'piece');
      await cacheStarted.future;
      await engine.dispose();
      cache.complete(
        scenario.contains('hit') ? Uint8List.fromList([1, 2]).toJS : null,
      );
      _check(await result == null, 'Disposed cache read returned data');
      _check(identical(engine.stats.value, before), 'Disposed stats changed');
      return;
    }
    final uri = await engine.localizeStatic(
      upstream: Uri.parse('data:application/octet-stream;base64,AQ=='),
      headers: const {},
      swarmId: 'swarm',
      logicalKey: 'root',
    );
    if (scenario == 'Disposed engine rejects a retained callback') {
      await engine.dispose();
    }
    retained.callAsFunction(
      null,
      scenario == 'Invalid worker request closes its port'
          ? null
          : {'url': uri.toString(), 'method': 'GET', 'headers': []}.jsify(),
      port,
    );
    if (scenario == 'Invalid worker request closes its port' ||
        scenario == 'Disposed engine rejects a retained callback') {
      await settle();
      _check(closes == 1, 'Rejected request port not closed');
      _check(
        port.getProperty<JSAny?>('onmessage'.toJS) == null,
        'Rejected request retained callback',
      );
      if (scenario.startsWith('Disposed')) {
        _check(
          messages.isEmpty && !cacheStarted.isCompleted,
          'Disposed callback performed work',
        );
      }
      return;
    }
    await cacheStarted.future;
    if (scenario.startsWith('Cancelled')) {
      event('cancel');
    } else {
      event('pull');
    }
    cache.complete(
      scenario.contains('miss') ? null : Uint8List.fromList([1, 2]).toJS,
    );
    await settle();
    _check(closes == 1, 'Completed/cancelled request port not closed');
    _check(
      port.getProperty<JSAny?>('onmessage'.toJS) == null,
      'Completed request retained callback',
    );
    if (scenario.startsWith('Cancelled')) {
      _check(
        peerRequests == 0,
        'Cancelled cache lookup started a peer request',
      );
      _check(messages.isEmpty, 'Cancelled request sent a response');
    } else {
      final types = messages.whereType<Map>().map((m) => m['type']).toList();
      _check(
        types.join(',') == 'meta,chunk,end',
        'Cached response incomplete: $types',
      );
    }
  } finally {
    await engine.dispose();
    globalContext.setProperty(name, original);
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
