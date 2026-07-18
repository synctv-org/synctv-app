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

  test('subtitle text removes WebVTT inline timing and style tags', () {
    expect(
      sanitizeSubtitleText(
        'comes out of the box\noff<00:23:35.919><c> industry</c>'
        '<00:23:36.480><c> adoption</c>',
      ),
      'comes out of the box\noff industry adoption',
    );
  });

  test('subtitle labels prefer user-facing metadata over internal keys', () {
    expect(
      subtitleDisplayLabel('sub_0', {
        'name': 'English (auto-generated)',
        'language': 'en',
      }),
      'English (auto-generated)',
    );
    expect(
      subtitleDisplayLabel('sub_1', {'name': '', 'language': 'zh-Hans'}),
      'zh-Hans',
    );
    expect(subtitleDisplayLabel('sub_2', const {}), 'sub_2');
  });
}
