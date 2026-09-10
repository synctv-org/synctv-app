import 'package:canvas_danmaku/scroll_danmaku_painter.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart' as canvas;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/features/room/presentation/widgets/danmaku_overlay.dart';
import 'package:video_player/video_player.dart';

ScrollDanmakuPainter painter(WidgetTester tester) => tester
    .widgetList<CustomPaint>(find.byType(CustomPaint))
    .map((widget) => widget.painter)
    .whereType<ScrollDanmakuPainter>()
    .single;

void main() {
  testWidgets(
    'in-place trimming does not suppress new comments or replay survivors',
    (tester) async {
      final video = VideoPlayerController.networkUrl(
        Uri.parse('https://example.test/video'),
      );
      video.value = const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        isPlaying: true,
        position: Duration(seconds: 1),
      );
      addTearDown(video.dispose);
      DanmakuItem comment(String text) => DanmakuItem(
        text: text,
        startTime: Duration.zero,
        endTime: const Duration(seconds: 8),
        color: Colors.white,
      );
      final items = [comment('Oldest'), comment('Survivor')];
      Widget overlay() => MaterialApp(
        home: DanmakuOverlay(videoController: video, danmakuList: items),
      );
      await tester.pumpWidget(overlay());
      await tester.pump(const Duration(milliseconds: 100));
      expect(painter(tester).danmakuItems, hasLength(2));
      items.removeAt(0);
      items.add(comment('New arrival'));
      await tester.pumpWidget(overlay());
      await tester.pump(const Duration(milliseconds: 100));
      expect(painter(tester).danmakuItems.map((item) => item.content.text), [
        'Oldest',
        'Survivor',
        'New arrival',
      ]);
      await tester.pump(const Duration(milliseconds: 100));
      expect(painter(tester).danmakuItems, hasLength(3));
      items.insert(0, comment('Survivor'));
      await tester.pumpWidget(overlay());
      await tester.pump(const Duration(milliseconds: 100));
      expect(painter(tester).danmakuItems.map((item) => item.content.text), [
        'Oldest',
        'Survivor',
        'New arrival',
        'Survivor',
      ]);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reenabling restores comments at the current playback position', (
    tester,
  ) async {
    final video = VideoPlayerController.networkUrl(
      Uri.parse('https://example.test/video'),
    );
    video.value = const VideoPlayerValue(
      duration: Duration(minutes: 1),
      isInitialized: true,
      isPlaying: true,
      position: Duration(seconds: 1),
    );
    addTearDown(video.dispose);
    Widget overlay(bool enabled) => MaterialApp(
      home: DanmakuOverlay(
        videoController: video,
        isEnabled: enabled,
        danmakuList: const [
          DanmakuItem(
            text: 'Visible again',
            startTime: Duration.zero,
            endTime: Duration(seconds: 8),
            color: Colors.white,
          ),
        ],
      ),
    );
    await tester.pumpWidget(overlay(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(painter(tester).danmakuItems.single.content.text, 'Visible again');
    await tester.pumpWidget(overlay(false));
    expect(
      find.byWidgetPredicate((widget) => widget is canvas.DanmakuScreen),
      findsNothing,
    );
    await tester.pumpWidget(overlay(true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(painter(tester).danmakuItems, hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('opacity override updates live and survives option changes', (
    tester,
  ) async {
    Widget overlay(double? opacity, double fontSize) => MaterialApp(
      home: DanmakuOverlay(
        videoController: null,
        danmakuList: const [],
        opacity: opacity,
        option: canvas.DanmakuOption(opacity: 0.8, fontSize: fontSize),
      ),
    );
    double visibleOpacity() => tester
        .widget<Opacity>(
          find
              .descendant(
                of: find.byWidgetPredicate(
                  (widget) => widget is canvas.DanmakuScreen,
                ),
                matching: find.byType(Opacity),
              )
              .first,
        )
        .opacity;
    await tester.pumpWidget(overlay(1, 16));
    expect(visibleOpacity(), 1);
    await tester.pumpWidget(overlay(0.2, 16));
    expect(visibleOpacity(), 0.2);
    await tester.pumpWidget(overlay(0.2, 20));
    expect(visibleOpacity(), 0.2);
    await tester.pumpWidget(overlay(null, 20));
    expect(visibleOpacity(), 0.8);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('replacement detaches old playback and unmount detaches new', (
    tester,
  ) async {
    final first = VideoPlayerController.networkUrl(
      Uri.parse('https://example.test/first'),
    );
    final second = VideoPlayerController.networkUrl(
      Uri.parse('https://example.test/second'),
    );
    const playing = VideoPlayerValue(
      duration: Duration(minutes: 1),
      isInitialized: true,
      isPlaying: true,
      position: Duration(seconds: 1),
    );
    first.value = playing;
    second.value = playing.copyWith(isPlaying: false);
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    Widget overlay(VideoPlayerController video) => MaterialApp(
      home: DanmakuOverlay(
        videoController: video,
        danmakuList: const [
          DanmakuItem(
            text: 'Replacement',
            startTime: Duration.zero,
            endTime: Duration(seconds: 8),
            color: Colors.white,
          ),
        ],
      ),
    );
    await tester.pumpWidget(overlay(first));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    final item = painter(tester).danmakuItems.single;
    await tester.pumpWidget(overlay(second));
    final pausedX = item.xPosition;
    first.value = playing.copyWith(position: const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    expect(item.xPosition, pausedX);
    second.value = playing;
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    expect(item.xPosition, lessThan(pausedX));
    await tester.pumpWidget(const SizedBox.shrink());
    first.value = playing.copyWith(isPlaying: false);
    second.value = playing.copyWith(isPlaying: false);
    expect(tester.takeException(), isNull);
  });

  for (final buffering in [false, true]) {
    testWidgets('visible danmaku freezes and resumes, buffering=$buffering', (
      tester,
    ) async {
      final video = VideoPlayerController.networkUrl(
        Uri.parse('https://example.test/video'),
      );
      video.value = const VideoPlayerValue(
        duration: Duration(minutes: 1),
        isInitialized: true,
        isPlaying: true,
        position: Duration(seconds: 1),
      );
      addTearDown(video.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 640,
            height: 360,
            child: DanmakuOverlay(
              videoController: video,
              danmakuList: const [
                DanmakuItem(
                  text: 'Stay with the video',
                  startTime: Duration.zero,
                  endTime: Duration(seconds: 8),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      final item = painter(tester).danmakuItems.single;
      video.value = video.value.copyWith(
        isPlaying: buffering,
        isBuffering: buffering,
      );
      await tester.pump(const Duration(milliseconds: 100));
      final pausedX = item.xPosition;
      await tester.pump(const Duration(seconds: 1));
      expect(item.xPosition, pausedX);
      video.value = video.value.copyWith(isPlaying: true, isBuffering: false);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      expect(item.xPosition, lessThan(pausedX));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    });
  }
}
