import 'package:synctv_app/contracts/synctv_models.dart';

class PlaybackSyncTarget {
  final double positionSeconds;
  final bool isAtEnd;

  const PlaybackSyncTarget({
    required this.positionSeconds,
    this.isAtEnd = false,
  });
}

PlaybackSyncTarget resolvePlaybackSyncTarget({
  required SyncTvPlaybackStatus status,
  required Duration duration,
  required DateTime now,
}) {
  final computedTime = status.derivedCurrentTime(now: now);
  if (!computedTime.isFinite || computedTime <= 0) {
    return const PlaybackSyncTarget(positionSeconds: 0);
  }
  if (duration <= Duration.zero) {
    return PlaybackSyncTarget(positionSeconds: computedTime);
  }
  final durationSeconds = duration.inMilliseconds / 1000.0;
  if (durationSeconds <= 0) {
    return PlaybackSyncTarget(positionSeconds: computedTime);
  }
  if (computedTime >= durationSeconds) {
    return PlaybackSyncTarget(positionSeconds: durationSeconds, isAtEnd: true);
  }
  return PlaybackSyncTarget(positionSeconds: computedTime);
}

bool shouldAutoSeekToPlaybackSyncTarget({
  required double currentPositionSeconds,
  required PlaybackSyncTarget target,
  required double driftThresholdSeconds,
  required bool freeModeEnabled,
}) {
  if (freeModeEnabled) return false;
  return (currentPositionSeconds - target.positionSeconds).abs() >
      driftThresholdSeconds;
}
