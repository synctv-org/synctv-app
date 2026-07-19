// Derived from package:video_player_media_kit under the MIT license.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

typedef VideoPlayerRuntimeFactory = VideoPlayerRuntime Function(int textureId);

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

class CancellableMediaKitVideoPlayer extends VideoPlayerPlatform {
  CancellableMediaKitVideoPlayer({VideoPlayerRuntimeFactory? runtimeFactory})
    : _runtimeFactory = runtimeFactory ?? _MediaKitVideoPlayerRuntime.new;

  final VideoPlayerRuntimeFactory _runtimeFactory;
  final Map<int, _VideoPlayerSession> _sessions = {};
  int _nextTextureId = 1;

  static void registerWith() {
    VideoPlayerPlatform.instance = CancellableMediaKitVideoPlayer();
  }

  @override
  Future<void> init() async {
    final sessions = _sessions.values.toList(growable: false);
    _sessions.clear();
    await Future.wait(sessions.map((session) => session.dispose()));
  }

  @override
  Future<int?> create(DataSource dataSource) async {
    final textureId = _nextTextureId++;
    final runtime = _runtimeFactory(textureId);
    final session = _VideoPlayerSession(runtime);
    _sessions[textureId] = session;
    session.open(_mediaFromDataSource(dataSource));
    return textureId;
  }

  @override
  Future<void> dispose(int playerId) async {
    final session = _sessions.remove(playerId);
    await session?.dispose();
  }

  @override
  Stream<VideoEvent> videoEventsFor(int playerId) {
    return _session(playerId).runtime.events;
  }

  @override
  Future<void> setLooping(int playerId, bool looping) {
    return _sessions[playerId]?.runtime.setLooping(looping) ?? Future.value();
  }

  @override
  Future<void> play(int playerId) {
    return _sessions[playerId]?.runtime.play() ?? Future.value();
  }

  @override
  Future<void> pause(int playerId) {
    return _sessions[playerId]?.runtime.pause() ?? Future.value();
  }

  @override
  Future<void> setVolume(int playerId, double volume) {
    return _sessions[playerId]?.runtime.setVolume(volume) ?? Future.value();
  }

  @override
  Future<void> seekTo(int playerId, Duration position) {
    return _sessions[playerId]?.runtime.seekTo(position) ?? Future.value();
  }

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) {
    return _sessions[playerId]?.runtime.setPlaybackSpeed(speed) ??
        Future.value();
  }

  @override
  Future<Duration> getPosition(int playerId) async {
    return _sessions[playerId]?.runtime.position ?? Duration.zero;
  }

  @override
  Widget buildView(int playerId) => _session(playerId).runtime.buildView();

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) => Future.value();

  @override
  Future<void> setWebOptions(int playerId, VideoPlayerWebOptions options) =>
      Future.value();

  _VideoPlayerSession _session(int textureId) {
    final session = _sessions[textureId];
    if (session == null) {
      throw StateError('Video player $textureId has been disposed');
    }
    return session;
  }

  Media _mediaFromDataSource(DataSource dataSource) {
    final resource = switch (dataSource.sourceType) {
      DataSourceType.asset =>
        dataSource.package == null
            ? 'asset:///${dataSource.asset}'
            : 'asset:///packages/${dataSource.package}/${dataSource.asset}',
      DataSourceType.network ||
      DataSourceType.file ||
      DataSourceType.contentUri =>
        dataSource.uri ??
            (throw ArgumentError(
              'A URI is required for ${dataSource.sourceType}',
            )),
    };
    return Media(resource, httpHeaders: dataSource.httpHeaders);
  }
}

class _VideoPlayerSession {
  _VideoPlayerSession(this.runtime);

  final VideoPlayerRuntime runtime;
  bool _cancelled = false;
  Future<void>? _disposeFuture;

  void open(Media media) {
    unawaited(
      runtime.open(media).catchError((Object error, StackTrace stackTrace) {
        if (!_cancelled) runtime.reportOpenError(error, stackTrace);
      }),
    );
  }

  Future<void> dispose() {
    _cancelled = true;
    return _disposeFuture ??= runtime.dispose();
  }
}

class _MediaKitVideoPlayerRuntime implements VideoPlayerRuntime {
  _MediaKitVideoPlayerRuntime(int textureId)
    : _player = Player(),
      _events = StreamController<VideoEvent>() {
    _videoController = VideoController(_player);
    _subscribe();
  }

  final Player _player;
  final StreamController<VideoEvent> _events;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  late final VideoController _videoController;
  bool _initialized = false;
  bool _disposed = false;
  Future<void>? _disposeFuture;
  int? _width;
  int? _height;
  Duration? _duration;

  @override
  Stream<VideoEvent> get events => _events.stream;

  @override
  Duration get position => _player.platform?.state.position ?? Duration.zero;

  @override
  Future<void> open(Media media) => _player.open(media, play: false);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> setLooping(bool looping) {
    return _player.setPlaylistMode(
      looping ? PlaylistMode.single : PlaylistMode.none,
    );
  }

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume * 100);

  @override
  Future<void> seekTo(Duration position) => _player.seek(position);

  @override
  Future<void> setPlaybackSpeed(double speed) => _player.setRate(speed);

  @override
  Widget buildView() {
    if (_disposed) throw StateError('Video player has been disposed');
    return Video(
      key: ValueKey(_videoController),
      controller: _videoController,
      wakelock: false,
      controls: NoVideoControls,
      fill: const Color(0x00000000),
      pauseUponEnteringBackgroundMode: false,
      resumeUponEnteringForegroundMode: false,
    );
  }

  @override
  void reportOpenError(Object error, StackTrace stackTrace) {
    if (_disposed || _events.isClosed) return;
    _events.addError(
      error is PlatformException
          ? error
          : PlatformException(code: 'open_failed', message: error.toString()),
      stackTrace,
    );
  }

  @override
  Future<void> dispose() => _disposeFuture ??= _disposeOnce();

  Future<void> _disposeOnce() async {
    _disposed = true;
    await Future.wait(
      _subscriptions.map((subscription) => subscription.cancel()),
    );
    _subscriptions.clear();
    await _events.close();
    try {
      await _player.stop();
    } finally {
      await _player.dispose();
    }
  }

  void _subscribe() {
    _subscriptions.add(
      _player.stream.duration.listen((duration) {
        if (duration > Duration.zero) {
          _duration = duration;
          _notifyInitialized();
        }
      }),
    );
    _subscriptions.add(
      _player.stream.videoParams.listen((params) {
        if (params.dw != null && params.dh != null) {
          _width = params.dw;
          _height = params.dh;
          _notifyInitialized();
        }
      }),
    );
    _subscriptions.add(
      _player.stream.tracks.listen((tracks) {
        if (tracks.video.length == 2 && tracks.audio.length > 2) {
          _width = 0;
          _height = 0;
          _notifyInitialized();
        }
      }),
    );
    _subscriptions.add(
      _player.stream.playing.listen((playing) {
        if (_canEmitPlaybackEvent) {
          _events.add(
            VideoEvent(
              eventType: VideoEventType.isPlayingStateUpdate,
              isPlaying: playing,
            ),
          );
        }
      }),
    );
    _subscriptions.add(
      _player.stream.completed.listen((completed) {
        if (_canEmitPlaybackEvent && completed) {
          _events.add(VideoEvent(eventType: VideoEventType.completed));
        }
      }),
    );
    _subscriptions.add(
      _player.stream.buffering.listen((buffering) {
        if (_canEmitPlaybackEvent) {
          _events.add(
            VideoEvent(
              eventType: buffering
                  ? VideoEventType.bufferingStart
                  : VideoEventType.bufferingEnd,
            ),
          );
        }
      }),
    );
    _subscriptions.add(
      _player.stream.buffer.listen((buffer) {
        if (_canEmitPlaybackEvent) {
          _events.add(
            VideoEvent(
              eventType: VideoEventType.bufferingUpdate,
              buffered: [DurationRange(Duration.zero, buffer)],
            ),
          );
        }
      }),
    );
    _subscriptions.add(
      _player.stream.error.listen((error) {
        reportOpenError(
          PlatformException(code: 'media_error', message: error),
          StackTrace.current,
        );
      }),
    );
  }

  bool get _canEmitPlaybackEvent =>
      _initialized && !_disposed && !_events.isClosed;

  void _notifyInitialized() {
    if (_initialized || _disposed || _events.isClosed) return;
    final width = _width;
    final height = _height;
    final duration = _duration;
    if (width == null || height == null || duration == null) return;
    _initialized = true;
    _events.add(
      VideoEvent(
        eventType: VideoEventType.initialized,
        size: Size(width.toDouble(), height.toDouble()),
        duration: duration,
      ),
    );
  }
}
