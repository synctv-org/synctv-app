part of 'account_center_page.dart';

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool dense;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBadge(
          icon: icon,
          color: theme.colorScheme.primary,
          size: dense ? 36 : 42,
          iconSize: dense ? 20 : 22,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    (dense
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.titleLarge)
                        ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool danger;
  final Widget child;

  const _Section({
    this.title,
    this.subtitle,
    this.danger = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasHeader = title != null || subtitle != null;
    return AppInkSurface(
      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: danger
            ? Colors.red.withValues(alpha: 0.38)
            : theme.dividerColor.withValues(alpha: 0.55),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: hasHeader
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: danger ? Colors.red.shade700 : null,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  child,
                ],
              )
            : child,
      ),
    );
  }
}

class _LoadErrorSummary extends StatelessWidget {
  final Map<String, String> errors;
  final Map<String, _AccountModuleInfo> moduleInfo;
  final VoidCallback onRetry;

  const _LoadErrorSummary({
    required this.errors,
    required this.moduleInfo,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      danger: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.someAccountModulesUnavailable,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppActionButton(
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                label: context.l10n.retryAll,
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final entry in errors.entries) ...[
            _ModuleErrorRow(
              info: moduleInfo[entry.key],
              fallbackLabel: entry.key,
              message: entry.value,
            ),
            if (entry.key != errors.keys.last) const AppDivider(height: 16),
          ],
        ],
      ),
    );
  }
}

class _LoadErrorBanner extends StatelessWidget {
  final String title;
  final _AccountModuleInfo? moduleInfo;
  final String message;
  final VoidCallback onRetry;

  const _LoadErrorBanner({
    required this.title,
    this.moduleInfo,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      danger: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                moduleInfo?.icon ?? Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  moduleInfo == null ? title : '$title：${moduleInfo!.label}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppActionButton(
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                label: context.l10n.retry,
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (moduleInfo != null) ...[
            Text(
              moduleInfo!.impact,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleErrorRow extends StatelessWidget {
  final _AccountModuleInfo? info;
  final String fallbackLabel;
  final String message;

  const _ModuleErrorRow({
    required this.info,
    required this.fallbackLabel,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final module = info;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          module?.icon ?? Icons.error_outline_rounded,
          color: Colors.red,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                module?.label ?? fallbackLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                module?.impact ?? context.l10n.moduleCurrentlyUnavailable,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaProviderBindCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MediaProviderBindCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInkSurface(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: color,
            size: 40,
            backgroundAlpha: 0.14,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: color),
        ],
      ),
    );
  }
}

class _InlineModuleError extends StatelessWidget {
  final _AccountModuleInfo? moduleInfo;
  final String message;
  final VoidCallback onRetry;

  const _InlineModuleError({
    this.moduleInfo,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInfoBanner(
      padding: const EdgeInsets.all(12),
      icon: moduleInfo?.icon ?? Icons.error_outline_rounded,
      color: Colors.red,
      backgroundColor: Colors.red.withValues(alpha: 0.06),
      border: Border.all(color: Colors.red.withValues(alpha: 0.26)),
      crossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        moduleInfo?.label ?? context.l10n.moduleUnavailable,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      message: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (moduleInfo != null) ...[
            Text(
              moduleInfo!.impact,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
              ),
            ),
            const SizedBox(height: 3),
          ],
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
        ],
      ),
      trailing: AppActionButton(
        onPressed: onRetry,
        label: context.l10n.retry,
        style: AppActionButtonStyle.text,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final double size;

  const _ProfileAvatar({
    required this.username,
    required this.size,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = DependencyScope.read<ResourceUrlResolver>(
      context,
    ).resolve(avatarUrl);
    return AppAvatar(
      name: username,
      imageUrl: imageUrl,
      size: size,
      shape: BoxShape.rectangle,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      foregroundColor: theme.colorScheme.primary,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EditableProfileAvatar extends StatelessWidget {
  const _EditableProfileAvatar({
    required this.username,
    required this.avatarUrl,
    required this.size,
    required this.updating,
    required this.onPick,
    this.onClear,
  });

  final String username;
  final String avatarUrl;
  final double size;
  final bool updating;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              _ProfileAvatar(
                username: username,
                avatarUrl: avatarUrl,
                size: size,
              ),
              Positioned.fill(
                child: AppInkSurface(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  onTap: updating ? null : onPick,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AppPanelSurface(
                      margin: const EdgeInsets.all(4),
                      width: 26,
                      height: 26,
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      child: updating
                          ? const Padding(
                              padding: EdgeInsets.all(6),
                              child: AppLoadingIndicator(
                                size: AppLoadingSize.sm,
                                centered: false,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (onClear != null) ...[
            const SizedBox(height: 8),
            AppActionButton(
              onPressed: updating ? null : onClear,
              label: context.l10n.remove,
              style: AppActionButtonStyle.text,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  final Color? color;

  const _StatusPill({
    required this.icon,
    required this.label,
    this.danger = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        this.color ?? (danger ? Colors.red : theme.colorScheme.primary);
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: color.withValues(alpha: 0.20)),
      icon: icon,
      iconSize: 14,
      color: color,
      backgroundColor: color.withValues(alpha: 0.10),
      textStyle: theme.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
      label: Text(label),
    );
  }
}

class _AccountNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AccountNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foreground,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  final SyncTvUser user;
  final String roleLabel;
  final String statusLabel;
  final String activeServerName;
  final String createdAtLabel;

  const _AccountHero({
    required this.user,
    required this.roleLabel,
    required this.statusLabel,
    required this.activeServerName,
    required this.createdAtLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppInkSurface(
      color: isDark ? const Color(0xFF1C1C1F) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 680;
            final identity = Row(
              children: [
                _ProfileAvatar(username: user.username, size: wide ? 76 : 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username.isEmpty
                            ? context.l10n.currentAccount
                            : user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (user.hasEmail) ...[
                        const SizedBox(height: 6),
                        Text(
                          user.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.66,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
            final metadata = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusPill(icon: Icons.dns_outlined, label: activeServerName),
                _StatusPill(
                  icon: Icons.admin_panel_settings_outlined,
                  label: roleLabel,
                ),
                _StatusPill(icon: Icons.circle_outlined, label: statusLabel),
                _StatusPill(
                  icon: Icons.calendar_month_outlined,
                  label: createdAtLabel,
                ),
              ],
            );
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [identity, const SizedBox(height: 14), metadata],
              );
            }
            return Row(
              children: [
                Expanded(child: identity),
                const SizedBox(width: 18),
                Flexible(child: metadata),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tone;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: tone, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoEntry {
  final String label;
  final String value;

  const _InfoEntry(this.label, this.value);
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoEntry> entries;

  const _InfoGrid({required this.entries});

  @override
  Widget build(BuildContext context) {
    return AppResponsiveWrap(
      minItemWidth: 240,
      maxColumns: 3,
      children: [
        for (final entry in entries)
          _InfoRow(label: entry.label, value: entry.value),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 3),
          AppSelectableText(
            value.isEmpty ? '-' : value,
            maxLines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationChip extends StatelessWidget {
  final String label;
  final client_enum.MyRoomRelation value;
  final client_enum.MyRoomRelation groupValue;
  final ValueChanged<client_enum.MyRoomRelation> onSelected;

  const _RelationChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: Text(label),
      selected: value == groupValue,
      onSelected: (_) => onSelected(value),
      showCheckmark: false,
    );
  }
}

class _RoomManagementTile extends StatelessWidget {
  final SyncTvRoom room;
  final String roleLabel;
  final String relationLabel;
  final String updatedAtLabel;
  final bool isOwner;
  final bool canManage;
  final VoidCallback onOpen;
  final VoidCallback onManage;
  final VoidCallback onLeaveOrDelete;

  const _RoomManagementTile({
    required this.room,
    required this.roleLabel,
    required this.relationLabel,
    required this.updatedAtLabel,
    required this.isOwner,
    required this.canManage,
    required this.onOpen,
    required this.onManage,
    required this.onLeaveOrDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final title = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.roomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                room.description.isEmpty ? room.roomId : room.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          );
          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(icon: Icons.badge_outlined, label: roleLabel),
              _StatusPill(icon: Icons.group_outlined, label: relationLabel),
              if (room.needPassword)
                _StatusPill(
                  icon: Icons.lock_outline_rounded,
                  label: context.l10n.password,
                ),
              if (room.needVerify)
                _StatusPill(
                  icon: Icons.fact_check_outlined,
                  label: context.l10n.review,
                ),
              if (room.isBanned)
                _StatusPill(
                  icon: Icons.block_rounded,
                  label: context.l10n.banned,
                  danger: true,
                ),
            ],
          );
          final meta = AppTooltip(
            message: context.l10n.roomPresenceSummary(
              room.onlineMemberCount,
              room.onlineGuestCount,
            ),
            child: Text(
              context.l10n.roomMemberUpdateSummary(
                room.onlineCount,
                room.memberCount,
                updatedAtLabel,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
              ),
            ),
          );
          final actions = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppActionButton(
                onPressed: onOpen,
                icon: Icons.open_in_new_rounded,
                label: context.l10n.open,
              ),
              if (canManage)
                AppActionButton(
                  onPressed: onManage,
                  icon: Icons.settings_outlined,
                  label: context.l10n.manage,
                  style: AppActionButtonStyle.outlined,
                ),
              AppActionButton(
                onPressed: onLeaveOrDelete,
                icon: isOwner
                    ? Icons.delete_outline_rounded
                    : Icons.logout_rounded,
                label: isOwner ? context.l10n.delete : context.l10n.leave,
                style: AppActionButtonStyle.outlined,
              ),
            ],
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoomCoverThumb(room: room, size: 88, wide: true),
                const SizedBox(height: 10),
                title,
                const SizedBox(height: 10),
                _RoomCreatorLine(room: room),
                const SizedBox(height: 10),
                chips,
                const SizedBox(height: 10),
                meta,
                const SizedBox(height: 12),
                actions,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoomCoverThumb(room: room, size: 88, wide: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 10),
                    _RoomCreatorLine(room: room),
                    const SizedBox(height: 10),
                    chips,
                    const SizedBox(height: 10),
                    meta,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _RoomCreatorLine extends StatelessWidget {
  const _RoomCreatorLine({required this.room});

  final SyncTvRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final creatorName = room.creator.trim().isEmpty
        ? context.l10n.unknownCreator
        : room.creator.trim();
    return Row(
      children: [
        AppAvatar(
          name: creatorName,
          imageUrl: DependencyScope.read<ResourceUrlResolver>(
            context,
          ).resolve(room.creatorAvatarUrl),
          radius: 12,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          foregroundColor: theme.colorScheme.primary,
          textStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.l10n.creatorName(creatorName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoomCoverThumb extends StatelessWidget {
  const _RoomCoverThumb({
    required this.room,
    required this.size,
    this.wide = false,
  });

  final SyncTvRoom room;
  final double size;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(7);
    final fallback = ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.meeting_room_outlined,
        color: theme.colorScheme.primary,
        size: wide ? 28 : 18,
      ),
    );
    final width = wide ? size * 1.35 : size;
    if (room.coverUrl.isEmpty) {
      return AppPanelSurface(
        width: width,
        height: size,
        borderRadius: borderRadius,
        child: fallback,
      );
    }
    return AppImageThumbnail(
      url: room.coverUrl,
      width: width,
      height: size,
      borderRadius: borderRadius,
      errorChild: fallback,
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _NotificationFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _PreferenceSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSwitchTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
