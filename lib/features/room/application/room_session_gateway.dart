import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

abstract interface class RoomSessionGateway {
  String get serverBaseUrl;

  bool get isGuestSession;

  bool get allowInsecureTls;

  Stream<void> get authErrors;

  Future<void> syncServerTime({bool refresh = false});

  Future<Uri> createWebSocketUri(String roomId);

  String encodeMessage(client.ClientMessage message);

  client.ServerMessage decodeMessage(String json);
}
