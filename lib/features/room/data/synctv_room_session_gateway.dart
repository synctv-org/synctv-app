import 'dart:typed_data';

import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/contracts/account_models.dart';

final class SyncTvRoomSessionGateway implements RoomSessionGateway {
  const SyncTvRoomSessionGateway();

  @override
  String get serverBaseUrl => SyncTvService.baseUrl;

  @override
  SyncTvSessionIdentity get sessionIdentity => SyncTvService.sessionIdentity;

  @override
  bool get allowInsecureTls => SyncTvService.allowInsecureTls;

  @override
  Stream<void> get authErrors => SyncTvService.onAuthError;

  @override
  Future<bool> refreshSessionAfterUnauthorized() =>
      SyncTvService.refreshSessionAfterUnauthorized();

  @override
  Future<void> syncServerTime({bool refresh = false}) =>
      SyncTvService.syncServerTime(refresh: refresh);

  @override
  Future<Uri> createWebSocketUri(String roomId) =>
      SyncTvService.createRoomWebSocketUri(roomId);

  @override
  String encodeMessage(client.ClientMessage message) =>
      SyncTvService.encodeRealtimeMessageJson(message);

  @override
  client.ServerMessage decodeMessage(String json) =>
      SyncTvService.decodeRealtimeMessageJson(json);

  @override
  Future<Uri> createWebTransportUri(String roomId) =>
      SyncTvService.createRoomWebTransportUri(roomId);

  @override
  Future<client.CreateRealtimeSessionResponse> createRealtimeSession(
    String roomId,
    List<client.ObserveResource> initialObservations,
  ) => SyncTvService.createRealtimeSession(roomId, initialObservations);

  @override
  Stream<Uint8List> openRealtimeSessionEvents(
    String roomId,
    String sessionId,
  ) => SyncTvService.openRealtimeSessionEvents(roomId, sessionId);

  @override
  Future<void> sendRealtimeSessionMessage(
    String roomId,
    String sessionId,
    client.ClientMessage message,
  ) => SyncTvService.sendRealtimeSessionMessage(roomId, sessionId, message);

  @override
  Future<void> endRealtimeSession(String roomId, String sessionId) =>
      SyncTvService.endRealtimeSession(roomId, sessionId);
}
