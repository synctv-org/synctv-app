import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  late List<http.Request> requests;
  late SyncTvProviderDomainService service;

  setUp(() {
    requests = [];
    final api = SyncTvApiClient(
      baseUrl: 'https://synctv.example',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    service = SyncTvProviderDomainService(api);
  });

  test('passwordless Emby login sends the empty password oneof', () async {
    await service.loginEmbyInfo(
      'https://emby.example',
      'guest',
      '',
      passwordless: true,
    );

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(body, containsPair('password', ''));
    expect(body, isNot(contains('apiKey')));
  });

  test('Emby login preserves password whitespace', () async {
    const password = '  secret password\t';

    await service.loginEmbyInfo('https://emby.example', 'alice', password);

    final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
    expect(body['password'], password);
  });

  test(
    'Emby login rejects an empty password without passwordless mode',
    () async {
      await expectLater(
        service.loginEmbyInfo('https://emby.example', 'guest', ''),
        throwsArgumentError,
      );

      expect(requests, isEmpty);
    },
  );

  test('Emby login rejects API Key and passwordless mode together', () async {
    await expectLater(
      service.loginEmbyInfo(
        'https://emby.example',
        'guest',
        '',
        apiKey: 'key',
        passwordless: true,
      ),
      throwsArgumentError,
    );

    expect(requests, isEmpty);
  });
}
