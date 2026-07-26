import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  test(
    'reports connection setup errors without an uncaught async error',
    () async {
      final uncaughtErrors = <Object>[];

      await runZonedGuarded(() async {
        final connection = RoomRealtimeConnection.connect(
          'room_1',
          createWebSocketUri: (_) async => throw StateError('ticket failed'),
          encodeMessage: (_) => '',
          decodeMessage: (_) => client.ServerMessage(),
          nowMillis: () => 0,
        );

        final readyFailure = expectLater(
          connection.ready,
          throwsA(isA<StateError>()),
        );
        await expectLater(connection.stream, emitsError(isA<StateError>()));
        await readyFailure;
        await Future<void>.delayed(Duration.zero);
      }, (error, _) => uncaughtErrors.add(error));

      expect(uncaughtErrors, isEmpty);
    },
  );
}
