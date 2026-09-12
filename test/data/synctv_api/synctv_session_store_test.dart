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

  for (final mutation in [
    'logout',
    'switch',
    'inactive server',
    'refresh',
    'clear anonymous',
  ]) {
    test('delayed restore cannot overwrite newer $mutation', () async {
      final delayed = Completer<SharedPreferences>();
      final stale = _ControlledPreferences();
      final saved = _profile(id: 'old', endpoint: 'https://old.example.test')
          .copyWith(
            sessionData: SyncTvServerSessionData.account(
              accessToken: 'old-access',
              refreshToken: 'old-refresh',
            ),
          );
      stale.values[SyncTvSessionStore.serversKey] = jsonEncode([
        saved.toJson(),
      ]);
      stale.values[SyncTvSessionStore.activeServerKey] = saved.endpoint;
      final currentPreferences = _ControlledPreferences();
      var loads = 0;
      final session = SyncTvSession();
      if (mutation != 'clear anonymous') {
        session.updateAccountTokens(accessToken: 'live-access');
      }
      final store =
          SyncTvSessionStore(
              session,
              builtInServerUrl: '',
              preferencesLoader: () => loads++ == 0
                  ? delayed.future
                  : Future.value(currentPreferences),
            )
            ..servers = [saved]
            ..activeServerEndpoint = saved.endpoint
            ..baseUrl = saved.endpoint;
      final restore = store.load();
      switch (mutation) {
        case 'clear anonymous':
          session.clear();
        case 'logout':
          await store.clearSessionAndPersist();
        case 'switch':
          await store.setBaseUrl('https://new.example.test');
        case 'inactive server':
          await store.addOrUpdateServer(
            declaredServerId: 'new',
            name: 'New',
            endpoint: 'https://new.example.test',
            activate: false,
          );
        case 'refresh':
          session.updateAccountTokens(
            accessToken: 'refreshed-access',
            isRefresh: true,
          );
      }
      final expectedIdentity = session.identity;
      final expectedServers = store.servers.map((s) => s.toJson()).toList();
      final expectedEndpoint = store.baseUrl;
      delayed.complete(stale);
      await restore;
      expect(session.identity, same(expectedIdentity));
      expect(store.servers.map((s) => s.toJson()).toList(), expectedServers);
      expect(store.baseUrl, expectedEndpoint);
      expect(stale.writtenKeys, isEmpty);
    });
  }

  test(
    'latest restore wins when preference loaders finish out of order',
    () async {
      final responses = [
        Completer<SharedPreferences>(),
        Completer<SharedPreferences>(),
      ];
      var calls = 0;
      final store = SyncTvSessionStore(
        SyncTvSession(),
        builtInServerUrl: '',
        preferencesLoader: () => responses[calls++].future,
      );
      final first = store.load();
      final second = store.load();
      _ControlledPreferences preferences(String name) {
        final profile = _profile(
          id: name,
          endpoint: 'https://$name.example.test',
        );
        return _ControlledPreferences()
          ..values[SyncTvSessionStore.serversKey] = jsonEncode([
            profile.toJson(),
          ])
          ..values[SyncTvSessionStore.activeServerKey] = profile.endpoint;
      }

      responses[1].complete(preferences('new'));
      await second;
      final identity = store.session.identity;
      responses[0].complete(preferences('old'));
      await first;
      expect(store.activeServer?.name, 'new');
      expect(store.session.identity, same(identity));
    },
  );

  test('restore cannot read a server switch awaiting persistence', () async {
    final started = Completer<void>();
    final release = Completer<void>();
    final preferences = _ControlledPreferences()
      ..beforeWrite = ((_) async {
        if (!started.isCompleted) {
          started.complete();
          await release.future;
        }
      });
    var loads = 0;
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: '',
      preferencesLoader: () async {
        loads++;
        return preferences;
      },
    );
    final save = store.setBaseUrl('https://new.example.test');
    await started.future;
    await store.load();
    expect(loads, 1);
    expect(store.baseUrl, 'https://new.example.test');
    release.complete();
    await save;
    await store.load();
    expect(loads, 2);
    expect(store.baseUrl, 'https://new.example.test');
  });

  test('restore can retry after preference loader failure', () async {
    final preferences = _ControlledPreferences();
    var attempts = 0;
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: '',
      preferencesLoader: () async {
        if (attempts++ == 0) throw StateError('storage unavailable');
        return preferences;
      },
    );
    await expectLater(store.load(), throwsStateError);
    await store.load();
    expect(attempts, 2);
    expect(store.servers, isEmpty);
  });

  test('restore skips partial startup repair', () async {
    final started = Completer<void>();
    final release = Completer<void>();
    var loads = 0;
    final preferences = _ControlledPreferences()
      ..beforeWrite = ((_) async {
        if (!started.isCompleted) {
          started.complete();
          await release.future;
        }
      });
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: 'https://built-in.example.test',
      preferencesLoader: () async {
        loads++;
        return preferences;
      },
    );
    final initial = store.load();
    await started.future;
    await store.load();
    expect(loads, 1);
    expect(store.baseUrl, 'https://built-in.example.test');
    release.complete();
    await initial;
  });

  for (final malformed in [
    42,
    true,
    'invalid',
    <Object>[],
    {'kind': 'account', 'access_token': 123},
  ]) {
    test(
      'malformed session $malformed preserves servers and valid neighboring sessions',
      () async {
        final bad = _profile(
          id: 'bad',
          endpoint: 'https://bad.example.test',
        ).toJson()..['session'] = malformed;
        final good = _profile(id: 'good', endpoint: 'https://good.example.test')
            .copyWith(
              sessionData: SyncTvServerSessionData.account(
                accessToken: 'valid-access',
                refreshToken: 'valid-refresh',
              ),
            );
        SharedPreferences.setMockInitialValues({
          SyncTvSessionStore.serversKey: jsonEncode([bad, good.toJson()]),
          SyncTvSessionStore.activeServerKey: 'https://bad.example.test',
        });
        final session = SyncTvSession();
        final store = SyncTvSessionStore(session, builtInServerUrl: '');
        await store.load();
        expect(store.servers, hasLength(2));
        expect(store.activeServer?.name, 'bad');
        expect(session.identity, isA<AnonymousSessionIdentity>());
        await store.activateServer(good.endpoint);
        expect(session.accessToken, 'valid-access');
        expect(session.refreshToken, 'valid-refresh');
      },
    );
  }

  for (final key in [
    SyncTvSessionStore.serversKey,
    SyncTvSessionStore.activeServerKey,
  ]) {
    test('non-string preference $key cannot prevent startup', () async {
      SharedPreferences.setMockInitialValues({
        SyncTvSessionStore.serversKey: jsonEncode([
          _profile(
            id: 'saved',
            endpoint: 'https://saved.example.test',
          ).toJson(),
        ]),
        key: 42,
      });
      final store = SyncTvSessionStore(SyncTvSession(), builtInServerUrl: '');
      await store.load();
      expect(
        store.servers.length,
        key == SyncTvSessionStore.serversKey ? 0 : 1,
      );
    });
  }

  test(
    'malformed guest fields cannot become credentials through string coercion',
    () {
      for (final field in ['access_token', 'room_id', 'display_name']) {
        expect(
          SyncTvServerSessionData.fromJson({
            'kind': 'guest',
            'access_token': 'guest-access',
            'room_id': 'room',
            'display_name': 'Guest',
            field: 123,
          }),
          isA<AnonymousServerSessionData>(),
        );
      }
      final recoverable = SyncTvServerSessionData.fromJson({
        'kind': 'account',
        'access_token': ['bad'],
        'refresh_token': 'valid-refresh',
      }) as AccountServerSessionData;
      expect(recoverable.accessToken, isNull);
      expect(recoverable.refreshToken, 'valid-refresh');
    },
  );

  test('failed startup repair retains readable server configuration', () async {
    final preferences = _ControlledPreferences()..failure = 'sessions';
    preferences.values[SyncTvSessionStore.serversKey] = jsonEncode([
      _profile(id: 'saved', endpoint: 'https://saved.example.test').toJson(),
    ]);
    preferences.values[SyncTvSessionStore.activeServerKey] =
        'https://missing.example.test';
    final store = SyncTvSessionStore(
      SyncTvSession(),
      builtInServerUrl: '',
      preferencesLoader: () async => preferences,
    );
    await store.load();
    expect(store.activeServerEndpoint, 'https://saved.example.test');
    expect(store.baseUrl, 'https://saved.example.test');
    expect(store.servers, hasLength(1));
  });

  test(
    'overlapping saves keep each server list and active endpoint together',
    () async {
      final release = Completer<void>();
      final started = Completer<void>();
      final preferences = _ControlledPreferences()
        ..beforeWrite = ((key) async {
          if (!started.isCompleted) {
            started.complete();
            await release.future;
          }
        });
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'old-access');
      final store =
          SyncTvSessionStore(
              session,
              builtInServerUrl: '',
              preferencesLoader: () async => preferences,
            )
            ..servers = [
              _profile(id: 'old', endpoint: 'https://old.example.test'),
            ]
            ..activeServerEndpoint = 'https://old.example.test';
      final first = store.persistSession();
      await started.future;
      store.servers.add(
        _profile(id: 'new', endpoint: 'https://new.example.test'),
      );
      store.activeServerEndpoint = 'https://new.example.test';
      session.updateAccountTokens(accessToken: 'new-access');
      final second = store.persistSession();
      await Future<void>.delayed(Duration.zero);
      expect(preferences.writtenKeys, isEmpty);
      release.complete();
      await Future.wait([first, second]);
      expect(preferences.writtenKeys, [
        SyncTvSessionStore.serversKey,
        SyncTvSessionStore.activeServerKey,
        SyncTvSessionStore.serversKey,
        SyncTvSessionStore.activeServerKey,
      ]);
      final restoredSession = SyncTvSession();
      final restored = SyncTvSessionStore(
        restoredSession,
        builtInServerUrl: '',
        preferencesLoader: () async => preferences,
      );
      await restored.load();
      expect(restored.servers, hasLength(2));
      expect(restored.activeServerEndpoint, 'https://new.example.test');
      expect(restoredSession.accessToken, 'new-access');
    },
  );

  for (final failure in ['sessions', 'active', 'remove']) {
    test(
      'session storage detects false $failure writes and permits retry',
      () async {
        final preferences = _ControlledPreferences()..failure = failure;
        final session = SyncTvSession()
          ..updateAccountTokens(accessToken: 'access');
        final store = SyncTvSessionStore(
          session,
          builtInServerUrl: '',
          preferencesLoader: () async => preferences,
        );
        if (failure != 'remove') {
          store.servers = [
            _profile(id: 'server', endpoint: 'https://example.test'),
          ];
          store.activeServerEndpoint = 'https://example.test';
        }
        await expectLater(store.clearSessionAndPersist(), throwsStateError);
        expect(session.identity, isA<AnonymousSessionIdentity>());
        preferences.failure = null;
        await store.persistSession();
        final restoredSession = SyncTvSession();
        final restored = SyncTvSessionStore(
          restoredSession,
          builtInServerUrl: '',
          preferencesLoader: () async => preferences,
        );
        await restored.load();
        expect(restoredSession.identity, isA<AnonymousSessionIdentity>());
        expect(restored.activeServerEndpoint, store.activeServerEndpoint);
      },
    );
  }

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

  test(
    'forceSingleServer keeps its session and removes other servers',
    () async {
      const deploymentEndpoint = 'https://app.example.com';
      final session = SyncTvSession();
      final store = SyncTvSessionStore(session, builtInServerUrl: '');
      await store.load();
      await store.addOrUpdateServer(
        endpoint: deploymentEndpoint,
        declaredServerId: 'deployment',
        name: 'Deployment',
        allowInsecureTls: true,
      );
      session
        ..updateAccountTokens(accessToken: 'deployment-access')
        ..updateAccountTokens(refreshToken: 'deployment-refresh');
      await store.persistSession();
      await store.addOrUpdateServer(
        endpoint: 'https://other.example.com',
        declaredServerId: 'other',
        name: 'Other',
      );

      final profile = await store.forceSingleServer('$deploymentEndpoint/');

      expect(store.servers, hasLength(1));
      expect(store.activeServerEndpoint, deploymentEndpoint);
      expect(store.baseUrl, deploymentEndpoint);
      expect(profile.endpoint, deploymentEndpoint);
      expect(profile.isBuiltIn, isTrue);
      expect(profile.allowInsecureTls, isFalse);
      expect(session.accessToken, 'deployment-access');
      expect(session.refreshToken, 'deployment-refresh');

      final restored = SyncTvRuntimeService(
        singleServerEndpoint: deploymentEndpoint,
      );
      addTearDown(restored.api.close);
      await restored.init();
      expect(restored.servers, hasLength(1));
      expect(restored.activeServer?.isBuiltIn, isTrue);
      expect(restored.activeServer?.allowInsecureTls, isFalse);
      expect(restored.session.accessToken, 'deployment-access');
      expect(restored.session.refreshToken, 'deployment-refresh');
    },
  );

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

  test(
    'single server mode initializes before its probe and enforces the origin',
    () async {
      const endpoint = 'https://app.example.com';
      final otherServer = _profile(
        id: 'other',
        endpoint: 'https://other.example.com',
      );
      SharedPreferences.setMockInitialValues({
        SyncTvSessionStore.serversKey: jsonEncode([otherServer.toJson()]),
        SyncTvSessionStore.activeServerKey: otherServer.endpoint,
      });
      final probeStarted = Completer<void>();
      final probeResponse = Completer<client.GetServerInfoResponse>();
      final runtime = SyncTvRuntimeService(
        singleServerEndpoint: endpoint,
        serverInfoProbe: (_) {
          probeStarted.complete();
          return probeResponse.future;
        },
      );
      addTearDown(runtime.api.close);

      await runtime.init().timeout(const Duration(seconds: 1));

      expect(runtime.singleServerMode, isTrue);
      expect(runtime.servers, hasLength(1));
      expect(runtime.activeServer?.endpoint, endpoint);
      expect(runtime.activeServer?.isBuiltIn, isTrue);
      expect(runtime.allowInsecureTls, isFalse);
      expect(probeStarted.isCompleted, isTrue);
      expect(probeResponse.isCompleted, isFalse);
      await expectLater(
        runtime.setBaseUrl('https://other.example.com'),
        throwsUnsupportedError,
      );
      await expectLater(
        runtime.addServer(endpoint, allowInsecureTls: true),
        throwsUnsupportedError,
      );
      await expectLater(
        runtime.addServer('https://other.example.com'),
        throwsUnsupportedError,
      );
      await expectLater(
        runtime.activateServer('https://other.example.com'),
        throwsUnsupportedError,
      );
      await expectLater(runtime.removeServer(endpoint), throwsUnsupportedError);

      probeResponse.complete(client.GetServerInfoResponse());
      await Future<void>.delayed(Duration.zero);
    },
  );

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

class _ControlledPreferences implements SharedPreferences {
  String? failure;
  Future<void> Function(String key)? beforeWrite;
  final writtenKeys = <String>[];
  final Map<String, String> values = {};

  @override
  Object? get(String key) => values[key];

  @override
  String? getString(String key) => values[key];

  @override
  Future<bool> setString(String key, String value) async {
    await beforeWrite?.call(key);
    if (failure == 'sessions' && key == SyncTvSessionStore.serversKey ||
        failure == 'active' && key == SyncTvSessionStore.activeServerKey) {
      return false;
    }
    writtenKeys.add(key);
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    if (failure == 'remove') return false;
    values.remove(key);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
