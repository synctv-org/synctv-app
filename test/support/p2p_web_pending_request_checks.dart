import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine_web.dart';

const p2pWebPendingRequestChecks = [
  'Pending cache cancellation releases request before late success',
  'Pending cache cancellation releases request before late failure',
  'Pending peer cancellation releases request before late success',
  'Pending peer cancellation releases request before late failure',
  'Pending length cancellation releases request before late success',
  'Pending length cancellation releases request before late failure',
  'Active cache request delivers success',
  'Active cache request reports failure',
  'Active peer request delivers success',
  'Active peer request reports failure',
  'Active length request delivers success',
  'Active length request reports failure',
];

Future<void> runP2pWebPendingRequestCheck(String scenario) async {
  final pendingCache = scenario.contains('cache');
  final pendingLength = scenario.contains('length');
  final lateFailure = scenario.contains('failure');
  final bridgeName = 'SyncTvP2pBridge'.toJS;
  final original = globalContext.getProperty<JSAny?>(bridgeName);
  final bridge = JSObject();
  final cache = Completer<JSAny?>();
  final peer = Completer<P2pPeerPiece?>();
  final origin = Completer<http.Response>();
  final started = Completer<void>();
  final originStarted = Completer<void>();
  JSFunction? handler;
  P2pPieceRequestCancellation? peerCancellation;
  var peerCalls = 0;
  var originCalls = 0;
  var cacheWrites = 0;
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
      if (identical(value, handler)) handler = null;
    }).toJS,
  );
  bridge.setProperty(
    'cacheGet'.toJS,
    ((JSAny? namespace, JSAny? key, JSAny? ttl) {
      if (pendingCache && !started.isCompleted) started.complete();
      return pendingCache ? cache.future.toJS : Future<JSAny?>.value().toJS;
    }).toJS,
  );
  bridge.setProperty(
    'cachePut'.toJS,
    ((JSAny? namespace, JSAny? key, JSAny? bytes, JSAny? limit, JSAny? ttl) {
      cacheWrites++;
      return Future<JSAny?>.value(0.toJS).toJS;
    }).toJS,
  );
  globalContext.setProperty(bridgeName, bridge);
  final client = MockClient((request) {
    originCalls++;
    if (!originStarted.isCompleted) originStarted.complete();
    return origin.future;
  });
  final engine = P2pMediaEngine(
    requestPeerPiece: (_, _, cancellation) {
      peerCalls++;
      peerCancellation = cancellation;
      if (!started.isCompleted) started.complete();
      return peer.future;
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
    ((JSAny? message) => messages.add(message?.dartify())).toJS,
  );
  Future<void> settle() async {
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  void finishPending() {
    final failure = StateError('Delayed request failed');
    if (pendingCache && !cache.isCompleted) {
      if (lateFailure) {
        cache.completeError(failure);
      } else {
        cache.complete(Uint8List.fromList([1, 2]).toJS);
      }
    }
    if (!pendingCache && !peer.isCompleted) {
      if (lateFailure) {
        peer.completeError(failure);
      } else {
        peer.complete(
          P2pPeerPiece(
            bytes: Uint8List.fromList([1, 2]),
            source: const P2pPeerSource(peerId: 'peer', swarmId: 'swarm'),
          ),
        );
      }
    }
    if (pendingLength && !origin.isCompleted) {
      if (lateFailure) {
        origin.completeError(failure);
      } else {
        origin.complete(
          http.Response('', 200, headers: {'content-length': '2'}),
        );
      }
    }
  }

  try {
    await http.runWithClient(engine.initialize, () => client);
    final uri = await engine.localizeStatic(
      upstream: Uri.parse('https://example.com/media.mp4'),
      headers: const {},
      swarmId: 'swarm',
      logicalKey: 'root',
    );
    handler!.callAsFunction(
      null,
      {
        'url': uri.toString(),
        'method': pendingLength ? 'HEAD' : 'GET',
        'headers': [],
      }.jsify(),
      port,
    );
    await started.future.timeout(const Duration(seconds: 2));
    if (pendingLength) {
      await originStarted.future.timeout(const Duration(seconds: 2));
    }
    _check(engine.activeWorkerRequestCount == 1, 'Request was not retained');
    if (scenario.startsWith('Active')) {
      port
          .getProperty<JSFunction>('onmessage'.toJS)
          .callAsFunction(
            port,
            {
              'data': {'type': 'pull'},
            }.jsify(),
          );
      finishPending();
      await settle();
      final types = messages.whereType<Map>().map((m) => m['type']).join(',');
      _check(
        types ==
            (lateFailure
                ? 'error'
                : pendingLength
                ? 'meta,end'
                : 'meta,chunk,end'),
        'Active request response was lost: $types',
      );
      _check(
        engine.activeWorkerRequestCount == 0,
        'Completed request retained',
      );
      _check(closes == 1, 'Completed request did not close exactly once');
      if (!lateFailure && !pendingLength) {
        final chunk = messages.whereType<Map>().firstWhere(
          (m) => m['type'] == 'chunk',
        );
        _check(
          (chunk['bytes'] as List).join(',') == '1,2',
          'Incorrect payload',
        );
        _check(
          pendingCache
              ? engine.stats.value.cacheHits == 1
              : engine.stats.value.p2pBytes == 2,
          'Successful request was not counted',
        );
      }
      return;
    }
    final before = engine.stats.value;
    port
        .getProperty<JSFunction>('onmessage'.toJS)
        .callAsFunction(
          port,
          {
            'data': {'type': 'cancel'},
          }.jsify(),
        );
    await settle();
    _check(
      engine.activeWorkerRequestCount == 0,
      'Cancelled request still retained',
    );
    _check(
      closes == 1,
      'Cancelled request did not close its port exactly once',
    );
    _check(
      port.getProperty<JSAny?>('onmessage'.toJS) == null,
      'Callback retained',
    );
    if (!pendingCache) {
      _check(
        peerCancellation!.isCancelled,
        'Peer cancellation was not propagated',
      );
    }
    finishPending();
    await settle();
    _check(identical(engine.stats.value, before), 'Late result changed stats');
    _check(messages.isEmpty && cacheWrites == 0, 'Late result produced output');
    _check(peerCalls == (pendingCache ? 0 : 1), 'Unexpected peer request');
    _check(originCalls == (pendingLength ? 1 : 0), 'Unexpected origin request');
    _check(closes == 1, 'Late completion closed the port again');
  } finally {
    await engine.dispose();
    finishPending();
    await settle();
    client.close();
    globalContext.setProperty(bridgeName, original);
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
