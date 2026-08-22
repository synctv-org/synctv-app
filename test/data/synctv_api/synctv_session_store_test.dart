import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

SyncTvServerProfile _profile({
  required String id,
  required String endpoint,
  bool isBuiltIn = false,
}) {
  return SyncTvServerProfile(
    endpoint: endpoint,
    declaredServerId: id,
    name: id,
    isBuiltIn: isBuiltIn,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('account session requires a token', () {
    final session = SyncTvSession();

    expect(session.updateAccountTokens, throwsArgumentError);
    expect(session.identity, isA<AnonymousSessionIdentity>());
  });

  test('server profile preserves its built-in identity', () {
    final profile = _profile(
      id: 'built-in',
      endpoint: 'https://built-in.example.com',
      isBuiltIn: true,
    );

    final restored = SyncTvServerProfile.fromJson(profile.toJson());

    expect(restored, isNotNull);
    expect(restored!.isBuiltIn, isTrue);
  });

  test('server profile persists its TLS verification policy', () {
    final profile = SyncTvServerProfile(
      endpoint: 'https://self-signed.example.com',
      declaredServerId: 'self-signed',
      name: 'Self signed',
      allowInsecureTls: true,
    );

    final restored = SyncTvServerProfile.fromJson(profile.toJson());

    expect(restored, isNotNull);
    expect(restored!.allowInsecureTls, isTrue);
  });

  test('explicit server configuration has priority in every build mode', () {
    expect(
      SyncTvSessionStore.resolveBuiltInServerUrl(
        configuredUrl: ' https://release.example.com/ ',
        debugMode: true,
      ),
      'https://release.example.com',
    );
    expect(
      SyncTvSessionStore.resolveBuiltInServerUrl(
        configuredUrl: 'https://release.example.com/',
        debugMode: false,
      ),
      'https://release.example.com',
    );
  });

  test('development builds use the local server by default', () {
    expect(
      SyncTvSessionStore.resolveBuiltInServerUrl(
        configuredUrl: '',
        debugMode: true,
      ),
      SyncTvSessionStore.fallbackClientBaseUrl,
    );
  });

  test('release builds have no built-in server by default', () {
    expect(
      SyncTvSessionStore.resolveBuiltInServerUrl(
        configuredUrl: '',
        debugMode: false,
      ),
      isEmpty,
    );
  });

  test(
    'built-in server survives removal while regular servers can be removed',
    () async {
      final store = SyncTvSessionStore(SyncTvSession());
      final builtInServer = _profile(
        id: 'built-in',
        endpoint: 'https://built-in.example.com',
        isBuiltIn: true,
      );
      final regularServer = _profile(
        id: 'regular',
        endpoint: 'https://regular.example.com',
      );
      store.servers = [builtInServer, regularServer];
      store.activeServerEndpoint = builtInServer.endpoint;
      store.baseUrl = builtInServer.endpoint;

      await store.removeServer(builtInServer.endpoint);

      expect(store.servers, contains(builtInServer));
      expect(store.activeServerEndpoint, builtInServer.endpoint);
      await store.removeServer(regularServer.endpoint);
      expect(store.servers, hasLength(1));
      expect(
        store.servers.single.declaredServerId,
        builtInServer.declaredServerId,
      );
      expect(store.servers.single.isBuiltIn, isTrue);
    },
  );

  test('load restores a missing built-in server', () async {
    final regularServer = _profile(
      id: 'regular',
      endpoint: 'https://regular.example.com',
    );
    SharedPreferences.setMockInitialValues({
      SyncTvSessionStore.serversKey: jsonEncode([regularServer.toJson()]),
      SyncTvSessionStore.activeServerKey: regularServer.endpoint,
    });
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: 'https://built-in.example.com',
    );

    await store.load();

    expect(store.servers.where((server) => server.isBuiltIn), hasLength(1));
    expect(
      store.servers.singleWhere((server) => server.isBuiltIn).endpoint,
      'https://built-in.example.com',
    );
    expect(store.activeServerEndpoint, regularServer.endpoint);
  });

  test('setting another base URL preserves the built-in server', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: 'https://built-in.example.com',
    );
    await store.load();

    await store.setBaseUrl('');
    await store.setBaseUrl('https://other.example.com');

    expect(store.servers, hasLength(2));
    expect(store.servers.where((server) => server.isBuiltIn), hasLength(1));
    expect(
      store.servers.singleWhere((server) => server.isBuiltIn).endpoint,
      'https://built-in.example.com',
    );
    expect(store.activeServer?.endpoint, 'https://other.example.com');
  });

  test('same declared id keeps sessions isolated by endpoint', () async {
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session, builtInServerUrl: '');
    await store.load();

    await store.addOrUpdateServer(
      declaredServerId: 'srv_claimed',
      name: 'First',
      endpoint: 'https://first.example.com',
    );
    session
      ..updateAccountTokens(accessToken: 'first-access')
      ..updateAccountTokens(refreshToken: 'first-refresh');
    await store.persistSession();

    await store.addOrUpdateServer(
      declaredServerId: 'srv_claimed',
      name: 'Imitator',
      endpoint: 'https://imitator.example.com',
    );
    expect(session.accessToken, isNull);
    expect(session.refreshToken, isNull);
    session.updateAccountTokens(accessToken: 'imitator-access');
    await store.persistSession();

    await store.activateServer('https://first.example.com');
    expect(session.accessToken, 'first-access');
    expect(session.refreshToken, 'first-refresh');

    await store.activateServer('https://imitator.example.com');
    expect(session.accessToken, 'imitator-access');
    expect(session.refreshToken, isNull);
    expect(store.servers, hasLength(2));
  });

  test('persisted active server is restored by endpoint', () async {
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session, builtInServerUrl: '');
    await store.load();
    await store.addOrUpdateServer(
      declaredServerId: 'same',
      name: 'First',
      endpoint: 'https://first.example.com',
    );
    await store.addOrUpdateServer(
      declaredServerId: 'same',
      name: 'Second',
      endpoint: 'https://second.example.com',
    );
    session.updateAccountTokens(accessToken: 'second-token');
    await store.persistSession();

    final restoredSession = SyncTvSession();
    final restored = SyncTvSessionStore(restoredSession, builtInServerUrl: '');
    await restored.load();

    expect(restored.activeServerEndpoint, 'https://second.example.com');
    expect(restoredSession.accessToken, 'second-token');
  });

  test('active server TLS policy survives a runtime restart', () async {
    final store = SyncTvSessionStore(SyncTvSession(), builtInServerUrl: '');
    await store.load();
    await store.addOrUpdateServer(
      declaredServerId: 'self-signed',
      name: 'Self signed',
      endpoint: 'https://self-signed.example.com',
      allowInsecureTls: true,
    );

    final restartedRuntime = SyncTvRuntimeService();
    addTearDown(restartedRuntime.api.close);
    await restartedRuntime.init();

    expect(restartedRuntime.activeServer?.allowInsecureTls, isTrue);
    expect(restartedRuntime.allowInsecureTls, isTrue);
    expect(restartedRuntime.api.allowInsecureTls, isTrue);
  });

  test('runtime init does not wait for a pending server probe', () async {
    const endpoint = 'https://pending.example.com';
    final pendingServer = SyncTvServerProfile(
      endpoint: endpoint,
      declaredServerId: '',
      name: endpoint,
    );
    SharedPreferences.setMockInitialValues({
      SyncTvSessionStore.serversKey: jsonEncode([pendingServer.toJson()]),
      SyncTvSessionStore.activeServerKey: endpoint,
    });
    final probeStarted = Completer<void>();
    final probeResponse = Completer<client.GetServerInfoResponse>();
    final runtime = SyncTvRuntimeService(
      serverInfoProbe: (_) {
        probeStarted.complete();
        return probeResponse.future;
      },
    );
    addTearDown(runtime.api.close);

    await runtime.init().timeout(const Duration(seconds: 1));

    expect(runtime.activeServer?.endpoint, endpoint);
    expect(probeStarted.isCompleted, isTrue);
    expect(probeResponse.isCompleted, isFalse);
    probeResponse.complete(client.GetServerInfoResponse());
    await Future<void>.delayed(Duration.zero);
  });

  test('pending server probe cannot override a later selection', () async {
    const pendingEndpoint = 'https://pending.example.com';
    const selectedEndpoint = 'https://selected.example.com';
    final pendingServer = SyncTvServerProfile(
      endpoint: pendingEndpoint,
      declaredServerId: '',
      name: pendingEndpoint,
    );
    final selectedServer = _profile(id: 'selected', endpoint: selectedEndpoint);
    SharedPreferences.setMockInitialValues({
      SyncTvSessionStore.serversKey: jsonEncode([
        pendingServer.toJson(),
        selectedServer.toJson(),
      ]),
      SyncTvSessionStore.activeServerKey: pendingEndpoint,
    });
    final probeResponse = Completer<client.GetServerInfoResponse>();
    final runtime = SyncTvRuntimeService(
      serverInfoProbe: (_) => probeResponse.future,
    );
    addTearDown(runtime.api.close);

    await runtime.init();
    await runtime.activateServer(selectedEndpoint);
    probeResponse.complete(
      client.GetServerInfoResponse(
        serverId: 'pending-id',
        serverName: 'Pending server',
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(runtime.activeServer?.endpoint, selectedEndpoint);
    expect(
      runtime.servers
          .singleWhere((server) => server.endpoint == pendingEndpoint)
          .isPending,
      isTrue,
    );
  });
}
