import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';

SyncTvServerProfile _profile({
  required String id,
  required String endpoint,
  bool isBuiltIn = false,
}) {
  return SyncTvServerProfile(
    serverId: id,
    name: id,
    endpoints: [endpoint],
    activeEndpoint: endpoint,
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
      store.activeServerId = builtInServer.serverId;
      store.baseUrl = builtInServer.activeEndpoint;

      await store.removeServer(builtInServer.serverId);

      expect(store.servers, contains(builtInServer));
      expect(store.activeServerId, builtInServer.serverId);
      await store.removeServer(regularServer.serverId);
      expect(store.servers, hasLength(1));
      expect(store.servers.single.serverId, builtInServer.serverId);
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
      SyncTvSessionStore.activeServerKey: regularServer.serverId,
    });
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: 'https://built-in.example.com',
    );

    await store.load();

    expect(store.servers.where((server) => server.isBuiltIn), hasLength(1));
    expect(
      store.servers.singleWhere((server) => server.isBuiltIn).activeEndpoint,
      'https://built-in.example.com',
    );
    expect(store.activeServerId, regularServer.serverId);
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
      store.servers.singleWhere((server) => server.isBuiltIn).activeEndpoint,
      'https://built-in.example.com',
    );
    expect(store.activeServer?.activeEndpoint, 'https://other.example.com');
  });
}
