class PlaybackSyncConfig {
  static const defaults = PlaybackSyncConfig();

  final double autoSeekDriftThresholdSeconds;
  final double manualSeekDriftThresholdSeconds;
  final bool autoSyncEnabled;

  const PlaybackSyncConfig({
    this.autoSeekDriftThresholdSeconds = 1.2,
    this.manualSeekDriftThresholdSeconds = 0.2,
    this.autoSyncEnabled = true,
  });

  factory PlaybackSyncConfig.fromJson(Map<String, Object?> json) {
    return PlaybackSyncConfig(
      autoSeekDriftThresholdSeconds:
          (json['autoSeekDriftThresholdSeconds'] as num?)?.toDouble() ??
              defaults.autoSeekDriftThresholdSeconds,
      manualSeekDriftThresholdSeconds:
          (json['manualSeekDriftThresholdSeconds'] as num?)?.toDouble() ??
              defaults.manualSeekDriftThresholdSeconds,
      autoSyncEnabled:
          json['autoSyncEnabled'] as bool? ?? defaults.autoSyncEnabled,
    ).normalized();
  }

  Map<String, Object?> toJson() => {
        'autoSeekDriftThresholdSeconds': autoSeekDriftThresholdSeconds,
        'manualSeekDriftThresholdSeconds': manualSeekDriftThresholdSeconds,
        'autoSyncEnabled': autoSyncEnabled,
      };

  PlaybackSyncConfig copyWith({
    double? autoSeekDriftThresholdSeconds,
    double? manualSeekDriftThresholdSeconds,
    bool? autoSyncEnabled,
  }) {
    return PlaybackSyncConfig(
      autoSeekDriftThresholdSeconds:
          autoSeekDriftThresholdSeconds ?? this.autoSeekDriftThresholdSeconds,
      manualSeekDriftThresholdSeconds: manualSeekDriftThresholdSeconds ??
          this.manualSeekDriftThresholdSeconds,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
    );
  }

  PlaybackSyncConfig normalized() {
    return PlaybackSyncConfig(
      autoSeekDriftThresholdSeconds:
          autoSeekDriftThresholdSeconds.clamp(0.05, 30.0).toDouble(),
      manualSeekDriftThresholdSeconds:
          manualSeekDriftThresholdSeconds.clamp(0.1, 5.0).toDouble(),
      autoSyncEnabled: autoSyncEnabled,
    );
  }
}
