@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/src/web_video_player_runtime.dart';
import 'package:web/web.dart' as web;

void main() {
  test(
    'seekTo preserves millisecond precision in the HTML video element',
    () async {
      final runtime = WebVideoPlayerRuntime(73250);
      final eventSubscription = runtime.events.listen((_) {});
      addTearDown(() async {
        await runtime.dispose();
        await eventSubscription.cancel();
      });

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
}
