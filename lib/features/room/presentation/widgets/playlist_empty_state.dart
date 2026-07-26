import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class PlaylistEmptyState extends StatelessWidget {
  final VoidCallback? onAdd;
  final bool compact;

  const PlaylistEmptyState({super.key, this.onAdd, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppEmptyState(
            icon: Icons.movie_filter_outlined,
            iconSize: compact ? 48 : 64,
            title: context.l10n.playlistEmpty,
            subtitle: context.l10n.playlistEmptyDescription,
            maxWidth: 280,
          ),
          if (onAdd != null) ...[
            const SizedBox(height: 8),
            AppActionButton(
              onPressed: onAdd,
              icon: Icons.add_rounded,
              label: context.l10n.addMedia,
              style: AppActionButtonStyle.tonal,
            ),
          ],
        ],
      ),
    );
  }
}
