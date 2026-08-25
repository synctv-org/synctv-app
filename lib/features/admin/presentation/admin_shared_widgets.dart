part of 'admin_settings_page.dart';

class _AdminPanelCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _AdminPanelCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}

class _AdminPager extends StatelessWidget {
  final int page;
  final int pageSize;
  final int? total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _AdminPager({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final total = this.total;
    final label = total == null
        ? context.l10n.pageSizeSummary(page, pageSize)
        : context.l10n.pageSizeTotalSummary(page, pageSize, total);
    return AppPaginationBar(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      label: label,
      onPrevious: onPrevious,
      onNext: onNext,
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(label, style: TextStyle(color: theme.hintColor)),
          ),
          Expanded(
            child: AppSelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCoverPreview extends StatelessWidget {
  const _RoomCoverPreview({required this.room});

  final SyncTvRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.meeting_room_outlined,
        color: theme.colorScheme.primary,
      ),
    );
    if (room.coverUrl.isEmpty) {
      return AppPanelSurface(
        width: 96,
        height: 64,
        borderRadius: BorderRadius.circular(8),
        child: fallback,
      );
    }
    return AppImageThumbnail(
      url: context.resourceUrlResolver.resolve(room.coverUrl),
      width: 96,
      height: 64,
      borderRadius: BorderRadius.circular(8),
      errorChild: fallback,
    );
  }
}

class _RoomChatHistoryDialog extends StatefulWidget {
  const _RoomChatHistoryDialog({required this.room});

  final SyncTvRoom room;

  @override
  State<_RoomChatHistoryDialog> createState() => _RoomChatHistoryDialogState();
}

class _RoomChatHistoryDialogState extends State<_RoomChatHistoryDialog> {
  final ScrollController _scrollController = ScrollController();
  final AdminChatModerationOptimisticState _moderationOptimism =
      AdminChatModerationOptimisticState();
  final Map<String, RoomChatMessageInfo> _messageIndex = {};
  final List<RoomChatMessageInfo> _messages = [];
  bool _loading = true;
  bool _loadingMore = false;
  String _nextCursor = '';
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _messages.clear();
      _messageIndex.clear();
      _moderationOptimism.clearServerMessages();
      _nextCursor = '';
    });
    await _loadPage(cursor: '');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadMore() async {
    if (_nextCursor.isEmpty || _loadingMore) return;
    setState(() => _loadingMore = true);
    await _loadPage(cursor: _nextCursor);
    if (mounted) setState(() => _loadingMore = false);
  }

  Future<void> _loadPage({required String cursor}) async {
    try {
      final page = await adminGateway.getChatHistory(
        widget.room.roomId,
        limit: 40,
        cursor: cursor,
      );
      if (!mounted) return;
      setState(() {
        for (final message in page.messages) {
          final displayMessage = _moderationOptimism.recordServerMessage(
            message,
          );
          final index = _messages.indexWhere((entry) => entry.id == message.id);
          if (index < 0) {
            _messages.add(displayMessage);
          } else {
            _messages[index] = displayMessage;
          }
          _messageIndex[message.id] = displayMessage;
        }
        _nextCursor = page.nextCursor;
      });
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.loadChatHistoryFailed('$e'),
      );
    }
  }

  Future<void> _copyMessage(RoomChatMessageInfo message) async {
    final text = _messagePreview(context, message).trim();
    if (text.isEmpty) {
      AppNotifications.showInfo(
        context,
        context.l10n.messageHasNoCopyableContent,
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      AppNotifications.showSuccess(context, context.l10n.messageCopied);
    }
  }

  Future<void> _deleteMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    final authorName = chatMessageDisplayUsername(
      messageType: message.messageType,
      username: message.username,
      missingUsername: context.l10n.deletedUser,
    );
    var deleteAllMessages = false;
    var deleteAllReactions = false;
    var banUser = false;
    final choice = await showAppDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AppConfirmDialog(
          title: context.l10n.deleteMessage,
          icon: const Icon(Icons.delete_outline_rounded),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.confirmDeleteUserMessage(authorName)),
              if (message.userId.isNotEmpty) ...[
                const SizedBox(height: 8),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  initiallyExpanded: false,
                  leading: AppCheckbox(
                    value: deleteAllMessages || deleteAllReactions,
                    semanticsLabel: context.l10n.deleteUserContent,
                    onChanged: (value) {
                      setDialogState(() {
                        deleteAllMessages = value;
                        deleteAllReactions = value;
                      });
                    },
                  ),
                  title: Text(context.l10n.deleteUserContent),
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: deleteAllMessages,
                      title: Text(context.l10n.deleteAllMessagesFromUser),
                      onChanged: (value) => setDialogState(
                        () => deleteAllMessages = value ?? false,
                      ),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: deleteAllReactions,
                      title: Text(context.l10n.deleteAllReactionsFromUser),
                      onChanged: (value) => setDialogState(
                        () => deleteAllReactions = value ?? false,
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: banUser,
                  title: Text(context.l10n.banUserFromChat),
                  onChanged: (value) =>
                      setDialogState(() => banUser = value ?? false),
                ),
              ],
            ],
          ),
          confirmLabel: context.l10n.delete,
          confirmIcon: Icons.delete_outline_rounded,
          destructive: true,
          onConfirm: () => Navigator.pop(context, true),
        ),
      ),
    );
    if (choice != true) return;
    if (!mounted) return;
    if (message.userId.isNotEmpty) {
      final intentId = _applyOptimisticModeration(
        message,
        deleteAllMessages: deleteAllMessages,
      );
      unawaited(
        _submitModeration(
          message,
          intentId: intentId,
          deleteAllMessages: deleteAllMessages,
          deleteAllReactions: deleteAllReactions,
          banUser: banUser,
        ),
      );
      return;
    }
    try {
      final updated = await adminGateway.deleteChatMessage(
        widget.room.roomId,
        message.id,
        expectedVersion: message.version,
        reason: 'admin_deleted',
      );
      final displayMessage = _moderationOptimism.recordServerMessage(updated);
      _messageIndex[updated.id] = displayMessage;
      if (!mounted) return;
      setState(() {
        final index = _messages.indexWhere((entry) => entry.id == message.id);
        if (index >= 0) _messages[index] = displayMessage;
      });
      AppNotifications.showSuccess(context, context.l10n.messageDeleted);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteMessageFailed('$e'),
        );
      }
    }
  }

  int _applyOptimisticModeration(
    RoomChatMessageInfo message, {
    required bool deleteAllMessages,
  }) {
    final intentId = _moderationOptimism.begin(
      messageId: message.id,
      userId: message.userId,
      deleteAllMessages: deleteAllMessages,
    );
    setState(() {
      for (var index = 0; index < _messages.length; index++) {
        final displayMessage = _moderationOptimism.messageForDisplay(
          _messages[index].id,
        );
        if (displayMessage == null) continue;
        _messages[index] = displayMessage;
        _messageIndex[displayMessage.id] = displayMessage;
      }
    });
    return intentId;
  }

  void _discardOptimisticModeration(int intentId) {
    _moderationOptimism.discard(intentId);
    if (!mounted) return;
    setState(() {
      for (var index = 0; index < _messages.length; index++) {
        final displayMessage = _moderationOptimism.messageForDisplay(
          _messages[index].id,
        );
        if (displayMessage == null) continue;
        _messages[index] = displayMessage;
        _messageIndex[displayMessage.id] = displayMessage;
      }
    });
  }

  Future<void> _submitModeration(
    RoomChatMessageInfo message, {
    required int intentId,
    required bool deleteAllMessages,
    required bool deleteAllReactions,
    required bool banUser,
  }) async {
    try {
      await adminGateway.adminModerateRoomChatUser(
        widget.room.roomId,
        message.userId,
        deleteAllMessages: deleteAllMessages,
        deleteAllReactions: deleteAllReactions,
        ban: banUser,
        messageId: message.id,
        reason: 'chat_moderation',
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to submit chat moderation: $error\n$stackTrace');
      _discardOptimisticModeration(intentId);
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteMessageFailed('$error'),
        );
      }
    }
  }

  Future<void> _reportMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    final reasons = <String, String>{
      'spam': context.l10n.reportReasonSpam,
      'abuse': context.l10n.reportReasonAbuse,
      'illegal': context.l10n.reportReasonIllegal,
      'sexual': context.l10n.reportReasonSexual,
      'other': context.l10n.reportReasonOther,
    };
    var selectedReason = 'spam';
    final detailController = TextEditingController();
    final submitted = await showAppDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(context.l10n.reportMessage),
              icon: const Icon(Icons.flag_outlined),
              body: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasons.entries
                          .map(
                            (entry) => ChoiceChip(
                              label: Text(entry.value),
                              selected: selectedReason == entry.key,
                              onSelected: (_) => setDialogState(
                                () => selectedReason = entry.key,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: detailController,
                      label: context.l10n.additionalDetails,
                      hintText: context.l10n.describeIssue,
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  icon: Icons.flag_outlined,
                  label: context.l10n.submit,
                ),
                _closeButton(dialogContext),
              ],
            );
          },
        );
      },
    );
    try {
      if (submitted != true) return;
      await adminGateway.reportChatMessage(
        widget.room.roomId,
        message.id,
        reasonCode: selectedReason,
        reason: detailController.text,
      );
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.reportSubmitted);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reportFailed('$e'));
      }
    } finally {
      detailController.dispose();
    }
  }

  Future<void> _showContext(RoomChatMessageInfo message) async {
    try {
      final contextInfo = await adminGateway.getChatMessageContext(
        widget.room.roomId,
        message.id,
        beforeLimit: 8,
        afterLimit: 8,
        includeDeleted: true,
      );
      if (!mounted) return;
      await showAppDialog<void>(
        context: context,
        builder: (_) => _RoomChatContextDialog(
          room: widget.room,
          contextInfo: contextInfo,
          onCopy: _copyMessage,
          onDelete: _deleteMessage,
          onReport: _reportMessage,
        ),
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadMessageContextFailed('$e'),
        );
      }
    }
  }

  void _jumpToReply(RoomChatMessageInfo message) {
    final replyId = message.replyToMessageId;
    if (replyId.isEmpty) return;
    final index = _messages.indexWhere((entry) => entry.id == replyId);
    if (index < 0) {
      _showContext(message);
      return;
    }
    _scrollController.animateTo(
      index * 118.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
    setState(() => _highlightedMessageId = replyId);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted || _highlightedMessageId != replyId) return;
      setState(() => _highlightedMessageId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: 920,
      maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      child: AppPanelSurface(
        color: theme.colorScheme.surface,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogHeader(
              icon: Icons.forum_outlined,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.chatHistory),
                  Text(
                    widget.room.roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  AppBadge(
                    icon: Icons.message_outlined,
                    label: Text(context.l10n.messagesLoaded(_messages.length)),
                  ),
                  const SizedBox(width: 8),
                  if (_nextCursor.isNotEmpty)
                    AppBadge(
                      icon: Icons.more_horiz_rounded,
                      label: Text(context.l10n.olderMessagesAvailable),
                    ),
                  const Spacer(),
                  AppIconButton(
                    tooltip: context.l10n.refresh,
                    icon: Icons.refresh_rounded,
                    onPressed: _loadInitial,
                  ),
                ],
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 620,
                child: _loading
                    ? const AppLoadingIndicator()
                    : _messages.isEmpty
                    ? AppEmptyMessage(message: context.l10n.noChatMessages)
                    : AppListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        itemCount:
                            _messages.length + (_nextCursor.isEmpty ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= _messages.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: AppActionButton(
                                  onPressed: _loadingMore ? null : _loadMore,
                                  icon: Icons.history_rounded,
                                  label: _loadingMore
                                      ? context.l10n.loading
                                      : context.l10n.loadOlderMessages,
                                  style: AppActionButtonStyle.outlined,
                                ),
                              ),
                            );
                          }
                          final message = _messages[index];
                          return _AdminChatMessageCard(
                            message: message,
                            quoted: _messageIndex[message.replyToMessageId],
                            highlighted: _highlightedMessageId == message.id,
                            onCopy: () => _copyMessage(message),
                            onDelete: () => _deleteMessage(message),
                            onReport: () => _reportMessage(message),
                            onContext: () => _showContext(message),
                            onJumpToReply: () => _jumpToReply(message),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomChatContextDialog extends StatelessWidget {
  const _RoomChatContextDialog({
    required this.room,
    required this.contextInfo,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
  });

  final SyncTvRoom room;
  final ChatMessageContextInfo contextInfo;
  final Future<void> Function(RoomChatMessageInfo message) onCopy;
  final Future<void> Function(RoomChatMessageInfo message) onDelete;
  final Future<void> Function(RoomChatMessageInfo message) onReport;

  @override
  Widget build(BuildContext context) {
    final messages = [
      ...contextInfo.before,
      contextInfo.message,
      ...contextInfo.after,
    ];
    return AppDialogFrame(
      maxWidth: 760,
      maxHeight: MediaQuery.sizeOf(context).height * 0.78,
      child: AppPanelSurface(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogHeader(
              icon: Icons.manage_search_rounded,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.messageContext),
                  Text(
                    room.roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: AppListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _AdminChatMessageCard(
                    message: message,
                    highlighted: message.id == contextInfo.message.id,
                    onCopy: () => onCopy(message),
                    onDelete: () => onDelete(message),
                    onReport: () => onReport(message),
                    onContext: null,
                    onJumpToReply: null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminChatMessageCard extends StatelessWidget {
  const _AdminChatMessageCard({
    required this.message,
    this.quoted,
    this.highlighted = false,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
    this.onContext,
    this.onJumpToReply,
  });

  final RoomChatMessageInfo message;
  final RoomChatMessageInfo? quoted;
  final bool highlighted;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final VoidCallback? onContext;
  final VoidCallback? onJumpToReply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDeleted = message.isDeleted;
    final authorName = chatMessageDisplayUsername(
      messageType: message.messageType,
      username: message.username,
      missingUsername: context.l10n.deletedUser,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: highlighted
            ? scheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppPanelSurface(
        color: isDeleted
            ? scheme.errorContainer.withValues(alpha: 0.16)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted
              ? scheme.primary.withValues(alpha: 0.36)
              : scheme.outlineVariant.withValues(alpha: 0.64),
        ),
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAvatar(
                  name: authorName,
                  radius: 15,
                  backgroundColor: scheme.primary.withValues(alpha: 0.10),
                  foregroundColor: scheme.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.l10n.messageAuthorTime(
                          message.userId.isEmpty
                              ? context.l10n.anonymous
                              : message.userId,
                          _formatTimestamp(message.timestamp),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (message.isEdited && !isDeleted)
                  AppBadge(
                    icon: Icons.edit_outlined,
                    label: Text(context.l10n.edited),
                  ),
                if (isDeleted)
                  AppBadge(
                    icon: Icons.delete_outline_rounded,
                    label: Text(context.l10n.deleted),
                    color: scheme.error,
                    backgroundColor: scheme.errorContainer.withValues(
                      alpha: 0.32,
                    ),
                  ),
              ],
            ),
            if (message.replyToMessageId.isNotEmpty) ...[
              const SizedBox(height: 9),
              _AdminQuotedMessage(
                messageId: message.replyToMessageId,
                quoted: quoted,
                onTap: onJumpToReply,
              ),
            ],
            if (message.content.trim().isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(
                isDeleted
                    ? context.l10n.messageDeletedContent
                    : message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDeleted ? scheme.onSurfaceVariant : scheme.onSurface,
                  height: 1.34,
                ),
              ),
            ],
            if (message.images.isNotEmpty) ...[
              const SizedBox(height: 10),
              _AdminChatImageGrid(images: message.images),
            ],
            if (message.reactions.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: topChatReactions(message.reactions, limit: 8)
                    .map(
                      (reaction) => AppBadge(
                        label: Text('${reaction.key} ${reaction.count}'),
                        color: reaction.reactedByMe
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        backgroundColor: reaction.reactedByMe
                            ? scheme.primary.withValues(alpha: 0.12)
                            : scheme.surface.withValues(alpha: 0.64),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                AppActionButton(
                  onPressed: onCopy,
                  icon: Icons.copy_rounded,
                  label: context.l10n.copy,
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                if (onContext != null)
                  AppActionButton(
                    onPressed: onContext,
                    icon: Icons.manage_search_rounded,
                    label: context.l10n.context,
                    size: AppActionButtonSize.sm,
                    style: AppActionButtonStyle.text,
                  ),
                AppActionButton(
                  onPressed: onReport,
                  icon: Icons.flag_outlined,
                  label: context.l10n.report,
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: isDeleted ? null : onDelete,
                  icon: Icons.delete_outline_rounded,
                  label: context.l10n.delete,
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.destructive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminQuotedMessage extends StatelessWidget {
  const _AdminQuotedMessage({
    required this.messageId,
    required this.quoted,
    this.onTap,
  });

  final String messageId;
  final RoomChatMessageInfo? quoted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = quoted == null
        ? context.l10n.quotedMessage
        : chatMessageDisplayUsername(
            messageType: quoted!.messageType,
            username: quoted!.username,
            missingUsername: context.l10n.deletedUser,
          );
    final preview = quoted == null
        ? context.l10n.tapToViewContext
        : _messagePreview(context, quoted!);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: AppPanelSurface(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 34,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview.isEmpty ? messageId : preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminChatImageGrid extends StatelessWidget {
  const _AdminChatImageGrid({required this.images});

  final List<StoredImageInfo> images;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((image) {
        final url = context.resourceUrlResolver.resolve(image.url);
        return AppImageThumbnail(
          url: url,
          width: 116,
          height: 86,
          borderRadius: BorderRadius.circular(7),
          errorChild: ColoredBox(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            child: const Icon(Icons.broken_image_outlined),
          ),
        );
      }).toList(),
    );
  }
}

String _messagePreview(BuildContext context, RoomChatMessageInfo message) {
  final parts = <String>[];
  if (message.content.trim().isNotEmpty) parts.add(message.content.trim());
  if (message.images.isNotEmpty) {
    parts.add(context.l10n.imageCount(message.images.length));
  }
  final reactionSuffix = chatReactionSummarySuffix(message.reactions, limit: 2);
  if (reactionSuffix.isNotEmpty) parts.add(reactionSuffix.trim());
  return parts.join(' ');
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatTile(this.label, this.value, this.icon, this.color, this.isDark);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: _AdminPanelCard(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 12),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ),
    );
  }
}

String _reviewStatusText(
  BuildContext context,
  common_enum.ReviewStatus status,
) {
  return switch (status) {
    common_enum.ReviewStatus.REVIEW_STATUS_PENDING =>
      context.l10n.pendingReview,
    common_enum.ReviewStatus.REVIEW_STATUS_APPROVED => context.l10n.approved,
    common_enum.ReviewStatus.REVIEW_STATUS_REJECTED => context.l10n.rejected,
    _ => context.l10n.unknown,
  };
}

String _providerStatusText(
  BuildContext context,
  provider_common_enum.ProviderInstanceStatus status,
) {
  return switch (status) {
    provider_common_enum
        .ProviderInstanceStatus
        .PROVIDER_INSTANCE_STATUS_CONNECTED =>
      context.l10n.connected,
    provider_common_enum
        .ProviderInstanceStatus
        .PROVIDER_INSTANCE_STATUS_DISCONNECTED =>
      context.l10n.disconnected,
    provider_common_enum
        .ProviderInstanceStatus
        .PROVIDER_INSTANCE_STATUS_ERROR =>
      context.l10n.error,
    _ => context.l10n.unknown,
  };
}

String _systemRoleText(BuildContext context, SyncTvUserRole role) {
  return switch (role) {
    AccountUserRole(value: common_enum.UserRole.USER_ROLE_ROOT) => 'Root',
    AccountUserRole(value: common_enum.UserRole.USER_ROLE_ADMIN) =>
      context.l10n.administrator,
    AccountUserRole(value: common_enum.UserRole.USER_ROLE_USER) =>
      context.l10n.user,
    _ => context.l10n.unknown,
  };
}

String _userStatusText(BuildContext context, common_enum.UserStatus status) {
  return switch (status) {
    common_enum.UserStatus.USER_STATUS_ACTIVE => context.l10n.active,
    common_enum.UserStatus.USER_STATUS_BANNED => context.l10n.banned,
    _ => context.l10n.unknown,
  };
}

String _roomStatusText(BuildContext context, common_enum.RoomStatus status) {
  return switch (status) {
    common_enum.RoomStatus.ROOM_STATUS_ACTIVE => context.l10n.active,
    common_enum.RoomStatus.ROOM_STATUS_CLOSED => context.l10n.closed,
    _ => context.l10n.unknown,
  };
}

String _resourceAvailabilityText(
  BuildContext context,
  client_enum.ResourceAvailability availability,
) {
  return switch (availability) {
    client_enum.ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE =>
      context.l10n.available,
    client_enum.ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE =>
      context.l10n.creatorUnavailable,
    _ => context.l10n.unknown,
  };
}

Color _roomStatusColor(common_enum.RoomStatus status) {
  return switch (status) {
    common_enum.RoomStatus.ROOM_STATUS_ACTIVE => Colors.green,
    common_enum.RoomStatus.ROOM_STATUS_CLOSED => Colors.grey,
    _ => Colors.grey,
  };
}

String _roomMemberRoleText(
  BuildContext context,
  common_enum.RoomMemberRole role,
) {
  return switch (role) {
    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR => context.l10n.creator,
    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN =>
      context.l10n.administrator,
    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER => context.l10n.member,
    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST => context.l10n.guest,
    _ => context.l10n.unknown,
  };
}

enum _RoomPasswordAction { keep, update, clear }

enum _PermissionOverrideMode { inherit, allow, deny }

class _PermissionOverrideResult {
  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;

  const _PermissionOverrideResult({
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
  });
}

Widget _closeButton(BuildContext context) {
  return AppActionButton(
    onPressed: () => Navigator.pop(context),
    label: context.l10n.close,
    style: AppActionButtonStyle.text,
  );
}

String _formatTimestamp(int timestamp) {
  if (timestamp <= 0) return '-';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
