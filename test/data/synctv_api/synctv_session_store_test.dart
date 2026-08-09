import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

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
      ..accessToken = 'first-access'
      ..refreshToken = 'first-refresh';
    await store.persistTokens();

    await store.addOrUpdateServer(
      declaredServerId: 'srv_claimed',
      name: 'Imitator',
      endpoint: 'https://imitator.example.com',
    );
    expect(session.accessToken, isNull);
    expect(session.refreshToken, isNull);
    session.accessToken = 'imitator-access';
    await store.persistTokens();

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
    session.accessToken = 'second-token';
    await store.persistTokens();

    final restoredSession = SyncTvSession();
    final restored = SyncTvSessionStore(restoredSession, builtInServerUrl: '');
    await restored.load();

    expect(restored.activeServerEndpoint, 'https://second.example.com');
    expect(restoredSession.accessToken, 'second-token');
  });
}
