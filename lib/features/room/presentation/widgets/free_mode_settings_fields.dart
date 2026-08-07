import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class FreeModeSettingsFields extends StatelessWidget {
  final PlaybackModeConfig config;
  final ValueChanged<PlaybackModeConfig> onChanged;

  const FreeModeSettingsFields({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final autoThresholdLabel = context.l10n.secondsValue(
      config.autoSeekDriftThresholdSeconds.toStringAsFixed(1),
    );
    final manualThresholdLabel = context.l10n.secondsValue(
      config.manualSeekDriftThresholdSeconds.toStringAsFixed(1),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: config.freeModeEnabled,
          onChanged: (value) {
            onChanged(config.copyWith(freeModeEnabled: value));
          },
          prefix: const Icon(Icons.explore_rounded),
          title: Text(context.l10n.freeMode),
          subtitle: Text(context.l10n.freeModeDescription),
        ),
        const SizedBox(height: 18),
        _PlaybackModeSlider(
          icon: Icons.linear_scale_rounded,
          title: context.l10n.syncCorrectionThreshold,
          valueLabel: autoThresholdLabel,
          value: config.autoSeekDriftThresholdSeconds,
          min: 0.1,
          max: 10.0,
          divisions: 99,
          enabled: !config.freeModeEnabled,
          onChanged: (value) {
            onChanged(config.copyWith(autoSeekDriftThresholdSeconds: value));
          },
        ),
        const SizedBox(height: 18),
        _PlaybackModeSlider(
          icon: Icons.touch_app_rounded,
          title: context.l10n.manualSyncDriftThreshold,
          valueLabel: manualThresholdLabel,
          value: config.manualSeekDriftThresholdSeconds,
          min: 0.1,
          max: 1.0,
          divisions: 18,
          enabled: true,
          onChanged: (value) {
            onChanged(config.copyWith(manualSeekDriftThresholdSeconds: value));
          },
        ),
      ],
    );
  }
}

class _PlaybackModeSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _PlaybackModeSlider({
    required this.icon,
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);
    return AppPanelSurface(
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                valueLabel,
                style: theme.textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Material(
            type: MaterialType.transparency,
            child: AppSlider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              divisions: divisions,
              label: valueLabel,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}
