import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  test('blocking APIs use account-scoped routes and map paged users', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.method == 'POST') {
          return http.Response(
            jsonEncode({
              'blockedUser': {
                'user': {'id': 'usr_target', 'username': 'Target'},
                'blockedAt': '1787284800',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'DELETE') {
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'users': [
              {
                'user': {'id': 'usr_target', 'username': 'Target'},
                'blockedAt': '1787284800',
              },
            ],
            'total': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final blocked = await api.user.blockUser(
      client.BlockUserRequest(userId: 'usr_target'),
    );
    final page = await api.user.listBlockedUsers(
      client.ListBlockedUsersRequest(page: 2, pageSize: 24, search: 'Target'),
    );
    await api.user.unblockUser(client.UnblockUserRequest(userId: 'usr_target'));

    expect(blocked.blockedUser.user.id, 'usr_target');
    expect(blocked.blockedUser.blockedAt.toInt(), 1787284800);
    expect(page.total, 1);
    expect(page.users.single.user.username, 'Target');
    expect(requests[0].method, 'POST');
    expect(requests[0].url.path, '/api/user/blocks');
    expect(jsonDecode(requests[0].body), {'userId': 'usr_target'});
    expect(requests[1].url.path, '/api/user/blocks');
    expect(requests[1].url.queryParameters, {
      'page': '2',
      'pageSize': '24',
      'search': 'Target',
    });
    expect(requests[2].method, 'DELETE');
    expect(requests[2].url.path, '/api/user/blocks/usr_target');
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer token',
      ),
      isTrue,
    );
  });
}
