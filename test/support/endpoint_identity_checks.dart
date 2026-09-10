import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_runtime_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

const _root = 'https://example.test';

void _equal(Object? actual, Object? expected) {
  if (actual != expected) throw StateError('Expected $expected, got $actual');
}

final endpointIdentityChecks = <String, Future<void> Function()>{
  'User API URL remains supported': () async {
    _equal(
      ServerEndpointIdentity.fromUserInput(' HTTPS://Example.Test:443/api/ '),
      _root,
    );
  },
  for (final path in [
    '/api',
    '/team/api',
    '/team/api/api',
    '/team%20one/api',
  ]) ...{
    'Stable identity $path': () async {
      final endpoint = '$_root$path';
      _equal(ServerEndpointIdentity.fromUserInput('$endpoint/api/'), endpoint);
      var normalized = endpoint;
      for (var i = 0; i < 4; i++) {
        normalized = ServerEndpointIdentity.normalize(normalized);
        _equal(normalized, endpoint);
      }
      final namespace = ServerEndpointIdentity.storageNamespace(endpoint);
      _equal(ServerEndpointIdentity.storageNamespace(normalized), namespace);
      if (namespace == ServerEndpointIdentity.storageNamespace(_root)) {
        throw StateError('Deployment namespaces collided');
      }
    },
    'Request and invite $path': () async {
      final endpoint = '$_root$path';
      Uri? requested;
      final api = SyncTvApiClient(
        baseUrl: endpoint,
        session: SyncTvSession(),
        httpClient: MockClient((request) async {
          requested = request.url;
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      try {
        api.configureServer(api.baseUrl, allowInsecureTls: false);
        _equal(api.baseUrl, endpoint);
        await api.publicService.getServerInfo(client.GetServerInfoRequest());
        _equal(requested.toString(), '$endpoint/api/public/server-info');
        _equal(api.resolveResourceUrl('/api/image'), '$endpoint/api/image');
        final link = RoomInviteService.createInviteLink(
          room: SyncTvRoom(roomId: 'room', roomName: 'Room', creatorId: 'user'),
          serverEndpoint: api.baseUrl,
        );
        final invite = RoomInviteService.parse(link);
        _equal(invite.serverEndpoint, endpoint);
        _equal(invite.roomId, 'room');
        _equal(
          RoomInviteService.matchesServerEndpoint(
            inviteEndpoint: invite.serverEndpoint!,
            serverEndpoint: endpoint,
          ),
          true,
        );
        _equal(
          RoomInviteService.matchesServerEndpoint(
            inviteEndpoint: invite.serverEndpoint!,
            serverEndpoint: _root,
          ),
          false,
        );
      } finally {
        api.close();
      }
    },
    'Stored sessions remain isolated $path': () async {
      SharedPreferences.setMockInitialValues({});
      final endpoint = '$_root$path';
      final session = SyncTvSession();
      final store = SyncTvSessionStore(session, builtInServerUrl: '');
      await store.load();
      await store.addOrUpdateServer(
        declaredServerId: 'same-id',
        name: 'Prefix',
        endpoint: endpoint,
      );
      session.updateAccountTokens(accessToken: 'prefix-token');
      await store.persistSession();
      await store.addOrUpdateServer(
        declaredServerId: 'same-id',
        name: 'Root',
        endpoint: _root,
      );
      _equal(session.accessToken, null);
      session.updateAccountTokens(accessToken: 'root-token');
      await store.persistSession();
      final restoredSession = SyncTvSession();
      final restored = SyncTvSessionStore(
        restoredSession,
        builtInServerUrl: '',
      );
      await restored.load();
      _equal(restored.servers.length, 2);
      _equal(restored.baseUrl, _root);
      _equal(restoredSession.accessToken, 'root-token');
      await restored.activateServer(endpoint);
      _equal(restored.baseUrl, endpoint);
      _equal(restoredSession.accessToken, 'prefix-token');
    },
    'Runtime accepts API input once $path': () async {
      SharedPreferences.setMockInitialValues({});
      final endpoint = '$_root$path';
      final runtime = SyncTvRuntimeService(
        singleServerEndpoint: endpoint,
        sessionStoreFactory: (session) =>
            SyncTvSessionStore(session, builtInServerUrl: ''),
        serverInfoProbe: (_) async =>
            client.GetServerInfoResponse(serverId: 'test', serverName: 'Test'),
      );
      try {
        await runtime.init();
        await runtime.setBaseUrl('$endpoint/api');
        _equal(runtime.api.baseUrl, endpoint);
        _equal(runtime.baseUrl, endpoint);
        await runtime.activateServer(endpoint);
        _equal(runtime.api.baseUrl, endpoint);
      } finally {
        runtime.api.close();
      }
    },
  },
};
