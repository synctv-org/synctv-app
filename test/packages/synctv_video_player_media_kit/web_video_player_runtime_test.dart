@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/src/web_video_player_runtime.dart';

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
}
