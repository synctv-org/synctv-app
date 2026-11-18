import 'package:flutter/foundation.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/domain/playback_sync_target.dart';

/// The player surface the playback sync loop drives. Keeping this an
/// interface lets the orchestration run under test without a live platform
/// player.
abstract class SyncedPlaybackPlayer {
  bool get isInitialized;
  double get playbackSpeed;
  bool get isPlaying;
  Duration get position;
  Duration get duration;
  Future<void> setPlaybackSpeed(double speed);
  Future<void> pause();
  Future<void> seekTo(Duration position);

  /// Starts playback through the platform's autoplay-aware path (a plain
  /// play can be rejected by browser autoplay policy).
  Future<void> play();
}

/// Drives [player] toward [status]: playback rate first, then pause, then
/// the seek decision, and only then playback start. Every step re-checks
/// [isCurrentSync] after its await and bails out without touching the player
/// again once a newer sync (or a controller replacement) has superseded
/// this one. Errors are swallowed after being reported through
/// [onSyncError], which decides whether they are worth surfacing.
Future<void> runPlaybackSync({
  required SyncedPlaybackPlayer player,
  required SyncTvPlaybackStatus status,
  required PlaybackModeConfig config,
  bool forceSeek = false,
  required bool Function() isCurrentSync,
  required VoidCallback onPlayerMutated,
  required void Function(Object error) onSyncError,
  DateTime Function()? now,
}) {
  return _runPlaybackSync(
    player: player,
    status: status,
    config: config,
    forceSeek: forceSeek,
    isCurrentSync: isCurrentSync,
    onPlayerMutated: onPlayerMutated,
    onSyncError: onSyncError,
    now: now ?? SyncedClock.now,
  );
}

Future<void> _runPlaybackSync({
  required SyncedPlaybackPlayer player,
  required SyncTvPlaybackStatus status,
  required PlaybackModeConfig config,
  required bool forceSeek,
  required bool Function() isCurrentSync,
  required VoidCallback onPlayerMutated,
  required void Function(Object error) onSyncError,
  required DateTime Function() now,
}) async {
  try {
    if (!isCurrentSync()) return;
    if (player.playbackSpeed != status.playbackRate) {
      await player.setPlaybackSpeed(status.playbackRate);
      if (!isCurrentSync()) return;
      onPlayerMutated();
    }

    final isLive = status.entry?.live == true;
    final target = isLive
        ? null
        : resolvePlaybackSyncTarget(
            status: status,
            duration: player.duration,
            now: now(),
          );
    final targetIsPlaying = target?.isAtEnd == true ? false : status.isPlaying;
    if (!targetIsPlaying && player.isPlaying) {
      await player.pause();
      if (!isCurrentSync()) return;
      onPlayerMutated();
    }
    if (target != null) {
      final currentPositionSeconds = player.position.inMilliseconds / 1000.0;
      final positionDrift = (currentPositionSeconds - target.positionSeconds)
          .abs();
      final shouldAutoSeek =
          target.isAtEnd ||
          shouldAutoSeekToPlaybackSyncTarget(
            currentPositionSeconds: currentPositionSeconds,
            target: target,
            driftThresholdSeconds: config.autoSeekDriftThresholdSeconds,
            freeModeEnabled: config.freeModeEnabled,
          );
      final shouldManualSeek =
          forceSeek && positionDrift >= config.manualSeekDriftThresholdSeconds;
      if (target.isAtEnd || shouldManualSeek || shouldAutoSeek) {
        await player.seekTo(
          Duration(milliseconds: (target.positionSeconds * 1000).toInt()),
        );
        if (!isCurrentSync()) return;
        onPlayerMutated();
      }
    }

    if (targetIsPlaying && !player.isPlaying) {
      await player.play();
      if (!isCurrentSync()) return;
      onPlayerMutated();
    }
    if (isCurrentSync()) onPlayerMutated();
  } catch (error) {
    onSyncError(error);
  }
}
