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

  String encodeMessage(client.ClientMessage message);

  client.ServerMessage decodeMessage(String json);
}
