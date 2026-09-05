import 'package:flutter/foundation.dart';

@immutable
final class DanmakuOverlayStyle {
  const DanmakuOverlayStyle({
    this.fontSize = 25,
    this.opacity = 0.8,
    this.duration = 8,
    this.area = 1,
    this.strokeWidth = 1.5,
    this.massiveMode = false,
    this.hideTop = false,
    this.hideBottom = false,
    this.hideScroll = false,
  });

  final double fontSize;
  final double opacity;
  final double duration;
  final double area;
  final double strokeWidth;
  final bool massiveMode;
  final bool hideTop;
  final bool hideBottom;
  final bool hideScroll;

  DanmakuOverlayStyle copyWith({
    double? fontSize,
    double? opacity,
    double? duration,
    double? area,
    double? strokeWidth,
    bool? massiveMode,
    bool? hideTop,
    bool? hideBottom,
    bool? hideScroll,
  }) => DanmakuOverlayStyle(
    fontSize: fontSize ?? this.fontSize,
    opacity: opacity ?? this.opacity,
    duration: duration ?? this.duration,
    area: area ?? this.area,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    massiveMode: massiveMode ?? this.massiveMode,
    hideTop: hideTop ?? this.hideTop,
    hideBottom: hideBottom ?? this.hideBottom,
    hideScroll: hideScroll ?? this.hideScroll,
  );

  DanmakuOverlayStyle normalized() {
    double finite(double value, double fallback) =>
        value.isFinite ? value : fallback;
    return DanmakuOverlayStyle(
      fontSize: finite(fontSize, 25).clamp(12, 64).toDouble(),
      opacity: finite(opacity, 0.8).clamp(0, 1).toDouble(),
      duration: finite(duration, 8).clamp(3, 20).toDouble(),
      area: finite(area, 1).clamp(0.1, 1).toDouble(),
      strokeWidth: finite(strokeWidth, 1.5).clamp(0, 6).toDouble(),
      massiveMode: massiveMode,
      hideTop: hideTop,
      hideBottom: hideBottom,
      hideScroll: hideScroll,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'fontSize': fontSize,
    'opacity': opacity,
    'duration': duration,
    'area': area,
    'strokeWidth': strokeWidth,
    'massiveMode': massiveMode,
    'hideTop': hideTop,
    'hideBottom': hideBottom,
    'hideScroll': hideScroll,
  };

  factory DanmakuOverlayStyle.fromJson(Map<String, Object?> json) {
    double number(String key, double defaultValue) {
      final value = json[key];
      return value is num ? value.toDouble() : defaultValue;
    }

    bool flag(String key, bool defaultValue) =>
        json[key] is bool ? json[key] as bool : defaultValue;
    return DanmakuOverlayStyle(
      fontSize: number('fontSize', 25),
      opacity: number('opacity', 0.8),
      duration: number('duration', 8),
      area: number('area', 1),
      strokeWidth: number('strokeWidth', 1.5),
      massiveMode: flag('massiveMode', false),
      hideTop: flag('hideTop', false),
      hideBottom: flag('hideBottom', false),
      hideScroll: flag('hideScroll', false),
    ).normalized();
  }
}

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
    this.videoDanmakuEnabled = true,
    this.chatDanmakuEnabled = true,
    this.videoDanmakuStyle = const DanmakuOverlayStyle(),
    this.chatDanmakuStyle = const DanmakuOverlayStyle(),
  });

  final double subtitleFontSize;
  final double subtitleOpacity;
  final double subtitleBackgroundOpacity;

  /// Fraction of the video content height used as the subtitle bottom inset.
  final double subtitleBottom;
  final int subtitleColor;
  final int subtitleBackgroundColor;
  final double subtitleOutlineWidth;
  final bool videoDanmakuEnabled;
  final bool chatDanmakuEnabled;
  final DanmakuOverlayStyle videoDanmakuStyle;
  final DanmakuOverlayStyle chatDanmakuStyle;

  PlaybackOverlayPreferenceValues copyWith({
    double? subtitleFontSize,
    double? subtitleOpacity,
    double? subtitleBackgroundOpacity,
    double? subtitleBottom,
    int? subtitleColor,
    int? subtitleBackgroundColor,
    double? subtitleOutlineWidth,
    bool? videoDanmakuEnabled,
    bool? chatDanmakuEnabled,
    DanmakuOverlayStyle? videoDanmakuStyle,
    DanmakuOverlayStyle? chatDanmakuStyle,
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
    videoDanmakuEnabled: videoDanmakuEnabled ?? this.videoDanmakuEnabled,
    chatDanmakuEnabled: chatDanmakuEnabled ?? this.chatDanmakuEnabled,
    videoDanmakuStyle: videoDanmakuStyle ?? this.videoDanmakuStyle,
    chatDanmakuStyle: chatDanmakuStyle ?? this.chatDanmakuStyle,
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
      videoDanmakuEnabled: videoDanmakuEnabled,
      chatDanmakuEnabled: chatDanmakuEnabled,
      videoDanmakuStyle: videoDanmakuStyle.normalized(),
      chatDanmakuStyle: chatDanmakuStyle.normalized(),
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
    'videoDanmakuEnabled': videoDanmakuEnabled,
    'chatDanmakuEnabled': chatDanmakuEnabled,
    'videoDanmakuStyle': videoDanmakuStyle.toJson(),
    'chatDanmakuStyle': chatDanmakuStyle.toJson(),
  };

  factory PlaybackOverlayPreferenceValues.fromJson(Map<String, Object?> json) {
    double number(String key, double fallback) {
      final value = json[key];
      return value is num ? value.toDouble() : fallback;
    }

    bool flag(String key, bool fallback) =>
        json[key] is bool ? json[key] as bool : fallback;
    Map<String, Object?> objectMap(Object? value) => value is Map
        ? Map<String, Object?>.from(value)
        : const <String, Object?>{};
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
      videoDanmakuEnabled: flag('videoDanmakuEnabled', true),
      chatDanmakuEnabled: flag('chatDanmakuEnabled', true),
      videoDanmakuStyle: DanmakuOverlayStyle.fromJson(
        objectMap(json['videoDanmakuStyle']),
      ),
      chatDanmakuStyle: DanmakuOverlayStyle.fromJson(
        objectMap(json['chatDanmakuStyle']),
      ),
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
