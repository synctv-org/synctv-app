import 'dart:typed_data';

import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/contracts/account_models.dart';

abstract interface class RoomSessionGateway {
  String get serverBaseUrl;

  SyncTvSessionIdentity get sessionIdentity;

  bool get allowInsecureTls;

  Stream<void> get authErrors;

  Future<bool> refreshSessionAfterUnauthorized();

  Future<void> syncServerTime({bool refresh = false});

  Future<Uri> createWebSocketUri(String roomId);

  /// WebTransport room URI (`https://…/wt/rooms/{roomId}`) with a fresh
  /// one-time ticket.
  Future<Uri> createWebTransportUri(String roomId);

  String encodeMessage(client.ClientMessage message);

  client.ServerMessage decodeMessage(String json);

  /// Creates an HTTP realtime session and returns its id + lease ttl.
  Future<client.CreateRealtimeSessionResponse> createRealtimeSession(
    String roomId,
    List<client.ObserveResource> initialObservations,
  );

  /// Attaches to the session's SSE downlink, yielding `ServerMessage` bytes.
  Stream<Uint8List> openRealtimeSessionEvents(String roomId, String sessionId);

  /// Posts one message into the session (chat, playback, observe, WebRTC,
  /// heartbeat).
  Future<void> sendRealtimeSessionMessage(
    String roomId,
    String sessionId,
    client.ClientMessage message,
  );

  /// Gracefully ends the session.
  Future<void> endRealtimeSession(String roomId, String sessionId);
}
