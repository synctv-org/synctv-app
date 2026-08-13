import 'package:flutter/foundation.dart';

@immutable
final class PlaybackOverlayPreferenceValues {
  const PlaybackOverlayPreferenceValues({
    this.subtitleFontSize = 18,
    this.subtitleOpacity = 1,
    this.subtitleBackgroundOpacity = 0,
    this.subtitleBottom = 0.08,
    this.subtitleColor = 0xFFFFFFFF,
    this.subtitleBackgroundColor = 0xFF000000,
    this.subtitleOutlineWidth = 2,
    this.danmakuFontSize = 25,
    this.danmakuOpacity = 0.8,
    this.danmakuDuration = 8,
    this.danmakuArea = 1,
    this.danmakuStrokeWidth = 1.5,
    this.danmakuMassiveMode = false,
    this.danmakuHideTop = false,
    this.danmakuHideBottom = false,
    this.danmakuHideScroll = false,
  });

  final double subtitleFontSize;
  final double subtitleOpacity;
  final double subtitleBackgroundOpacity;

  /// Fraction of the video content height used as the subtitle bottom inset.
  final double subtitleBottom;
  final int subtitleColor;
  final int subtitleBackgroundColor;
  final double subtitleOutlineWidth;
  final double danmakuFontSize;
  final double danmakuOpacity;
  final double danmakuDuration;
  final double danmakuArea;
  final double danmakuStrokeWidth;
  final bool danmakuMassiveMode;
  final bool danmakuHideTop;
  final bool danmakuHideBottom;
  final bool danmakuHideScroll;

  PlaybackOverlayPreferenceValues copyWith({
    double? subtitleFontSize,
    double? subtitleOpacity,
    double? subtitleBackgroundOpacity,
    double? subtitleBottom,
    int? subtitleColor,
    int? subtitleBackgroundColor,
    double? subtitleOutlineWidth,
    double? danmakuFontSize,
    double? danmakuOpacity,
    double? danmakuDuration,
    double? danmakuArea,
    double? danmakuStrokeWidth,
    bool? danmakuMassiveMode,
    bool? danmakuHideTop,
    bool? danmakuHideBottom,
    bool? danmakuHideScroll,
  }) => PlaybackOverlayPreferenceValues(
    subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
    subtitleOpacity: subtitleOpacity ?? this.subtitleOpacity,
    subtitleBackgroundOpacity:
        subtitleBackgroundOpacity ?? this.subtitleBackgroundOpacity,
    subtitleBottom: subtitleBottom ?? this.subtitleBottom,
    subtitleColor: subtitleColor ?? this.subtitleColor,
    subtitleBackgroundColor:
        subtitleBackgroundColor ?? this.subtitleBackgroundColor,
    subtitleOutlineWidth: subtitleOutlineWidth ?? this.subtitleOutlineWidth,
    danmakuFontSize: danmakuFontSize ?? this.danmakuFontSize,
    danmakuOpacity: danmakuOpacity ?? this.danmakuOpacity,
    danmakuDuration: danmakuDuration ?? this.danmakuDuration,
    danmakuArea: danmakuArea ?? this.danmakuArea,
    danmakuStrokeWidth: danmakuStrokeWidth ?? this.danmakuStrokeWidth,
    danmakuMassiveMode: danmakuMassiveMode ?? this.danmakuMassiveMode,
    danmakuHideTop: danmakuHideTop ?? this.danmakuHideTop,
    danmakuHideBottom: danmakuHideBottom ?? this.danmakuHideBottom,
    danmakuHideScroll: danmakuHideScroll ?? this.danmakuHideScroll,
  );

  PlaybackOverlayPreferenceValues normalized() {
    double finite(double value, double fallback) =>
        value.isFinite ? value : fallback;
    return PlaybackOverlayPreferenceValues(
      subtitleFontSize: finite(subtitleFontSize, 18).clamp(12, 48).toDouble(),
      subtitleOpacity: finite(subtitleOpacity, 1).clamp(0, 1).toDouble(),
      subtitleBackgroundOpacity: finite(
        subtitleBackgroundOpacity,
        0,
      ).clamp(0, 1).toDouble(),
      subtitleBottom: finite(subtitleBottom, 0.08).clamp(0, 0.3).toDouble(),
      subtitleColor: subtitleColor,
      subtitleBackgroundColor: subtitleBackgroundColor,
      subtitleOutlineWidth: finite(
        subtitleOutlineWidth,
        2,
      ).clamp(0, 6).toDouble(),
      danmakuFontSize: finite(danmakuFontSize, 25).clamp(12, 64).toDouble(),
      danmakuOpacity: finite(danmakuOpacity, 0.8).clamp(0, 1).toDouble(),
      danmakuDuration: finite(danmakuDuration, 8).clamp(3, 20).toDouble(),
      danmakuArea: finite(danmakuArea, 1).clamp(0.1, 1).toDouble(),
      danmakuStrokeWidth: finite(
        danmakuStrokeWidth,
        1.5,
      ).clamp(0, 6).toDouble(),
      danmakuMassiveMode: danmakuMassiveMode,
      danmakuHideTop: danmakuHideTop,
      danmakuHideBottom: danmakuHideBottom,
      danmakuHideScroll: danmakuHideScroll,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'subtitleFontSize': subtitleFontSize,
    'subtitleOpacity': subtitleOpacity,
    'subtitleBackgroundOpacity': subtitleBackgroundOpacity,
    'subtitleBottom': subtitleBottom,
    'subtitleColor': subtitleColor,
    'subtitleBackgroundColor': subtitleBackgroundColor,
    'subtitleOutlineWidth': subtitleOutlineWidth,
    'danmakuFontSize': danmakuFontSize,
    'danmakuOpacity': danmakuOpacity,
    'danmakuDuration': danmakuDuration,
    'danmakuArea': danmakuArea,
    'danmakuStrokeWidth': danmakuStrokeWidth,
    'danmakuMassiveMode': danmakuMassiveMode,
    'danmakuHideTop': danmakuHideTop,
    'danmakuHideBottom': danmakuHideBottom,
    'danmakuHideScroll': danmakuHideScroll,
  };

  factory PlaybackOverlayPreferenceValues.fromJson(Map<String, Object?> json) {
    double number(String key, double fallback) {
      final value = json[key];
      return value is num ? value.toDouble() : fallback;
    }

    bool flag(String key, bool fallback) =>
        json[key] is bool ? json[key] as bool : fallback;
    return PlaybackOverlayPreferenceValues(
      subtitleFontSize: number('subtitleFontSize', 18),
      subtitleOpacity: number('subtitleOpacity', 1),
      subtitleBackgroundOpacity: number('subtitleBackgroundOpacity', 0),
      subtitleBottom: number('subtitleBottom', 0.08),
      subtitleColor: json['subtitleColor'] is num
          ? (json['subtitleColor'] as num).toInt()
          : 0xFFFFFFFF,
      subtitleBackgroundColor: json['subtitleBackgroundColor'] is num
          ? (json['subtitleBackgroundColor'] as num).toInt()
          : 0xFF000000,
      subtitleOutlineWidth: number('subtitleOutlineWidth', 2),
      danmakuFontSize: number('danmakuFontSize', 25),
      danmakuOpacity: number('danmakuOpacity', 0.8),
      danmakuDuration: number('danmakuDuration', 8),
      danmakuArea: number('danmakuArea', 1),
      danmakuStrokeWidth: number('danmakuStrokeWidth', 1.5),
      danmakuMassiveMode: flag('danmakuMassiveMode', false),
      danmakuHideTop: flag('danmakuHideTop', false),
      danmakuHideBottom: flag('danmakuHideBottom', false),
      danmakuHideScroll: flag('danmakuHideScroll', false),
    ).normalized();
  }
}

abstract interface class PlaybackOverlayPreferencesStore {
  Future<PlaybackOverlayPreferenceValues> load();
  Future<void> save(PlaybackOverlayPreferenceValues values);
}

final class PlaybackOverlayPreferencesController extends ChangeNotifier {
  PlaybackOverlayPreferencesController({required this.store});

  final PlaybackOverlayPreferencesStore store;
  PlaybackOverlayPreferenceValues _value =
      const PlaybackOverlayPreferenceValues();

  PlaybackOverlayPreferenceValues get value => _value;

  Future<void> load() async {
    _value = (await store.load()).normalized();
    notifyListeners();
  }

  Future<void> save(PlaybackOverlayPreferenceValues value) async {
    final previous = _value;
    _value = value.normalized();
    notifyListeners();
    try {
      await store.save(_value);
    } catch (_) {
      _value = previous;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> reset() => save(const PlaybackOverlayPreferenceValues());
}
