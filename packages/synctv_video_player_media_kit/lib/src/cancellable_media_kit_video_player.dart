// Derived from package:video_player_media_kit under the MIT license.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:media_kit/media_kit.dart';
import 'package:video_player/video_player.dart' hide VideoTrack;
import 'package:video_player_platform_interface/video_player_platform_interface.dart'
    hide VideoTrack;

import 'hls_master_playlist.dart';
import 'media_kit_player_handle.dart';
import 'platform_video_player_runtime.dart'
    if (dart.library.js_interop) 'web_video_player_runtime.dart'
    as platform_runtime;
import 'video_player_runtime.dart';

export 'media_kit_player_handle.dart';
export 'video_player_runtime.dart';

const syncTvVideoFormatHeader = 'x-synctv-internal-media-format';
const syncTvVideoLiveHeader = 'x-synctv-internal-media-live';

extension AdaptiveVideoTrackController on VideoPlayerController {
  Stream<AdaptiveVideoTrackSnapshot> get adaptiveVideoTracks {
    // The backend session uses the same identifier assigned by video_player.
    // ignore: invalid_use_of_visible_for_testing_member
    return CancellableMediaKitVideoPlayer.adaptiveVideoTracksFor(playerId);
  }

  Future<void> selectAdaptiveVideoTrack(String trackId) {
    // ignore: invalid_use_of_visible_for_testing_member
    final id = playerId;
    return CancellableMediaKitVideoPlayer.selectAdaptiveVideoTrack(id, trackId);
  }
}

extension AdaptiveAudioTrackController on VideoPlayerController {
  Stream<AdaptiveAudioTrackSnapshot> get adaptiveAudioTracks {
    // ignore: invalid_use_of_visible_for_testing_member
    return CancellableMediaKitVideoPlayer.adaptiveAudioTracksFor(playerId);
  }

  Future<void> selectAdaptiveAudioTrack(String trackId) {
    // ignore: invalid_use_of_visible_for_testing_member
    final id = playerId;
    return CancellableMediaKitVideoPlayer.selectAdaptiveAudioTrack(id, trackId);
  }
}

extension BrowserPictureInPictureController on VideoPlayerController {
  Stream<bool> get browserPictureInPictureEvents {
    // The backend session uses the same identifier assigned by video_player.
    // ignore: invalid_use_of_visible_for_testing_member
    return CancellableMediaKitVideoPlayer.pictureInPictureEventsFor(playerId);
  }

  Future<bool> enterBrowserPictureInPicture() {
    // ignore: invalid_use_of_visible_for_testing_member
    return CancellableMediaKitVideoPlayer.enterPictureInPicture(playerId);
  }

  Future<void> exitBrowserPictureInPicture() {
    // ignore: invalid_use_of_visible_for_testing_member
    return CancellableMediaKitVideoPlayer.exitPictureInPicture(playerId);
  }
}

class CancellableMediaKitVideoPlayer extends VideoPlayerPlatform {
  CancellableMediaKitVideoPlayer({VideoPlayerRuntimeFactory? runtimeFactory})
    : _runtimeFactory =
          runtimeFactory ??
          (platform_runtime.usesPlatformWebVideoPlayerRuntime
              ? platform_runtime.createPlatformWebVideoPlayerRuntime
              : MediaKitVideoPlayerRuntime.new);

  final VideoPlayerRuntimeFactory _runtimeFactory;
  final Map<int, _VideoPlayerSession> _sessions = {};
  int _nextTextureId = 1;

  static void registerWith() {
    VideoPlayerPlatform.instance = CancellableMediaKitVideoPlayer();
  }

  static bool get browserPictureInPictureAvailable =>
      platform_runtime.browserPictureInPictureAvailable;

  static Stream<bool> pictureInPictureEventsFor(int playerId) {
    final runtime = _runtimeFor(playerId);
    if (runtime is! PictureInPictureRuntime) {
      return Stream<bool>.value(false);
    }
    return (runtime! as PictureInPictureRuntime).pictureInPictureEvents;
  }

  static Future<bool> enterPictureInPicture(int playerId) async {
    final runtime = _runtimeFor(playerId);
    if (runtime is! PictureInPictureRuntime) return false;
    return (runtime! as PictureInPictureRuntime).enterPictureInPicture();
  }

  static Future<void> exitPictureInPicture(int playerId) async {
    final runtime = _runtimeFor(playerId);
    if (runtime is PictureInPictureRuntime) {
      await (runtime! as PictureInPictureRuntime).exitPictureInPicture();
    }
  }

  static VideoPlayerRuntime? _runtimeFor(int playerId) {
    final platform = VideoPlayerPlatform.instance;
    if (platform is! CancellableMediaKitVideoPlayer) return null;
    return platform._sessions[playerId]?.runtime;
  }

  static Stream<AdaptiveVideoTrackSnapshot> adaptiveVideoTracksFor(
    int playerId,
  ) {
    final runtime = _runtimeFor(playerId);
    if (runtime is! AdaptiveVideoTrackRuntime) {
      return const Stream<AdaptiveVideoTrackSnapshot>.empty();
    }
    return (runtime as AdaptiveVideoTrackRuntime).adaptiveVideoTracks;
  }

  static Future<void> selectAdaptiveVideoTrack(
    int playerId,
    String trackId,
  ) async {
    final runtime = _runtimeFor(playerId);
    if (runtime is AdaptiveVideoTrackRuntime) {
      await (runtime as AdaptiveVideoTrackRuntime).selectAdaptiveVideoTrack(
        trackId,
      );
    }
  }

  static Stream<AdaptiveAudioTrackSnapshot> adaptiveAudioTracksFor(
    int playerId,
  ) {
    final runtime = _runtimeFor(playerId);
    if (runtime is! AdaptiveAudioTrackRuntime) {
      return const Stream<AdaptiveAudioTrackSnapshot>.empty();
    }
    return (runtime as AdaptiveAudioTrackRuntime).adaptiveAudioTracks;
  }

  static Future<void> selectAdaptiveAudioTrack(
    int playerId,
    String trackId,
  ) async {
    final runtime = _runtimeFor(playerId);
    if (runtime is AdaptiveAudioTrackRuntime) {
      await (runtime as AdaptiveAudioTrackRuntime).selectAdaptiveAudioTrack(
        trackId,
      );
    }
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
  Future<void> setWebOptions(int playerId, VideoPlayerWebOptions options) {
    final runtime = _sessions[playerId]?.runtime;
    if (runtime == null || runtime is! WebVideoPlayerOptionsRuntime) {
      return Future.value();
    }
    return (runtime as WebVideoPlayerOptionsRuntime).setWebOptions(options);
  }

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
    final headers = Map<String, String>.of(dataSource.httpHeaders);
    String? syncTvFormatHint;
    bool syncTvIsLive = false;
    for (final key in headers.keys.toList(growable: false)) {
      if (key.toLowerCase() == syncTvVideoFormatHeader) {
        syncTvFormatHint = headers.remove(key);
      } else if (key.toLowerCase() == syncTvVideoLiveHeader) {
        syncTvIsLive = headers.remove(key) == 'true';
      }
    }
    return Media(
      resource,
      httpHeaders: headers,
      extras: {
        'formatHint': syncTvFormatHint ?? dataSource.formatHint?.name,
        if (syncTvIsLive) 'isLive': 'true',
      },
    );
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

/// The native runtime that adapts a media_kit player to the
/// video_player platform interface, with cancellation-safe sessions and
/// manifest-driven HLS variant selection. [handle] and [httpClient] exist
/// so tests can drive the event translation and variant logic without a
/// live playback pipeline.
class MediaKitVideoPlayerRuntime
    implements
        VideoPlayerRuntime,
        AdaptiveVideoTrackRuntime,
        AdaptiveAudioTrackRuntime {
  MediaKitVideoPlayerRuntime(
    int textureId, {
    MediaKitPlayerHandle? handle,
    http.Client? httpClient,
  }) : this._(handle ?? RealMediaKitPlayerHandle(), httpClient);

  MediaKitVideoPlayerRuntime._(this._handle, this._httpClient)
    : _events = StreamController<VideoEvent>() {
    _subscribe();
  }

  final MediaKitPlayerHandle _handle;
  final http.Client? _httpClient;
  final StreamController<VideoEvent> _events;
  final StreamController<AdaptiveVideoTrackSnapshot> _adaptiveTracks =
      StreamController<AdaptiveVideoTrackSnapshot>.broadcast();
  final StreamController<AdaptiveAudioTrackSnapshot> _adaptiveAudioTracks =
      StreamController<AdaptiveAudioTrackSnapshot>.broadcast();
  final List<StreamSubscription<Object?>> _subscriptions = [];
  bool _initialized = false;
  bool _disposed = false;
  Future<void>? _disposeFuture;
  int? _width;
  int? _height;
  Duration? _duration;
  static const int _maxAdaptiveManifestBytes = 4 * 1024 * 1024;
  Media? _sourceMedia;
  List<AdaptiveVideoTrackInfo> _manifestTracks = const [];
  final Map<String, Uri> _manifestTrackUris = {};
  final Map<String, int> _manifestTrackBitrates = {};
  String _selectedAdaptiveTrackId = 'auto';
  int _manifestLoadGeneration = 0;

  @override
  Stream<AdaptiveVideoTrackSnapshot> get adaptiveVideoTracks async* {
    yield _adaptiveVideoTrackSnapshot();
    yield* _adaptiveTracks.stream;
  }

  @override
  Stream<AdaptiveAudioTrackSnapshot> get adaptiveAudioTracks async* {
    yield _adaptiveAudioTrackSnapshot();
    yield* _adaptiveAudioTracks.stream;
  }

  @override
  Future<void> selectAdaptiveVideoTrack(String trackId) async {
    if (_manifestTracks.any((track) => track.id == trackId) ||
        (trackId == 'auto' && _manifestTracks.isNotEmpty)) {
      await _selectHlsVariant(trackId);
      return;
    }
    final track = trackId == 'auto'
        ? VideoTrack.auto()
        : _handle.tracks.video
              .where((track) => track.id == trackId)
              .firstOrNull;
    if (track != null) await _handle.setVideoTrack(track);
  }

  @override
  Future<void> selectAdaptiveAudioTrack(String trackId) async {
    final track = trackId == 'auto'
        ? AudioTrack.auto()
        : _handle.tracks.audio
              .where((track) => track.id == trackId)
              .firstOrNull;
    if (track != null) await _handle.setAudioTrack(track);
  }

  @override
  Stream<VideoEvent> get events => _events.stream;

  @override
  Duration get position => _handle.position;

  @override
  Future<void> open(Media media) async {
    // The view that attaches the output is only mounted once initialization
    // reports a video size, which itself needs decoding: attach first.
    _handle.attachVideoOutput();
    _sourceMedia = media;
    _manifestTracks = const [];
    _manifestTrackUris.clear();
    _manifestTrackBitrates.clear();
    _selectedAdaptiveTrackId = 'auto';
    final generation = ++_manifestLoadGeneration;
    if (_isHlsMedia(media) && _handle.isNativePlatform) {
      await _handle.setProperty('hls-bitrate', 'max');
    }
    await _handle.open(media, play: false);
    unawaited(_loadHlsVariants(media, generation));
  }

  @override
  Future<void> play() => _handle.play();

  @override
  Future<void> pause() => _handle.pause();

  @override
  Future<void> setLooping(bool looping) {
    return _handle.setPlaylistMode(
      looping ? PlaylistMode.single : PlaylistMode.none,
    );
  }

  @override
  Future<void> setVolume(double volume) => _handle.setVolume(volume * 100);

  @override
  Future<void> seekTo(Duration position) => _handle.seek(position);

  @override
  Future<void> setPlaybackSpeed(double speed) => _handle.setRate(speed);

  @override
  Widget buildView() {
    if (_disposed) throw StateError('Video player has been disposed');
    return _handle.buildVideoWidget();
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
    _manifestLoadGeneration++;
    await Future.wait(
      _subscriptions.map((subscription) => subscription.cancel()),
    );
    _subscriptions.clear();
    // A single-subscription controller nobody ever listened to never
    // completes its done future, so awaiting close() would hang teardown;
    // only the normal listened path gets the awaited close.
    if (_events.hasListener) {
      await _events.close();
    } else {
      _events.close();
    }
    await _adaptiveTracks.close();
    await _adaptiveAudioTracks.close();
    _httpClient?.close();
    try {
      await _handle.stop();
    } finally {
      await _handle.dispose();
    }
  }

  void _subscribe() {
    _subscriptions.add(
      _handle.durationStream.listen((duration) {
        if (duration > Duration.zero) {
          _duration = duration;
          _notifyInitialized();
        }
      }),
    );
    _subscriptions.add(
      _handle.videoParamsStream.listen((params) {
        if (params.dw != null && params.dh != null) {
          _width = params.dw;
          _height = params.dh;
          _notifyInitialized();
        }
      }),
    );
    _subscriptions.add(
      _handle.tracksStream.listen((tracks) {
        if (tracks.video.length == 2 && tracks.audio.length > 2) {
          _width = 0;
          _height = 0;
          _notifyInitialized();
        }
        _emitAdaptiveVideoTracks();
        _emitAdaptiveAudioTracks();
      }),
    );
    _subscriptions.add(
      _handle.trackStream.listen((_) {
        _emitAdaptiveVideoTracks();
        _emitAdaptiveAudioTracks();
      }),
    );
    _subscriptions.add(
      _handle.playingStream.listen((playing) {
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
      _handle.completedStream.listen((completed) {
        if (_canEmitPlaybackEvent && completed) {
          _events.add(VideoEvent(eventType: VideoEventType.completed));
        }
      }),
    );
    _subscriptions.add(
      _handle.bufferingStream.listen((buffering) {
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
      _handle.bufferStream.listen((buffer) {
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
      _handle.errorStream.listen((error) {
        reportOpenError(
          PlatformException(code: 'media_error', message: error),
          StackTrace.current,
        );
      }),
    );
  }

  AdaptiveVideoTrackSnapshot _adaptiveVideoTrackSnapshot() {
    if (_manifestTracks.length > 1) {
      return AdaptiveVideoTrackSnapshot(
        tracks: _manifestTracks,
        selectedTrackId: _selectedAdaptiveTrackId,
        automaticSelectionAvailable: !_handle.isNativePlatform,
      );
    }
    return AdaptiveVideoTrackSnapshot(
      tracks: _handle.tracks.video
          .where((track) => track.id != 'auto' && track.id != 'no')
          .map(
            (track) => AdaptiveVideoTrackInfo(
              id: track.id,
              title: track.title,
              width: track.w,
              height: track.h,
              fps: track.fps,
              bitrate: track.bitrate,
              codec: track.codec,
            ),
          )
          .toList(growable: false),
      selectedTrackId: _handle.selectedTracks.video.id,
    );
  }

  void _emitAdaptiveVideoTracks() {
    if (!_disposed && !_adaptiveTracks.isClosed) {
      _adaptiveTracks.add(_adaptiveVideoTrackSnapshot());
    }
  }

  AdaptiveAudioTrackSnapshot _adaptiveAudioTrackSnapshot() {
    return AdaptiveAudioTrackSnapshot(
      tracks: _handle.tracks.audio
          .where((track) => track.id != 'auto' && track.id != 'no')
          .map(
            (track) => AdaptiveAudioTrackInfo(
              id: track.id,
              title: track.title,
              language: track.language,
              bitrate: track.bitrate,
              codec: track.codec,
              channels: track.channelscount ?? track.audiochannels,
              sampleRate: track.samplerate,
            ),
          )
          .toList(growable: false),
      selectedTrackId: _handle.selectedTracks.audio.id,
    );
  }

  void _emitAdaptiveAudioTracks() {
    if (!_disposed && !_adaptiveAudioTracks.isClosed) {
      _adaptiveAudioTracks.add(_adaptiveAudioTrackSnapshot());
    }
  }

  Future<void> _loadHlsVariants(Media media, int generation) async {
    if (!_isHlsMedia(media)) return;
    try {
      final client = _httpClient ?? http.Client();
      final request = http.Request('GET', Uri.parse(media.uri));
      request.headers.addAll(media.httpHeaders ?? const {});
      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) return;
      if (response.contentLength case final length?
          when length > _maxAdaptiveManifestBytes) {
        return;
      }
      final bodyBytes = BytesBuilder(copy: false);
      await for (final chunk in response.stream) {
        if (bodyBytes.length + chunk.length > _maxAdaptiveManifestBytes) return;
        bodyBytes.add(chunk);
      }
      final variants = parseHlsMasterPlaylist(
        utf8.decode(bodyBytes.takeBytes()),
        response.request!.url,
      );
      if (_disposed || generation != _manifestLoadGeneration) return;
      final tracks = <AdaptiveVideoTrackInfo>[];
      _manifestTrackUris.clear();
      _manifestTrackBitrates.clear();
      for (final (index, variant) in variants.indexed) {
        final id = 'hls:$index:${variant.bandwidth}';
        tracks.add(
          AdaptiveVideoTrackInfo(
            id: id,
            width: variant.width,
            height: variant.height,
            fps: variant.fps,
            bitrate: variant.averageBandwidth ?? variant.bandwidth,
            codec: variant.codecs,
          ),
        );
        _manifestTrackUris[id] = variant.uri;
        _manifestTrackBitrates[id] = variant.bandwidth;
      }
      _manifestTracks = List.unmodifiable(tracks);
      if (_handle.isNativePlatform &&
          _selectedAdaptiveTrackId == 'auto' &&
          tracks.isNotEmpty) {
        final highestBitrate = tracks.last.bitrate;
        final highestBitrateTracks = tracks
            .where((track) => track.bitrate == highestBitrate)
            .length;
        _selectedAdaptiveTrackId = highestBitrateTracks == 1
            ? tracks.last.id
            : '';
      }
      _emitAdaptiveVideoTracks();
    } catch (_) {
      // Playback remains available when manifest inspection is unavailable.
    }
  }

  bool _isHlsMedia(Media media) {
    if (media.extras?['formatHint'] == 'hls') return true;
    return Uri.tryParse(media.uri)?.path.toLowerCase().endsWith('.m3u8') ==
        true;
  }

  Future<void> _selectHlsVariant(String trackId) async {
    final source = _sourceMedia;
    if (source == null) return;
    final wasPlaying = _handle.isPlaying;
    final previousPosition = position;
    if (_handle.isNativePlatform) {
      final bitrate = _manifestTrackBitrates[trackId];
      final duplicateBitrate =
          bitrate != null &&
          _manifestTrackBitrates.values
                  .where((candidate) => candidate == bitrate)
                  .length >
              1;
      final variantUri = _manifestTrackUris[trackId];
      if (duplicateBitrate && variantUri != null) {
        _selectedAdaptiveTrackId = trackId;
        await _handle.open(
          Media(variantUri.toString(), httpHeaders: source.httpHeaders),
          play: false,
        );
      } else {
        final selectedBitrate = trackId == 'auto' ? 'max' : bitrate?.toString();
        if (selectedBitrate == null) return;
        await _handle.setProperty('hls-bitrate', selectedBitrate);
        _selectedAdaptiveTrackId = trackId == 'auto'
            ? _manifestTracks.last.id
            : trackId;
        await _handle.open(source, play: false);
      }
    } else {
      final variantUri = _manifestTrackUris[trackId];
      _selectedAdaptiveTrackId = trackId;
      await _handle.open(
        trackId == 'auto' || variantUri == null
            ? source
            : Media(variantUri.toString(), httpHeaders: source.httpHeaders),
        play: false,
      );
    }
    if ((_duration ?? Duration.zero) > Duration.zero &&
        previousPosition > Duration.zero) {
      await _handle.seek(previousPosition);
    }
    if (wasPlaying) await _handle.play();
    _emitAdaptiveVideoTracks();
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
