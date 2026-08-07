class PlaybackModeConfig {
  static const defaults = PlaybackModeConfig();

  final double autoSeekDriftThresholdSeconds;
  final double manualSeekDriftThresholdSeconds;
  final bool freeModeEnabled;

  const PlaybackModeConfig({
    this.autoSeekDriftThresholdSeconds = 1.2,
    this.manualSeekDriftThresholdSeconds = 0.2,
    this.freeModeEnabled = false,
  });

  factory PlaybackModeConfig.fromJson(Map<String, Object?> json) {
    return PlaybackModeConfig(
      autoSeekDriftThresholdSeconds:
          (json['autoSeekDriftThresholdSeconds'] as num?)?.toDouble() ??
          defaults.autoSeekDriftThresholdSeconds,
      manualSeekDriftThresholdSeconds:
          (json['manualSeekDriftThresholdSeconds'] as num?)?.toDouble() ??
          defaults.manualSeekDriftThresholdSeconds,
      freeModeEnabled:
          json['freeModeEnabled'] as bool? ?? defaults.freeModeEnabled,
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
    return PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: autoSeekDriftThresholdSeconds
          .clamp(0.05, 30.0)
          .toDouble(),
      manualSeekDriftThresholdSeconds: manualSeekDriftThresholdSeconds
          .clamp(0.1, 5.0)
          .toDouble(),
      freeModeEnabled: freeModeEnabled,
    );
  }
}
