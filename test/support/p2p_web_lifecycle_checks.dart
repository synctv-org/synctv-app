import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine_web.dart';

const p2pWebLifecycleChecks = [
  'Concurrent initialization shares one request',
  'Pending initialization cannot localize media',
  'Disposal prevents late initialization',
  'Old disposal preserves the new handler',
  'Failed replacement preserves the active handler',
  'Rejected readiness leaves no handler',
  'Missing bridge fails without registration',
];

Future<void> runP2pWebLifecycleCheck(String scenario) async {
  final name = 'SyncTvP2pBridge'.toJS;
  final original = globalContext.getProperty<JSAny?>(name);
  final bridge = JSObject();
  final firstReady = Completer<JSAny?>();
  final secondReady = Completer<JSAny?>();
  final readiness = [firstReady, secondReady];
  var readyCalls = 0;
  var registrations = 0;
  JSAny? handler;
  final engines = <P2pMediaEngine>[];
  bridge.setProperty(
    'ready'.toJS,
    (() => readiness[readyCalls++].future.toJS).toJS,
  );
  bridge.setProperty(
    'setRequestHandler'.toJS,
    ((JSAny? value) {
      registrations++;
      handler = value;
    }).toJS,
  );
  bridge.setProperty(
    'clearRequestHandler'.toJS,
    ((JSAny? value) {
      if (identical(handler, value)) handler = null;
    }).toJS,
  );
  globalContext.setProperty(name, bridge);
  P2pMediaEngine create() {
    final engine = P2pMediaEngine(
      requestPeerPiece: (_, _, _) async => null,
      maxCacheBytes: 1024,
      securityMode: P2pMediaSecurityMode.values.first,
      serverBaseUrl: 'https://example.com',
    );
    engines.add(engine);
    return engine;
  }

  Future<void> initialize(P2pMediaEngine engine, Completer<JSAny?> ready) {
    final pending = engine.initialize();
    ready.complete(true.toJS);
    return pending;
  }

  try {
    final first = create();
    switch (scenario) {
      case 'Concurrent initialization shares one request':
        final one = first.initialize();
        final two = first.initialize();
        _check(identical(one, two), 'Initialization futures differ');
        _check(readyCalls == 1, 'Duplicate readiness requests');
        _check(handler == null, 'Handler registered before readiness');
        firstReady.complete(true.toJS);
        await Future.wait([one, two]);
        await first.initialize();
        _check(registrations == 1, 'Duplicate handler registration');
      case 'Pending initialization cannot localize media':
        final pending = first.initialize();
        final failure = await _failure(
          first.localizeStatic(
            upstream: Uri.parse('https://example.com/media'),
            headers: const {},
            swarmId: 'swarm',
            logicalKey: 'root',
          ),
        );
        _check(failure is StateError, 'Unready media localization succeeded');
        firstReady.complete(true.toJS);
        await pending;
      case 'Disposal prevents late initialization':
        final failure = _failure(first.initialize());
        await first.dispose();
        firstReady.complete(true.toJS);
        _check(
          await failure is StateError,
          'Disposed initialization succeeded',
        );
        _check(handler == null, 'Disposed engine retained a handler');
        _check(registrations == 0, 'Disposed engine registered a handler');
        _check(
          await _failure(first.initialize()) is StateError,
          'Disposed engine initialized again',
        );
      case 'Old disposal preserves the new handler':
        await initialize(first, firstReady);
        final second = create();
        await initialize(second, secondReady);
        final current = handler;
        await first.dispose();
        _check(
          current != null && identical(handler, current),
          'Old disposal removed the new handler',
        );
        await second.dispose();
        _check(handler == null, 'Owner disposal retained its handler');
      case 'Failed replacement preserves the active handler':
        await initialize(first, firstReady);
        final current = handler;
        final second = create();
        final failure = _failure(second.initialize());
        secondReady.complete(false.toJS);
        _check(await failure is StateError, 'Unavailable worker accepted');
        await second.dispose();
        _check(
          current != null && identical(handler, current),
          'Failed replacement removed active handler',
        );
      case 'Rejected readiness leaves no handler':
        final failure = _failure(first.initialize());
        final error = StateError('Readiness failed');
        firstReady.completeError(error);
        _check(await failure != null, 'Readiness rejection was ignored');
        _check(
          handler == null && registrations == 0,
          'Rejected initialization registered a handler',
        );
      case 'Missing bridge fails without registration':
        globalContext.setProperty(name, null);
        _check(
          await _failure(first.initialize()) is StateError,
          'Missing bridge accepted',
        );
        _check(readyCalls == 0 && registrations == 0, 'Missing bridge used');
      default:
        throw ArgumentError.value(scenario);
    }
  } finally {
    for (final engine in engines) {
      await engine.dispose();
    }
    globalContext.setProperty(name, original);
  }
}

Future<Object?> _failure(Future<Object?> operation) async {
  try {
    await operation;
    return null;
  } catch (error) {
    return error;
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
