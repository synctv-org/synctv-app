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
    return SegmentedButton<ProviderAddTarget>(
      key: const Key('provider-add-target'),
      segments: [
        for (final target in targets)
          ButtonSegment(
            value: target,
            icon: Icon(_icon(target)),
            label: Text(_label(context, target)),
          ),
      ],
      selected: {value},
      onSelectionChanged: enabled
          ? (selection) => onChanged(selection.single)
          : null,
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
