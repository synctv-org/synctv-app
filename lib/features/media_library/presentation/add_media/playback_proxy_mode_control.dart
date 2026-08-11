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
  });

  final source_enum.PlaybackProxyMode value;
  final ValueChanged<source_enum.PlaybackProxyMode> onChanged;
  final bool enabled;

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
        SegmentedButton<source_enum.PlaybackProxyMode>(
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
            ButtonSegment(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              icon: const Icon(Icons.auto_awesome_outlined, size: 17),
              label: Text(context.l10n.playbackProxyAuto),
            ),
            ButtonSegment(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
              icon: const Icon(Icons.speed_rounded, size: 17),
              label: Text(context.l10n.playbackProxyPrefer),
            ),
            ButtonSegment(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
              icon: const Icon(Icons.lock_outline_rounded, size: 17),
              label: Text(context.l10n.playbackProxyOnly),
            ),
          ],
          selected: {value},
          onSelectionChanged: enabled
              ? (selection) => onChanged(selection.single)
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          _description(context),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (value ==
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER) ...[
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
    _ => context.l10n.playbackProxyAutoDescription,
  };
}
