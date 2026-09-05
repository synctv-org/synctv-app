import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/room/presentation/widgets/custom_video_player.dart';

final class _MemoryOverlayStore implements PlaybackOverlayPreferencesStore {
  PlaybackOverlayPreferenceValues value =
      const PlaybackOverlayPreferenceValues();

  @override
  Future<PlaybackOverlayPreferenceValues> load() async => value;

  @override
  Future<void> save(PlaybackOverlayPreferenceValues values) async {
    value = values;
  }
}

void main() {
  test('overlay preferences clamp values and persist updates', () async {
    final store = _MemoryOverlayStore();
    final controller = PlaybackOverlayPreferencesController(store: store);

    await controller.save(
      const PlaybackOverlayPreferenceValues(
        subtitleFontSize: 100,
        subtitleOpacity: -1,
        videoDanmakuStyle: DanmakuOverlayStyle(
          duration: 1,
          area: 2,
          strokeWidth: 20,
        ),
        chatDanmakuStyle: DanmakuOverlayStyle(fontSize: 100, opacity: -1),
        subtitleOutlineWidth: -1,
      ),
    );

    expect(controller.value.subtitleFontSize, 48);
    expect(controller.value.subtitleOpacity, 0);
    expect(controller.value.videoDanmakuStyle.duration, 3);
    expect(controller.value.videoDanmakuStyle.area, 1);
    expect(controller.value.videoDanmakuStyle.strokeWidth, 6);
    expect(controller.value.chatDanmakuStyle.fontSize, 64);
    expect(controller.value.chatDanmakuStyle.opacity, 0);
    expect(controller.value.subtitleOutlineWidth, 0);
    expect(store.value.videoDanmakuStyle.duration, 3);
  });

  test('reset restores platform defaults', () async {
    final controller = PlaybackOverlayPreferencesController(
      store: _MemoryOverlayStore(),
    );
    await controller.save(
      controller.value.copyWith(
        videoDanmakuEnabled: false,
        chatDanmakuEnabled: false,
        videoDanmakuStyle: controller.value.videoDanmakuStyle.copyWith(
          fontSize: 60,
          hideTop: true,
        ),
      ),
    );
    await controller.reset();

    expect(controller.value.videoDanmakuEnabled, isTrue);
    expect(controller.value.chatDanmakuEnabled, isTrue);
    expect(controller.value.videoDanmakuStyle.fontSize, 25);
    expect(controller.value.videoDanmakuStyle.hideTop, isFalse);
  });

  test('video and chat danmaku preferences serialize independently', () {
    const values = PlaybackOverlayPreferenceValues(
      videoDanmakuEnabled: false,
      chatDanmakuEnabled: true,
      videoDanmakuStyle: DanmakuOverlayStyle(fontSize: 18, opacity: 0.4),
      chatDanmakuStyle: DanmakuOverlayStyle(fontSize: 30, opacity: 0.9),
    );

    final restored = PlaybackOverlayPreferenceValues.fromJson(values.toJson());

    expect(restored.videoDanmakuEnabled, isFalse);
    expect(restored.chatDanmakuEnabled, isTrue);
    expect(restored.videoDanmakuStyle.fontSize, 18);
    expect(restored.videoDanmakuStyle.opacity, 0.4);
    expect(restored.chatDanmakuStyle.fontSize, 30);
    expect(restored.chatDanmakuStyle.opacity, 0.9);
  });

  test(
    'video content rectangle stays within viewport at every aspect ratio',
    () {
      expect(
        videoContentSize(const Size(1200, 700), aspectRatio: 16 / 9),
        const Size(1200, 675),
      );
      expect(
        videoContentSize(const Size(700, 1200), aspectRatio: 16 / 9),
        const Size(700, 393.75),
      );
      expect(videoContentSize(const Size(0, 0)), Size.zero);
      expect(subtitleBackgroundColor(0), Colors.transparent);
      expect(subtitleBackgroundColor(double.nan), Colors.transparent);
      expect(subtitleBackgroundColor(0.5).a, closeTo(0.5, 0.001));
      expect(
        subtitleBackgroundColor(0.5, color: 0xFFFF0000).a,
        closeTo(0.5, 0.001),
      );
    },
  );
}
