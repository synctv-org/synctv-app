@TestOn('browser')
library;

import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:synctv_video_player_media_kit/src/web_video_player_runtime.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:web/web.dart' as web;

/// 0.3 s of 8 kHz mono silence: small enough to inline, real enough for the
/// browser to fire loadedmetadata and expose a duration.
const _silenceUri =
    'data:audio/wav;base64,UklGRoQJAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YWAJAACAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA=';

/// Records everything the runtime's single-subscription event stream emits
/// (data and errors) so tests can wait on specific outcomes.
class _EventLog {
  _EventLog(WebVideoPlayerRuntime runtime) {
    subscription = runtime.events.listen(
      events.add,
      onError: errors.add,
      onDone: done.complete,
    );
  }

  final events = <VideoEvent>[];
  final errors = <Object>[];
  final done = Completer<void>();
  late final StreamSubscription<VideoEvent> subscription;

  Future<void> close() async {
    await subscription.cancel();
    if (!done.isCompleted) done.complete();
  }
}

_EventLog _observe(WebVideoPlayerRuntime runtime) {
  final log = _EventLog(runtime);
  addTearDown(log.close);
  return log;
}

/// Builds a runtime the way production does: with an events listener
/// attached for its whole lifetime, and hands back that listener's log.
(WebVideoPlayerRuntime, _EventLog) _runtime(int textureId) {
  final runtime = WebVideoPlayerRuntime(textureId);
  final log = _observe(runtime);
  addTearDown(runtime.dispose);
  return (runtime, log);
}

void main() {
  test(
    'seekTo preserves millisecond precision in the HTML video element',
    () async {
      final (runtime, _) = _runtime(73250);

      await runtime.seekTo(const Duration(milliseconds: 73250));

      expect(runtime.position, const Duration(milliseconds: 73250));
    },
  );

  test('restores the video size when Flutter mounts the platform view', () {
    final video = web.HTMLVideoElement();
    video.style
      ..position = 'fixed'
      ..left = '-10000px'
      ..top = '-10000px'
      ..width = '1px'
      ..height = '1px';

    restoreMountedWebVideoStyle(video);

    expect(video.style.position, isEmpty);
    expect(video.style.left, isEmpty);
    expect(video.style.top, isEmpty);
    expect(video.style.width, '100%');
    expect(video.style.height, '100%');
  });

  test('a native source initializes and reports its duration', () async {
    final (runtime, log) = _runtime(8011);

    await runtime.open(Media(_silenceUri));

    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (!log.events.any(
          (event) => event.eventType == VideoEventType.initialized,
        ) &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    expect(
      log.events.map((event) => event.eventType),
      contains(VideoEventType.initialized),
    );
    final video = web.document.querySelector(
      '#synctv-video-element-8011',
    ) as web.HTMLVideoElement?;
    expect(video!.duration, greaterThan(0));
  });

  test(
    'opening an m3u8 hands the stream to a player without hanging',
    () async {
      final (runtime, log) = _runtime(8012);

      // Browsers split on native HLS support: the engine attaches through
      // hls.js, or the manifest goes straight onto the element for native
      // playback. Either way the URL must reach a player; silently doing
      // nothing (or hanging) is the failure this guards against.
      await runtime.open(Media('https://localhost.invalid/live/stream.m3u8'));
      final video = web.document.querySelector(
        '#synctv-video-element-8012',
      ) as web.HTMLVideoElement?;
      final handedToPlayer =
          runtime.hasActiveEngineForTesting ||
          video!.getAttribute('src') ==
              'https://localhost.invalid/live/stream.m3u8';
      expect(handedToPlayer, isTrue);
      expect(log.errors, isEmpty, reason: 'selection itself must not error');
    },
  );

  test('volume maps to the element: zero mutes, values clamp to 1.0', () async {
    final (runtime, _) = _runtime(8013);
    final video = web.document.querySelector(
      '#synctv-video-element-8013',
    ) as web.HTMLVideoElement?;

    await runtime.setVolume(0);
    expect(video!.muted, isTrue);

    await runtime.setVolume(0.5);
    expect(video.muted, isFalse);
    expect(video.volume, 0.5);

    await runtime.setVolume(2);
    expect(video.volume, 1.0);
  });

  test('playback speed and looping apply to the element', () async {
    final (runtime, _) = _runtime(8014);
    final video = web.document.querySelector(
      '#synctv-video-element-8014',
    ) as web.HTMLVideoElement?;

    await runtime.setPlaybackSpeed(1.5);
    expect(video!.playbackRate, 1.5);

    await runtime.setLooping(true);
    expect(video.loop, isTrue);
  });

  test(
    'dispose removes the element from the DOM and stays idempotent',
    () async {
      final (runtime, _) = _runtime(8015);

      expect(
        web.document.querySelector('#synctv-video-element-8015'),
        isNotNull,
        reason: 'the runtime keeps its element in the document pre-mount',
      );

      await runtime.dispose();
      expect(web.document.querySelector('#synctv-video-element-8015'), isNull);

      // A second dispose (e.g. player teardown racing a widget disposal)
      // must be a silent no-op.
      await runtime.dispose();
    },
  );

  test('open rejects custom headers the browser cannot attach', () async {
    final (runtime, _) = _runtime(8021);

    await expectLater(
      runtime.open(
        Media('https://example.test/v.mp4', httpHeaders: {'X-Custom': '1'}),
      ),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'web_media_headers_unsupported',
        ),
      ),
    );
  });

  test('open rejects file and content URIs', () async {
    final (runtime, _) = _runtime(8022);

    for (final uri in ['file:///tmp/movie.mp4', 'content://media/movie.mp4']) {
      await expectLater(
        runtime.open(Media(uri)),
        throwsA(
          isA<PlatformException>().having(
            (error) => error.code,
            'code',
            'web_local_media_unsupported',
          ),
        ),
        reason: uri,
      );
    }
  });

  test('a real element load failure maps to a media error code', () async {
    final (runtime, log) = _runtime(8023);

    // Bytes that claim to be MP4 but cannot decode: the element itself
    // raises its error event and the runtime maps the MediaError code.
    await runtime.open(Media('data:video/mp4;base64,AAAA'));

    await _waitFor(() => log.errors.isNotEmpty);
    expect(log.errors, hasLength(1));
    final error = log.errors.single;
    expect(error, isA<PlatformException>());
    expect((error as PlatformException).code, startsWith('MEDIA_ERR_'));
  });

  test('muted playback reports state changes and completion', () async {
    final (runtime, log) = _runtime(8024);

    await runtime.open(Media(_silenceUri));
    await _waitFor(
      () => log.events.any(
        (event) => event.eventType == VideoEventType.initialized,
      ),
    );

    // Autoplay policy blocks unmuted audio in a headless browser; muted
    // playback is the path production falls back to.
    await runtime.setVolume(0);
    await runtime.play();
    await _waitFor(
      () => log.events.any(
        (event) =>
            event.eventType == VideoEventType.isPlayingStateUpdate &&
            event.isPlaying == true,
      ),
    );

    await runtime.pause();
    await _waitFor(
      () => log.events.any(
        (event) =>
            event.eventType == VideoEventType.isPlayingStateUpdate &&
            event.isPlaying == false,
      ),
    );

    await runtime.play();
    await _waitFor(
      () => log.events.any(
        (event) => event.eventType == VideoEventType.completed,
      ),
      timeout: const Duration(seconds: 15),
    );
  });

  test('waiting and canplaythrough drive the buffering events', () async {
    final (runtime, log) = _runtime(8025);

    await runtime.open(Media(_silenceUri));
    await _waitFor(
      () => log.events.any(
        (event) => event.eventType == VideoEventType.initialized,
      ),
    );

    final video = web.document.querySelector(
      '#synctv-video-element-8025',
    ) as web.HTMLVideoElement;
    video.dispatchEvent(web.Event('waiting'));
    await _waitFor(
      () => log.events.any(
        (event) => event.eventType == VideoEventType.bufferingStart,
      ),
    );

    video.dispatchEvent(web.Event('canplaythrough'));
    await _waitFor(
      () => log.events.any(
        (event) => event.eventType == VideoEventType.bufferingEnd,
      ),
    );
  });

  test('web options map onto the media element', () async {
    final (runtime, _) = _runtime(8026);

    await runtime.open(Media(_silenceUri));
    final video = web.document.querySelector(
      '#synctv-video-element-8026',
    ) as web.HTMLVideoElement;

    await runtime.setWebOptions(
      const VideoPlayerWebOptions(
        controls: VideoPlayerWebOptionsControls.enabled(
          allowDownload: false,
          allowPictureInPicture: false,
        ),
        allowContextMenu: false,
        allowRemotePlayback: false,
        poster: null,
      ),
    );

    expect(video.controls, isTrue);
    expect(video.getAttribute('controlsList'), 'nodownload');
    expect(video.disablePictureInPicture, isTrue);
    expect(video.disableRemotePlayback, isTrue);

    final menuEvent = web.Event(
      'contextmenu',
      web.EventInit(cancelable: true, bubbles: true),
    );
    final notPrevented = video.dispatchEvent(menuEvent);
    expect(notPrevented, isFalse, reason: 'the context menu is suppressed');

    // Poster still routes through when provided.
    await runtime.setWebOptions(
      VideoPlayerWebOptions(poster: Uri.parse('https://example.test/p.jpg')),
    );
    expect(video.poster, 'https://example.test/p.jpg');
    expect(
      video.controls,
      isFalse,
      reason: 're-applying options resets prior element state',
    );
  });
}

Future<void> _waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('condition was not met within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}
