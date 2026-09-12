import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

import '../../support/endpoint_identity_checks.dart';

void main() {
  for (final check in endpointIdentityChecks.entries) {
    test(check.key, check.value);
  }
  for (final path in [
    '/api',
    '/team/api',
    '/team/api/api',
    '/team%20one/api',
  ]) {
    test('adding and restoring canonical server $path', () async {
      SharedPreferences.setMockInitialValues({});
      final endpoint = 'https://example.test$path';
      final probes = <String>[];
      SyncTvRuntimeService createRuntime() => SyncTvRuntimeService(
        sessionStoreFactory: (session) =>
            SyncTvSessionStore(session, builtInServerUrl: ''),
        serverInfoProbe: (api) async {
          probes.add(api.baseUrl);
          return client.GetServerInfoResponse(
            serverId: 'server',
            serverName: 'Server',
          );
        },
      );
      final runtime = createRuntime();
      addTearDown(() => runtime.api.close());
      await runtime.init();
      final profile = await runtime.addServer('$endpoint/api');
      expect(probes, [endpoint]);
      expect(profile.endpoint, endpoint);
      expect(runtime.api.baseUrl, endpoint);
      expect(runtime.activeServer?.endpoint, endpoint);
      final restored = createRuntime();
      addTearDown(() => restored.api.close());
      await restored.init();
      expect(restored.api.baseUrl, endpoint);
      expect(restored.activeServer?.endpoint, endpoint);
      await restored.activateServer(endpoint);
      expect(restored.api.baseUrl, endpoint);
    });
  }
}
