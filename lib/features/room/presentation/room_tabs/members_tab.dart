part of '../room_screen.dart';

mixin _RoomMembersTab on _RoomScreenBase {
  @override
  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: AppTooltip(
                  message: context.l10n.roomPresenceSummary(
                    _onlineMemberCount,
                    _onlineGuestCount,
                  ),
                  child: Text(
                    context.l10n.roomOnlineTotal(
                      _onlineMemberCount + _onlineGuestCount,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppBadge(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                borderRadius: BorderRadius.circular(20),
                icon: Icons.circle,
                iconSize: 8,
                color: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                textStyle: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                label: Text(context.l10n.live),
              ),
            ],
          ),
        ),
        Expanded(
          child: AppRefreshIndicator(
            onRefresh: () async => _observeRoomMembers(),
            child: AppListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];

                final viewerIsCreator = _isRoomCreator;
                final viewerIsRoomAdmin =
                    _selfMember?.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN;
                final viewerIsSysAdmin = _capabilities.isSystemAdmin;
                int viewerLevel = 1;
                if (viewerIsCreator) {
                  viewerLevel = 3;
                } else if (viewerIsRoomAdmin) {
                  viewerLevel = 2;
                }
                if (viewerIsSysAdmin) {
                  viewerLevel = 4;
                }

                final isTargetCreator =
                    member.role.isRoomCreator ||
                    member.username == widget.room.creator;
                final isTargetAdmin = member.role.isRoomAdministrator;
                final isMe = _currentUser?.id == member.id;
                final isBlocked = _blockedUserIds.contains(member.id);
                final targetLevel = isTargetCreator
                    ? 3
                    : (isTargetAdmin ? 2 : 1);
                final canManageRole =
                    _canManageMemberPermissions && viewerLevel > targetLevel;
                final canKick = _canRemoveMembers && viewerLevel > targetLevel;

                final memberActions = <Widget>[
                  if (!isMe) ...[
                    if (!isTargetCreator &&
                        canManageRole &&
                        member.role.isRoomMember)
                      AppIconButton(
                        icon: Icons.admin_panel_settings_outlined,
                        tooltip: context.l10n.makeAdmin,
                        onPressed: () => _setRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.tonal,
                      ),
                    if (!isTargetCreator && canManageRole && isTargetAdmin)
                      AppIconButton(
                        icon: Icons.remove_moderator_outlined,
                        tooltip: context.l10n.removeAdmin,
                        onPressed: () => _removeRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.outlined,
                      ),
                    if (!isTargetCreator && canKick)
                      AppIconButton(
                        icon: Icons.remove_circle_outline,
                        tooltip: context.l10n.removeMember,
                        onPressed: () => _kickMember(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.destructiveSubtle,
                      ),
                    AppIconButton(
                      icon: Icons.flag_outlined,
                      tooltip: context.l10n.reportMember,
                      onPressed: () => _showReportRoomMemberDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                    AppIconButton(
                      icon: Icons.person_search_outlined,
                      tooltip: context.l10n.reportUser,
                      onPressed: () => _showReportUserDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                    AppIconButton(
                      icon: Icons.person_off_outlined,
                      tooltip: isBlocked
                          ? context.l10n.unblockUser
                          : context.l10n.blockUser,
                      onPressed: isBlocked
                          ? () => _unblockUserFromRoom(member)
                          : () => _blockUser(
                              userId: member.id,
                              username: member.username,
                            ),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: isBlocked
                          ? AppIconButtonStyle.tonal
                          : AppIconButtonStyle.destructiveSubtle,
                    ),
                  ],
                ];

                return AppPanelSurface(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            _RoomAvatarFrame(
                              highlighted: isTargetCreator,
                              color: primaryColor,
                              child: AppAvatar(
                                name: member.username,
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: primaryColor,
                              ),
                            ),
                            if (isTargetCreator)
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.star,
                                  size: 14,
                                  color: AppColors.warning,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 132,
                                    ),
                                    child: Text(
                                      member.username,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isMe)
                                    _RoomMiniBadge(
                                      label: context.l10n.me,
                                      color: theme.primaryColor,
                                    ),
                                  if (isBlocked)
                                    _RoomMiniBadge(
                                      label: context.l10n.userBlocked,
                                      color: theme.colorScheme.error,
                                    ),
                                  if (isTargetAdmin) ...[
                                    _RoomMiniBadge(
                                      label: context.l10n.administrator,
                                      color: Colors.blue,
                                      borderSide: BorderSide(
                                        color: Colors.blue.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.onlineCount > 0
                                    ? context.l10n.onlineConnections(
                                        member.connectionCount,
                                      )
                                    : context.l10n.offlineJoinedAt(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          member.createdAt * 1000,
                                        ).toString().substring(0, 10),
                                      ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: member.onlineCount > 0
                                      ? AppColors.success
                                      : theme.disabledColor,
                                  fontSize: 12,
                                ),
                              ),
                              if (memberActions.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: memberActions,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setRoomAdmin(SyncTvUser member) async {
    if (!_canManageMemberPermissions) return;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.makeAdmin,
      icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
      content: Text(context.l10n.confirmMakeAdmin(member.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.confirm,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await _roomGateway.setRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          AppNotifications.showSuccess(
            context,
            context.l10n.madeAdmin(member.username),
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(context, context.l10n.settingFailed('$e'));
        }
      }
    }
  }

  Future<void> _removeRoomAdmin(SyncTvUser member) async {
    if (!_canManageMemberPermissions) return;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.removeAdmin,
      icon: const Icon(
        Icons.remove_moderator_rounded,
        color: AppColors.warning,
      ),
      content: Text(context.l10n.confirmRemoveAdmin(member.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.confirm,
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await _roomGateway.removeRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          AppNotifications.showSuccess(
            context,
            context.l10n.removedAdmin(member.username),
          );
        }
      } catch (e) {
        if (mounted) {
          AppNotifications.showError(
            context,
            context.l10n.cancelActionFailed('$e'),
          );
        }
      }
    }
  }

  Future<void> _kickMember(SyncTvUser member) async {
    if (!_canRemoveMembers) return;
    final cooldown = await _askKickCooldownSeconds(member.username);
    if (cooldown == null) return;
    try {
      await _roomGateway.kickMember(
        widget.room.roomId,
        member.id,
        kickCooldownSeconds: cooldown,
      );
      _observeRoomMembers();
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.memberKicked);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.kickMemberFailed('$e'),
        );
      }
    }
  }

  Future<int?> _askKickCooldownSeconds(String username) async {
    final controller = TextEditingController(text: '60');
    final value = await showAppDialog<int>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: Text(context.l10n.kickMember),
        icon: const Icon(Icons.remove_circle_outline),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.confirmKickMember(username)),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller,
              label: context.l10n.cooldownSeconds,
              hintText: '1 - 2592000',
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          AppActionButton(
            onPressed: () => Navigator.pop(dialogContext),
            label: context.l10n.cancel,
            style: AppActionButtonStyle.text,
          ),
          AppActionButton(
            onPressed: () {
              final seconds = int.tryParse(controller.text.trim());
              if (seconds == null || seconds < 1 || seconds > 2592000) {
                AppNotifications.showWarning(
                  context,
                  context.l10n.cooldownSecondsRange,
                );
                return;
              }
              Navigator.pop(dialogContext, seconds);
            },
            icon: Icons.logout_rounded,
            label: context.l10n.kick,
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }
}
