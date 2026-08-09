import 'package:synctv_app/features/room/application/room_session_gateway.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

final class SyncTvRoomSessionGateway implements RoomSessionGateway {
  const SyncTvRoomSessionGateway();

  @override
  String get serverBaseUrl => SyncTvService.baseUrl;

  @override
  bool get isGuestSession => SyncTvService.isGuestSession;

  @override
  bool get allowInsecureTls => SyncTvService.allowInsecureTls;

  @override
  Stream<void> get authErrors => SyncTvService.onAuthError;

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
}
