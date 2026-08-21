import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class CinemaRoomCard extends StatelessWidget {
  final String roomName;
  final String description;
  final String coverUrl;
  final int onlineMemberCount;
  final int onlineGuestCount;
  final String creatorName;
  final String creatorAvatarUrl;
  final bool creatorBlocked;
  final client_enum.ResourceAvailability availability;
  final bool isBanned;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onLongPress;
  final bool isFavorite;
  final bool favoriteLoading;
  final bool isOwner;
  final bool joined;
  final bool canJoin;
  final client_enum.RoomDiscoveryAccess discoveryAccess;
  final bool showScaleAnimation;

  const CinemaRoomCard({
    super.key,
    required this.roomName,
    this.description = '',
    this.coverUrl = '',
    required this.onlineMemberCount,
    required this.onlineGuestCount,
    this.creatorName = '',
    this.creatorAvatarUrl = '',
    this.creatorBlocked = false,
    this.availability =
        client_enum.ResourceAvailability.RESOURCE_AVAILABILITY_UNSPECIFIED,
    this.isBanned = false,
    required this.onTap,
    this.onFavoritePressed,
    this.onLongPress,
    this.isFavorite = false,
    this.favoriteLoading = false,
    this.isOwner = false,
    this.joined = false,
    this.canJoin = false,
    this.discoveryAccess =
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNSPECIFIED,
    this.showScaleAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isUnavailable =
        isBanned ||
        availability ==
            client_enum
                .ResourceAvailability
                .RESOURCE_AVAILABILITY_CREATOR_INACTIVE ||
        discoveryAccess ==
            client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNAVAILABLE;
    final statusLabel = isBanned ? l10n.roomBanned : _accessLabel(context);
    final isGuestAccess =
        discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST;
    final statusColor = isUnavailable
        ? theme.colorScheme.error
        : isGuestAccess
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;
    final audienceText = l10n.roomOnlineTotal(
      onlineMemberCount + onlineGuestCount,
    );
    final audienceTooltip = l10n.roomPresenceSummary(
      onlineMemberCount,
      onlineGuestCount,
    );

    final card = AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      onTap: onTap,
      onLongPress: onLongPress,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 260) {
            return _CompactRoomCard(
              roomName: roomName,
              description: description,
              coverUrl: coverUrl,
              creatorName: creatorName,
              creatorBlocked: creatorBlocked,
              audienceText: audienceText,
              audienceTooltip: audienceTooltip,
              statusLabel: statusLabel,
              statusColor: statusColor,
              isUnavailable: isUnavailable,
              isFavorite: isFavorite,
              favoriteLoading: favoriteLoading,
              onFavoritePressed: onFavoritePressed,
            );
          }

          final coverHeight = (constraints.maxWidth / 2).clamp(
            120.0,
            constraints.maxHeight - 108,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: coverHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _RoomCover(
                      roomName: roomName,
                      coverUrl: coverUrl,
                      statusColor: statusColor,
                      isUnavailable: isUnavailable,
                      fill: true,
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: AppBadge(
                        label: Text(statusLabel),
                        color: statusColor,
                        backgroundColor: theme.colorScheme.surface.withValues(
                          alpha: 0.92,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              roomName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (onFavoritePressed != null)
                            AppIconButton(
                              tooltip: isFavorite
                                  ? l10n.removeFavorite
                                  : l10n.favoriteRoom,
                              icon: Icons.bookmark_border_rounded,
                              selectedIcon: Icons.bookmark_rounded,
                              selected: isFavorite,
                              loading: favoriteLoading,
                              onPressed: onFavoritePressed,
                              style: AppIconButtonStyle.ghost,
                              size: AppIconButtonSize.sm,
                              constraints: const BoxConstraints.tightFor(
                                width: 30,
                                height: 30,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _RoomCreator(
                        name: creatorName,
                        avatarUrl: creatorAvatarUrl,
                        blocked: creatorBlocked,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              description.trim().isEmpty
                                  ? l10n.noDescription
                                  : description.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: _RoomMetric(
                              icon: Icons.people_alt_rounded,
                              label: audienceText,
                              tooltip: audienceTooltip,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (!showScaleAnimation) return card;

    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return AnimatedScale(
            scale: hasFocus ? 1.02 : 1,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            child: AppAnimatedPanelSurface(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: hasFocus
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
              child: card,
            ),
          );
        },
      ),
    );
  }

  String _accessLabel(BuildContext context) {
    final l10n = context.l10n;
    if (isBanned ||
        availability ==
            client_enum
                .ResourceAvailability
                .RESOURCE_AVAILABILITY_CREATOR_INACTIVE ||
        discoveryAccess ==
            client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNAVAILABLE) {
      return l10n.roomUnavailableShort;
    }
    if (isOwner) return l10n.createdByMe;
    if (joined) return l10n.roomJoined;
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST) {
      return l10n.roomGuestAccess;
    }
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_PASSWORD) {
      return l10n.passwordRequiredShort;
    }
    if (discoveryAccess ==
        client_enum
            .RoomDiscoveryAccess
            .ROOM_DISCOVERY_ACCESS_REQUEST_APPROVAL) {
      return l10n.roomApprovalRequired;
    }
    if (discoveryAccess ==
        client_enum
            .RoomDiscoveryAccess
            .ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL) {
      return l10n.roomApprovalPending;
    }
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_SIGN_IN) {
      return l10n.signInToJoin;
    }
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_INVITATION) {
      return l10n.roomInvitationOnly;
    }
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_FULL) {
      return l10n.roomFull;
    }
    if (discoveryAccess ==
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_COOLDOWN) {
      return l10n.roomJoinCooldown;
    }
    return canJoin ? l10n.roomJoinable : l10n.roomUnavailableShort;
  }
}

class _CompactRoomCard extends StatelessWidget {
  const _CompactRoomCard({
    required this.roomName,
    required this.description,
    required this.coverUrl,
    required this.creatorName,
    required this.creatorBlocked,
    required this.audienceText,
    required this.audienceTooltip,
    required this.statusLabel,
    required this.statusColor,
    required this.isUnavailable,
    required this.isFavorite,
    required this.favoriteLoading,
    required this.onFavoritePressed,
  });

  final String roomName;
  final String description;
  final String coverUrl;
  final String creatorName;
  final bool creatorBlocked;
  final String audienceText;
  final String audienceTooltip;
  final String statusLabel;
  final Color statusColor;
  final bool isUnavailable;
  final bool isFavorite;
  final bool favoriteLoading;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        _RoomCover(
          roomName: roomName,
          coverUrl: coverUrl,
          statusColor: statusColor,
          isUnavailable: isUnavailable,
          fill: true,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.78),
              ],
              stops: const [0.32, 1],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: AppBadge(
            label: Text(statusLabel),
            color: statusColor,
            backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.92),
          ),
        ),
        if (creatorBlocked)
          Positioned(
            top: 42,
            left: 10,
            child: AppBadge(
              icon: Icons.block_rounded,
              label: Text(context.l10n.blockedCreator),
              color: theme.colorScheme.error,
              backgroundColor: theme.colorScheme.surface.withValues(
                alpha: 0.92,
              ),
            ),
          ),
        if (onFavoritePressed != null)
          Positioned(
            top: 8,
            right: 8,
            child: AppIconButton(
              tooltip: isFavorite
                  ? context.l10n.removeFavorite
                  : context.l10n.favoriteRoom,
              icon: Icons.bookmark_border_rounded,
              selectedIcon: Icons.bookmark_rounded,
              selected: isFavorite,
              loading: favoriteLoading,
              onPressed: onFavoritePressed,
              style: AppIconButtonStyle.filled,
              size: AppIconButtonSize.sm,
            ),
          ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                roomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (description.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  description.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      creatorName.trim().isEmpty
                          ? context.l10n.unknownCreator
                          : creatorName.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.people_alt_rounded,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: AppTooltip(
                      message: audienceTooltip,
                      child: Text(
                        audienceText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomCreator extends StatelessWidget {
  const _RoomCreator({
    required this.name,
    required this.avatarUrl,
    required this.blocked,
  });

  final String name;
  final String avatarUrl;
  final bool blocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = name.trim().isEmpty
        ? context.l10n.unknownCreator
        : name.trim();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAvatar(
          name: label,
          imageUrl: avatarUrl,
          radius: 12,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          foregroundColor: theme.colorScheme.primary,
          textStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (blocked) ...[
          const SizedBox(width: 8),
          AppBadge(
            icon: Icons.block_rounded,
            label: Text(context.l10n.blockedCreator),
            color: theme.colorScheme.error,
            backgroundColor: theme.colorScheme.errorContainer,
          ),
        ],
      ],
    );
  }
}

class _RoomCover extends StatelessWidget {
  const _RoomCover({
    required this.roomName,
    required this.coverUrl,
    required this.statusColor,
    required this.isUnavailable,
    this.fill = false,
  });

  final String roomName;
  final String coverUrl;
  final Color statusColor;
  final bool isUnavailable;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accents = <Color>[
      const Color(0xFF2563EB),
      const Color(0xFF0F766E),
      const Color(0xFFB45309),
      const Color(0xFFBE185D),
      const Color(0xFF6D28D9),
      const Color(0xFF047857),
    ];
    final hash = roomName.runes.fold<int>(0, (value, rune) => value + rune);
    final accent = isUnavailable
        ? theme.colorScheme.error
        : accents[hash % accents.length];
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.88),
            Color.lerp(accent, const Color(0xFF111827), 0.48)!,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -14,
            bottom: -18,
            child: Icon(
              isUnavailable ? Icons.block_rounded : Icons.live_tv_rounded,
              size: 128,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Center(
            child: AppIconBadge(
              icon: isUnavailable ? Icons.block_rounded : Icons.live_tv_rounded,
              color: Colors.white,
              size: 46,
              iconSize: 25,
              backgroundAlpha: 0.14,
            ),
          ),
        ],
      ),
    );
    final image = coverUrl.isEmpty
        ? fallback
        : Stack(
            fit: StackFit.expand,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return AppImageThumbnail(
                    url: coverUrl,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    borderRadius: BorderRadius.zero,
                    errorChild: fallback,
                  );
                },
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.surface.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
            ],
          );
    return AppPanelSurface(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: fill
          ? SizedBox.expand(child: image)
          : AspectRatio(aspectRatio: 16 / 8, child: image),
    );
  }
}

class _RoomMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;

  const _RoomMetric({
    required this.icon,
    required this.label,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppTooltip(
      message: tooltip,
      child: AppBadge(
        icon: icon,
        iconSize: 14,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.62,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        textStyle: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
          fontWeight: FontWeight.w600,
        ),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
