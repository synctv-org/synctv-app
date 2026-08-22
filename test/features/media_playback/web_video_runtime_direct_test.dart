@TestOn('browser')
library;

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:synctv_video_player_media_kit/src/web_video_player_runtime.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:web/web.dart' as web;

const _baseUrl = String.fromEnvironment('SYNCTV_WEB_MEDIA_TEST_BASE');

void main() {
  test('DASH runtime setup', () async {
    final runtime = WebVideoPlayerRuntime(9902);
    final errors = <Object>[];
    final initialized = Completer<void>();
    final sub = runtime.events.listen((event) {
      if (event.eventType == VideoEventType.initialized &&
          !initialized.isCompleted) {
        initialized.complete();
      }
    }, onError: errors.add);
    addTearDown(() async {
      await sub.cancel();
      await runtime.dispose();
    });
    try {
      await runtime.open(
        Media(
          '$_baseUrl/dash/manifest.mpd',
          extras: const {'formatHint': 'dash'},
        ),
      );
    } catch (error, stackTrace) {
      fail('open failed: $error\n$stackTrace');
    }
    await Future.any([
      initialized.future,
      Future<void>.delayed(const Duration(seconds: 5)),
    ]);
    final video = web.document.querySelector('video') as web.HTMLVideoElement?;
    expect(
      initialized.isCompleted,
      isTrue,
      reason:
          'DASH events: $errors; DOM: readyState=${video?.readyState}, '
          'size=${video?.videoWidth}x${video?.videoHeight}, '
          'duration=${video?.duration}, error=${video?.error?.message}',
    );
    expect(errors, isEmpty);
  }, skip: _baseUrl.isEmpty);
}
