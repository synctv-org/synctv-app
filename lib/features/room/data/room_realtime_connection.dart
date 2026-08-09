import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/core/network/server_http_client.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
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

  RoomRealtimeConnection._({
    required this._outgoing,
    required this._socket,
    required this.stream,
    required this.onOutgoing,
  });

  final StreamController<List<int>> _outgoing;
  final Future<WebSocket> _socket;
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
    await _outgoing.close();
    final socket = await _socket;
    await socket.close();
  }

  static RoomRealtimeConnection connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    required Future<Uri> Function(String roomId) createWebSocketUri,
    required RealtimeMessageEncoder encodeMessage,
    required RealtimeMessageDecoder decodeMessage,
    required int Function() nowMillis,
    bool allowInsecureTls = false,
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  }) {
    late final WebSocket socket;
    StreamSubscription<List<int>>? outgoingSubscription;
    Timer? heartbeatTimer;
    final incoming = StreamController<Uint8List>();
    final outgoing = StreamController<List<int>>();

    final socketFuture = createWebSocketUri(roomId)
        .timeout(_connectTimeout)
        .then(
          (uri) => _connectWebSocket(
            uri,
            allowInsecureTls: allowInsecureTls,
          ).timeout(_connectTimeout),
        )
        .then((connected) {
          socket = connected;
          socket.pingInterval = const Duration(seconds: 10);
          socket.listen(
            (frame) {
              try {
                if (frame is! String) return;
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
                socket.add(encodeMessage(message));
              });
          heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (_) {
            if (!outgoing.isClosed) {
              outgoing.add(
                RoomRealtimeCodec.encodeSync(timestampMillis: nowMillis()),
              );
            }
          });
          for (final message in initialMessages) {
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
        },
      ),
    );
    incoming.onCancel = () async {
      heartbeatTimer?.cancel();
      await outgoing.close();
      await outgoingSubscription?.cancel();
      await socketFuture
          .then((_) => socket.close().timeout(_closeTimeout))
          .catchError((_) {});
    };

    return RoomRealtimeConnection._(
      outgoing: outgoing,
      socket: socketFuture,
      stream: incoming.stream,
      onOutgoing: onOutgoing,
    );
  }

  static Future<WebSocket> _connectWebSocket(
    Uri uri, {
    required bool allowInsecureTls,
  }) async {
    if (!allowInsecureTls || uri.scheme.toLowerCase() != 'wss') {
      return WebSocket.connect(uri.toString());
    }
    final client = createServerIoHttpClient(
      uri.replace(scheme: 'https'),
      allowInsecureTls: true,
    );
    try {
      return await WebSocket.connect(uri.toString(), customClient: client);
    } finally {
      client.close(force: false);
    }
  }
}
