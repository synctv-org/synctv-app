import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:web/web.dart' as web;

import 'video_player_runtime.dart';
import 'web_playback_engine.dart';

const bool usesPlatformWebVideoPlayerRuntime = true;
bool get browserPictureInPictureAvailable =>
    web.document.has('pictureInPictureEnabled') &&
    web.document.pictureInPictureEnabled &&
    web.HTMLVideoElement().has('requestPictureInPicture');
const _engineAssetBase = String.fromEnvironment(
  'SYNCTV_WEB_PLAYBACK_ENGINE_ASSET_BASE',
);

VideoPlayerRuntime createPlatformWebVideoPlayerRuntime(int textureId) =>
    WebVideoPlayerRuntime(textureId);

@visibleForTesting
void restoreMountedWebVideoStyle(web.HTMLVideoElement video) {
  video.style
    ..position = ''
    ..left = ''
    ..top = ''
    ..width = '100%'
    ..height = '100%';
}

class WebVideoPlayerRuntime
    implements
        VideoPlayerRuntime,
        AdaptiveVideoTrackRuntime,
        WebVideoPlayerOptionsRuntime,
        PictureInPictureRuntime {
  WebVideoPlayerRuntime(int textureId)
    : _viewType = 'synctv-video-player-$textureId',
      _video = web.HTMLVideoElement()
        ..id = 'synctv-video-element-$textureId'
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..style.objectFit = 'contain'
        ..autoplay = false
        ..controls = false
        ..playsInline = true {
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      restoreMountedWebVideoStyle(_video);
      return _video;
    });
    // Adaptive engines can begin fetching a manifest before Flutter mounts the
    // platform view. Keep the element in the document until HtmlElementView
    // adopts it, then clear the temporary off-screen placement above.
    _video.style
      ..position = 'fixed'
      ..left = '-10000px'
      ..top = '-10000px'
      ..width = '1px'
      ..height = '1px';
    web.document.body?.append(_video);
    _subscribeToMediaEvents();
  }

  static const _hlsBundle = _WebEngineBundle(
    path: 'playback/hls-1.7.1.min.js',
    integrity: 'sha256-bPrXAaYfuKma3V6ERJ5kZhFpsGUr9EzrKihGXIgXtfE=',
    globalName: 'Hls',
  );
  static const _dashBundle = _WebEngineBundle(
    path: 'playback/dash-5.2.1.min.js',
    integrity: 'sha256-OiKx9FdqspT0HlbxVs7Hlypfg+3aN5QWd4KT/yLS60k=',
    globalName: 'dashjs',
  );
  static const _mpegTsBundle = _WebEngineBundle(
    path: 'playback/mpegts-1.8.2.js',
    integrity: 'sha256-vaMXSHNqacthDC7fRiPmM/H09Htb2oNmjI0oflGww6g=',
    globalName: 'mpegts',
  );

  final String _viewType;
  final web.HTMLVideoElement _video;
  final StreamController<VideoEvent> _events = StreamController<VideoEvent>();
  final StreamController<AdaptiveVideoTrackSnapshot> _adaptiveTracks =
      StreamController<AdaptiveVideoTrackSnapshot>.broadcast();
  final StreamController<bool> _pictureInPictureEvents =
      StreamController<bool>.broadcast();
  final List<StreamSubscription<Object?>> _subscriptions = [];
  final List<JSFunction> _engineCallbacks = [];

  JSObject? _engine;
  WebPlaybackEngine? _engineKind;
  bool _initialized = false;
  bool _buffering = false;
  bool _disposed = false;
  int _mediaGeneration = 0;
  Timer? _initializationTimeoutTimer;
  web.EventHandler? _onContextMenu;
  web.EventHandler? _onEnterPictureInPicture;
  web.EventHandler? _onLeavePictureInPicture;
  List<AdaptiveVideoTrackInfo> _tracks = const [];
  final Map<String, String> _dashRepresentationIds = {};
  String _selectedTrackId = 'auto';
  bool _dashAutomaticSelection = true;

  @override
  Stream<VideoEvent> get events => _events.stream;

  @override
  Stream<AdaptiveVideoTrackSnapshot> get adaptiveVideoTracks async* {
    yield _adaptiveTrackSnapshot;
    yield* _adaptiveTracks.stream;
  }

  @override
  Stream<bool> get pictureInPictureEvents async* {
    yield _isPictureInPictureActive;
    yield* _pictureInPictureEvents.stream;
  }

  bool get _isPictureInPictureActive =>
      browserPictureInPictureAvailable &&
      web.document.pictureInPictureElement == _video;

  @visibleForTesting
  bool get hasActiveEngineForTesting => _engine != null;

  @override
  Duration get position => Duration(
    milliseconds: (_video.currentTime * Duration.millisecondsPerSecond).round(),
  );

  @override
  Future<void> open(Media media) async {
    if (_disposed) throw StateError('Video player has been disposed');
    if (media.httpHeaders?.isNotEmpty ?? false) {
      throw PlatformException(
        code: 'web_media_headers_unsupported',
        message:
            'The browser cannot attach custom headers to media requests. Use a provider proxy route.',
      );
    }

    final generation = ++_mediaGeneration;
    await _resetMedia();
    if (!_isCurrentMediaGeneration(generation)) return;
    final resolvedUri = _resolveMediaUri(media.uri);
    final uri = Uri.parse(resolvedUri);
    final transport = detectWebPlaybackTransport(
      formatHint: media.extras?['formatHint'] as String?,
      uri: uri,
    );
    final engine = selectWebPlaybackEngine(
      transport: transport,
      nativeHls: _video.canPlayType('application/vnd.apple.mpegurl').isNotEmpty,
    );
    _engineKind = engine;

    switch (engine) {
      case WebPlaybackEngine.progressive || WebPlaybackEngine.nativeHls:
        _openNative(resolvedUri);
      case WebPlaybackEngine.hlsJs:
        if (await _openHls(resolvedUri, generation)) {
          _scheduleInitializationTimeout();
        }
      case WebPlaybackEngine.dashJs:
        if (await _openDash(resolvedUri, generation)) {
          _scheduleInitializationTimeout();
        }
      case WebPlaybackEngine.mpegTsJs:
        if (await _openMpegTs(resolvedUri, transport, generation)) {
          _scheduleInitializationTimeout();
        }
    }
  }

  bool _isCurrentMediaGeneration(int generation) =>
      !_disposed && generation == _mediaGeneration;

  void _openNative(String uri) {
    _video.src = uri;
    _video.load();
  }

  Future<bool> _openHls(String uri, int generation) async {
    final constructor = await _WebEngineLoader.load(_hlsBundle) as JSFunction;
    if (!_isCurrentMediaGeneration(generation)) return false;
    final supported = constructor.callMethod<JSBoolean>('isSupported'.toJS);
    if (!supported.toDart) {
      throw PlatformException(
        code: 'hls_mse_unsupported',
        message: 'HLS.js cannot initialize in this browser.',
      );
    }
    final config = <String, Object?>{
      'enableWorker': true,
      'lowLatencyMode': true,
      'backBufferLength': 60,
    }.jsify();
    final hls = constructor.callAsConstructor<JSObject>(config);
    _engine = hls;

    final events = constructor.getProperty<JSObject>('Events'.toJS);
    _bindEngineError(
      hls,
      events.getProperty<JSAny>('ERROR'.toJS),
      code: 'hls_engine_error',
      fatalOnly: true,
    );
    _bindEngineEvent(
      hls,
      events.getProperty<JSAny>('MANIFEST_PARSED'.toJS),
      (_, _) => _refreshHlsTracks(),
    );
    _bindEngineEvent(hls, events.getProperty<JSAny>('LEVEL_SWITCHED'.toJS), (
      _,
      data,
    ) {
      final level = _readInt(data, 'level');
      if (level != null) {
        _selectedTrackId = hlsSelectedTrackId(
          manualLevel: _readInt(hls, 'manualLevel'),
        );
        _emitAdaptiveTracks();
      }
    });
    hls.callMethod<JSAny?>('loadSource'.toJS, uri.toJS);
    hls.callMethod<JSAny?>('attachMedia'.toJS, _video);
    return true;
  }

  Future<bool> _openDash(String uri, int generation) async {
    final dashjs = await _WebEngineLoader.load(_dashBundle);
    if (!_isCurrentMediaGeneration(generation)) return false;
    final mediaPlayerFactory = dashjs.getProperty<JSFunction>(
      'MediaPlayer'.toJS,
    );
    final mediaPlayer = mediaPlayerFactory.callAsFunction(dashjs) as JSObject;
    final player = mediaPlayer.callMethod<JSObject>('create'.toJS);
    _engine = player;

    _bindEngineError(
      player,
      'error'.toJS,
      code: 'dash_engine_error',
      singleArgument: true,
    );
    _bindEngineEvent(
      player,
      'streamInitialized'.toJS,
      (_, _) => _refreshDashTracks(),
      singleArgument: true,
    );
    _bindEngineEvent(
      player,
      'representationSwitch'.toJS,
      (_, _) => _refreshDashTracks(),
      singleArgument: true,
    );
    player.callMethod<JSAny?>('initialize'.toJS, _video, uri.toJS, false.toJS);
    return true;
  }

  Future<bool> _openMpegTs(
    String uri,
    WebPlaybackTransport transport,
    int generation,
  ) async {
    final mpegts = await _WebEngineLoader.load(_mpegTsBundle);
    if (!_isCurrentMediaGeneration(generation)) return false;
    final supported = mpegts.callMethod<JSBoolean>('isSupported'.toJS);
    if (!supported.toDart) {
      throw PlatformException(
        code: 'mpegts_mse_unsupported',
        message: 'mpegts.js cannot initialize in this browser.',
      );
    }
    final mediaDataSource = <String, Object?>{
      'type': transport == WebPlaybackTransport.flv ? 'flv' : 'mpegts',
      'url': uri,
    }.jsify();
    final config = <String, Object?>{
      'enableWorker': true,
      'lazyLoad': true,
      'autoCleanupSourceBuffer': true,
    }.jsify();
    final player = mpegts.callMethod<JSObject>(
      'createPlayer'.toJS,
      mediaDataSource,
      config,
    );
    _engine = player;

    final events = mpegts.getProperty<JSObject>('Events'.toJS);
    if (events.has('ERROR')) {
      _bindEngineError(
        player,
        events.getProperty<JSAny>('ERROR'.toJS),
        code: 'mpegts_engine_error',
      );
    }
    player.callMethod<JSAny?>('attachMediaElement'.toJS, _video);
    player.callMethod<JSAny?>('load'.toJS);
    return true;
  }

  void _bindEngineError(
    JSObject engine,
    JSAny eventName, {
    required String code,
    bool fatalOnly = false,
    bool singleArgument = false,
  }) {
    _bindEngineEvent(engine, eventName, (event, data) {
      if (fatalOnly && _readBool(data, 'fatal') != true) return;
      final details = _readString(data, 'details');
      final type = _readString(data, 'type');
      final error = _readString(data, 'error');
      final message = <String>[
        ?type,
        ?details,
        ?error,
        ?_readScalarString(event),
        ?_readScalarString(data),
      ].toSet().join(': ');
      reportOpenError(
        PlatformException(
          code: code,
          message: message.isEmpty
              ? 'The media engine reported an error.'
              : message,
        ),
        StackTrace.current,
      );
    }, singleArgument: singleArgument);
  }

  void _bindEngineEvent(
    JSObject engine,
    JSAny eventName,
    void Function(JSAny? event, JSAny? data) callback, {
    bool singleArgument = false,
  }) {
    final jsCallback = singleArgument
        ? ((JSAny? data) => callback(null, data)).toJS
        : callback.toJS;
    _engineCallbacks.add(jsCallback);
    engine.callMethod<JSAny?>('on'.toJS, eventName, jsCallback);
  }

  void _refreshHlsTracks() {
    final hls = _engine;
    if (hls == null || _engineKind != WebPlaybackEngine.hlsJs) return;
    final levels = hls.getProperty<JSArray<JSObject>>('levels'.toJS).toDart;
    _tracks = [
      for (final (index, value) in levels.indexed)
        AdaptiveVideoTrackInfo(
          id: 'hls:$index',
          title: _readString(value, 'name'),
          width: _readInt(value, 'width'),
          height: _readInt(value, 'height'),
          fps: _readDouble(value, 'frameRate'),
          bitrate: _readInt(value, 'bitrate'),
          codec: _readString(value, 'videoCodec'),
        ),
    ];
    _selectedTrackId = hlsSelectedTrackId(
      manualLevel: _readInt(hls, 'manualLevel'),
    );
    _emitAdaptiveTracks();
  }

  void _refreshDashTracks() {
    final player = _engine;
    if (player == null || _engineKind != WebPlaybackEngine.dashJs) return;
    final representations = player
        .callMethod<JSArray<JSObject>>(
          'getRepresentationsByType'.toJS,
          'video'.toJS,
        )
        .toDart;
    _dashRepresentationIds.clear();
    _tracks = [
      for (final (index, representation) in representations.indexed)
        if (_readString(representation, 'id') case final representationId?)
          AdaptiveVideoTrackInfo(
            id: _dashTrackId(index, representationId),
            title: representationId,
            width: _readInt(representation, 'width'),
            height: _readInt(representation, 'height'),
            fps: _readDouble(representation, 'frameRate'),
            bitrate: _readInt(representation, 'bandwidth'),
            codec: _readString(representation, 'codecs'),
          ),
    ];
    for (final (index, representation) in representations.indexed) {
      final representationId = _readString(representation, 'id');
      if (representationId != null) {
        _dashRepresentationIds[_dashTrackId(index, representationId)] =
            representationId;
      }
    }
    if (_dashAutomaticSelection) {
      _selectedTrackId = 'auto';
    } else {
      final current = player.callMethod<JSObject?>(
        'getCurrentRepresentationForType'.toJS,
        'video'.toJS,
      );
      final currentId = _readString(current, 'id');
      _selectedTrackId =
          _dashRepresentationIds.entries
              .where((entry) => entry.value == currentId)
              .map((entry) => entry.key)
              .firstOrNull ??
          'auto';
    }
    _emitAdaptiveTracks();
  }

  String _dashTrackId(int index, String representationId) =>
      'dash:$index:$representationId';

  @override
  Future<void> selectAdaptiveVideoTrack(String trackId) async {
    final engine = _engine;
    if (engine == null) return;
    if (_engineKind == WebPlaybackEngine.hlsJs) {
      final level = trackId == 'auto'
          ? -1
          : int.tryParse(trackId.replaceFirst('hls:', ''));
      if (level == null || level >= _tracks.length) return;
      engine.setProperty('currentLevel'.toJS, level.toJS);
      _selectedTrackId = trackId;
      _emitAdaptiveTracks();
      return;
    }
    if (_engineKind == WebPlaybackEngine.dashJs) {
      final representationId = _dashRepresentationIds[trackId];
      if (trackId != 'auto' && representationId == null) return;
      _dashAutomaticSelection = trackId == 'auto';
      engine.callMethod<JSAny?>(
        'updateSettings'.toJS,
        <String, Object?>{
          'streaming': {
            'abr': {
              'autoSwitchBitrate': {'video': _dashAutomaticSelection},
            },
          },
        }.jsify(),
      );
      if (representationId != null) {
        engine.callMethod<JSAny?>(
          'setRepresentationForTypeById'.toJS,
          'video'.toJS,
          representationId.toJS,
          true.toJS,
        );
      }
      _selectedTrackId = trackId;
      _emitAdaptiveTracks();
    }
  }

  AdaptiveVideoTrackSnapshot get _adaptiveTrackSnapshot =>
      AdaptiveVideoTrackSnapshot(
        tracks: _tracks,
        selectedTrackId: _selectedTrackId,
      );

  void _emitAdaptiveTracks() {
    if (!_disposed && !_adaptiveTracks.isClosed) {
      _adaptiveTracks.add(_adaptiveTrackSnapshot);
    }
  }

  void _subscribeToMediaEvents() {
    _onEnterPictureInPicture = ((web.Event _) {
      _emitPictureInPictureState(true);
    }).toJS;
    _onLeavePictureInPicture = ((web.Event _) {
      _emitPictureInPictureState(false);
    }).toJS;
    _video.addEventListener('enterpictureinpicture', _onEnterPictureInPicture);
    _video.addEventListener('leavepictureinpicture', _onLeavePictureInPicture);
    _subscriptions.addAll([
      _video.onLoadedMetadata.listen(_notifyInitialized),
      _video.onCanPlay.listen(_notifyInitialized),
      _video.onCanPlayThrough.listen((_) => _setBuffering(false)),
      _video.onPlaying.listen((_) => _setBuffering(false)),
      _video.onWaiting.listen((_) {
        _setBuffering(true);
        _sendBufferingRanges();
      }),
      _video.onStalled.listen((_) => _setBuffering(true)),
      _video.onPlay.listen((_) {
        _sendEvent(
          VideoEvent(
            eventType: VideoEventType.isPlayingStateUpdate,
            isPlaying: true,
          ),
        );
      }),
      _video.onPause.listen((_) {
        _sendEvent(
          VideoEvent(
            eventType: VideoEventType.isPlayingStateUpdate,
            isPlaying: false,
          ),
        );
      }),
      _video.onEnded.listen((_) {
        _setBuffering(false);
        _sendEvent(VideoEvent(eventType: VideoEventType.completed));
      }),
      _video.onError.listen((_) {
        _setBuffering(false);
        final error = _video.error;
        reportOpenError(
          PlatformException(
            code: switch (error?.code) {
              1 => 'MEDIA_ERR_ABORTED',
              2 => 'MEDIA_ERR_NETWORK',
              3 => 'MEDIA_ERR_DECODE',
              4 => 'MEDIA_ERR_SRC_NOT_SUPPORTED',
              _ => 'MEDIA_ERR_UNKNOWN',
            },
            message: error?.message.isNotEmpty == true
                ? error!.message
                : 'The browser could not play this media.',
          ),
          StackTrace.current,
        );
      }),
    ]);
  }

  void _emitPictureInPictureState(bool active) {
    if (!_disposed && !_pictureInPictureEvents.isClosed) {
      _pictureInPictureEvents.add(active);
    }
  }

  void _notifyInitialized(Object? _) {
    if (_disposed || _initialized) return;
    final duration = _video.duration.isFinite && _video.duration >= 0
        ? Duration(
            milliseconds: (_video.duration * Duration.millisecondsPerSecond)
                .round(),
          )
        : Duration.zero;
    final size = Size(
      _video.videoWidth.toDouble(),
      _video.videoHeight.toDouble(),
    );
    if (size.width <= 0 || size.height <= 0) return;
    _initializationTimeoutTimer?.cancel();
    _initializationTimeoutTimer = null;
    _initialized = true;
    _sendEvent(
      VideoEvent(
        eventType: VideoEventType.initialized,
        duration: duration,
        size: size,
      ),
    );
  }

  void _scheduleInitializationTimeout() {
    _initializationTimeoutTimer?.cancel();
    _initializationTimeoutTimer = Timer(const Duration(seconds: 15), () {
      if (_initialized || _disposed) return;
      reportOpenError(
        PlatformException(
          code: 'web_media_initialization_timeout',
          message: 'The browser did not receive playable video metadata.',
        ),
        StackTrace.current,
      );
    });
  }

  void _setBuffering(bool buffering) {
    if (_buffering == buffering) return;
    _buffering = buffering;
    _sendEvent(
      VideoEvent(
        eventType: buffering
            ? VideoEventType.bufferingStart
            : VideoEventType.bufferingEnd,
      ),
    );
  }

  void _sendBufferingRanges() {
    if (_disposed) return;
    final ranges = <DurationRange>[];
    for (var index = 0; index < _video.buffered.length; index++) {
      ranges.add(
        DurationRange(
          Duration(
            milliseconds:
                (_video.buffered.start(index) * Duration.millisecondsPerSecond)
                    .round(),
          ),
          Duration(
            milliseconds:
                (_video.buffered.end(index) * Duration.millisecondsPerSecond)
                    .round(),
          ),
        ),
      );
    }
    _sendEvent(
      VideoEvent(eventType: VideoEventType.bufferingUpdate, buffered: ranges),
    );
  }

  void _sendEvent(VideoEvent event) {
    if (!_disposed && !_events.isClosed) _events.add(event);
  }

  @override
  Future<void> play() async {
    try {
      await _video.play().toDart;
    } catch (error) {
      if (error is JSObject && error.isA<web.DOMException>()) {
        final exception = error as web.DOMException;
        throw PlatformException(
          code: exception.name,
          message: exception.message,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> pause() async => _video.pause();

  @override
  Future<void> setLooping(bool looping) async => _video.loop = looping;

  @override
  Future<void> setVolume(double volume) async {
    _video.muted = volume == 0;
    if (volume > 0) _video.volume = volume.clamp(0, 1);
  }

  @override
  Future<void> seekTo(Duration position) async {
    final seconds = position.inMilliseconds / Duration.millisecondsPerSecond;
    if ((_video.currentTime - seconds).abs() > 0.001) {
      _video.currentTime = seconds;
    }
  }

  @override
  Future<void> setPlaybackSpeed(double speed) async {
    _video.playbackRate = speed;
  }

  @override
  Future<void> setWebOptions(VideoPlayerWebOptions options) async {
    _resetWebOptions();
    if (options.controls.enabled) {
      _video.controls = true;
      if (options.controls.controlsList.isNotEmpty) {
        _video.setAttribute('controlsList', options.controls.controlsList);
      }
      if (!options.controls.allowPictureInPicture) {
        _video.disablePictureInPicture = true;
      }
    }
    if (!options.allowContextMenu) {
      _onContextMenu = ((web.Event event) => event.preventDefault()).toJS;
      _video.addEventListener('contextmenu', _onContextMenu);
    }
    if (!options.allowRemotePlayback) _video.disableRemotePlayback = true;
    if (options.poster != null) _video.poster = options.poster.toString();
  }

  @override
  Future<bool> enterPictureInPicture() async {
    if (_disposed ||
        !browserPictureInPictureAvailable ||
        _video.disablePictureInPicture ||
        _video.readyState == 0) {
      return false;
    }
    try {
      if (!_isPictureInPictureActive) {
        await _video.requestPictureInPicture().toDart;
      }
      _emitPictureInPictureState(true);
      return true;
    } on Object {
      return false;
    }
  }

  @override
  Future<void> exitPictureInPicture() async {
    if (_disposed || !_isPictureInPictureActive) return;
    try {
      await web.document.exitPictureInPicture().toDart;
    } on Object {
      return;
    } finally {
      _emitPictureInPictureState(false);
    }
  }

  void _resetWebOptions() {
    _video.controls = false;
    _video.removeAttribute('controlsList');
    _video.removeAttribute('disablePictureInPicture');
    if (_onContextMenu != null) {
      _video.removeEventListener('contextmenu', _onContextMenu);
      _onContextMenu = null;
    }
    _video.removeAttribute('disableRemotePlayback');
    _video.removeAttribute('poster');
  }

  @override
  Widget buildView() {
    if (_disposed) throw StateError('Video player has been disposed');
    return HtmlElementView(viewType: _viewType);
  }

  @override
  void reportOpenError(Object error, StackTrace stackTrace) {
    if (_disposed || _events.isClosed) return;
    _initializationTimeoutTimer?.cancel();
    _initializationTimeoutTimer = null;
    _events.addError(
      error is PlatformException
          ? error
          : PlatformException(code: 'media_error', message: error.toString()),
      stackTrace,
    );
  }

  Future<void> _resetMedia() async {
    _initialized = false;
    _initializationTimeoutTimer?.cancel();
    _initializationTimeoutTimer = null;
    _buffering = false;
    _tracks = const [];
    _dashRepresentationIds.clear();
    _selectedTrackId = 'auto';
    _dashAutomaticSelection = true;
    _emitAdaptiveTracks();
    final engine = _engine;
    final engineKind = _engineKind;
    _engine = null;
    _engineKind = null;
    _engineCallbacks.clear();
    if (engine != null) {
      switch (engineKind) {
        case WebPlaybackEngine.dashJs:
          engine.callMethod<JSAny?>('reset'.toJS);
        case WebPlaybackEngine.mpegTsJs:
          if (engine.has('unload')) {
            engine.callMethod<JSAny?>('unload'.toJS);
          }
          if (engine.has('detachMediaElement')) {
            engine.callMethod<JSAny?>('detachMediaElement'.toJS);
          }
          engine.callMethod<JSAny?>('destroy'.toJS);
        case WebPlaybackEngine.hlsJs:
          engine.callMethod<JSAny?>('destroy'.toJS);
        case WebPlaybackEngine.progressive ||
            WebPlaybackEngine.nativeHls ||
            null:
          break;
      }
    }
    _video.pause();
    _video.removeAttribute('src');
    _video.load();
  }

  String _resolveMediaUri(String resource) {
    final uri = Uri.parse(resource);
    if (uri.scheme == 'asset') {
      final assetPath = uri.path.startsWith('/')
          ? uri.path.substring(1)
          : uri.path;
      return ui_web.assetManager.getAssetUrl(assetPath);
    }
    if (uri.scheme == 'file' || uri.scheme == 'content') {
      throw PlatformException(
        code: 'web_local_media_unsupported',
        message: 'Local file and content URIs are unavailable in the browser.',
      );
    }
    return resource;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    final shouldExitPictureInPicture = _isPictureInPictureActive;
    _disposed = true;
    _mediaGeneration++;
    if (shouldExitPictureInPicture) {
      try {
        await web.document.exitPictureInPicture().toDart;
      } on Object {
        // Continue releasing the player when the browser rejects PiP exit.
      }
    }
    await _resetMedia();
    _resetWebOptions();
    if (_onEnterPictureInPicture != null) {
      _video.removeEventListener(
        'enterpictureinpicture',
        _onEnterPictureInPicture,
      );
      _onEnterPictureInPicture = null;
    }
    if (_onLeavePictureInPicture != null) {
      _video.removeEventListener(
        'leavepictureinpicture',
        _onLeavePictureInPicture,
      );
      _onLeavePictureInPicture = null;
    }
    await Future.wait(
      _subscriptions.map((subscription) => subscription.cancel()),
    );
    _subscriptions.clear();
    _video.remove();
    await _pictureInPictureEvents.close();
    await _adaptiveTracks.close();
    await _events.close();
  }
}

class _WebEngineBundle {
  const _WebEngineBundle({
    required this.path,
    required this.integrity,
    required this.globalName,
  });

  final String path;
  final String integrity;
  final String globalName;
}

class _WebEngineLoader {
  const _WebEngineLoader._();

  static final Map<String, Future<JSObject>> _loads = {};

  static Future<JSObject> load(_WebEngineBundle bundle) {
    final existing = globalContext.getProperty<JSObject?>(
      bundle.globalName.toJS,
    );
    if (existing != null) return Future.value(existing);
    return _loads.putIfAbsent(bundle.globalName, () async {
      try {
        return await _load(bundle);
      } on Object {
        _loads.remove(bundle.globalName);
        rethrow;
      }
    });
  }

  static Future<JSObject> _load(_WebEngineBundle bundle) async {
    final baseUri = _engineAssetBase.isEmpty
        ? Uri.parse(web.document.baseURI)
        : Uri.parse(
            _engineAssetBase.endsWith('/')
                ? _engineAssetBase
                : '$_engineAssetBase/',
          );
    final script = web.HTMLScriptElement()
      ..src = baseUri.resolve(bundle.path).toString()
      ..async = true
      ..integrity = bundle.integrity
      ..crossOrigin = 'anonymous'
      ..dataset['synctvPlaybackEngine'] = bundle.globalName;
    final completer = Completer<void>();
    late final StreamSubscription<Object?> loadSubscription;
    late final StreamSubscription<Object?> errorSubscription;
    loadSubscription = script.onLoad.listen((_) {
      if (!completer.isCompleted) completer.complete();
      unawaited(errorSubscription.cancel());
    });
    errorSubscription = script.onError.listen((_) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Unable to load ${bundle.globalName} from ${bundle.path}'),
        );
      }
      unawaited(loadSubscription.cancel());
    });
    web.document.head?.append(script);
    try {
      await completer.future;
    } finally {
      await loadSubscription.cancel();
      await errorSubscription.cancel();
      script.remove();
    }
    final global = globalContext.getProperty<JSObject?>(bundle.globalName.toJS);
    if (global == null) {
      throw StateError('${bundle.globalName} did not register its global API');
    }
    return global;
  }
}

int? _readInt(JSAny? value, String property) {
  final object = _asObject(value);
  final propertyValue = object?.getProperty<JSAny?>(property.toJS)?.dartify();
  return propertyValue is num ? propertyValue.round() : null;
}

double? _readDouble(JSAny? value, String property) {
  final object = _asObject(value);
  final propertyValue = object?.getProperty<JSAny?>(property.toJS)?.dartify();
  return propertyValue is num ? propertyValue.toDouble() : null;
}

String? _readString(JSAny? value, String property) {
  final object = _asObject(value);
  final propertyValue = object?.getProperty<JSAny?>(property.toJS)?.dartify();
  return propertyValue is String && propertyValue.isNotEmpty
      ? propertyValue
      : null;
}

bool? _readBool(JSAny? value, String property) {
  final object = _asObject(value);
  final propertyValue = object?.getProperty<JSAny?>(property.toJS)?.dartify();
  return propertyValue is bool ? propertyValue : null;
}

JSObject? _asObject(JSAny? value) =>
    value?.isA<JSObject>() == true ? value as JSObject : null;

String? _readScalarString(JSAny? value) {
  final dartValue = value?.dartify();
  return dartValue is String && dartValue.isNotEmpty ? dartValue : null;
}
