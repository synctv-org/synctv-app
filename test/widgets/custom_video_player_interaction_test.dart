import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';

void main() {
  test('mobile platforms use gesture-only player interaction', () {
    expect(
      videoPlayerInteractionModeForPlatform(TargetPlatform.android),
      VideoPlayerInteractionMode.mobile,
    );
    expect(
      videoPlayerInteractionModeForPlatform(TargetPlatform.iOS),
      VideoPlayerInteractionMode.mobile,
    );
  });

  test('desktop platforms use pointer player interaction', () {
    for (final platform in [
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      expect(
        videoPlayerInteractionModeForPlatform(platform),
        VideoPlayerInteractionMode.desktop,
      );
    }
  });
}
