import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/data/room_realtime_socket_contract.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

void main() {
  test(
    'synchronous ticket failure uses ready and stream error contracts',
    () async {
      final failure = StateError('ticket unavailable');
      final connection = RoomRealtimeConnection.connect(
        'room',
        createWebSocketUri: (_) => throw failure,
        encodeMessage: (_) => '',
        decodeMessage: (_) => client.ServerMessage(),
        nowMillis: () => 0,
      );
      final ready = expectLater(connection.ready, throwsA(same(failure)));
      await expectLater(
        connection.stream,
        emitsInOrder([emitsError(same(failure)), emitsDone]),
      );
      await ready;
      await connection.close();
    },
  );

  for (final pendingSetup in [false, true]) {
    test('concurrent close waits for shared teardown, setup=$pendingSetup', () {
      fakeAsync((async) {
        final teardown = Completer<void>();
        final socket = _Socket()..closeCompletion = teardown;
        final connection = RoomRealtimeConnection.connect(
          'room',
          createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
          connectSocket: (_, {required allowInsecureTls}) async => socket,
          encodeMessage: (_) => 'encoded',
          decodeMessage: (_) => client.ServerMessage(),
          nowMillis: () => 0,
        );
        if (!pendingSetup) async.flushMicrotasks();
        var completions = 0;
        connection.close().then((_) => completions++);
        connection.close().then((_) => completions++);
        async.flushMicrotasks();
        expect(socket.closeCalls, 1);
        expect(completions, 0);
        teardown.complete();
        async.flushMicrotasks();
        expect(completions, 2);
        expect(async.periodicTimerCount, 0);
      });
    });
  }

  test('close is idempotent across concurrent callers', () async {
    final socket = _Socket();
    final connection = RoomRealtimeConnection.connect(
      'room',
      createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
      connectSocket: (_, {required allowInsecureTls}) async => socket,
      encodeMessage: (_) => 'encoded',
      decodeMessage: (_) => client.ServerMessage(),
      nowMillis: () => 0,
    );
    await Future.wait([connection.close(), connection.close()]);
    expect(socket.closeCalls, 1);
  });

  test('malformed incoming frame closes the socket once', () {
    fakeAsync((async) {
      final socket = _Socket()
        ..frames.add('bad')
        ..frames.add('another bad frame');
      final errors = <Object>[];
      final connection = RoomRealtimeConnection.connect(
        'room',
        createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
        connectSocket: (_, {required allowInsecureTls}) async => socket,
        encodeMessage: (_) => 'encoded',
        decodeMessage: (_) => throw FormatException('bad frame'),
        nowMillis: () => 0,
      );
      final subscription = connection.stream.listen(
        (_) {},
        onError: errors.add,
      );
      async.flushMicrotasks();
      async.elapse(Duration.zero);
      expect(errors, hasLength(1));
      expect(socket.closeCalls, 1);
      expect(async.periodicTimerCount, 0);
      subscription.cancel();
      async.flushMicrotasks();
    });
  });

  test('socket error closes transport and suppresses queued errors', () {
    fakeAsync((async) {
      final failure = StateError('transport failed');
      final socket = _Socket();
      final errors = <Object>[];
      var decoded = 0;
      final connection = RoomRealtimeConnection.connect(
        'room',
        createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
        connectSocket: (_, {required allowInsecureTls}) async => socket,
        encodeMessage: (_) => 'encoded',
        decodeMessage: (_) {
          decoded++;
          return client.ServerMessage();
        },
        nowMillis: () => 0,
      );
      final subscription = connection.stream.listen(
        (_) {},
        onError: errors.add,
      );
      async.flushMicrotasks();
      socket.frames
        ..addError(failure)
        ..add('late frame')
        ..addError(StateError('late error'));
      async.flushMicrotasks();
      expect(errors, [same(failure)]);
      expect(decoded, 0);
      expect(socket.closeCalls, 1);
      expect(async.periodicTimerCount, 0);
      subscription.cancel();
      async.flushMicrotasks();
    });
  });

  for (final stage in ['encode', 'observe', 'send']) {
    test('outgoing $stage failure reaches the connection error stream', () {
      fakeAsync((async) {
        final failure = StateError('outgoing failed');
        final errors = <Object>[];
        final socket = _Socket()..sendError = stage == 'send' ? failure : null;
        final connection = RoomRealtimeConnection.connect(
          'room',
          createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
          connectSocket: (_, {required allowInsecureTls}) async => socket,
          encodeMessage: (_) {
            if (stage == 'encode') throw failure;
            return 'encoded';
          },
          onOutgoing: (_) {
            if (stage == 'observe') throw failure;
          },
          decodeMessage: (_) => client.ServerMessage(),
          nowMillis: () => 0,
        );
        final subscription = connection.stream.listen(
          (_) {},
          onError: errors.add,
        );
        async.flushMicrotasks();
        final bytes = RoomRealtimeCodec.encodeSync(timestampMillis: 0);
        connection.send(bytes);
        connection.send(bytes);
        async.flushMicrotasks();
        expect(errors, [same(failure)]);
        expect(socket.closed, isTrue);
        expect(async.periodicTimerCount, 0);
        subscription.cancel();
        async.flushMicrotasks();
      });
    });
  }

  test('remote close stops heartbeats while incoming listener is paused', () {
    fakeAsync((async) {
      final socket = _Socket();
      final connection = RoomRealtimeConnection.connect(
        'room',
        createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
        connectSocket: (_, {required allowInsecureTls}) async => socket,
        encodeMessage: (_) => 'heartbeat',
        decodeMessage: (_) => client.ServerMessage(),
        nowMillis: () => 0,
      );
      final subscription = connection.stream.listen((_) {})..pause();
      async.flushMicrotasks();
      expect(async.periodicTimerCount, 1);
      socket.frames.close();
      async.flushMicrotasks();
      expect(async.periodicTimerCount, 0);
      async.elapse(const Duration(seconds: 30));
      expect(socket.sent, isEmpty);
      subscription.cancel();
      async.flushMicrotasks();
    });
  });

  for (final cancelStream in [false, true]) {
    test('pending connection cleanup is bounded, cancel=$cancelStream', () {
      fakeAsync((async) {
        final connecting = Completer<RoomRealtimeSocket>();
        final socket = _Socket();
        final connection = RoomRealtimeConnection.connect(
          'room',
          createWebSocketUri: (_) async => Uri.parse('ws://example.test'),
          connectSocket: (_, {required allowInsecureTls}) => connecting.future,
          encodeMessage: (_) => '',
          decodeMessage: (_) => client.ServerMessage(),
          nowMillis: () => 0,
        );
        final subscription = connection.stream.listen((_) {});
        async.flushMicrotasks();
        var finished = false;
        final cleanup = cancelStream
            ? subscription.cancel()
            : connection.close();
        cleanup.then((_) => finished = true);
        async.flushMicrotasks();
        async.elapse(const Duration(seconds: 3));
        expect(finished, isTrue);
        expect(() => connection.send([1]), returnsNormally);
        connecting.complete(socket);
        async.flushMicrotasks();
        expect(socket.closed, isTrue);
        expect(socket.sent, isEmpty);
        subscription.cancel();
        async.flushMicrotasks();
        expect(async.periodicTimerCount, 0);
      });
    });
  }
}

class _Socket implements RoomRealtimeSocket {
  final frames = StreamController<String>();
  final sent = <String>[];
  bool closed = false;
  int closeCalls = 0;
  Object? sendError;
  Completer<void>? closeCompletion;

  @override
  Stream<String> get messages => frames.stream;

  @override
  void send(String message) {
    if (sendError != null) throw sendError!;
    sent.add(message);
  }

  @override
  Future<void> close() async {
    closed = true;
    closeCalls++;
    unawaited(frames.close());
    await closeCompletion?.future;
  }
}
