import 'package:synctv_app/contracts/room_management_models.dart';

typedef VoiceSignalingCallback = void Function(
  String type,
  Map<String, dynamic> data,
);
typedef VoiceIceServersLoader = Future<List<IceServerInfo>> Function();

/// Remote voice playback volume bounds. 1.0 is the platform default gain;
/// values above 1.0 boost quieter calls.
abstract final class VoiceChatVolumeRange {
  static const double min = 0.0;
  static const double max = 2.0;
  static const double initial = 1.0;

  static double clamp(double value) => value.clamp(min, max).toDouble();
}

abstract interface class VoiceChatSession {
  bool get isConnected;
  bool get hasPeersConnected;
  bool get isMuted;
  int get participantCount;

  /// Current playback gain applied to remote voice tracks.
  double get remoteVolume;

  /// Sets the playback gain for remote voice tracks, including tracks that
  /// connect later. The value is clamped to [VoiceChatVolumeRange].
  void setRemoteVolume(double value);

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
