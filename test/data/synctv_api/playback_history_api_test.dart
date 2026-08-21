import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  test(
    'playback history APIs map ordering, cursor, delete, and clear',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.method == 'GET') {
            return http.Response(
              jsonEncode({
                'entries': [
                  {'id': 'ph_1', 'mediaName': 'First'},
                ],
                'nextCursorEntryId': 'ph_2',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path.endsWith('/ph_1')) {
            return http.Response(
              jsonEncode({'deleted': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            jsonEncode({'deletedCount': '3'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final page = await api.room.listPlaybackHistory(
        'room_1',
        client.ListPlaybackHistoryRequest(
          cursorEntryId: 'ph_cursor',
          limit: 20,
          sortDirection: client.SortDirection.SORT_DIRECTION_ASC,
        ),
      );
      final deleted = await api.room.deletePlaybackHistoryEntry(
        'room_1',
        client.DeletePlaybackHistoryEntryRequest(entryId: 'ph_1'),
      );
      final cleared = await api.room.clearPlaybackHistory('room_1');

      expect(page.entries.single.mediaName, 'First');
      expect(page.nextCursorEntryId, 'ph_2');
      expect(deleted.deleted, isTrue);
      expect(cleared.deletedCount.toInt(), 3);
      expect(requests[0].url.path, '/api/rooms/room_1/playback/history');
      expect(requests[0].url.queryParameters, {
        'cursorEntryId': 'ph_cursor',
        'limit': '20',
        'sortDirection': '1',
      });
      expect(requests[1].method, 'DELETE');
      expect(requests[1].url.path, '/api/rooms/room_1/playback/history/ph_1');
      expect(requests[2].method, 'DELETE');
      expect(requests[2].url.path, '/api/rooms/room_1/playback/history');
    },
  );
}
