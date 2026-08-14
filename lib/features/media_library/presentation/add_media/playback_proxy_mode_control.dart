import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class PlaybackProxyModeControl extends StatelessWidget {
  const PlaybackProxyModeControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.supportsDirectPlayback = true,
  });

  final source_enum.PlaybackProxyMode value;
  final ValueChanged<source_enum.PlaybackProxyMode> onChanged;
  final bool enabled;
  final bool supportsDirectPlayback;

  static const _segmentedMinimumWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.route_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.playbackProxyMode,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final options = _options(context);
            if (constraints.maxWidth < _segmentedMinimumWidth) {
              return DropdownButtonFormField<source_enum.PlaybackProxyMode>(
                key: const Key('playback-proxy-mode-dropdown'),
                initialValue: value,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: [
                  for (final option in options)
                    DropdownMenuItem(
                      value: option.value,
                      child: _optionLabel(option),
                    ),
                ],
                onChanged: enabled
                    ? (selection) {
                        if (selection != null) onChanged(selection);
                      }
                    : null,
              );
            }
            return SegmentedButton<source_enum.PlaybackProxyMode>(
              key: const Key('playback-proxy-mode'),
              showSelectedIcon: false,
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(0, 40)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStatePropertyAll(
                  TextStyle(fontSize: 13, letterSpacing: 0),
                ),
              ),
              segments: [
                for (final option in options)
                  ButtonSegment(
                    value: option.value,
                    icon: Icon(option.icon, size: 17),
                    label: Text(option.label),
                  ),
              ],
              selected: {value},
              onSelectionChanged: enabled
                  ? (selection) => onChanged(selection.single)
                  : null,
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          _description(context),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (_showsDirectPlaybackRisk(value)) ...[
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.playbackProxyDirectRisk,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _description(BuildContext context) => switch (value) {
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER =>
      context.l10n.playbackProxyPreferDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY =>
      context.l10n.playbackProxyOnlyDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER =>
      context.l10n.playbackProxyDirectPreferDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY =>
      context.l10n.playbackProxyDirectOnlyDescription,
    _ => context.l10n.playbackProxyAutoDescription,
  };

  List<_PlaybackProxyModeOption> _options(BuildContext context) => [
    _PlaybackProxyModeOption(
      value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      icon: Icons.auto_awesome_outlined,
      label: context.l10n.playbackProxyAuto,
    ),
    _PlaybackProxyModeOption(
      value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
      icon: Icons.speed_rounded,
      label: context.l10n.playbackProxyPrefer,
    ),
    _PlaybackProxyModeOption(
      value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      icon: Icons.lock_outline_rounded,
      label: context.l10n.playbackProxyOnly,
    ),
    if (supportsDirectPlayback)
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
        icon: Icons.lan_rounded,
        label: context.l10n.playbackProxyDirectPrefer,
      ),
    if (supportsDirectPlayback)
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
        icon: Icons.link_rounded,
        label: context.l10n.playbackProxyDirectOnly,
      ),
  ];

  Widget _optionLabel(_PlaybackProxyModeOption option) => Row(
    children: [
      Icon(option.icon, size: 17),
      const SizedBox(width: 8),
      Expanded(child: Text(option.label)),
    ],
  );

  bool _showsDirectPlaybackRisk(source_enum.PlaybackProxyMode mode) =>
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER ||
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER ||
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
}

class _PlaybackProxyModeOption {
  const _PlaybackProxyModeOption({
    required this.value,
    required this.icon,
    required this.label,
  });

  final source_enum.PlaybackProxyMode value;
  final IconData icon;
  final String label;
}
