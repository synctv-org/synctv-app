import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test('Twitch resolve preserves the complete resource URL', () async {
    late http.Request capturedRequest;
    final api = SyncTvApiClient(
      baseUrl: 'https://synctv.example',
      session: SyncTvSession()
        ..updateAccountTokens(accessToken: 'access-token'),
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'metadata': {
              'id': 'monstercat',
              'title': 'Monstercat',
              'author': 'Monstercat',
              'isLive': true,
            },
            'playback': {
              'resource': {'kind': 1, 'id': 'monstercat'},
              'qualities': [],
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    const resource = 'https://www.twitch.tv/monstercat';
    await SyncTvProviderDomainService(api).resolveTwitch(resource);

    expect(capturedRequest.url.path, '/api/providers/twitch/resolve');
    final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
    expect(body['resource'], resource);
  });
}
