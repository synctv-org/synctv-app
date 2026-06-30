import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/utils/room_taxonomy.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

class CinemaRoomCard extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String description;
  final String coverUrl;
  final int viewerCount;
  final int connectionCount;
  final int memberCount;
  final String creatorName;
  final String creatorAvatarUrl;
  final int availability;
  final bool isBanned;
  final bool needPassword;
  final bool hidden;
  final int createdAt;
  final String categoryName;
  final List<RoomLabelInfo> labels;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showScaleAnimation;

  const CinemaRoomCard({
    super.key,
    required this.roomId,
    required this.roomName,
    this.description = '',
    this.coverUrl = '',
    required this.viewerCount,
    this.connectionCount = 0,
    this.memberCount = 0,
    this.creatorName = '',
    this.creatorAvatarUrl = '',
    this.availability = 0,
    this.isBanned = false,
    required this.needPassword,
    required this.hidden,
    required this.createdAt,
    this.categoryName = '',
    this.labels = const [],
    required this.onTap,
    this.onLongPress,
    this.showScaleAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnavailable = isBanned || availability == 2;
    final statusLabel = isBanned ? '已封禁' : (availability == 2 ? '不可用' : '可加入');
    final statusColor = isUnavailable
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    final audienceText = memberCount > 0
        ? '在线 $viewerCount / 成员 $memberCount'
        : '在线 $viewerCount';
    final connectionText = connectionCount > 0 ? '$connectionCount 连接' : '暂无连接';
    final hasTaxonomy = categoryName.trim().isNotEmpty || labels.isNotEmpty;
    final dateStr = createdAt > 0
        ? DateFormat(
            'MM-dd HH:mm',
          ).format(DateTime.fromMillisecondsSinceEpoch(createdAt))
        : '';

    final card = AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoomCover(
            coverUrl: coverUrl,
            statusColor: statusColor,
            isUnavailable: isUnavailable,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
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
                const SizedBox(width: 8),
                AppBadge(
                  label: Text(statusLabel),
                  color: statusColor,
                  backgroundColor: statusColor.withValues(
                    alpha: isUnavailable ? 0.14 : 0.10,
                  ),
                  borderSide: BorderSide(
                    color: statusColor.withValues(alpha: 0.26),
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 3, 16, 0),
            child: Text(
              roomId,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
          if (hasTaxonomy)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _RoomTaxonomyRow(
                categoryName: categoryName,
                labels: labels,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _RoomCreator(name: creatorName, avatarUrl: creatorAvatarUrl),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _RoomMetric(
                  icon: Icons.people_alt_rounded,
                  label: audienceText,
                ),
                _RoomMetric(icon: Icons.link_rounded, label: connectionText),
                if (needPassword)
                  const _RoomMetric(icon: Icons.lock_rounded, label: '密码'),
                if (hidden)
                  const _RoomMetric(
                    icon: Icons.visibility_off_rounded,
                    label: '隐藏',
                  ),
                if (dateStr.isNotEmpty)
                  _RoomMetric(icon: Icons.schedule_rounded, label: dateStr),
              ],
            ),
          ),
        ],
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
}

class _RoomCreator extends StatelessWidget {
  const _RoomCreator({required this.name, required this.avatarUrl});

  final String name;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = name.trim().isEmpty ? '未知创建者' : name.trim();
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
      ],
    );
  }
}

class _RoomTaxonomyRow extends StatelessWidget {
  const _RoomTaxonomyRow({required this.categoryName, required this.labels});

  final String categoryName;
  final List<RoomLabelInfo> labels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = categoryName.trim();
    final visibleLabels = labels.take(category.isEmpty ? 3 : 2).toList();
    final overflowCount = labels.length - visibleLabels.length;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (category.isNotEmpty)
          AppBadge(
            icon: Icons.category_outlined,
            iconSize: 12,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.24),
            ),
            constraints: const BoxConstraints(maxWidth: 150),
            label: Text(category, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        for (final label in visibleLabels) _RoomLabelBadge(label: label),
        if (overflowCount > 0)
          AppBadge(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            color: theme.colorScheme.onSurfaceVariant,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.7),
            label: Text('+$overflowCount'),
          ),
      ],
    );
  }
}

class _RoomLabelBadge extends StatelessWidget {
  const _RoomLabelBadge({required this.label});

  final RoomLabelInfo label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = parseRoomLabelColor(label.color, theme.colorScheme.secondary);
    final text = label.name.trim().isEmpty ? label.key : label.name.trim();
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      color: color,
      backgroundColor: color.withValues(alpha: 0.11),
      borderSide: BorderSide(color: color.withValues(alpha: 0.24)),
      constraints: const BoxConstraints(maxWidth: 126),
      label: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _RoomCover extends StatelessWidget {
  const _RoomCover({
    required this.coverUrl,
    required this.statusColor,
    required this.isUnavailable,
  });

  final String coverUrl;
  final Color statusColor;
  final bool isUnavailable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = ColoredBox(
      color: statusColor.withValues(alpha: 0.12),
      child: Center(
        child: AppIconBadge(
          icon: isUnavailable
              ? Icons.block_rounded
              : Icons.meeting_room_rounded,
          color: statusColor,
        ),
      ),
    );
    return AppPanelSurface(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: coverUrl.isEmpty
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
              ),
      ),
    );
  }
}

class _RoomMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RoomMetric({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBadge(
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
      label: Text(label),
    );
  }
}
