import 'package:synctv_app/contracts/room_management_models.dart';

typedef VoiceSignalingCallback = void Function(
  String type,
  Map<String, dynamic> data,
);
typedef VoiceIceServersLoader = Future<List<IceServerInfo>> Function();

abstract interface class VoiceChatSession {
  bool get isConnected;
  bool get hasPeersConnected;
  bool get isMuted;
  int get participantCount;

  void handleSignalingMessage(String type, Map<String, dynamic> data);
  Future<void> join({required String clientOperationId});
  Future<bool> rejectJoin(String clientOperationId);
  Future<void> leave();
  void toggleMute();
  Future<void> dispose();
}

abstract interface class VoiceChatSessionFactory {
  VoiceChatSession create({
    required VoiceSignalingCallback onSignalingMessage,
    required VoiceIceServersLoader loadIceServers,
    required void Function() onStateChange,
  });
}
