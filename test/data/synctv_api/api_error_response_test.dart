import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_management_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  for (final entry in <String, String>{
    'HTML document': '<!DOCTYPE html><html><body>Proxy failed</body></html>',
    'plain response': 'upstream debug output',
    'truncated JSON': '{"message":"unfinished',
    'JSON list': '["internal diagnostic"]',
    'JSON string': '"internal diagnostic"',
    'missing message': '{"debug":"internal diagnostic"}',
    'object message': '{"message":{"debug":"internal diagnostic"}}',
    'list message': '{"message":["internal diagnostic"]}',
    'numeric message': '{"message":123}',
    'blank message': '{"message":"   "}',
  }.entries) {
    test('${entry.key} uses a concise HTTP fallback', () async {
      final api = _api(entry.value);
      addTearDown(api.close);
      await expectLater(
        _login(api),
        throwsA(
          isA<SyncTvApiException>()
              .having((error) => error.message, 'message', 'HTTP 502')
              .having((error) => error.statusCode, 'status', 502)
              .having((error) => error.requestMethod, 'method', 'POST')
              .having(
                (error) => error.requestUri?.path,
                'path',
                '/api/auth/direct-password/login',
              ),
        ),
      );
    });
  }

  test(
    'structured messages and diagnostic metadata survive normalization',
    () async {
      final api = _api(
        jsonEncode({
          'message': '  Please retry later.  ',
          'code': 14,
          'details': [
            {
              'metadata': {'errorCode': '1234', 'requestId': 'request-1'},
            },
          ],
        }),
      );
      addTearDown(api.close);
      await expectLater(
        _login(api),
        throwsA(
          isA<SyncTvApiException>()
              .having(
                (error) => error.message,
                'message',
                'Please retry later.',
              )
              .having((error) => error.grpcCode, 'grpcCode', 14)
              .having((error) => error.code, 'code', 1234)
              .having((error) => error.requestId, 'requestId', 'request-1'),
        ),
      );
    },
  );

  for (final upload in [false, true]) {
    test(
      '${upload ? 'upload' : 'SSE'} uses the shared HTML error fallback',
      () async {
        final api = _api('<html><body>Proxy failed</body></html>');
        addTearDown(api.close);
        final request = upload
            ? api.uploadRawBytes('/upload', [1], contentType: 'image/png')
            : SyncTvRoomManagementDomainService(api)
                  .watchRoomSettings('room')
                  .first;
        await expectLater(
          request,
          throwsA(
            isA<SyncTvApiException>()
                .having((error) => error.message, 'message', 'HTTP 502')
                .having(
                  (error) => error.requestMethod,
                  'method',
                  upload ? 'PUT' : 'GET',
                ),
          ),
        );
      },
    );
  }
}

SyncTvApiClient _api(String body) => SyncTvApiClient(
  baseUrl: 'https://example.test',
  session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
  httpClient: MockClient((_) async => http.Response(body, 502)),
);

Future<Object?> _login(SyncTvApiClient api) => api.auth.loginWithDirectPassword(
  client.LoginWithDirectPasswordRequest(
    loginSessionId: 'session',
    password: 'password',
  ),
);
