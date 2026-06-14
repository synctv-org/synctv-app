import 'package:flutter/material.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

class PlaylistEmptyState extends StatelessWidget {
  final VoidCallback? onAdd;
  final bool compact;

  const PlaylistEmptyState({
    super.key,
    this.onAdd,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppEmptyState(
            icon: Icons.movie_filter_outlined,
            iconSize: compact ? 48 : 64,
            title: '播放列表为空',
            subtitle: '添加影片后即可一起观看',
            maxWidth: 280,
          ),
          if (onAdd != null) ...[
            const SizedBox(height: 8),
            AppActionButton(
              onPressed: onAdd,
              icon: Icons.add_rounded,
              label: '添加影片',
              style: AppActionButtonStyle.tonal,
            ),
          ],
        ],
      ),
    );
  }
}
