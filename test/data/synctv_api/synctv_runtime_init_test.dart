import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

class _ControlledStore extends SyncTvSessionStore {
  _ControlledStore(super.session) : super(builtInServerUrl: '');

  int loads = 0;
  int forces = 0;
  Future<void> Function() onLoad = () async {};
  Future<void> Function() onForce = () async {};

  @override
  Future<void> load() {
    loads++;
    return onLoad();
  }

  @override
  Future<SyncTvServerProfile> forceSingleServer(String endpoint) async {
    forces++;
    await onForce();
    baseUrl = endpoint;
    return SyncTvServerProfile(
      endpoint: endpoint,
      declaredServerId: 'test',
      name: 'Test',
    );
  }
}

void main() {
  late _ControlledStore store;
  late SyncTvRuntimeService runtime;

  setUp(() {
    runtime = SyncTvRuntimeService(
      singleServerEndpoint: 'https://example.test',
      sessionStoreFactory: (session) => store = _ControlledStore(session),
    );
  });
  tearDown(() => runtime.api.close());

  test('concurrent initialization shares one pending load', () async {
    final gate = Completer<void>();
    store.onLoad = () => gate.future;
    final first = runtime.init();
    final second = runtime.init();
    expect(store.loads, 1);
    gate.complete();
    await Future.wait([first, second]);
    expect(store.forces, 1);
  });

  test('successful initialization preserves client on startup retry', () async {
    await runtime.init();
    final api = runtime.api;
    await runtime.init();
    expect(runtime.api, same(api));
    expect(store.loads, 1);
    expect(store.forces, 1);
  });

  for (final synchronous in [false, true]) {
    test('load failure is retryable (synchronous: $synchronous)', () async {
      final failure = StateError('load failed');
      store.onLoad = () {
        if (synchronous) throw failure;
        return Future.error(failure);
      };
      final bootstrap = runtime.api;
      await expectLater(runtime.init(), throwsA(same(failure)));
      expect(runtime.api, same(bootstrap));
      store.onLoad = () async {};
      await runtime.init();
      expect(store.loads, 2);
      expect(runtime.api, isNot(same(bootstrap)));
    });
  }

  test('concurrent failure reaches all callers and allows one retry', () async {
    final gate = Completer<void>();
    store.onLoad = () => gate.future;
    final failure = StateError('load failed');
    final first = expectLater(runtime.init(), throwsA(same(failure)));
    final second = expectLater(runtime.init(), throwsA(same(failure)));
    gate.completeError(failure);
    await Future.wait([first, second]);
    store.onLoad = () async {};
    await Future.wait([runtime.init(), runtime.init()]);
    expect(store.loads, 2);
    expect(store.forces, 1);
  });

  test('single-server persistence failure can retry initialization', () async {
    final failure = StateError('persistence failed');
    store.onForce = () => Future.error(failure);
    final SyncTvApiClient bootstrap = runtime.api;
    await expectLater(runtime.init(), throwsA(same(failure)));
    expect(runtime.api, same(bootstrap));
    store.onForce = () async {};
    await runtime.init();
    await runtime.init();
    expect(store.loads, 2);
    expect(store.forces, 2);
    expect(runtime.api.baseUrl, 'https://example.test');
  });
}
