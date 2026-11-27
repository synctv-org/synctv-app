import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

typedef VideoPlayerRuntimeFactory = VideoPlayerRuntime Function(int textureId);

/// Seek step, in seconds, a browser applies when its media UI issues a
/// `seekbackward`/`seekforward` action without its own offset.
const defaultUserMediaSeekOffset = 10.0;

/// Playback commands issued by the browser's own media UI — the
/// picture-in-picture window controls or hardware media keys — rather than by
/// the app's widgets. Web runtimes surface them through
/// [UserMediaActionsRuntime.userMediaPlaybackActions] so the app can treat
/// them like its own control buttons.
enum UserMediaPlaybackActionKind {
  play,
  pause,
  seekBackward,
  seekForward,
  seekTo,
}

class UserMediaPlaybackAction {
  const UserMediaPlaybackAction.play()
    : this._(UserMediaPlaybackActionKind.play, null);
  const UserMediaPlaybackAction.pause()
    : this._(UserMediaPlaybackActionKind.pause, null);
  const UserMediaPlaybackAction.seekBackward(double seconds)
    : this._(UserMediaPlaybackActionKind.seekBackward, seconds);
  const UserMediaPlaybackAction.seekForward(double seconds)
    : this._(UserMediaPlaybackActionKind.seekForward, seconds);
  const UserMediaPlaybackAction.seekTo(double seconds)
    : this._(UserMediaPlaybackActionKind.seekTo, seconds);
  const UserMediaPlaybackAction._(this.kind, this.seconds);

  final UserMediaPlaybackActionKind kind;

  /// The seek offset in seconds for [UserMediaPlaybackActionKind.seekBackward]
  /// and [UserMediaPlaybackActionKind.seekForward], the absolute position in
  /// seconds for [UserMediaPlaybackActionKind.seekTo], and null otherwise.
  final double? seconds;

  /// Maps a `MediaSession` action name and its details fields to a user
  /// action. Returns null for actions this player does not handle; a null or
  /// non-positive seek offset leaves the command without a usable target, so
  /// it is dropped as well.
  static UserMediaPlaybackAction? parse(
    String action, {
    double? seekOffsetSeconds,
    double? seekTimeSeconds,
  }) {
    const defaultSeekOffsetSeconds = defaultUserMediaSeekOffset;
    double? positive(double? value) =>
        value != null && value.isFinite && value > 0 ? value : null;
    double? nonNegative(double? value) =>
        value != null && value.isFinite && value >= 0 ? value : null;
    return switch (action) {
      'play' => const UserMediaPlaybackAction.play(),
      'pause' => const UserMediaPlaybackAction.pause(),
      'seekbackward' => UserMediaPlaybackAction.seekBackward(
        positive(seekOffsetSeconds) ?? defaultSeekOffsetSeconds,
      ),
      'seekforward' => UserMediaPlaybackAction.seekForward(
        positive(seekOffsetSeconds) ?? defaultSeekOffsetSeconds,
      ),
      // A seek to position 0 is valid; only reject missing or broken values.
      'seekto' =>
        nonNegative(seekTimeSeconds) == null
            ? null
            : UserMediaPlaybackAction.seekTo(seekTimeSeconds!),
      _ => null,
    };
  }
}

/// Exposes the playback commands that arrive through the browser's media UI.
abstract interface class UserMediaActionsRuntime {
  Stream<UserMediaPlaybackAction> get userMediaPlaybackActions;
}

class AdaptiveVideoTrackInfo {
  const AdaptiveVideoTrackInfo({
    required this.id,
    this.title,
    this.width,
    this.height,
    this.fps,
    this.bitrate,
    this.codec,
  });

  final String id;
  final String? title;
  final int? width;
  final int? height;
  final double? fps;
  final int? bitrate;
  final String? codec;

  String get resolution =>
      width != null && height != null ? '${width}x$height' : '';
}

class AdaptiveVideoTrackSnapshot {
  const AdaptiveVideoTrackSnapshot({
    this.tracks = const [],
    this.selectedTrackId = 'auto',
    this.automaticSelectionAvailable = true,
  });

  final List<AdaptiveVideoTrackInfo> tracks;
  final String selectedTrackId;
  final bool automaticSelectionAvailable;
}

abstract interface class AdaptiveVideoTrackRuntime {
  Stream<AdaptiveVideoTrackSnapshot> get adaptiveVideoTracks;

  Future<void> selectAdaptiveVideoTrack(String trackId);
}

class AdaptiveAudioTrackInfo {
  const AdaptiveAudioTrackInfo({
    required this.id,
    this.title,
    this.language,
    this.bitrate,
    this.codec,
    this.channels,
    this.sampleRate,
  });

  final String id;
  final String? title;
  final String? language;
  final int? bitrate;
  final String? codec;
  final int? channels;
  final int? sampleRate;
}

class AdaptiveAudioTrackSnapshot {
  const AdaptiveAudioTrackSnapshot({
    this.tracks = const [],
    this.selectedTrackId = 'auto',
    this.automaticSelectionAvailable = true,
  });

  final List<AdaptiveAudioTrackInfo> tracks;
  final String selectedTrackId;
  final bool automaticSelectionAvailable;
}

abstract interface class AdaptiveAudioTrackRuntime {
  Stream<AdaptiveAudioTrackSnapshot> get adaptiveAudioTracks;

  Future<void> selectAdaptiveAudioTrack(String trackId);
}

abstract interface class WebVideoPlayerOptionsRuntime {
  Future<void> setWebOptions(VideoPlayerWebOptions options);
}

abstract interface class PictureInPictureRuntime {
  Stream<bool> get pictureInPictureEvents;

  Future<bool> enterPictureInPicture();

  Future<void> exitPictureInPicture();
}

abstract interface class VideoPlayerRuntime {
  Stream<VideoEvent> get events;

  Future<void> open(Media media);

  Future<void> dispose();

  Future<void> play();

  Future<void> pause();

  Future<void> setLooping(bool looping);

  Future<void> setVolume(double volume);

  Future<void> seekTo(Duration position);

  Future<void> setPlaybackSpeed(double speed);

  Duration get position;

  Widget buildView();

  void reportOpenError(Object error, StackTrace stackTrace);
}
