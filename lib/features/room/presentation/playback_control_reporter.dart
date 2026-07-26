import 'package:video_player/video_player.dart';
import 'package:synctv_app/features/room/application/room_realtime_protocol.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

class PlaybackControlReporter {
  const PlaybackControlReporter({
    required this.currentStatus,
    required this.isLive,
    required this.boundPosition,
    required this.protocol,
  });

  final SyncTvPlaybackStatus? currentStatus;
  final bool isLive;
  final double Function(double positionSeconds) boundPosition;
  final RoomRealtimeProtocol protocol;

  List<int>? playbackStateChanged({
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

  List<int>? seek({
    required VideoPlayerValue value,
    required Duration position,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    if (!_canReport(value)) return null;
    if (isLive) return null;
    return _message(
      PlaybackControlAction.seek,
      isPlaying: currentStatus?.isPlaying ?? value.isPlaying,
      position: position.inMilliseconds / 1000.0,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }

  List<int>? playbackSpeedChanged({
    required VideoPlayerValue value,
    required double speed,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      PlaybackControlAction.speed,
      isPlaying: currentStatus?.isPlaying ?? value.isPlaying,
      position: isLive ? null : value.position.inMilliseconds / 1000.0,
      playbackRate: speed,
      clientOperationId: clientOperationId,
      clientTimeMillis: clientTimeMillis,
    );
  }

  bool _canReport(VideoPlayerValue value) => value.isInitialized;

  List<int> _message(
    PlaybackControlAction action, {
    required bool isPlaying,
    required double? position,
    double? playbackRate,
    String? clientOperationId,
    int? clientTimeMillis,
  }) {
    final boundedPosition = position == null ? null : boundPosition(position);
    return protocol.encodeGuardedPlaybackStateUpdate(
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
