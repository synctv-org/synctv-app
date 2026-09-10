import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

String _thresholdLabel(BuildContext context, double value) => context.l10n
    .secondsValue(value.toStringAsFixed(2).replaceFirst(RegExp(r'0$'), ''));

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
    final autoThresholdLabel = _thresholdLabel(
      context,
      config.autoSeekDriftThresholdSeconds,
    );
    final manualThresholdLabel = _thresholdLabel(
      context,
      config.manualSeekDriftThresholdSeconds,
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
          min: PlaybackModeConfig.minAutoSeekDriftSeconds,
          max: PlaybackModeConfig.maxAutoSeekDriftSeconds,
          divisions: 599,
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
          min: PlaybackModeConfig.minManualSeekDriftSeconds,
          max: PlaybackModeConfig.maxManualSeekDriftSeconds,
          divisions: 98,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      valueLabel,
                      style: theme.textTheme.labelLarge?.copyWith(color: color),
                    ),
                  ],
                ),
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
              semanticFormatterCallback: (value) =>
                  _thresholdLabel(context, value),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}
