import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';

@immutable
class RoomShellState {
  const RoomShellState({
    required this.roomName,
    required this.hasCurrentPlayback,
    required this.canControlPlayback,
    required this.hasCurrentUser,
    required this.canManageRoom,
  });

  final String roomName;
  final bool hasCurrentPlayback;
  final bool canControlPlayback;
  final bool hasCurrentUser;
  final bool canManageRoom;
}

@immutable
class RoomShellCallbacks {
  const RoomShellCallbacks({
    required this.back,
    required this.stopPlayback,
    required this.openRoomSettings,
  });

  final VoidCallback back;
  final VoidCallback stopPlayback;
  final VoidCallback openRoomSettings;
}

class RoomShellView extends StatelessWidget {
  const RoomShellView({
    super.key,
    required this.state,
    required this.callbacks,
    required this.primary,
    required this.secondary,
    required this.latencyBadge,
  });

  final RoomShellState state;
  final RoomShellCallbacks callbacks;
  final Widget primary;
  final Widget secondary;
  final Widget Function(bool compact) latencyBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compactChrome = MediaQuery.sizeOf(context).width < 560;
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppPageBar(
        // 48px gives the room title breathing room without making the chrome
        // dominate the player on desktop or mobile widths.
        toolbarHeight: 48,
        leading: AppIconButton(
          onPressed: callbacks.back,
          icon: Icons.arrow_back_rounded,
          tooltip: context.l10n.back,
        ),
        title: Text(state.roomName),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: latencyBadge(compactChrome),
          ),
          if (state.hasCurrentPlayback && state.canControlPlayback)
            AppTooltip(
              message: context.l10n.stopPlayback,
              child: AppActionButton(
                onPressed: callbacks.stopPlayback,
                icon: Icons.stop_circle_outlined,
                label: context.l10n.stop,
                style: AppActionButtonStyle.destructive,
              ),
            ),
          if (state.hasCurrentUser)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: compactChrome
                  ? AppIconButton(
                      onPressed: callbacks.openRoomSettings,
                      icon: state.canManageRoom
                          ? Icons.tune_rounded
                          : Icons.lock_outline_rounded,
                      tooltip: context.l10n.roomSettings,
                      style: AppIconButtonStyle.tonal,
                    )
                  : AppTooltip(
                      message: context.l10n.roomSettings,
                      child: AppActionButton(
                        onPressed: callbacks.openRoomSettings,
                        icon: state.canManageRoom
                            ? Icons.tune_rounded
                            : Icons.lock_outline_rounded,
                        label: context.l10n.roomSettingsShort,
                        style: AppActionButtonStyle.tonal,
                      ),
                    ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: AppMetrics.pagePadding(context),
        child: AppAdaptiveSplitView(
          minPrimaryWidth: 680,
          minSecondaryWidth: 320,
          maxSecondaryWidth: 420,
          spacing: AppMetrics.usesDenseLayout(context) ? 12 : 14,
          primary: primary,
          secondary: secondary,
          collapsedPrimaryAspectRatio: 16 / 9,
          collapsedSecondaryMinHeight: 520,
        ),
      ),
    );
  }
}
