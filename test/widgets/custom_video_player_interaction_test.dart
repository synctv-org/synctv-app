import 'package:flutter/material.dart';
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

  testWidgets('playback navigation invokes previous and next callbacks', (
    tester,
  ) async {
    var previousCount = 0;
    var nextCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackNavigationControls(
            previousTooltip: 'Previous video',
            nextTooltip: 'Next video',
            onPrevious: () => previousCount++,
            onNext: () => nextCount++,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('playback_previous_button')), findsOneWidget);
    expect(find.byKey(const Key('playback_next_button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('playback_previous_button')));
    await tester.tap(find.byKey(const Key('playback_next_button')));
    await tester.pump(const Duration(milliseconds: 200));

    expect(previousCount, 1);
    expect(nextCount, 1);
  });

  testWidgets('playback navigation keeps disabled boundary buttons visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PlaybackNavigationControls(
            previousTooltip: 'Previous video',
            nextTooltip: 'Next video',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.skip_previous_rounded), findsOneWidget);
    expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('playback_previous_button'))),
      const Size(40, 40),
    );
    expect(
      tester.getSize(find.byKey(const Key('playback_next_button'))),
      const Size(40, 40),
    );
  });
}
