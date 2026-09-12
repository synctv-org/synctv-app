import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_account_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  const largeId = '9007199254740993';
  const adjacentId = '9007199254740992';
  const maximumId = '9223372036854775807';
  late List<http.Request> requests;
  late SyncTvNotificationDomainService service;

  setUp(() {
    requests = [];
    final transport = MockClient((request) async {
      requests.add(request);
      if (request.method == 'GET') {
        return http.Response(
          jsonEncode({'id': request.url.pathSegments.last}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
      return http.Response('', 204);
    });
    addTearDown(transport.close);
    service = SyncTvNotificationDomainService(
      SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: transport,
      ),
    );
  });

  test('notification read and delete preserve the server decimal ID', () async {
    for (final id in [adjacentId, largeId, maximumId]) {
      final item = notificationFromProto(client.NotificationProto(id: id));
      expect(item.id, id);
      expect(item.hasValidId, isTrue);
      await service.markNotificationAsRead(item);
      expect(jsonDecode(requests.last.body), {
        'notificationIds': [id],
      });
      await service.deleteNotification(item);
      expect(requests.last.method, 'DELETE');
      expect(requests.last.url.pathSegments.last, id);
      final detail = await service.getNotification(id);
      expect(requests.last.url.pathSegments.last, id);
      expect(detail.id, id);
    }
  });

  test(
    'batch IDs remain distinct and normalize without numeric rounding',
    () async {
      await service.markNotificationsAsRead([
        adjacentId,
        largeId,
        maximumId,
        '000$largeId',
        '0',
        '-1',
        '9223372036854775808',
        '1e3',
        '',
      ]);
      expect(requests, hasLength(1));
      expect(jsonDecode(requests.single.body), {
        'notificationIds': [adjacentId, largeId, maximumId],
      });
    },
  );

  test('invalid IDs cannot generate notification requests', () async {
    for (final id in ['', '0', '-1', '9223372036854775808', 'NaN']) {
      final item = notificationFromProto(client.NotificationProto(id: id));
      expect(item.hasValidId, isFalse);
      await service.markNotificationAsRead(item);
      await service.deleteNotification(item);
      await expectLater(service.getNotification(id), throwsFormatException);
    }
    expect(requests, isEmpty);
  });
}
