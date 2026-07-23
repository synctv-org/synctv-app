import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class RoomRealtimeConnection {
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
  final Stream<Uint8List> stream;
  final void Function(List<int> bytes, [client.ClientMessage? message])?
  onOutgoing;

  StreamSink<List<int>> get sink => _outgoing.sink;

  Future<void> get ready async {
    await _socket;
  }

  void sendMessage(client.ClientMessage message) {
    unawaited(_sendMessage(message));
  }

  Future<void> _sendMessage(client.ClientMessage message) async {
    final socket = await _socket;
    final bytes = message.writeToBuffer();
    onOutgoing?.call(bytes, message);
    socket.add(SyncTvService.encodeRealtimeMessageJson(message));
  }

  Future<void> close([int? closeCode, String? closeReason]) async {
    await _outgoing.close();
    final socket = await _socket;
    await socket.close(closeCode, closeReason);
  }

  static RoomRealtimeConnection connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes, [client.ClientMessage? message])? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
    Future<Uri> Function(String roomId)? createWebSocketUri,
  }) {
    late final WebSocket socket;
    StreamSubscription<List<int>>? outgoingSubscription;
    Timer? heartbeatTimer;
    final incoming = StreamController<Uint8List>();
    final outgoing = StreamController<List<int>>();

    final socketFuture =
        (createWebSocketUri ?? SyncTvService.createRoomWebSocketUri)(roomId)
            .timeout(_connectTimeout)
            .then(
              (uri) =>
                  WebSocket.connect(uri.toString()).timeout(_connectTimeout),
            )
            .then((connected) {
              socket = connected;
              socket.pingInterval = const Duration(seconds: 10);
              socket.listen(
                (frame) {
                  try {
                    if (frame is! String) return;
                    final message = SyncTvService.decodeRealtimeMessageJson(
                      frame,
                    );
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
                    onOutgoing?.call(bytes, message);
                    socket.add(
                      SyncTvService.encodeRealtimeMessageJson(message),
                    );
                  });
              heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (_) {
                if (!outgoing.isClosed) {
                  outgoing.add(RoomRealtimeCodec.encodeSync());
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
}
