import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../models/chat_detail_time.dart';

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
  final Set<String> _loadedCursors = {};
  int _loadRevision = 0;
  String _nextCursor = '';
  int _total = 0;
  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ChatReactionUsersDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roomId != widget.roomId ||
        oldWidget.messageId != widget.messageId ||
        oldWidget.reactionKey != widget.reactionKey) {
      _users.clear();
      _loadedCursors.clear();
      _nextCursor = '';
      _total = 0;
      _loading = false;
      _load();
    }
  }

  Future<void> _load({bool loadMore = false}) async {
    if (_loading) return;
    if (loadMore && _nextCursor.isEmpty) return;
    final revision = ++_loadRevision;
    final cursor = loadMore ? _nextCursor : '';
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await widget.loadUsers(cursor: cursor);
      if (!mounted || revision != _loadRevision) return;
      setState(() {
        _total = page.total;
        if (!loadMore) _loadedCursors.clear();
        _loadedCursors.add(cursor);
        _nextCursor = _loadedCursors.contains(page.nextCursor)
            ? ''
            : page.nextCursor;
        final members = <String, ChatReactionUserInfo>{
          if (loadMore)
            for (final user in _users) user.userId: user,
          for (final user in page.users) user.userId: user,
        };
        _users
          ..clear()
          ..addAll(members.values);
      });
    } catch (error) {
      if (mounted && revision == _loadRevision) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted && revision == _loadRevision) {
        setState(() => _loading = false);
      }
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
                        _error == null
                            ? context.l10n.noMembers
                            : context.l10n.loadFailed('$_error'),
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
                        final reactedAt = formatChatDetailTime(user.reactedAt);
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
                                  if (reactedAt != null)
                                    Text(
                                      reactedAt,
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
            if (_error != null || _nextCursor.isNotEmpty) ...[
              const SizedBox(height: 12),
              if (_error != null && _users.isNotEmpty)
                Text(
                  context.l10n.loadFailed('$_error'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: AppActionButton(
                  onPressed: _loading
                      ? null
                      : () => _load(loadMore: _nextCursor.isNotEmpty),
                  loading: _loading,
                  icon: _error == null ? Icons.more_horiz : Icons.refresh,
                  label: _error == null
                      ? context.l10n.loadMore
                      : context.l10n.retry,
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
}
