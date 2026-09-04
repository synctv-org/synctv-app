import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

typedef VideoPlayerRuntimeFactory = VideoPlayerRuntime Function(int textureId);

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
