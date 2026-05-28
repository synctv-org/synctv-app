import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CinemaRoomCard extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String description;
  final int viewerCount;
  final int memberCount;
  final int availability;
  final bool isBanned;
  final bool needPassword;
  final bool hidden;
  final int createdAt;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showScaleAnimation;

  const CinemaRoomCard({
    super.key,
    required this.roomId,
    required this.roomName,
    this.description = '',
    required this.viewerCount,
    this.memberCount = 0,
    this.availability = 0,
    this.isBanned = false,
    required this.needPassword,
    required this.hidden,
    required this.createdAt,
    required this.onTap,
    this.onLongPress,
    this.showScaleAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = isBanned || availability == 2;
    final statusLabel = isBanned ? '已封禁' : (availability == 2 ? '不可用' : '可加入');
    final statusColor =
        isUnavailable ? theme.colorScheme.error : theme.colorScheme.primary;
    final audienceText = memberCount > 0 && memberCount != viewerCount
        ? '$viewerCount / $memberCount'
        : '$viewerCount';
    final dateStr = createdAt > 0
        ? DateFormat('MM-dd HH:mm')
            .format(DateTime.fromMillisecondsSinceEpoch(createdAt))
        : '';

    final card = Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isUnavailable
                          ? Icons.block_rounded
                          : Icons.meeting_room_rounded,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roomName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          roomId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.56),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RoomBadge(
                    label: statusLabel,
                    color: statusColor,
                    filled: isUnavailable,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Text(
                  description.trim().isEmpty ? '暂无简介' : description.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                    height: 1.32,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _RoomMetric(
                    icon: Icons.people_alt_rounded,
                    label: audienceText,
                  ),
                  if (needPassword)
                    const _RoomMetric(
                      icon: Icons.lock_rounded,
                      label: '密码',
                    ),
                  if (hidden)
                    const _RoomMetric(
                      icon: Icons.visibility_off_rounded,
                      label: '隐藏',
                    ),
                  if (dateStr.isNotEmpty)
                    _RoomMetric(
                      icon: Icons.schedule_rounded,
                      label: dateStr,
                    ),
                ],
              ),
            ],
          ),
        ),
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      hasFocus ? theme.colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: card,
            ),
          );
        },
      ),
    );
  }
}

class _RoomBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _RoomBadge({
    required this.label,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: filled ? 0.14 : 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoomMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RoomMetric({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.64),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
