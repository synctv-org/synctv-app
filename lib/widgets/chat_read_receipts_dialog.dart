import 'package:flutter/material.dart';
import 'package:synctv_app/models/room_media_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

class ChatReadReceiptsDialog extends StatelessWidget {
  final ChatMessageReadReceiptsInfo receipts;

  const ChatReadReceiptsDialog({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('消息阅读详情'),
      contentPadding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      content: SizedBox(
        width: 620,
        height: 460,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ChatReceiptUserColumn(
                title: '${receipts.readerTotal} 已读',
                users: receipts.readers.map((item) => item.user).toList(),
                readTimes: {
                  for (final item in receipts.readers)
                    item.user.id: item.readAt,
                },
              ),
            ),
            VerticalDivider(
              width: 28,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
            Expanded(
              child: _ChatReceiptUserColumn(
                title: '${receipts.unreadTotal} 未读',
                users: receipts.unreadMembers,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}

class _ChatReceiptUserColumn extends StatelessWidget {
  final String title;
  final List<WUser> users;
  final Map<String, int> readTimes;

  const _ChatReceiptUserColumn({
    required this.title,
    required this.users,
    this.readTimes = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: users.isEmpty
              ? Center(
                  child: Text(
                    '暂无成员',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final readAt = readTimes[user.id] ?? 0;
                    return Row(
                      children: [
                        AppAvatar(
                          name: user.username,
                          imageUrl: user.avatarUrl,
                          radius: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.username.isEmpty ? user.id : user.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (readAt > 0)
                                Text(
                                  _formatReceiptTime(readAt),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  static String _formatReceiptTime(int seconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    return '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
