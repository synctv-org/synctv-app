import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class PlaybackControlReporter {
  const PlaybackControlReporter({
    required this.currentStatus,
    required this.isSyncing,
    required this.boundPosition,
  });

  final SyncTvPlaybackStatus? currentStatus;
  final bool isSyncing;
  final double Function(double positionSeconds) boundPosition;

  client.ClientMessage? playbackStateChanged({
    required VideoPlayerValue value,
    required bool isPlaying,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      isPlaying ? PlaybackControlAction.play : PlaybackControlAction.pause,
      isPlaying: isPlaying,
      position: value.position.inMilliseconds / 1000.0,
      playbackRate: value.playbackSpeed,
    );
  }

  client.ClientMessage? seek({
    required VideoPlayerValue value,
    required Duration position,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      PlaybackControlAction.seek,
      isPlaying: value.isPlaying,
      position: position.inMilliseconds / 1000.0,
      playbackRate: value.playbackSpeed,
    );
  }

  client.ClientMessage? playbackSpeedChanged({
    required VideoPlayerValue value,
    required double speed,
  }) {
    if (!_canReport(value)) return null;
    return _message(
      PlaybackControlAction.speed,
      isPlaying: value.isPlaying,
      position: value.position.inMilliseconds / 1000.0,
      playbackRate: speed,
    );
  }

  bool _canReport(VideoPlayerValue value) => value.isInitialized && !isSyncing;

  client.ClientMessage _message(
    PlaybackControlAction action, {
    required bool isPlaying,
    required double position,
    required double playbackRate,
  }) {
    return RoomRealtimeCodec.buildGuardedPlaybackStateUpdateMessage(
      action,
      currentStatus,
      isPlaying: isPlaying,
      position: boundPosition(position),
      playbackRate: playbackRate,
    );
  }
}
