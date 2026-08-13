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
        danmakuDuration: 1,
        danmakuArea: 2,
        danmakuStrokeWidth: 20,
        subtitleOutlineWidth: -1,
      ),
    );

    expect(controller.value.subtitleFontSize, 48);
    expect(controller.value.subtitleOpacity, 0);
    expect(controller.value.danmakuDuration, 3);
    expect(controller.value.danmakuArea, 1);
    expect(controller.value.danmakuStrokeWidth, 6);
    expect(controller.value.subtitleOutlineWidth, 0);
    expect(store.value.danmakuDuration, 3);
  });

  test('reset restores platform defaults', () async {
    final controller = PlaybackOverlayPreferencesController(
      store: _MemoryOverlayStore(),
    );
    await controller.save(
      controller.value.copyWith(danmakuFontSize: 60, danmakuHideTop: true),
    );
    await controller.reset();

    expect(controller.value.danmakuFontSize, 25);
    expect(controller.value.danmakuHideTop, isFalse);
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
