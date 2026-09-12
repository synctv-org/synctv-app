import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_admin_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';

void main() {
  for (final room in [false, true]) {
    for (final id in ['9007199254740993', '9223372036854775807']) {
      test('report request and response preserve $id (room: $room)', () async {
        final requests = <http.Request>[];
        final api = SyncTvApiClient(
          baseUrl: 'https://example.test',
          session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
          httpClient: MockClient((request) async {
            requests.add(request);
            return http.Response(
              jsonEncode({
                'reports': [
                  {'id': 'report', 'targetChatMessageId': id},
                ],
                'total': 1,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }),
        );
        final service = SyncTvAdminDomainService(api);
        final page = room
            ? await service.listRoomContentReportsPage(
                'room',
                targetChatMessageId: id,
              )
            : await service.listContentReportsPage(targetChatMessageId: id);
        expect(
          requests.single.url.path,
          room ? '/api/rooms/room/reports' : '/api/admin/reports',
        );
        expect(requests.single.url.queryParameters['targetChatMessageId'], id);
        expect(page.reports.single.targetChatMessageId, id);
      });
    }
    test('invalid report ID never reaches transport (room: $room)', () async {
      var requests = 0;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession(),
        httpClient: MockClient((request) async {
          requests++;
          return http.Response('{}', 200);
        }),
      );
      final service = SyncTvAdminDomainService(api);
      for (final id in ['9223372036854775808', '-1', '0x10', '1.5']) {
        await expectLater(
          room
              ? service.listRoomContentReportsPage(
                  'room',
                  targetChatMessageId: id,
                )
              : service.listContentReportsPage(targetChatMessageId: id),
          throwsFormatException,
        );
      }
      expect(requests, 0);
    });
  }
}
