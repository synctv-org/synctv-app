import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test('TrueNAS provider service maps binds and files', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://synctv.example',
      session: SyncTvSession()..accessToken = 'token',
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/providers/truenas/binds') {
          return http.Response(
            jsonEncode({
              'binds': [
                {
                  'id': '1',
                  'serverId': 'nas-home',
                  'endpoint': 'https://nas.example',
                  'hostname': 'storage-node.example',
                  'version': '25.10',
                  'systemProduct': 'TrueNAS SCALE',
                  'createdAt': '100',
                  'providerInstanceName': 'remote',
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'content': [
              {
                'name': 'Movie.mkv',
                'path': '/mnt/tank/Movie.mkv',
                'isDir': false,
                'size': '1073741824',
                'mode': 420,
                'uid': 1000,
                'gid': 1000,
                'isMountpoint': false,
                'attributes': ['ARCHIVE'],
                'zfsAttributes': ['ZFS_ARCHIVE'],
              },
            ],
            'total': '1',
            'page': '2',
            'hasMore': false,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvProviderDomainService(api);

    final binds = await service.getTrueNasBindInfos(instanceName: 'remote');
    final page = await service.listTrueNasFiles(
      'nas-home',
      '/mnt/tank',
      page: 2,
      search: 'Movie',
      instanceName: 'remote',
    );

    expect(binds.single.systemProduct, 'TrueNAS SCALE');
    expect(page.items.single.path, '/mnt/tank/Movie.mkv');
    expect(page.items.single.zfsAttributes, ['ZFS_ARCHIVE']);
    final body = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(body['path'], '/mnt/tank');
    expect(body['page'], '2');
    expect(body['search'], 'Movie');
  });
}
