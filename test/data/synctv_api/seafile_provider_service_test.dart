import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test('Seafile service maps encrypted libraries and thumbnails', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://synctv.example',
      session: SyncTvSession()
        ..updateAccountTokens(accessToken: 'access-token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = switch (request.url.path) {
          '/api/providers/seafile/binds' => {
            'binds': [
              {
                'id': '1',
                'serverId': 'seafile-home',
                'endpoint': 'https://seafile.example',
                'username': 'alice@example.com',
                'version': '11.0.12',
                'features': ['seafile-basic'],
                'createdAt': '100',
                'providerInstanceName': 'remote',
              },
            ],
          },
          '/api/providers/seafile/repositories' => {
            'content': [
              {
                'repositoryId': 'repo-1',
                'repositoryName': 'Movies',
                'path': '/',
                'name': 'Movies',
                'isDir': true,
                'size': '1073741824',
                'repositoryEncrypted': true,
                'passwordRequired': true,
              },
            ],
            'total': '1',
            'page': '1',
            'hasMore': false,
          },
          '/api/providers/seafile/list' => {
            'content': [
              {
                'repositoryId': 'repo-1',
                'path': '/Movie.mkv',
                'name': 'Movie.mkv',
                'objectId': 'object-id',
                'isDir': false,
                'size': '1024',
                'hasThumbnail': true,
              },
            ],
            'total': '1',
            'page': '1',
            'hasMore': false,
          },
          _ => null,
        };
        return response == null
            ? http.Response('not found', 404)
            : http.Response(
                jsonEncode(response),
                200,
                headers: {'content-type': 'application/json'},
              );
      }),
    );
    final service = SyncTvProviderDomainService(api);

    final binds = await service.getSeafileBindInfos(instanceName: 'remote');
    final libraries = await service.listSeafileRepositories(
      'seafile-home',
      instanceName: 'remote',
    );
    final files = await service.listSeafileFiles(
      'seafile-home',
      'repo-1',
      '',
      instanceName: 'remote',
    );

    expect(binds.single.features, ['seafile-basic']);
    expect(libraries.items.single.repositoryEncrypted, isTrue);
    expect(libraries.items.single.passwordRequired, isTrue);
    expect(files.items.single.objectId, 'object-id');
    expect(
      Uri.parse(files.items.single.thumbnailUrl).queryParameters,
      containsPair('repositoryId', 'repo-1'),
    );
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer access-token',
      ),
      isTrue,
    );
  });
}
