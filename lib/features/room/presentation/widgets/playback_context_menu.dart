import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/widgets/player_control_popup_style.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum PlaybackContextMenuAction {
  toggleLoop,
  toggleShuffle,
  sync,
  reloadSource,
  pictureInPicture,
  copyDebugInfo,
  toggleDetailedStatistics,
}

@immutable
class PlaybackContextMenuState {
  const PlaybackContextMenuState({
    required this.isLive,
    required this.loopEnabled,
    required this.shuffleEnabled,
    required this.canChangePlayMode,
    required this.detailedStatisticsVisible,
    this.canSync = false,
    this.canReloadSource = false,
    this.canEnterPictureInPicture = false,
  });

  final bool isLive;
  final bool loopEnabled;
  final bool shuffleEnabled;
  final bool canChangePlayMode;
  final bool detailedStatisticsVisible;
  final bool canSync;
  final bool canReloadSource;
  final bool canEnterPictureInPicture;
}

Future<PlaybackContextMenuAction?> showPlaybackContextMenu({
  required BuildContext context,
  required Offset globalPosition,
  required PlaybackContextMenuState state,
}) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
  if (overlay == null || !overlay.hasSize) {
    return Future.value();
  }
  final anchor = overlay.globalToLocal(globalPosition);
  final items = <PopupMenuEntry<PlaybackContextMenuAction>>[
    if (!state.isLive && state.canChangePlayMode) ...[
      _menuItem(
        action: PlaybackContextMenuAction.toggleLoop,
        icon: Icons.repeat_one_rounded,
        label: context.l10n.loopPlayback,
        selected: state.loopEnabled,
      ),
      _menuItem(
        action: PlaybackContextMenuAction.toggleShuffle,
        icon: Icons.shuffle_rounded,
        label: context.l10n.shufflePlayback,
        selected: state.shuffleEnabled,
      ),
      const PopupMenuDivider(height: 9),
    ],
    if (state.canSync)
      _menuItem(
        action: PlaybackContextMenuAction.sync,
        icon: state.isLive ? Icons.refresh_rounded : Icons.sync_rounded,
        label: state.isLive
            ? context.l10n.reloadLivePlayback
            : context.l10n.syncPlayback,
      ),
    if (state.canReloadSource && !(state.isLive && state.canSync))
      _menuItem(
        action: PlaybackContextMenuAction.reloadSource,
        icon: Icons.restart_alt_rounded,
        label: context.l10n.reloadPlaybackSource,
      ),
    if (state.canEnterPictureInPicture)
      _menuItem(
        action: PlaybackContextMenuAction.pictureInPicture,
        icon: Icons.picture_in_picture_alt_rounded,
        label: context.l10n.pictureInPicture,
      ),
    if (state.canSync ||
        (state.canReloadSource && !(state.isLive && state.canSync)) ||
        state.canEnterPictureInPicture)
      const PopupMenuDivider(height: 9),
    _menuItem(
      action: PlaybackContextMenuAction.copyDebugInfo,
      icon: Icons.content_copy_rounded,
      label: context.l10n.copyPlaybackDebugInfo,
    ),
    _menuItem(
      action: PlaybackContextMenuAction.toggleDetailedStatistics,
      icon: Icons.monitor_heart_outlined,
      label: context.l10n.detailedPlaybackStatistics,
      selected: state.detailedStatisticsVisible,
    ),
  ];

  return showMenu<PlaybackContextMenuAction>(
    context: context,
    popUpAnimationStyle: playerControlPopupAnimationStyle,
    color: const Color(0xF51C1C22),
    elevation: 18,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.white12),
    ),
    position: RelativeRect.fromLTRB(
      anchor.dx,
      anchor.dy,
      (overlay.size.width - anchor.dx).clamp(0, overlay.size.width),
      (overlay.size.height - anchor.dy).clamp(0, overlay.size.height),
    ),
    items: items,
  );
}

PopupMenuItem<PlaybackContextMenuAction> _menuItem({
  required PlaybackContextMenuAction action,
  required IconData icon,
  required String label,
  bool selected = false,
}) {
  return PopupMenuItem<PlaybackContextMenuAction>(
    value: action,
    height: 42,
    child: SizedBox(
      width: 258,
      child: Row(
        children: [
          Icon(icon, size: 19, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          if (selected)
            const Icon(Icons.check_rounded, size: 19, color: Color(0xFF7CFFB2))
          else
            const SizedBox(width: 19),
        ],
      ),
    ),
  );
}
