class PlaybackModeConfig {
  static const defaults = PlaybackModeConfig();
  static const minAutoSeekDriftSeconds = 0.05;
  static const maxAutoSeekDriftSeconds = 30.0;
  static const minManualSeekDriftSeconds = 0.1;
  static const maxManualSeekDriftSeconds = 5.0;

  final double autoSeekDriftThresholdSeconds;
  final double manualSeekDriftThresholdSeconds;
  final bool freeModeEnabled;

  const PlaybackModeConfig({
    this.autoSeekDriftThresholdSeconds = 1.2,
    this.manualSeekDriftThresholdSeconds = 0.2,
    this.freeModeEnabled = false,
  });

  factory PlaybackModeConfig.fromJson(Map<String, Object?> json) {
    double number(String key, double fallback) {
      final value = json[key];
      return value is num ? value.toDouble() : fallback;
    }

    return PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: number(
        'autoSeekDriftThresholdSeconds',
        defaults.autoSeekDriftThresholdSeconds,
      ),
      manualSeekDriftThresholdSeconds: number(
        'manualSeekDriftThresholdSeconds',
        defaults.manualSeekDriftThresholdSeconds,
      ),
      freeModeEnabled: json['freeModeEnabled'] is bool
          ? json['freeModeEnabled'] as bool
          : defaults.freeModeEnabled,
    ).normalized();
  }

  Map<String, Object?> toJson() => {
    'autoSeekDriftThresholdSeconds': autoSeekDriftThresholdSeconds,
    'manualSeekDriftThresholdSeconds': manualSeekDriftThresholdSeconds,
    'freeModeEnabled': freeModeEnabled,
  };

  PlaybackModeConfig copyWith({
    double? autoSeekDriftThresholdSeconds,
    double? manualSeekDriftThresholdSeconds,
    bool? freeModeEnabled,
  }) {
    return PlaybackModeConfig(
      autoSeekDriftThresholdSeconds:
          autoSeekDriftThresholdSeconds ?? this.autoSeekDriftThresholdSeconds,
      manualSeekDriftThresholdSeconds:
          manualSeekDriftThresholdSeconds ??
          this.manualSeekDriftThresholdSeconds,
      freeModeEnabled: freeModeEnabled ?? this.freeModeEnabled,
    );
  }

  PlaybackModeConfig normalized() {
    double finite(double value, double fallback) =>
        value.isFinite ? value : fallback;
    return PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: finite(
        autoSeekDriftThresholdSeconds,
        defaults.autoSeekDriftThresholdSeconds,
      ).clamp(minAutoSeekDriftSeconds, maxAutoSeekDriftSeconds).toDouble(),
      manualSeekDriftThresholdSeconds: finite(
        manualSeekDriftThresholdSeconds,
        defaults.manualSeekDriftThresholdSeconds,
      ).clamp(minManualSeekDriftSeconds, maxManualSeekDriftSeconds).toDouble(),
      freeModeEnabled: freeModeEnabled,
    );
  }
}
