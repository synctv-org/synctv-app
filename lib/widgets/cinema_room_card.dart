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
    final isDark = theme.brightness == Brightness.dark;

    const accentColor = Color(0xFFCF0A2C); // 电影红
    final cardBgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF8E8E93);
    final dividerColor = isDark ? Colors.white24 : Colors.black12;
    final audienceText = memberCount > 0 && memberCount != viewerCount
        ? '$viewerCount / $memberCount'
        : '$viewerCount';
    final isUnavailable = isBanned || availability == 2;
    final statusLabel = isBanned ? '封禁' : (availability == 2 ? '不可用' : '');

    // 格式化时间
    final dateStr = createdAt > 0
        ? DateFormat('MM-dd HH:mm')
            .format(DateTime.fromMillisecondsSinceEpoch(createdAt))
        : '';

    Widget card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: onLongPress,
          child: SizedBox(
            height: description.trim().isEmpty ? 140 : 156,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 左侧：电影票存根部分 (Stub)
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A2A35)
                        : const Color(0xFFF8F9FA),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_activity_rounded,
                        color: accentColor.withValues(alpha: 0.8),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'NO.${roomId.length > 4 ? roomId.substring(roomId.length - 4) : roomId}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: subTextColor,
                          fontFamily: 'monospace',
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 竖向条形码装饰
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          8,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: [
                              1.0,
                              3.0,
                              2.0,
                              1.0,
                              4.0,
                              2.0,
                              1.0,
                              3.0
                            ][index],
                            height: 24,
                            color: subTextColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 虚线分割 (撕票线)
                CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: TicketTearPainter(
                      color: cardBgColor, dividerColor: dividerColor),
                ),

                // 右侧：主票面信息
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 头部状态
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.1),
                                border: Border.all(
                                    color: accentColor.withValues(alpha: 0.3)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'CINEMA TICKET',
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (dateStr.isNotEmpty) ...[
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: subTextColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (needPassword)
                                  Icon(Icons.lock_rounded,
                                      size: 14, color: subTextColor),
                                if (statusLabel.isNotEmpty) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: accentColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                                if (hidden) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color:
                                          subTextColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.chair_rounded,
                                            size: 10, color: subTextColor),
                                        const SizedBox(width: 2),
                                        Text(
                                          '包场',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: subTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 房间名
                        Text(
                          roomName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (description.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description.trim(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: subTextColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const Spacer(),

                        // 底部信息 (人数 & 入场)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AUDIENCE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: subTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.person_rounded,
                                        size: 14, color: textColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      audienceText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    isUnavailable ? Colors.grey : accentColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isUnavailable
                                            ? Colors.grey
                                            : accentColor)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ADMIT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (showScaleAnimation) {
      return Focus(
        child: Builder(builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scaleByDouble(
                  hasFocus ? 1.05 : 1.0,
                  hasFocus ? 1.05 : 1.0,
                  1,
                  1,
                ),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: hasFocus ? accentColor : Colors.transparent,
                  width: hasFocus ? 4.0 : 0.0,
                ),
              ),
              child: card,
            ),
          );
        }),
      );
    }

    return card;
  }
}

// 电影票撕票线与半圆缺口绘制
class TicketTearPainter extends CustomPainter {
  final Color color;
  final Color dividerColor;

  TicketTearPainter({required this.color, required this.dividerColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制虚线
    final Paint dashPaint = Paint()
      ..color = dividerColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double radius = 10.0;
    const double dashHeight = 5.0;
    const double dashSpace = 5.0;

    // 画虚线
    double startY = radius;
    while (startY < size.height - radius) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        dashPaint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
