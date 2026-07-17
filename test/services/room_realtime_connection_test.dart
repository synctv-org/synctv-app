import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/services/room_realtime_connection.dart';

void main() {
  test(
    'reports connection setup errors without an uncaught async error',
    () async {
      final uncaughtErrors = <Object>[];

      await runZonedGuarded(() async {
        final connection = RoomRealtimeConnection.connect(
          'room_1',
          createWebSocketUri: (_) async => throw StateError('ticket failed'),
        );

        await expectLater(connection.stream, emitsError(isA<StateError>()));
        await Future<void>.delayed(Duration.zero);
      }, (error, _) => uncaughtErrors.add(error));

      expect(uncaughtErrors, isEmpty);
    },
  );
}
