import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  final queries =
      <String, Future<List<Object>> Function(SyncTvProviderDomainService)>{
        'alist': (service) => service.getAllAlistBindInfos(),
        'emby': (service) => service.getAllEmbyBindInfos(),
        'cloudreve': (service) => service.getAllCloudreveBindInfos(),
        'bilibili': (service) => service.getAllBilibiliBindInfos(),
        'twitch': (service) => service.getAllTwitchBindInfos(),
        'fnos': (service) => service.getAllFnosBindInfos(),
        'qnap': (service) => service.getAllQnapBindInfos(),
        'synology': (service) => service.getAllSynologyBindInfos(),
        'nextcloud': (service) => service.getAllNextcloudBindInfos(),
        'seafile': (service) => service.getAllSeafileBindInfos(),
        'truenas': (service) => service.getAllTrueNasBindInfos(),
        'youtube': (service) => service.getAllYoutubeBindInfos(),
        'douyin': (service) => service.getAllDouyinBindInfos(),
        'tiktok': (service) => service.getAllTikTokBindInfos(),
      };

  for (final entry in queries.entries) {
    for (final state in ['populated', 'empty', 'failed']) {
      test(
        '${entry.key} all bindings use one unfiltered request: $state',
        () async {
          final requests = <http.Request>[];
          final path = '/api/providers/${entry.key}/binds';
          final client = MockClient((request) async {
            requests.add(request);
            if (request.url.path != path) {
              return http.Response('Instance directory unavailable', 503);
            }
            if (state == 'failed') {
              return http.Response('Bindings unavailable', 503);
            }
            return http.Response(
              jsonEncode({
                'binds': [
                  if (state == 'populated')
                    for (final instance in ['', 'remote'])
                      {
                        'id': instance.isEmpty ? 'local-id' : 'remote-id',
                        'serverId': 'shared-server',
                        'providerInstanceName': instance,
                        'createdAt': '100',
                      },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          });
          addTearDown(client.close);
          final service = SyncTvProviderDomainService(
            SyncTvApiClient(
              baseUrl: 'https://synctv.example',
              session: SyncTvSession()
                ..updateAccountTokens(accessToken: 'test-token'),
              httpClient: client,
            ),
          );
          if (state == 'failed') {
            await expectLater(
              entry.value(service),
              throwsA(isA<SyncTvApiException>()),
            );
          } else {
            final binds = await entry.value(service);
            expect(
              binds.map(_identity).toList(),
              state == 'empty'
                  ? isEmpty
                  : [
                      ('local-id', 'shared-server', ''),
                      ('remote-id', 'shared-server', 'remote'),
                    ],
            );
          }
          expect(requests, hasLength(1));
          expect(requests.single.url.path, path);
          expect(requests.single.method, 'GET');
          expect(
            requests.single.url.queryParameters['instanceName'] ?? '',
            isEmpty,
          );
          expect(requests.single.headers['authorization'], 'Bearer test-token');
        },
      );
    }
  }
}

(String, String, String) _identity(Object bind) => switch (bind) {
  AlistBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  EmbyBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  CloudreveBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  BilibiliBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  TwitchBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  FnosBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  QnapBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  SynologyBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  NextcloudBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  SeafileBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  TrueNasBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  YoutubeBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  DouyinBindInfo(:final id, :final serverId, :final providerInstanceName) ||
  TikTokBindInfo(
    :final id,
    :final serverId,
    :final providerInstanceName,
  ) => (id, serverId, providerInstanceName),
  _ => throw StateError('Unsupported binding: ${bind.runtimeType}'),
};
