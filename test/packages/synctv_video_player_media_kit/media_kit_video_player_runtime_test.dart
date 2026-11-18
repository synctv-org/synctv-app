@TestOn('vm')
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:media_kit/media_kit.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart'
    hide VideoTrack;

/// Scriptable stand-in for the media_kit player: every stream is a
/// broadcast controller the test fires, and every command is recorded.
class _FakeHandle implements MediaKitPlayerHandle {
  final durationController = StreamController<Duration>.broadcast();
  final videoParamsController = StreamController<VideoParams>.broadcast();
  final tracksController = StreamController<Tracks>.broadcast();
  final trackController = StreamController<Track>.broadcast();
  final playingController = StreamController<bool>.broadcast();
  final completedController = StreamController<bool>.broadcast();
  final bufferingController = StreamController<bool>.broadcast();
  final bufferController = StreamController<Duration>.broadcast();
  final errorController = StreamController<String>.broadcast();

  @override
  Tracks tracks = const Tracks();
  @override
  Track selectedTracks = const Track();
  @override
  bool isPlaying = false;
  @override
  Duration position = Duration.zero;
  @override
  bool isNativePlatform = true;

  final opens = <({Media media, bool play})>[];
  final properties = <(String, String)>[];
  double? lastVolume;
  double? lastRate;
  Duration? lastSeek;
  PlaylistMode? playlistMode;
  VideoTrack? videoTrack;
  AudioTrack? audioTrack;
  int stopCalls = 0;
  int disposeCalls = 0;

  @override
  Stream<Duration> get durationStream => durationController.stream;
  @override
  Stream<VideoParams> get videoParamsStream => videoParamsController.stream;
  @override
  Stream<Tracks> get tracksStream => tracksController.stream;
  @override
  Stream<Track> get trackStream => trackController.stream;
  @override
  Stream<bool> get playingStream => playingController.stream;
  @override
  Stream<bool> get completedStream => completedController.stream;
  @override
  Stream<bool> get bufferingStream => bufferingController.stream;
  @override
  Stream<Duration> get bufferStream => bufferController.stream;
  @override
  Stream<String> get errorStream => errorController.stream;

  @override
  Future<void> setProperty(String name, String value) async {
    properties.add((name, value));
  }

  @override
  Future<void> open(Media media, {bool play = false}) async {
    opens.add((media: media, play: play));
  }

  @override
  Future<void> play() async => isPlaying = true;

  @override
  Future<void> pause() async => isPlaying = false;

  @override
  Future<void> stop() async => stopCalls++;

  @override
  Future<void> setVolume(double volume) async => lastVolume = volume;

  @override
  Future<void> setRate(double rate) async => lastRate = rate;

  @override
  Future<void> seek(Duration position) async => lastSeek = position;

  @override
  Future<void> setPlaylistMode(PlaylistMode mode) async => playlistMode = mode;

  @override
  Future<void> setVideoTrack(VideoTrack track) async => videoTrack = track;

  @override
  Future<void> setAudioTrack(AudioTrack track) async => audioTrack = track;

  @override
  Future<void> dispose() async => disposeCalls++;

  @override
  Widget buildVideoWidget() => throw UnimplementedError();

  Future<void> close() async {
    await Future.wait([
      durationController.close(),
      videoParamsController.close(),
      tracksController.close(),
      trackController.close(),
      playingController.close(),
      completedController.close(),
      bufferingController.close(),
      bufferController.close(),
      errorController.close(),
    ]);
  }
}

http.StreamedResponse _manifestResponse(
  String body, {
  int status = 200,
  int? contentLength,
  Uri? url,
}) {
  final bytes = Uint8List.fromList(body.codeUnits);
  return http.StreamedResponse(
    Stream.value(bytes),
    status,
    contentLength: contentLength ?? bytes.length,
    request: http.Request(
      'GET',
      url ?? Uri.parse('https://media.test/master.m3u8'),
    ),
  );
}

const _masterManifest = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=900000,RESOLUTION=640x360
low.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=3200000,RESOLUTION=1280x720
high.m3u8
''';

void main() {
  late _FakeHandle handle;
  late MediaKitVideoPlayerRuntime runtime;

  setUp(() {
    handle = _FakeHandle();
    runtime = MediaKitVideoPlayerRuntime(1, handle: handle);
  });

  tearDown(() async {
    await runtime.dispose();
    await handle.close();
  });

  test('initialization waits for size and duration together', () async {
    final received = <VideoEvent>[];
    final subscription = runtime.events.listen(received.add);

    handle.durationController.add(const Duration(minutes: 2));
    await pumpEventQueue();
    expect(received, isEmpty, reason: 'duration alone is not enough');

    handle.videoParamsController.add(const VideoParams(dw: 1920, dh: 1080));
    await pumpEventQueue();
    expect(received, hasLength(1));
    expect(received.single.eventType, VideoEventType.initialized);
    expect(received.single.size, const Size(1920, 1080));
    expect(received.single.duration, const Duration(minutes: 2));

    handle.durationController.add(const Duration(seconds: 30));
    await pumpEventQueue();
    expect(received, hasLength(1), reason: 'initialized fires exactly once');

    await subscription.cancel();
  });

  test('an audio-only track layout initializes with a zero size', () async {
    final received = <VideoEvent>[];
    final subscription = runtime.events.listen(received.add);
    addTearDown(subscription.cancel);

    handle.durationController.add(const Duration(minutes: 1));
    handle.tracksController.add(
      Tracks(
        video: [VideoTrack.auto(), VideoTrack.no()],
        audio: [
          AudioTrack.auto(),
          AudioTrack.no(),
          const AudioTrack('1', 'English', null),
        ],
      ),
    );
    await pumpEventQueue();

    final initialized = received
        .where((event) => event.eventType == VideoEventType.initialized)
        .single;
    expect(initialized.size, Size.zero);
  });

  test('playback events are gated until the player initializes', () async {
    final received = <VideoEvent>[];
    final subscription = runtime.events.listen(received.add);
    addTearDown(subscription.cancel);

    handle.playingController.add(true);
    handle.completedController.add(true);
    handle.bufferingController.add(true);
    handle.bufferController.add(const Duration(seconds: 5));
    await pumpEventQueue();
    expect(received, isEmpty, reason: 'no events before initialization');

    handle.durationController.add(const Duration(minutes: 1));
    handle.videoParamsController.add(const VideoParams(dw: 640, dh: 360));
    await pumpEventQueue();
    expect(
      received.map((event) => event.eventType),
      contains(VideoEventType.initialized),
    );

    handle.playingController.add(true);
    await pumpEventQueue();
    expect(received.last.eventType, VideoEventType.isPlayingStateUpdate);

    handle.completedController.add(false);
    await pumpEventQueue();
    expect(
      received
          .where((event) => event.eventType == VideoEventType.completed)
          .length,
      0,
      reason: 'completed=false is not reported',
    );

    handle.completedController.add(true);
    await pumpEventQueue();
    expect(
      received.map((event) => event.eventType),
      contains(VideoEventType.completed),
    );

    handle.bufferingController.add(true);
    await pumpEventQueue();
    expect(
      received.map((event) => event.eventType),
      contains(VideoEventType.bufferingStart),
    );

    handle.bufferController.add(const Duration(seconds: 5));
    await pumpEventQueue();
    expect(
      received.map((event) => event.eventType),
      contains(VideoEventType.bufferingUpdate),
    );
  });

  test('player errors surface as media_error platform exceptions', () async {
    final errors = <Object>[];
    final subscription = runtime.events.listen((_) {}, onError: errors.add);
    addTearDown(subscription.cancel);

    handle.errorController.add('boom');
    await pumpEventQueue();

    expect(errors, hasLength(1));
    expect(errors.single, isA<PlatformException>());
    expect((errors.single as PlatformException).code, 'media_error');
  });

  test('commands map to the media_kit scales', () async {
    await runtime.setVolume(0.5);
    expect(handle.lastVolume, 50, reason: 'media_kit volume is 0-100');

    await runtime.setPlaybackSpeed(1.5);
    expect(handle.lastRate, 1.5);

    await runtime.seekTo(const Duration(seconds: 42));
    expect(handle.lastSeek, const Duration(seconds: 42));

    await runtime.setLooping(true);
    expect(handle.playlistMode, PlaylistMode.single);
    await runtime.setLooping(false);
    expect(handle.playlistMode, PlaylistMode.none);

    expect(runtime.position, Duration.zero);
  });

  test('player tracks feed the adaptive snapshots', () async {
    handle.tracks = Tracks(
      video: [
        VideoTrack.auto(),
        VideoTrack.no(),
        const VideoTrack('1', null, null, w: 1280, h: 720, bitrate: 2000000),
      ],
      audio: [
        AudioTrack.auto(),
        AudioTrack.no(),
        const AudioTrack('a1', 'English', 'eng', channelscount: 2),
      ],
    );
    handle.selectedTracks = const Track(
      video: VideoTrack('1', null, null),
      audio: AudioTrack('a1', 'English', 'eng'),
    );

    final video = await runtime.adaptiveVideoTracks.first;
    expect(video.tracks.map((track) => track.id), ['1']);
    expect(video.selectedTrackId, '1');
    expect(video.tracks.single.width, 1280);

    final audio = await runtime.adaptiveAudioTracks.first;
    expect(audio.tracks.map((track) => track.id), ['a1']);
    expect(audio.tracks.single.channels, 2);

    await runtime.selectAdaptiveVideoTrack('1');
    expect(handle.videoTrack?.id, '1');
    await runtime.selectAdaptiveAudioTrack('auto');
    expect(handle.audioTrack, AudioTrack.auto());
  });

  test(
    'opening an HLS source pins mpv to max bitrate and loads variants',
    () async {
      var manifestRequests = 0;
      final client = MockClient.streaming((request, bodyStream) async {
        manifestRequests++;
        return _manifestResponse(_masterManifest);
      });
      final hlsRuntime = MediaKitVideoPlayerRuntime(
        2,
        handle: handle,
        httpClient: client,
      );
      addTearDown(hlsRuntime.dispose);

      await hlsRuntime.open(
        Media(
          'https://media.test/master.m3u8',
          httpHeaders: {'Range': 'bytes=0-'},
        ),
      );

      expect(
        handle.properties,
        contains(('hls-bitrate', 'max')),
        reason: 'the native pipeline starts at the highest variant',
      );
      expect(handle.opens, hasLength(1));

      final snapshot = await _nextTrackSnapshot(hlsRuntime);
      expect(manifestRequests, 1);
      expect(snapshot.tracks.map((track) => track.id).toList(), [
        'hls:0:900000',
        'hls:1:3200000',
      ]);
      expect(snapshot.selectedTrackId, 'hls:1:3200000');
      expect(
        snapshot.automaticSelectionAvailable,
        isFalse,
        reason: 'the native player cannot switch variants on its own',
      );
    },
  );

  test('non-HLS sources skip the manifest fetch and property', () async {
    var manifestRequests = 0;
    final client = MockClient.streaming((request, bodyStream) async {
      manifestRequests++;
      return _manifestResponse(_masterManifest);
    });
    final runtime2 = MediaKitVideoPlayerRuntime(
      3,
      handle: handle,
      httpClient: client,
    );
    addTearDown(runtime2.dispose);

    await runtime2.open(Media('https://media.test/movie.mp4'));
    await pumpEventQueue();

    expect(manifestRequests, 0);
    expect(handle.properties, isEmpty);
  });

  test('manifest problems leave playback untouched', () async {
    final client = MockClient.streaming(
      (request, bodyStream) async => throw StateError('network down'),
    );
    final runtime2 = MediaKitVideoPlayerRuntime(
      4,
      handle: handle,
      httpClient: client,
    );
    addTearDown(runtime2.dispose);

    await runtime2.open(Media('https://media.test/master.m3u8'));
    final snapshot = await _nextTrackSnapshot(runtime2, waitForTracks: false);
    expect(snapshot.tracks, isEmpty);

    // A non-2xx response is equally ignored.
    final statusRuntime = MediaKitVideoPlayerRuntime(
      5,
      handle: handle,
      httpClient: MockClient.streaming(
        (request, bodyStream) async => _manifestResponse('nope', status: 503),
      ),
    );
    addTearDown(statusRuntime.dispose);
    await statusRuntime.open(Media('https://media.test/master.m3u8'));
    final statusSnapshot = await _nextTrackSnapshot(
      statusRuntime,
      waitForTracks: false,
    );
    expect(statusSnapshot.tracks, isEmpty);
  });

  test(
    'oversized manifests are rejected by content length and stream',
    () async {
      final byContentLength = MediaKitVideoPlayerRuntime(
        6,
        handle: handle,
        httpClient: MockClient.streaming(
          (request, bodyStream) async =>
              _manifestResponse('x', contentLength: 5 * 1024 * 1024),
        ),
      );
      addTearDown(byContentLength.dispose);
      await byContentLength.open(Media('https://media.test/master.m3u8'));
      expect(
        (await _nextTrackSnapshot(
          byContentLength,
          waitForTracks: false,
        )).tracks,
        isEmpty,
      );

      // No content length: the streamed byte total still trips the cap.
      final hugeBody = '#EXTM3U\n${'#' * (5 * 1024 * 1024)}';
      final byStream = MediaKitVideoPlayerRuntime(
        7,
        handle: handle,
        httpClient: MockClient.streaming(
          (request, bodyStream) async => http.StreamedResponse(
            Stream.value(Uint8List.fromList(hugeBody.codeUnits)),
            200,
            request: http.Request(
              'GET',
              Uri.parse('https://media.test/master.m3u8'),
            ),
          ),
        ),
      );
      addTearDown(byStream.dispose);
      await byStream.open(Media('https://media.test/master.m3u8'));
      expect(
        (await _nextTrackSnapshot(byStream, waitForTracks: false)).tracks,
        isEmpty,
      );
    },
  );

  test('a newer open supersedes an in-flight manifest load', () async {
    final responder = Completer<http.StreamedResponse>();
    final client = MockClient.streaming(
      (request, bodyStream) => responder.future,
    );
    final runtime2 = MediaKitVideoPlayerRuntime(
      8,
      handle: handle,
      httpClient: client,
    );
    addTearDown(runtime2.dispose);

    await runtime2.open(Media('https://media.test/one.m3u8'));
    await runtime2.open(Media('https://media.test/two.mp4'));

    responder.complete(_manifestResponse(_masterManifest));
    final snapshot = await _nextTrackSnapshot(runtime2, waitForTracks: false);
    expect(
      snapshot.tracks,
      isEmpty,
      reason: 'the stale manifest must not populate the newer source',
    );
  });

  test(
    'duplicate top bitrates leave automatic selection to the user',
    () async {
      const duplicateManifest = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,CODECS="avc1.64001f"
avc.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1920x1080,CODECS="hvc1.1.6.L120"
hevc.m3u8
''';
      final runtime2 = MediaKitVideoPlayerRuntime(
        9,
        handle: handle,
        httpClient: MockClient.streaming(
          (request, bodyStream) async => _manifestResponse(duplicateManifest),
        ),
      );
      addTearDown(runtime2.dispose);
      await runtime2.open(Media('https://media.test/master.m3u8'));

      final snapshot = await _nextTrackSnapshot(runtime2);
      expect(snapshot.selectedTrackId, isEmpty);
    },
  );

  test(
    'selecting a unique variant sets the bitrate property and reopens',
    () async {
      final runtime2 = MediaKitVideoPlayerRuntime(
        10,
        handle: handle,
        httpClient: MockClient.streaming(
          (request, bodyStream) async => _manifestResponse(_masterManifest),
        ),
      );
      addTearDown(runtime2.dispose);
      await runtime2.open(
        Media(
          'https://media.test/master.m3u8',
          httpHeaders: {'Referer': 'https://media.test/'},
        ),
      );
      await _nextTrackSnapshot(runtime2);
      final initialOpens = handle.opens.length;

      handle.position = const Duration(seconds: 33);
      handle.isPlaying = true;
      handle.durationController.add(const Duration(minutes: 5));
      await pumpEventQueue();

      await runtime2.selectAdaptiveVideoTrack('hls:0:900000');

      expect(handle.properties, contains(('hls-bitrate', '900000')));
      expect(handle.opens, hasLength(initialOpens + 1));
      expect(handle.opens.last.media.uri, 'https://media.test/master.m3u8');
      expect(handle.lastSeek, const Duration(seconds: 33));
      expect(handle.isPlaying, isTrue, reason: 'playing state is restored');
    },
  );

  test(
    'selecting a duplicate-bitrate variant reopens the variant URI',
    () async {
      const duplicateManifest = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,CODECS="avc1.64001f"
avc.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1920x1080,CODECS="hvc1.1.6.L120"
hevc.m3u8
''';
      final runtime2 = MediaKitVideoPlayerRuntime(
        11,
        handle: handle,
        httpClient: MockClient.streaming(
          (request, bodyStream) async => _manifestResponse(duplicateManifest),
        ),
      );
      addTearDown(runtime2.dispose);
      await runtime2.open(Media('https://media.test/master.m3u8'));
      await _nextTrackSnapshot(runtime2);

      await runtime2.selectAdaptiveVideoTrack('hls:1:2000000');

      expect(handle.properties.where((p) => p.$1 == 'hls-bitrate'), isNotEmpty);
      expect(
        handle.opens.last.media.uri,
        'https://media.test/hevc.m3u8',
        reason: 'identical bitrates need the concrete playlist',
      );
    },
  );

  test('non-native platforms reopen the variant URI directly', () async {
    handle.isNativePlatform = false;
    final runtime2 = MediaKitVideoPlayerRuntime(
      12,
      handle: handle,
      httpClient: MockClient.streaming(
        (request, bodyStream) async => _manifestResponse(_masterManifest),
      ),
    );
    addTearDown(runtime2.dispose);
    await runtime2.open(Media('https://media.test/master.m3u8'));
    final snapshot = await _nextTrackSnapshot(runtime2);
    expect(snapshot.automaticSelectionAvailable, isTrue);

    await runtime2.selectAdaptiveVideoTrack('hls:0:900000');
    expect(handle.opens.last.media.uri, 'https://media.test/low.m3u8');
    expect(handle.properties, isEmpty);
  });

  test('dispose stops and releases the player exactly once', () async {
    final errors = <Object>[];
    final subscription = runtime.events.listen((_) {}, onError: errors.add);
    addTearDown(subscription.cancel);

    handle.durationController.add(const Duration(minutes: 1));
    handle.videoParamsController.add(const VideoParams(dw: 640, dh: 360));
    await pumpEventQueue();

    await runtime.dispose();
    await runtime.dispose();

    expect(handle.stopCalls, 1);
    expect(handle.disposeCalls, 1);

    handle.errorController.add('late failure');
    handle.playingController.add(true);
    await pumpEventQueue();
    expect(errors, isEmpty, reason: 'a disposed runtime reports nothing');

    expect(
      () => runtime.buildView(),
      throwsStateError,
      reason: 'the view cannot outlive the runtime',
    );
  });
}

/// First adaptive snapshot after subscribing. Manifest loads resolve
/// asynchronously, so by default the sync seed snapshot (always empty) is
/// skipped and the wait is for the first populated one.
Future<AdaptiveVideoTrackSnapshot> _nextTrackSnapshot(
  MediaKitVideoPlayerRuntime runtime, {
  bool waitForTracks = true,
}) async {
  final completer = Completer<AdaptiveVideoTrackSnapshot>();
  late StreamSubscription<AdaptiveVideoTrackSnapshot> subscription;
  subscription = runtime.adaptiveVideoTracks.listen((snapshot) {
    if (completer.isCompleted) return;
    if (waitForTracks && snapshot.tracks.isEmpty) return;
    completer.complete(snapshot);
    unawaited(subscription.cancel());
  });
  final snapshot = await completer.future.timeout(const Duration(seconds: 5));
  // Give any stale manifest completions a chance to surface.
  await pumpEventQueue();
  return snapshot;
}
