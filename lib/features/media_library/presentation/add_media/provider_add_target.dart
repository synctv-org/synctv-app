import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum ProviderAddTarget { parse, media, playlist }

class ProviderAddTargetSelector extends StatelessWidget {
  const ProviderAddTargetSelector({
    super.key,
    required this.value,
    required this.targets,
    required this.onChanged,
    this.enabled = true,
  });

  final ProviderAddTarget value;
  final List<ProviderAddTarget> targets;
  final ValueChanged<ProviderAddTarget> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final labels = {
      for (final target in targets) target: _label(context, target),
    };
    final style = Theme.of(context).textTheme.labelLarge;
    var segmentWidth = 0.0;
    for (final label in labels.values.expand((label) => label.split(' '))) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      // Reserve room for the icon, gap and button padding.
      final width = painter.width + 72;
      if (width > segmentWidth) segmentWidth = width;
      painter.dispose();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SegmentedButton<ProviderAddTarget>(
          key: const Key('provider-add-target'),
          direction: constraints.maxWidth < segmentWidth * targets.length
              ? Axis.vertical
              : Axis.horizontal,
          segments: [
            for (final target in targets)
              ButtonSegment(
                value: target,
                icon: Icon(_icon(target)),
                label: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: (constraints.maxWidth - 72).clamp(
                      0,
                      double.infinity,
                    ),
                  ),
                  child: Text(labels[target]!),
                ),
              ),
          ],
          selected: {value},
          onSelectionChanged: enabled
              ? (selection) => onChanged(selection.single)
              : null,
        );
      },
    );
  }

  static IconData _icon(ProviderAddTarget target) => switch (target) {
    ProviderAddTarget.parse => Icons.link_rounded,
    ProviderAddTarget.media => Icons.video_library_outlined,
    ProviderAddTarget.playlist => Icons.playlist_play_rounded,
  };

  static String _label(BuildContext context, ProviderAddTarget target) =>
      switch (target) {
        ProviderAddTarget.parse => context.l10n.parseLink,
        ProviderAddTarget.media => context.l10n.selectMedia,
        ProviderAddTarget.playlist => context.l10n.dynamicPlaylist,
      };
}
