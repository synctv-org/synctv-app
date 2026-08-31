import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
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

  test(
    'sends initial playback observations once per websocket lifecycle',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final received = <String>[];
      final receivedInitialMessages = Completer<void>();
      final expectedCount =
          RoomRealtimeCodec.encodeInitialObservations().length;
      WebSocket? serverSocket;
      final serverSubscription = server.listen((request) async {
        if (!WebSocketTransformer.isUpgradeRequest(request)) return;
        serverSocket = await WebSocketTransformer.upgrade(request);
        serverSocket!.listen((frame) {
          if (frame is! String) return;
          received.add(frame);
          if (received.length == expectedCount &&
              !receivedInitialMessages.isCompleted) {
            receivedInitialMessages.complete();
          }
        });
      });

      final connection = RoomRealtimeConnection.connect(
        'room_1',
        createWebSocketUri: (_) async =>
            Uri.parse('ws://127.0.0.1:${server.port}/ws/room_1'),
        encodeMessage: (message) => message.writeToJson(),
        decodeMessage: (_) => client.ServerMessage(),
        nowMillis: () => 0,
        initialMessages: RoomRealtimeCodec.encodeInitialObservations(),
      );

      try {
        await connection.ready;
        await receivedInitialMessages.future.timeout(
          const Duration(seconds: 2),
        );
        final observeIds = received
            .map(
              (frame) =>
                  client.ClientMessage.fromJson(frame)
                      .observeResource
                      .observeId,
            )
            .toList(growable: false);
        expect(observeIds.where((id) => id == 'playback_state'), hasLength(1));
        expect(observeIds.where((id) => id == 'playback'), hasLength(1));
      } finally {
        await connection.close();
        await serverSocket?.close();
        await serverSubscription.cancel();
        await server.close(force: true);
      }
    },
  );
}
