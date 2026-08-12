import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test('Nextcloud service maps binds, metadata, and signed previews', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://synctv.example',
      session: SyncTvSession()
        ..updateAccountTokens(accessToken: 'access-token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = switch (request.url.path) {
          '/api/providers/nextcloud/binds' => {
            'binds': [
              {
                'id': '1',
                'serverId': 'nextcloud-home',
                'endpoint': 'https://cloud.example',
                'username': 'alice',
                'userId': 'alice-id',
                'version': '31.0.7',
                'edition': 'community',
                'createdAt': '100',
                'providerInstanceName': 'remote',
              },
            ],
          },
          '/api/providers/nextcloud/list' => {
            'content': [
              {
                'name': 'Movie.mkv',
                'path': '/Videos/Movie.mkv',
                'fileId': '9007199254740993',
                'isDir': false,
                'size': '1073741824',
                'modifiedAt': 'Sun, 12 Jul 2026 08:00:00 GMT',
                'contentType': 'video/x-matroska',
                'etag': 'etag-1',
                'permissions': 'RGDNVW',
                'ownerId': 'alice-id',
                'ownerDisplayName': 'Alice',
                'favorite': true,
                'hasPreview': true,
                'blurhash': 'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                'width': 1920,
                'height': 1080,
                'durationMillis': '7200000',
              },
            ],
            'total': '1',
            'page': '2',
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

    final binds = await service.getNextcloudBindInfos(instanceName: 'remote');
    final page = await service.listNextcloudFiles(
      'nextcloud-home',
      '/Videos',
      page: 2,
      search: 'Movie',
      instanceName: 'remote',
    );

    expect(binds.single.userId, 'alice-id');
    expect(binds.single.version, '31.0.7');
    expect(page.items.single.fileId, 9007199254740993);
    expect(page.items.single.durationMillis, 7200000);
    expect(page.items.single.blurhash, isNotEmpty);
    expect(
      Uri.parse(page.items.single.previewUrl).queryParameters,
      containsPair('fileId', '9007199254740993'),
    );
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer access-token',
      ),
      isTrue,
    );
    final body = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(body['path'], '/Videos');
    expect(body['page'], '2');
    expect(body['search'], 'Movie');
  });
}
