import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_management_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_media_service.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

final roomWatchCursorChecks = <String, Future<void> Function()>{
  for (final search in [false, true])
    for (final id in ['9007199254740993', '9223372036854775807'])
      'Chat ${search ? 'search' : 'history'} cursor $id': () async {
        final transport = MockClient(
          (request) async => http.Response(
            jsonEncode({
              'eventCursor': {'sequence': id},
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
        );
        try {
          final service = SyncTvRoomMediaDomainService(
            SyncTvApiClient(
              baseUrl: 'https://example.test',
              session: SyncTvSession()
                ..updateAccountTokens(accessToken: 'token'),
              httpClient: transport,
            ),
          );
          final cursor = search
              ? (await service.searchChatMessages(
                  'room',
                  query: 'sample',
                )).eventCursor
              : (await service.getChatHistory('room')).eventCursor;
          if (cursor != id) {
            throw StateError('Chat cursor: expected $id, got $cursor');
          }
        } finally {
          transport.close();
        }
      },
  for (final surface in ['Settings', 'Members', 'Playlist']) ...{
    for (final id in ['9007199254740993', '9223372036854775807']) ...{
      for (final event in ['request', 'observed', 'changed'])
        '$surface $event $id': () => _check(
          surface: surface,
          version: event == 'request' ? id : '',
          expectedQuery: event == 'request' ? id : null,
          sequence: event == 'request' ? '42' : id,
          changed: event == 'changed',
        ),
    },
    '$surface zero cursor': () => _check(
      surface: surface,
      version: '0',
      expectedQuery: '0',
      sequence: '0',
    ),
    '$surface legacy event ID': () =>
        _check(surface: surface, version: 'legacy-event', sequence: '0'),
    '$surface malformed cursors': () async {
      for (final version in ['-1', '0x10', '9223372036854775808', '1.5']) {
        await _check(surface: surface, version: version, sequence: '42');
      }
    },
  },
  for (final id in ['9007199254740993', '9223372036854775807', '0'])
    'WebSocket request and events $id': () async {
      final request = client.ClientMessage.fromBuffer(
        RoomRealtimeCodec.encodeRoomSettingsObservation(version: id),
      );
      final sequence = request.observeResource.roomSettings.afterEventSequence;
      if (sequence.toString() != id) {
        throw StateError('WebSocket request: expected $id, got $sequence');
      }
      for (final changed in [false, true]) {
        final message = client.ServerMessage()
          ..mergeFromProto3Json({
            changed ? 'resourceEvent' : 'resourceObserved': {
              'observeId': 'room_settings',
              'eventCursor': {'sequence': id, 'eventId': 'legacy-event'},
              if (changed) 'roomSettings': {'settings': {}},
            },
          });
        final decoded = RoomRealtimeCodec.decode(message.writeToBuffer());
        final expected = id == '0' ? 'legacy-event' : id;
        if (decoded.resourceVersion != expected) {
          throw StateError(
            'WebSocket event: expected $expected, got ${decoded.resourceVersion}',
          );
        }
      }
    },
};

Future<void> _check({
  required String surface,
  required String version,
  required String sequence,
  String? expectedQuery,
  bool changed = false,
}) async {
  Uri? requestUri;
  final transport = MockClient((request) async {
    requestUri = request.url;
    final payload = {
      'observeId': surface,
      'eventCursor': {'sequence': sequence, 'eventId': 'legacy-event'},
      if (!changed) 'changed': false,
      if (changed && surface == 'Settings')
        'roomSettings': {
          'settings': {'chatEnabled': true},
        },
    };
    return http.Response(
      'event: ${changed ? 'changed' : 'observed'}\n'
      'data: ${jsonEncode(payload)}\n\n',
      200,
      headers: {'content-type': 'text/event-stream'},
    );
  });
  try {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: transport,
    );
    final service = SyncTvRoomManagementDomainService(api);
    final stream = switch (surface) {
      'Members' => service.watchRoomMembers('room', version: version),
      'Playlist' => SyncTvRoomMediaDomainService(
        api,
      ).watchPlaylistItems('room', version: version),
      _ => service.watchRoomSettings('room', version: version),
    };
    final event = await stream.first;
    final actualVersion = switch (event) {
      RoomResourceObserved(:final version) => version,
      RoomResourceChanged(:final version) => version,
      _ => throw StateError('Unexpected watch event'),
    };
    final actualQuery = requestUri?.queryParameters['afterEventSequence'];
    if (actualQuery != expectedQuery) {
      throw StateError(
        'Request cursor: expected $expectedQuery, got $actualQuery',
      );
    }
    final expectedVersion = sequence == '0' ? 'legacy-event' : sequence;
    if (actualVersion != expectedVersion) {
      throw StateError(
        'Event cursor: expected $expectedVersion, got $actualVersion',
      );
    }
  } finally {
    transport.close();
  }
}
