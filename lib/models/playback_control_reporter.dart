import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class PlaybackControlReporter {
  const PlaybackControlReporter({
    required this.currentStatus,
    required this.isLive,
    required this.boundPosition,
  });

  final SyncTvPlaybackStatus? currentStatus;
  final bool isLive;
  final double Function(double positionSeconds) boundPosition;

  client.ClientMessage? playbackStateChanged({
    required VideoPlayerValue value,
    required bool isPlaying,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      isPlaying ? PlaybackControlAction.play : PlaybackControlAction.pause,
      isPlaying: isPlaying,
      position: isLive ? null : value.position.inMilliseconds / 1000.0,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }

  client.ClientMessage? seek({
    required VideoPlayerValue value,
    required Duration position,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    if (!_canReport(value)) return null;
    if (isLive) return null;
    return _message(
      PlaybackControlAction.seek,
      isPlaying: value.isPlaying,
      position: position.inMilliseconds / 1000.0,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }

  client.ClientMessage? playbackSpeedChanged({
    required VideoPlayerValue value,
    required double speed,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      PlaybackControlAction.speed,
      isPlaying: value.isPlaying,
      position: isLive ? null : value.position.inMilliseconds / 1000.0,
      playbackRate: speed,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }

  bool _canReport(VideoPlayerValue value) => value.isInitialized;

  client.ClientMessage _message(
    PlaybackControlAction action, {
    required bool isPlaying,
    required double? position,
    double? playbackRate,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    final boundedPosition = position == null ? null : boundPosition(position);
    return RoomRealtimeCodec.buildGuardedPlaybackStateUpdateMessage(
      action,
      currentStatus,
      isPlaying: isPlaying,
      position: boundedPosition,
      playbackRate: playbackRate,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }
}
