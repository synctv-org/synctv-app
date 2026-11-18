import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// The media_kit surface the native video player runtime drives. The real
/// player implements it in production; tests substitute fakes to exercise
/// the runtime's event translation and HLS variant logic without a live
/// playback pipeline.
abstract class MediaKitPlayerHandle {
  Stream<Duration> get durationStream;
  Stream<VideoParams> get videoParamsStream;
  Stream<Tracks> get tracksStream;
  Stream<Track> get trackStream;
  Stream<bool> get playingStream;
  Stream<bool> get completedStream;
  Stream<bool> get bufferingStream;
  Stream<Duration> get bufferStream;
  Stream<String> get errorStream;

  /// The currently selected tracks and playback state.
  Tracks get tracks;
  Track get selectedTracks;
  bool get isPlaying;
  Duration get position;

  /// Whether the underlying platform is the native (libmpv) backend, which
  /// supports mpv properties such as `hls-bitrate`.
  bool get isNativePlatform;

  Future<void> setProperty(String name, String value);
  Future<void> open(Media media, {bool play});
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> setRate(double rate);
  Future<void> seek(Duration position);
  Future<void> setPlaylistMode(PlaylistMode mode);
  Future<void> setVideoTrack(VideoTrack track);
  Future<void> setAudioTrack(AudioTrack track);
  Future<void> dispose();

  /// Builds the platform video surface for this handle's player.
  Widget buildVideoWidget();
}

/// [MediaKitPlayerHandle] backed by a real media_kit [Player].
class RealMediaKitPlayerHandle implements MediaKitPlayerHandle {
  RealMediaKitPlayerHandle() : _player = Player();

  final Player _player;
  VideoController? _videoController;

  @override
  Stream<Duration> get durationStream => _player.stream.duration;
  @override
  Stream<VideoParams> get videoParamsStream => _player.stream.videoParams;
  @override
  Stream<Tracks> get tracksStream => _player.stream.tracks;
  @override
  Stream<Track> get trackStream => _player.stream.track;
  @override
  Stream<bool> get playingStream => _player.stream.playing;
  @override
  Stream<bool> get completedStream => _player.stream.completed;
  @override
  Stream<bool> get bufferingStream => _player.stream.buffering;
  @override
  Stream<Duration> get bufferStream => _player.stream.buffer;
  @override
  Stream<String> get errorStream => _player.stream.error;

  @override
  Tracks get tracks => _player.state.tracks;
  @override
  Track get selectedTracks => _player.state.track;
  @override
  bool get isPlaying => _player.state.playing;
  @override
  Duration get position => _player.platform?.state.position ?? Duration.zero;
  @override
  bool get isNativePlatform => _player.platform is NativePlayer;

  @override
  Future<void> setProperty(String name, String value) async {
    final platform = _player.platform;
    if (platform is NativePlayer) {
      // Dynamic dispatch: the web build stubs NativePlayer without mpv
      // property methods, and this branch never runs there.
      await (platform as dynamic).setProperty(name, value);
    }
  }

  @override
  Future<void> open(Media media, {bool play = false}) =>
      _player.open(media, play: play);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> setRate(double rate) => _player.setRate(rate);

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setPlaylistMode(PlaylistMode mode) =>
      _player.setPlaylistMode(mode);

  @override
  Future<void> setVideoTrack(VideoTrack track) => _player.setVideoTrack(track);

  @override
  Future<void> setAudioTrack(AudioTrack track) => _player.setAudioTrack(track);

  @override
  Future<void> dispose() => _player.dispose();

  @override
  Widget buildVideoWidget() {
    final controller = _videoController ??= VideoController(_player);
    return Video(
      key: ValueKey(controller),
      controller: controller,
      wakelock: true,
      controls: NoVideoControls,
      fill: const Color(0x00000000),
      pauseUponEnteringBackgroundMode: false,
      resumeUponEnteringForegroundMode: false,
    );
  }
}
