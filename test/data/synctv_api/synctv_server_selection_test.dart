@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

const _old = 'https://old.example.test';
const _selected = 'https://selected.example.test';
const _slow = 'https://slow.example.test';
const _new = 'https://new.example.test';

Future<SyncTvRuntimeService> _runtime({
  SyncTvServerInfoProbe? probe,
  bool builtIn = false,
}) async {
  SharedPreferences.setMockInitialValues({
    SyncTvSessionStore.serversKey: jsonEncode([
      for (final endpoint in [_old, _selected])
        SyncTvServerProfile(
          endpoint: endpoint,
          declaredServerId: endpoint,
          name: endpoint,
        ).toJson(),
    ]),
    SyncTvSessionStore.activeServerKey: _old,
  });
  final runtime = SyncTvRuntimeService(
    serverInfoProbe: probe,
    sessionStoreFactory: (session) =>
        SyncTvSessionStore(session, builtInServerUrl: builtIn ? _old : ''),
  );
  await runtime.init();
  addTearDown(runtime.api.close);
  return runtime;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final action in ['activate', 'set endpoint', 'add newer', 'remove']) {
    test('slow add cannot overwrite later $action', () async {
      final response = Completer<client.GetServerInfoResponse>();
      final runtime = await _runtime(
        probe: (api) => api.baseUrl == _slow
            ? response.future
            : Future.value(
                client.GetServerInfoResponse(
                  serverId: 'new',
                  serverName: 'New',
                ),
              ),
      );
      final oldRequest = runtime.addServer(_slow);
      final rejected = expectLater(
        oldRequest,
        throwsA(isA<SyncTvStaleEndpointException>()),
      );
      switch (action) {
        case 'activate':
          await runtime.activateServer(_selected);
        case 'set endpoint':
          await runtime.setBaseUrl(_selected);
        case 'add newer':
          await runtime.addServer(_new);
        case 'remove':
          await runtime.removeServer(_old);
      }
      final selected = runtime.baseUrl;
      response.complete(
        client.GetServerInfoResponse(serverId: 'slow', serverName: 'Slow'),
      );
      await rejected;
      expect(runtime.baseUrl, selected);
      expect(runtime.api.baseUrl, selected);
      expect(runtime.servers.any((s) => s.endpoint == _slow), isFalse);
      final restored = SyncTvSessionStore(
        SyncTvSession(),
        builtInServerUrl: '',
      );
      await restored.load();
      expect(restored.baseUrl, selected);
    });
  }

  test(
    'failed newer addition still supersedes an older pending selection',
    () async {
      final response = Completer<client.GetServerInfoResponse>();
      final runtime = await _runtime(
        probe: (api) => api.baseUrl == _slow
            ? response.future
            : Future.error(StateError('probe failed')),
      );
      final pending = runtime.addServer(_slow);
      final rejected = expectLater(
        pending,
        throwsA(isA<SyncTvStaleEndpointException>()),
      );
      await expectLater(runtime.addServer(_new), throwsStateError);
      response.complete(client.GetServerInfoResponse(serverId: 'slow'));
      await rejected;
      expect(runtime.api.baseUrl, _old);
      expect(runtime.baseUrl, _old);
    },
  );

  test(
    'removing the built-in server cannot change API or credentials',
    () async {
      final runtime = await _runtime(builtIn: true);
      runtime.session.updateAccountTokens(accessToken: 'current-access');
      final generation = runtime.api.endpointGeneration;
      final identity = runtime.session.identity;
      await runtime.removeServer(_old);
      expect(runtime.api.baseUrl, _old);
      expect(runtime.baseUrl, _old);
      expect(runtime.api.endpointGeneration, generation);
      expect(runtime.session.identity, same(identity));
      expect(runtime.servers.length, 2);
    },
  );

  test(
    'removing an inactive server preserves the active API and credentials',
    () async {
      final runtime = await _runtime();
      runtime.session.updateAccountTokens(accessToken: 'current-access');
      final generation = runtime.api.endpointGeneration;
      final identity = runtime.session.identity;
      await runtime.removeServer(_selected);
      expect(runtime.api.baseUrl, _old);
      expect(runtime.baseUrl, _old);
      expect(runtime.api.endpointGeneration, generation);
      expect(runtime.session.identity, same(identity));
      expect(runtime.servers.single.endpoint, _old);
    },
  );
}
