import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test(
    'QNAP provider service maps binds, files, and thumbnail transport',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://synctv.example',
        session: SyncTvSession()
          ..updateAccountTokens(accessToken: 'access-token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path == '/api/providers/qnap/binds') {
            return http.Response(
              jsonEncode({
                'binds': [
                  {
                    'id': '1',
                    'serverId': 'qnap-home',
                    'endpoint': 'https://nas.example',
                    'username': 'alice',
                    'serverName': 'Home NAS',
                    'version': '5.2.4',
                    'supportRtt': true,
                    'createdAt': '100',
                    'providerInstanceName': 'remote',
                  },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/providers/qnap/list') {
            return http.Response(
              jsonEncode({
                'content': [
                  {
                    'name': 'Movie.mkv',
                    'path': '/Multimedia/Movie.mkv',
                    'isDir': false,
                    'size': '1073741824',
                    'modifiedAt': '1700000000',
                    'fileType': '1',
                    'preTranscodedHeights': [720, 1080],
                  },
                ],
                'total': '1',
                'page': '2',
                'hasMore': false,
                'realtimeTranscode': true,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('not found', 404);
        }),
      );
      final service = SyncTvProviderDomainService(api);

      final binds = await service.getQnapBindInfos(instanceName: 'remote');
      final page = await service.listQnapFiles(
        'qnap-home',
        '/Multimedia',
        page: 2,
        search: 'Movie',
        instanceName: 'remote',
      );

      expect(binds.single.serverName, 'Home NAS');
      expect(binds.single.supportRtt, isTrue);
      expect(page.realtimeTranscode, isTrue);
      expect(page.items.single.preTranscodedHeights, [720, 1080]);
      expect(
        Uri.parse(page.items.single.thumbnailUrl).queryParameters,
        containsPair('path', '/Multimedia/Movie.mkv'),
      );
      expect(api.authenticatedResourceHeaders, {
        'authorization': 'Bearer access-token',
      });

      final bindRequest = requests.first;
      expect(bindRequest.url.queryParameters['instanceName'], 'remote');
      final listRequest = requests.last;
      expect(listRequest.method, 'POST');
      expect(listRequest.headers['authorization'], 'Bearer access-token');
      final body = jsonDecode(listRequest.body) as Map<String, dynamic>;
      expect(body['serverId'], 'qnap-home');
      expect(body['path'], '/Multimedia');
      expect(body['page'], '2');
      expect(body['search'], 'Movie');
    },
  );
}
