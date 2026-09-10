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
  var _closed = false;
  Future<void>? _closeFuture;

  RoomRealtimeConnection._({
    required this._outgoing,
    required this._socket,
    required this.stream,
    required this.onOutgoing,
    required this.closeSocket,
  });

  final StreamController<List<int>> _outgoing;
  final Future<RoomRealtimeSocket> _socket;
  @override
  final Stream<Uint8List> stream;
  final void Function(List<int> bytes)? onOutgoing;
  final Future<void> Function() closeSocket;

  @override
  Future<void> get ready async {
    await _socket;
  }

  @override
  void send(List<int> bytes) {
    if (bytes.isNotEmpty && !_outgoing.isClosed) _outgoing.add(bytes);
  }

  @override
  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    _closed = true;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    // An unconnected queue has no listener to consume its done event.
    unawaited(_outgoing.close());
    try {
      await _socket.timeout(_closeTimeout);
      await closeSocket().timeout(_closeTimeout);
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
    Future<void>? socketCloseFuture;
    Future<void> closeSocket() =>
        socketCloseFuture ??= Future<void>.sync(socket.close);

    StreamSubscription<List<int>>? outgoingSubscription;
    final incoming = StreamController<Uint8List>();
    final outgoing = StreamController<List<int>>();

    void failTransport(Object error, StackTrace stackTrace) {
      if (outgoing.isClosed) return;
      if (!incoming.isClosed) incoming.addError(error, stackTrace);
      unawaited(connection.close());
    }

    final connectingSocket = Future<Uri>.sync(() => createWebSocketUri(roomId))
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
            unawaited(closeSocket().catchError((_) {}));
            return connected;
          }
          socket.messages.listen(
            (frame) {
              if (outgoing.isClosed) return;
              try {
                final message = decodeMessage(frame);
                final bytes = Uint8List.fromList(message.writeToBuffer());
                onIncoming?.call(bytes);
                incoming.add(bytes);
              } catch (error, stackTrace) {
                failTransport(error, stackTrace);
              }
            },
            onError: failTransport,
            onDone: () {
              connection._heartbeatTimer?.cancel();
              connection._heartbeatTimer = null;
              unawaited(outgoing.close());
              unawaited(incoming.close());
            },
          );
          outgoingSubscription = outgoing.stream
              .where((bytes) => bytes.isNotEmpty)
              .listen((bytes) {
                if (outgoing.isClosed) return;
                try {
                  final message = client.ClientMessage.fromBuffer(bytes);
                  onOutgoing?.call(bytes);
                  socket.send(encodeMessage(message));
                } catch (error, stackTrace) {
                  failTransport(error, stackTrace);
                }
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
        onError: (Object error, StackTrace stackTrace) {
          unawaited(outgoing.close());
          incoming.addError(error, stackTrace);
          unawaited(incoming.close());
        },
      ),
    );
    connection = RoomRealtimeConnection._(
      outgoing: outgoing,
      socket: socketFuture,
      stream: incoming.stream,
      onOutgoing: onOutgoing,
      closeSocket: closeSocket,
    );
    incoming.onCancel = () async {
      connection._heartbeatTimer?.cancel();
      connection._heartbeatTimer = null;
      unawaited(outgoing.close());
      await outgoingSubscription?.cancel();
      if (connection._closed) return;
      await socketFuture
          .timeout(_closeTimeout)
          .then((_) => closeSocket().timeout(_closeTimeout))
          .catchError((_) {});
    };

    return connection;
  }
}
