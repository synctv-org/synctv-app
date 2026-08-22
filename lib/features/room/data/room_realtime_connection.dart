import 'dart:async';
import 'dart:typed_data';

import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/data/room_realtime_socket.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

typedef RealtimeMessageEncoder = String Function(client.ClientMessage message);
typedef RealtimeMessageDecoder = client.ServerMessage Function(String json);

final class IoRoomRealtimeChannelFactory implements RoomRealtimeChannelFactory {
  const IoRoomRealtimeChannelFactory({required this.sessionGateway});

  final RoomSessionGateway sessionGateway;

  @override
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    return RoomRealtimeConnection.connect(
      roomId,
      createWebSocketUri: sessionGateway.createWebSocketUri,
      encodeMessage: sessionGateway.encodeMessage,
      decodeMessage: sessionGateway.decodeMessage,
      nowMillis: SyncedClock.nowMillis,
      allowInsecureTls: sessionGateway.allowInsecureTls,
      initialMessages: initialMessages,
      onOutgoing: onOutgoing,
      onIncoming: onIncoming,
    );
  }
}

class RoomRealtimeConnection implements RoomRealtimeChannel {
  static const _connectTimeout = Duration(seconds: 10);
  static const _closeTimeout = Duration(seconds: 2);

  Timer? _heartbeatTimer;

  RoomRealtimeConnection._({
    required this._outgoing,
    required this._socket,
    required this.stream,
    required this.onOutgoing,
  });

  final StreamController<List<int>> _outgoing;
  final Future<RoomRealtimeSocket> _socket;
  @override
  final Stream<Uint8List> stream;
  final void Function(List<int> bytes)? onOutgoing;

  @override
  Future<void> get ready async {
    await _socket;
  }

  @override
  void send(List<int> bytes) {
    if (bytes.isNotEmpty) _outgoing.add(bytes);
  }

  @override
  Future<void> close() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _outgoing.close();
    try {
      final socket = await _socket.timeout(_closeTimeout);
      await socket.close().timeout(_closeTimeout);
    } catch (_) {
      // A late connection closes itself after setup completes.
    }
  }

  static RoomRealtimeConnection connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    required Future<Uri> Function(String roomId) createWebSocketUri,
    required RealtimeMessageEncoder encodeMessage,
    required RealtimeMessageDecoder decodeMessage,
    required int Function() nowMillis,
    bool allowInsecureTls = false,
    Future<RoomRealtimeSocket> Function(
      Uri uri, {
      required bool allowInsecureTls,
    })?
    connectSocket,
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    late final RoomRealtimeSocket socket;
    late final RoomRealtimeConnection connection;
    StreamSubscription<List<int>>? outgoingSubscription;
    final incoming = StreamController<Uint8List>();
    final outgoing = StreamController<List<int>>();

    final connectingSocket = createWebSocketUri(roomId)
        .timeout(_connectTimeout)
        .then(
          (uri) => (connectSocket ?? connectRoomRealtimeSocket)(
            uri,
            allowInsecureTls: allowInsecureTls,
          ),
        );

    final socketFuture = connectingSocket
        .timeout(
          _connectTimeout,
          onTimeout: () {
            unawaited(
              connectingSocket
                  .then((lateSocket) => lateSocket.close())
                  .catchError((_) {}),
            );
            throw TimeoutException(
              'Room realtime socket timed out',
              _connectTimeout,
            );
          },
        )
        .then((connected) {
          socket = connected;
          if (outgoing.isClosed) {
            unawaited(socket.close().catchError((_) {}));
            return connected;
          }
          socket.messages.listen(
            (frame) {
              try {
                final message = decodeMessage(frame);
                final bytes = Uint8List.fromList(message.writeToBuffer());
                onIncoming?.call(bytes);
                incoming.add(bytes);
              } catch (error, stackTrace) {
                incoming.addError(error, stackTrace);
              }
            },
            onError: incoming.addError,
            onDone: incoming.close,
          );
          outgoingSubscription = outgoing.stream
              .where((bytes) => bytes.isNotEmpty)
              .listen((bytes) {
                final message = client.ClientMessage.fromBuffer(bytes);
                onOutgoing?.call(bytes);
                socket.send(encodeMessage(message));
              });
          connection._heartbeatTimer = Timer.periodic(
            const Duration(seconds: 25),
            (_) {
              if (!outgoing.isClosed) {
                outgoing.add(
                  RoomRealtimeCodec.encodeSync(timestampMillis: nowMillis()),
                );
              }
            },
          );
          for (final message in initialMessages) {
            if (outgoing.isClosed) break;
            if (message.isNotEmpty) outgoing.add(message);
          }
          return connected;
        });

    unawaited(
      socketFuture.then<void>(
        (_) {},
        onError: (Object error, StackTrace stackTrace) async {
          incoming.addError(error, stackTrace);
          await incoming.close();
          await outgoing.close();
        },
      ),
    );
    connection = RoomRealtimeConnection._(
      outgoing: outgoing,
      socket: socketFuture,
      stream: incoming.stream,
      onOutgoing: onOutgoing,
    );
    incoming.onCancel = () async {
      connection._heartbeatTimer?.cancel();
      connection._heartbeatTimer = null;
      await outgoing.close();
      await outgoingSubscription?.cancel();
      await socketFuture
          .then((_) => socket.close().timeout(_closeTimeout))
          .catchError((_) {});
    };

    return connection;
  }
}
