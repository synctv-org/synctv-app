import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class ChatReactionUsersDialog extends StatefulWidget {
  const ChatReactionUsersDialog({
    super.key,
    required this.roomId,
    required this.messageId,
    required this.reactionKey,
    required this.loadUsers,
  });

  final String roomId;
  final String messageId;
  final String reactionKey;
  final Future<ChatReactionUsersPage> Function({String cursor}) loadUsers;

  @override
  State<ChatReactionUsersDialog> createState() =>
      _ChatReactionUsersDialogState();
}

class _ChatReactionUsersDialogState extends State<ChatReactionUsersDialog> {
  final List<ChatReactionUserInfo> _users = [];
  String _nextCursor = '';
  int _total = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool loadMore = false}) async {
    if (_loading) return;
    if (loadMore && _nextCursor.isEmpty) return;
    setState(() => _loading = true);
    try {
      final page = await widget.loadUsers(cursor: loadMore ? _nextCursor : '');
      if (!mounted) return;
      setState(() {
        _total = page.total;
        _nextCursor = page.nextCursor;
        if (loadMore) {
          final existing = _users.map((user) => user.userId).toSet();
          for (final user in page.users) {
            if (existing.add(user.userId)) _users.add(user);
          }
        } else {
          _users
            ..clear()
            ..addAll(page.users);
        }
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialog(
      title: Text(context.l10n.reactionMembers(widget.reactionKey)),
      body: SizedBox(
        width: 420,
        height: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _total > 0
                  ? context.l10n.memberCount(_total)
                  : context.l10n.reactingMembers,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading && _users.isEmpty
                  ? const AppLoadingIndicator()
                  : _users.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.noMembers,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : AppListView.separated(
                      itemCount: _users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        final name = user.username.isEmpty
                            ? user.userId
                            : user.username;
                        return Row(
                          children: [
                            AppAvatar(name: name, radius: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (user.reactedAt > 0)
                                    Text(
                                      _formatTime(user.reactedAt),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
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
            if (_nextCursor.isNotEmpty) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: AppActionButton(
                  onPressed: _loading ? null : () => _load(loadMore: true),
                  loading: _loading,
                  icon: Icons.more_horiz,
                  label: context.l10n.loadMore,
                  style: AppActionButtonStyle.tonal,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => Navigator.pop(context),
          label: context.l10n.close,
          style: AppActionButtonStyle.text,
        ),
      ],
    );
  }

  static String _formatTime(int seconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    return '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
