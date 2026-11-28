import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';

/// Resolves a browser media UI command (picture-in-picture window controls,
/// hardware media keys) into the position the user asked for, or null when
/// the command carries no usable target.
///
/// Relative seeks wrap around the media bounds: a step before the start or
/// past the end clamps to the edge, so the resulting room-wide seek intent
/// always lands on a playable position.
Duration? resolveUserMediaSeekTarget({
  required UserMediaPlaybackAction action,
  required Duration position,
  required Duration duration,
}) {
  double? positionSeconds;
  switch (action.kind) {
    case UserMediaPlaybackActionKind.seekTo:
      positionSeconds = action.seconds;
    case UserMediaPlaybackActionKind.seekBackward:
    case UserMediaPlaybackActionKind.seekForward:
      final offset = action.seconds ?? defaultUserMediaSeekOffset;
      final currentPosition = position.inMilliseconds / 1000.0;
      positionSeconds = action.kind == UserMediaPlaybackActionKind.seekBackward
          ? currentPosition - offset
          : currentPosition + offset;
    case UserMediaPlaybackActionKind.play:
    case UserMediaPlaybackActionKind.pause:
      return null;
  }
  if (positionSeconds == null || !positionSeconds.isFinite) return null;
  final maximum = duration > Duration.zero
      ? duration.inMilliseconds / 1000.0
      : double.infinity;
  final bounded = positionSeconds.clamp(0.0, maximum).toDouble();
  return Duration(milliseconds: (bounded * 1000).round());
}
