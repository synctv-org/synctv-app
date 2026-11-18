part of '../room_screen.dart';

mixin _RoomChatTab on _RoomScreenBase {
  @override
  Widget _buildChatTab() {
    final theme = Theme.of(context);
    return Column(
      key: _chatTabKey,
      children: [
        _buildVoiceControl(theme),
        if (_pinnedMessages.isNotEmpty || _pinnedMessagesLoading)
          _buildPinnedChatMessagesBar(theme),
        Expanded(
          child: Stack(
            children: [
              AppListView.builder(
                controller: _chatScrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 56),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Column(
                    children: [
                      if (_startsDay(index, msg))
                        _buildChatDateDivider(msg.timestampMillis),
                      _buildChatMessageItem(msg),
                    ],
                  );
                },
              ),
              if (_showChatScrollToBottom)
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: AppFloatingActionButton(
                    heroTag: 'desktop_chat_scroll_to_bottom',
                    onPressed: _scrollToBottom,
                    tooltip: context.l10n.scrollToBottom,
                    icon: Icons.keyboard_arrow_down_rounded,
                    small: true,
                  ),
                ),
            ],
          ),
        ),
        if (_canSendChatMessages) ...[
          const AppDivider(height: 1),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
            ),
            child: _buildChatInputArea(),
          ),
        ],
      ],
    );
  }

  Widget _buildPinnedChatMessagesBar(ThemeData theme) {
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.52),
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.62),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Icon(Icons.push_pin_rounded, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            context.l10n.pinned,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _pinnedMessagesLoading && _pinnedMessages.isEmpty
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    ),
                  )
                : AppSingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final message in _pinnedMessages)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: _buildPinnedChatMessageChip(message, theme),
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 6),
          AppIconButton(
            tooltip: context.l10n.refreshPinnedMessages,
            iconSize: 18,
            size: AppIconButtonSize.sm,
            onPressed: _pinnedMessagesLoading ? null : _loadPinnedChatMessages,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedChatMessageChip(
    RoomRealtimeChatEntry message,
    ThemeData theme,
  ) {
    final scheme = theme.colorScheme;
    final note = message.pin?.note.trim() ?? '';
    final preview = _chatPreviewText(message);
    final title = note.isEmpty ? message.username : note;
    final subtitle = note.isEmpty ? preview : '${message.username}: $preview';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _jumpToChatMessage(message.id),
        child: AppPanelSurface(
          color: scheme.surface.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: context.l10n.unpin,
                iconSize: 17,
                size: AppIconButtonSize.sm,
                style: AppIconButtonStyle.ghost,
                onPressed: () => _toggleChatPin(message),
                icon: Icons.close_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInputArea() {
    final mentionCandidates = <String, SyncTvUser>{};
    for (final member in _mentionCandidates) {
      if (member.id.isNotEmpty) mentionCandidates[member.id] = member;
    }
    for (final member in _members) {
      if (member.id.isNotEmpty) {
        mentionCandidates.putIfAbsent(member.id, () => member);
      }
    }
    final currentUser = _currentUser;
    if (currentUser != null && currentUser.id.isNotEmpty) {
      mentionCandidates[currentUser.id] = currentUser;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingToMessage != null) ...[
          _buildReplyComposerPreview(_replyingToMessage!),
          const SizedBox(height: 8),
        ],
        ChatInputArea(
          textController: _messageController,
          isVoiceInputMode: false,
          isLoading: _sendingChatMessage,
          conversationType: 'synctv',
          onSendMessage: () => _sendMessage(_messageController.text),
          mentionCandidates: mentionCandidates.values.toList(),
          mentionCandidatesLoading: _mentionCandidatesLoading,
          mentionCandidatesHasMore: _mentionCandidatesHasMore,
          onMentionsChanged: (mentions) {
            _pendingChatMentions = mentions;
          },
          onMentionQueryChanged: _handleMentionQueryChanged,
          onMentionLoadMore: _loadMoreMentionCandidates,
          onSwitchToVoiceMode: () {},
          onShowImagePicker: _pickChatImage,
          onStartRecording: () {},
          onStopRecording: () {},
          onCancelRecording: () {},
          selectedImageBytes: _selectedChatImage?.previewBytes,
          onCancelSelectedImage: () {
            setState(() => _selectedChatImage = null);
          },
        ),
      ],
    );
  }

  Widget _buildReplyComposerPreview(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.replyingTo(message.username),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _chatPreviewText(message),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            tooltip: context.l10n.cancelReply,
            iconSize: 18,
            size: AppIconButtonSize.sm,
            onPressed: () => setState(() => _replyingToMessage = null),
            icon: Icons.close_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildChatImageGrid(List<StoredImageInfo> images) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((image) => _buildChatImageThumb(image)).toList(),
    );
  }

  /// Whether the message at [index] opens a new calendar day in the chat
  /// timeline, so a date divider renders above it.
  bool _startsDay(int index, RoomRealtimeChatEntry message) {
    if (index <= 0) return true;
    final previous = _messages[index - 1];
    if (previous.timestampMillis == message.timestampMillis) return false;
    return !_sameCalendarDay(previous.timestampMillis, message.timestampMillis);
  }

  bool _sameCalendarDay(int millisA, int millisB) {
    final a = DateTime.fromMillisecondsSinceEpoch(millisA);
    final b = DateTime.fromMillisecondsSinceEpoch(millisB);
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildChatDateDivider(int timestampMillis) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(date.year, date.month, date.day);
    final differenceInDays = today.difference(thatDay).inDays;
    final String label;
    if (thatDay == today) {
      label = l10n.chatDateToday;
    } else if (differenceInDays == 1) {
      label = l10n.chatDateYesterday;
    } else {
      label = DateFormat('yMMMd').format(date);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.8,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessageItem(RoomRealtimeChatEntry message) {
    if (message.isDeleted) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isMine =
        _currentUser != null &&
        message.userId.isNotEmpty &&
        message.userId == _currentUser!.id;
    final alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final messageKey = message.dedupeKey;
    final actionsVisible =
        message.id.isNotEmpty &&
        (_hoveredChatMessageId == messageKey ||
            _activeChatMessageId == messageKey);
    final reactionsVisible =
        message.id.isNotEmpty && _expandedChatActionMessageId == messageKey;
    final bubbleColor = isMine
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.72);
    final borderColor = isMine
        ? scheme.primary.withValues(alpha: 0.22)
        : scheme.outlineVariant.withValues(alpha: 0.55);
    final textColor = isMine ? scheme.onPrimaryContainer : scheme.onSurface;
    final authorColor = isMine
        ? scheme.primary
        : scheme.onSurfaceVariant.withValues(alpha: 0.92);
    final replyPreview = _replyPreviewFor(message);
    final highlighted =
        message.id.isNotEmpty && _highlightedChatMessageId == message.id;
    final itemKey = message.id.isEmpty ? null : _chatMessageKey(message.id);

    return MouseRegion(
      key: itemKey,
      onEnter: (_) => setState(() => _hoveredChatMessageId = messageKey),
      onExit: (_) {
        if (_activeChatMessageId != messageKey &&
            _expandedChatActionMessageId != messageKey) {
          setState(() => _hoveredChatMessageId = null);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: (details) {
          setState(() {
            _activeChatMessageId = messageKey;
            _hoveredChatMessageId = messageKey;
          });
          _showChatMessageContextMenu(message, details.globalPosition);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: highlighted
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ChatMessageHoverLayout(
                alignEnd: isMine,
                actions: actionsVisible
                    ? _buildChatMessageActionBar(
                        message,
                        isMine,
                        showReactions: reactionsVisible,
                      )
                    : null,
                message: Column(
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    AppPanelSurface(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        topRight: const Radius.circular(8),
                        bottomLeft: Radius.circular(isMine ? 8 : 3),
                        bottomRight: Radius.circular(isMine ? 3 : 8),
                      ),
                      border: Border.all(color: borderColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  message.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: authorColor,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                message.timeLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant.withValues(
                                    alpha: 0.68,
                                  ),
                                  height: 1.15,
                                ),
                              ),
                              if (message.isEdited) ...[
                                const SizedBox(width: 6),
                                Text(
                                  context.l10n.edited,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant.withValues(
                                      alpha: 0.62,
                                    ),
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (message.replyToMessageId.isNotEmpty) ...[
                            const SizedBox(height: 7),
                            _buildQuotedChatMessage(
                              replyPreview,
                              messageId: message.replyToMessageId,
                              isMine: isMine,
                            ),
                          ],
                          if (message.content.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            AppSelectableText(
                              message.content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: textColor,
                                height: 1.32,
                              ),
                            ),
                          ],
                          if (message.images.isNotEmpty) ...[
                            if (message.content.isNotEmpty)
                              const SizedBox(height: 8),
                            _buildChatImageGrid(message.images),
                          ],
                        ],
                      ),
                    ),
                    if (message.id.isNotEmpty &&
                        (message.reactions.isNotEmpty || isMine)) ...[
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (message.reactions.isNotEmpty)
                            Expanded(child: _buildChatReactionBar(message))
                          else if (isMine)
                            const Spacer(),
                          if (isMine) ...[
                            if (message.reactions.isNotEmpty)
                              const SizedBox(width: 6),
                            _buildChatReadReceiptButton(message),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionBar(RoomRealtimeChatEntry message) {
    return AppSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: message.userId == _currentUser?.id,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: message.reactions
            .map(
              (reaction) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: _buildChatReactionChip(message, reaction),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChatReadReceiptButton(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final receipt = _chatReceiptCache[message.id];
    final loading = _chatReceiptLoadingIds.contains(message.id);
    final mentionReceipt = receipt == null
        ? null
        : _mentionReadReceiptSummary(message, receipt);
    final hasMentions = _mentionedUsersForMessage(message, receipt).isNotEmpty;
    final text =
        mentionReceipt ??
        (receipt == null
            ? (hasMentions ? context.l10n.mentionRead : context.l10n.read)
            : context.l10n.readUnreadSummary(
                receipt.readerTotal,
                receipt.unreadTotal,
              ));
    final isMentionReceipt = mentionReceipt != null || hasMentions;
    final label = isMentionReceipt
        ? context.l10n.viewMentionReadDetails
        : context.l10n.viewReadDetails;
    return AppTooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: !loading,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: loading ? null : () => _showChatReadReceipts(message),
          child: AppPanelSurface(
            height: 32,
            color: isMentionReceipt
                ? scheme.primary.withValues(alpha: 0.11)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isMentionReceipt
                  ? scheme.primary.withValues(alpha: 0.28)
                  : scheme.outlineVariant.withValues(alpha: 0.58),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                else
                  Icon(
                    isMentionReceipt
                        ? Icons.alternate_email_rounded
                        : Icons.visibility_outlined,
                    size: 13,
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _mentionReadReceiptSummary(
    RoomRealtimeChatEntry message,
    ChatMessageReadReceiptsInfo receipt,
  ) {
    final mentionedUsers = _mentionedUsersForMessage(message, receipt);
    if (mentionedUsers.isEmpty) return null;
    final mentionedIds = mentionedUsers.map((user) => user.id).toSet();
    final readCount = receipt.readers
        .where((reader) => mentionedIds.contains(reader.user.id))
        .length;
    final unreadCount = receipt.unreadMembers
        .where((user) => mentionedIds.contains(user.id))
        .length;
    if (readCount == 0 && unreadCount == 0) {
      return context.l10n.mentionRead;
    }
    if (mentionedUsers.length == 1) {
      return unreadCount == 0
          ? context.l10n.mentionRead
          : context.l10n.mentionUnread;
    }
    return context.l10n.mentionReadUnreadSummary(readCount, unreadCount);
  }

  List<SyncTvUser> _mentionedUsersForMessage(
    RoomRealtimeChatEntry message,
    ChatMessageReadReceiptsInfo? receipt,
  ) {
    if (message.mentions.isEmpty) return const [];
    final mentionedIds = message.mentions
        .map((mention) => mention.userId)
        .toSet();
    final users = <String, SyncTvUser>{};
    for (final mention in message.mentions) {
      if (mention.userId.isEmpty || mention.username.trim().isEmpty) continue;
      users[mention.userId] = SyncTvUser(
        id: mention.userId,
        username: mention.username,
        role: const RoomMembershipRole(
          common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
        ),
      );
    }
    if (receipt != null) {
      for (final reader in receipt.readers) {
        users[reader.user.id] = reader.user;
      }
      for (final user in receipt.unreadMembers) {
        users[user.id] = user;
      }
    } else {
      for (final user in _members) {
        users[user.id] = user;
      }
      final currentUser = _currentUser;
      if (currentUser != null) users[currentUser.id] = currentUser;
    }
    return mentionedIds
        .map((id) => users[id])
        .whereType<SyncTvUser>()
        .where((user) => user.username.trim().isNotEmpty)
        .toList();
  }

  Future<void> _showChatReadReceipts(RoomRealtimeChatEntry message) async {
    if (!mounted || !_canViewChatHistory || message.id.isEmpty) return;
    final revision = _chatState.beginSnapshot();
    if (!_isCurrentChatMessageRead(message, revision) ||
        _chatReceiptLoadingIds.contains(message.id)) {
      return;
    }
    ChatMessageReadReceiptsInfo? receipt = _chatReceiptCache[message.id];
    if (receipt == null) {
      setState(() => _chatReceiptLoadingIds.add(message.id));
      try {
        final loaded = await _chatGateway.getReadReceipts(
          widget.room.roomId,
          message.id,
        );
        if (!_isCurrentChatMessageRead(message, revision)) return;
        setState(() {
          _chatReceiptCache[message.id] = loaded;
        });
        receipt = loaded;
      } catch (e) {
        if (mounted && _isCurrentChatMessageRead(message, revision)) {
          AppNotifications.showError(
            context,
            context.l10n.loadReadDetailsFailed('$e'),
          );
        }
        return;
      } finally {
        if (_isCurrentChatUserRead(message.userId, revision)) {
          setState(() => _chatReceiptLoadingIds.remove(message.id));
        }
      }
    }
    final visibleReceipt = receipt;
    if (!mounted || !_isCurrentChatMessageRead(message, revision)) return;
    await _chatDetailDialogs.show(
      context: context,
      messageId: message.id,
      userId: message.userId,
      builder: (context) => ChatReadReceiptsDialog(receipts: visibleReceipt),
    );
  }

  Future<void> _showChatReactionUsers(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty ||
        !_isCurrentChatMessageRead(message, _chatState.revision)) {
      return;
    }
    await _chatDetailDialogs.show(
      context: context,
      messageId: message.id,
      userId: message.userId,
      builder: (context) => ChatReactionUsersDialog(
        roomId: widget.room.roomId,
        messageId: message.id,
        reactionKey: reaction.key,
        loadUsers: ({String cursor = ''}) => _chatGateway.listReactionUsers(
          widget.room.roomId,
          message.id,
          reaction.key,
          cursor: cursor,
        ),
      ),
    );
  }

  Widget _buildQuotedChatMessage(
    RoomRealtimeChatEntry? quote, {
    required String messageId,
    required bool isMine,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = isMine ? scheme.primary : scheme.secondary;
    final author = quote?.username.trim();
    final title = author == null || author.isEmpty
        ? context.l10n.quotedMessage
        : author;
    final preview = quote == null
        ? context.l10n.loadingQuotedMessage
        : _chatPreviewText(quote);
    return AppTooltip(
      message: context.l10n.jumpToQuotedMessage,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => _jumpToChatMessage(messageId),
          child: AppPanelSurface(
            color: scheme.surface.withValues(alpha: isMine ? 0.5 : 0.62),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: accent.withValues(alpha: 0.22)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3,
                  height: 31,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionChip(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = reaction.reactedByMe;
    final background = selected
        ? scheme.primary.withValues(alpha: 0.14)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.7);
    final borderColor = selected
        ? scheme.primary.withValues(alpha: 0.42)
        : scheme.outlineVariant.withValues(alpha: 0.68);

    return AppTooltip(
      message: selected
          ? context.l10n.reactionSelectedHint
          : context.l10n.reactionUnselectedHint,
      child: InkWell(
        onTap: () => _toggleChatReaction(message, reaction),
        onLongPress: () => _showChatReactionUsers(message, reaction),
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 28,
          child: AppPanelSurface(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(reaction.key, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 3),
                Text(
                  '${reaction.count}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessageActionBar(
    RoomRealtimeChatEntry message,
    bool isMine, {
    bool showReactions = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 2,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPanelSurface(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _chatMessageToolButtons(message, isMine),
              ),
            ),
            if (showReactions) ...[
              const SizedBox(height: 4),
              _buildChatReactionPicker(message),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _chatMessageToolButtons(
    RoomRealtimeChatEntry message,
    bool isMine,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return [
      _buildChatActionIcon(
        tooltip: context.l10n.react,
        icon: Icons.add_reaction_outlined,
        keepExpanded: true,
        onPressed: () => setState(() {
          final key = message.dedupeKey;
          _expandedChatActionMessageId = _expandedChatActionMessageId == key
              ? null
              : key;
          _hoveredChatMessageId = key;
        }),
      ),
      _buildChatActionIcon(
        tooltip: context.l10n.reply,
        icon: Icons.reply_rounded,
        onPressed: () => _replyToChatMessage(message),
      ),
      _buildChatActionIcon(
        tooltip: context.l10n.copy,
        icon: Icons.copy_rounded,
        onPressed: () => _copyChatMessageText(message),
      ),
      if (isMine)
        _buildChatActionIcon(
          tooltip: context.l10n.editMessage,
          icon: Icons.edit_outlined,
          onPressed: () => _editChatMessage(message),
        ),
      _buildChatActionIcon(
        tooltip: message.isPinned ? context.l10n.unpin : context.l10n.pin,
        icon: message.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        onPressed: () => _toggleChatPin(message),
      ),
      if (isMine || _canDeleteChatMessages)
        _buildChatActionIcon(
          tooltip: context.l10n.delete,
          icon: Icons.delete_outline_rounded,
          color: scheme.error,
          onPressed: () => _deleteChatMessage(message),
        ),
      if (!isMine && message.userId.isNotEmpty)
        _buildChatActionIcon(
          tooltip: context.l10n.blockUser,
          icon: Icons.person_off_outlined,
          color: scheme.error,
          onPressed: () =>
              _blockUser(userId: message.userId, username: message.username),
        ),
      _buildChatActionIcon(
        tooltip: context.l10n.report,
        icon: Icons.flag_outlined,
        onPressed: () => _showReportChatMessageDialog(message),
      ),
    ];
  }

  Widget _buildChatReactionPicker(RoomRealtimeChatEntry message) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
        _expandedChatActionMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: AppPanelSurface(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: commonChatReactionKeys
                .map((key) => _buildQuickReactionButton(message, key))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButton(RoomRealtimeChatEntry message, String key) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return AppTooltip(
      message: reactedByMe
          ? context.l10n.removeReaction(key)
          : context.l10n.addReaction(key),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          setState(() => _expandedChatActionMessageId = null);
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 17))),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButtonWithClose(
    RoomRealtimeChatEntry message,
    String key,
    VoidCallback onClose,
  ) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return AppTooltip(
      message: reactedByMe
          ? context.l10n.removeReaction(key)
          : context.l10n.addReaction(key),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          onClose();
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 17))),
        ),
      ),
    );
  }

  bool _chatReactionReactedByMe(RoomRealtimeChatEntry message, String key) {
    for (final reaction in message.reactions) {
      if (reaction.key == key) return reaction.reactedByMe;
    }
    return false;
  }

  Widget _buildChatActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool keepExpanded = false,
  }) {
    final button = AppIconButton(
      tooltip: tooltip,
      iconSize: 16,
      size: AppIconButtonSize.sm,
      style: AppIconButtonStyle.ghost,
      onPressed: () {
        if (!keepExpanded) {
          setState(() => _expandedChatActionMessageId = null);
        }
        onPressed();
      },
      icon: icon,
    );
    if (color == null) return button;
    // Tint only the icon: filled error buttons are too heavy for chat rows.
    return IconTheme.merge(
      data: IconThemeData(color: color),
      child: button,
    );
  }

  Widget _buildContextActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onClose,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final button = AppIconButton(
      tooltip: tooltip,
      iconSize: 16,
      size: AppIconButtonSize.sm,
      style: AppIconButtonStyle.ghost,
      onPressed: () {
        onClose();
        onPressed();
      },
      icon: icon,
    );
    if (color == null) return button;
    return IconTheme.merge(
      data: IconThemeData(color: color),
      child: button,
    );
  }

  Future<void> _showChatMessageContextMenu(
    RoomRealtimeChatEntry message,
    Offset position,
  ) async {
    final isMine = _currentUser != null && message.userId == _currentUser!.id;
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.l10n.closeMessageActions,
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, _, _) {
        return ChatContextMenuPopup(
          anchor: position,
          reactionCount: commonChatReactionKeys.length,
          actionCount: isMine || _canDeleteChatMessages ? 6 : 5,
          child: _buildChatContextActionPanel(
            message,
            isMine,
            onClose: () => Navigator.pop(dialogContext),
          ),
        );
      },
    );
    if (!mounted) return;
    setState(() {
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Widget _buildChatContextActionPanel(
    RoomRealtimeChatEntry message,
    bool isMine, {
    required VoidCallback onClose,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: AppPanelSurface(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.7),
          width: chatContextMenuBorderWidth,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: commonChatReactionKeys
                  .map(
                    (key) => _buildQuickReactionButtonWithClose(
                      message,
                      key,
                      onClose,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 7),
            AppDivider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: chatContextMenuItemSpacing,
              runSpacing: chatContextMenuItemSpacing,
              children: [
                _buildContextActionIcon(
                  tooltip: context.l10n.reply,
                  icon: Icons.reply_rounded,
                  onClose: onClose,
                  onPressed: () => _replyToChatMessage(message),
                ),
                _buildContextActionIcon(
                  tooltip: context.l10n.copy,
                  icon: Icons.copy_rounded,
                  onClose: onClose,
                  onPressed: () => _copyChatMessageText(message),
                ),
                if (isMine)
                  _buildContextActionIcon(
                    tooltip: context.l10n.editMessage,
                    icon: Icons.edit_outlined,
                    onClose: onClose,
                    onPressed: () => _editChatMessage(message),
                  ),
                _buildContextActionIcon(
                  tooltip: message.isPinned
                      ? context.l10n.unpin
                      : context.l10n.pin,
                  icon: message.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                  onClose: onClose,
                  onPressed: () => _toggleChatPin(message),
                ),
                if (isMine || _canDeleteChatMessages)
                  _buildContextActionIcon(
                    tooltip: context.l10n.delete,
                    icon: Icons.delete_outline_rounded,
                    color: scheme.error,
                    onClose: onClose,
                    onPressed: () => _deleteChatMessage(message),
                  ),
                if (!isMine && message.userId.isNotEmpty)
                  _buildContextActionIcon(
                    tooltip: context.l10n.blockUser,
                    icon: Icons.person_off_outlined,
                    color: scheme.error,
                    onClose: onClose,
                    onPressed: () => _blockUser(
                      userId: message.userId,
                      username: message.username,
                    ),
                  ),
                _buildContextActionIcon(
                  tooltip: context.l10n.report,
                  icon: Icons.flag_outlined,
                  onClose: onClose,
                  onPressed: () => _showReportChatMessageDialog(message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleChatReaction(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await _setChatReaction(
      message,
      reaction.key,
      enabled: !reaction.reactedByMe,
    );
  }

  Future<void> _setChatReaction(
    RoomRealtimeChatEntry message,
    String reactionKey, {
    required bool enabled,
  }) async {
    if (message.id.isEmpty) return;
    final revision = _chatState.revision;
    try {
      final updated = await _chatGateway.setReaction(
        widget.room.roomId,
        message.id,
        reactionKey,
        enabled: enabled,
      );
      if (!mounted) return;
      final entry = RoomRealtimeChatEntry.fromHistory(updated);
      setState(() {
        _mergeChatMessage(
          entry,
          addToTimeline: true,
          snapshotRevision: revision,
        );
      });
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.reactionFailed('$e'));
      }
    }
  }

  void _replyToChatMessage(RoomRealtimeChatEntry message) {
    setState(() {
      _replyingToMessage = message;
      _hoveredChatMessageId = null;
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Future<void> _copyChatMessageText(RoomRealtimeChatEntry message) async {
    final text = message.content.trim();
    if (text.isEmpty) {
      AppNotifications.showInfo(context, context.l10n.noCopyableMessageText);
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      AppNotifications.showSuccess(context, context.l10n.messageCopied);
    }
  }

  Future<void> _toggleChatPin(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty || message.isDeleted) return;
    final revision = _chatState.revision;
    try {
      final event = message.isPinned
          ? await _chatGateway.unpin(widget.room.roomId, message.id)
          : await _chatGateway.pin(widget.room.roomId, message.id);
      if (!mounted) return;
      setState(() => _applyChatPinEvent(event, snapshotRevision: revision));
      AppNotifications.showSuccess(
        context,
        message.isPinned
            ? context.l10n.messageUnpinned
            : context.l10n.messagePinned,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          message.isPinned
              ? context.l10n.unpinMessageFailed('$e')
              : context.l10n.pinMessageFailed('$e'),
        );
      }
    }
  }

  Future<void> _deleteChatMessage(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty) return;
    final isMine = _currentUser != null && message.userId == _currentUser!.id;
    if (!isMine && !_canDeleteChatMessages) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: context.l10n.deleteMessage,
        content: Text(context.l10n.confirmDeleteChatMessage),
        confirmLabel: context.l10n.delete,
        confirmIcon: Icons.delete_outline_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _chatGateway.delete(
        widget.room.roomId,
        message.id,
        expectedVersion: message.version,
        reason: 'user_deleted',
      );
      if (!mounted) return;
      setState(() {
        _mergeChatMessage(
          message.copyWith(
            content: '',
            images: const [],
            reactions: const [],
            reactionCount: 0,
            mentions: const [],
            version: message.version + 1,
            isDeleted: true,
            clearPin: true,
          ),
        );
        _chatReceiptCache.remove(message.id);
        if (_replyingToMessage?.id == message.id) {
          _replyingToMessage = null;
        }
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

  Future<void> _editChatMessage(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty || message.isDeleted) return;
    final content = await AppDialogs.showStyledDialog<String>(
      context: context,
      title: context.l10n.editMessage,
      icon: const Icon(Icons.edit_outlined),
      content: ChatMessageEditForm(
        initialContent: message.content,
        onSave: (content) async {
          final revision = _chatState.revision;
          final updated = await _chatGateway.edit(
            widget.room.roomId,
            message.id,
            content: content,
            expectedVersion: message.version,
          );
          if (!mounted) return;
          final entry = RoomRealtimeChatEntry.fromHistory(updated);
          setState(() {
            _mergeChatMessage(
              entry,
              addToTimeline: true,
              snapshotRevision: revision,
            );
          });
        },
      ),
      actions: const [],
    );
    if (mounted && content != null && content != message.content) {
      AppNotifications.showSuccess(context, context.l10n.messageUpdated);
    }
  }

  Future<void> _showReportChatMessageDialog(
    RoomRealtimeChatEntry message,
  ) async {
    if (message.id.isEmpty) return;
    await _showReportContentDialog(
      title: context.l10n.reportMessage,
      submit: (reasonCode, reason) => _chatGateway.reportMessage(
        widget.room.roomId,
        message.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Widget _buildChatImageThumb(StoredImageInfo image) {
    final url = _resourceUrlResolver.resolve(image.url);
    return AppImagePreview(
      url: url,
      width: 180,
      height: 120,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildVoiceControl(ThemeData theme) {
    if (_voiceChatManager == null || !_canUseVoiceChat) {
      return const SizedBox.shrink();
    }

    return AppInfoBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _voiceChatManager!.isConnected
          ? (_voiceChatManager!.isMuted ? AppColors.danger : AppColors.success)
          : theme.disabledColor,
      backgroundColor: theme.cardColor,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      icon: _voiceChatManager!.isConnected
          ? Icons.mic_rounded
          : Icons.mic_off_rounded,
      title: Text(
        _voiceChatManager!.isConnected
            ? (_voiceChatManager!.hasPeersConnected
                  ? (_voiceChatManager!.isMuted
                        ? context.l10n.voiceConnectedMuted(
                            _voiceChatManager!.participantCount,
                          )
                        : context.l10n.voiceConnected(
                            _voiceChatManager!.participantCount,
                          ))
                  : (_voiceChatManager!.isMuted
                        ? context.l10n.waitingToJoinVoiceMuted(1)
                        : context.l10n.waitingToJoinVoice(1)))
            : context.l10n.voiceChat,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      trailing: _voiceChatManager!.isConnected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: _voiceChatManager!.remoteVolume <= 0
                      ? Icons.volume_off_rounded
                      : _voiceChatManager!.remoteVolume > 1
                      ? Icons.volume_up_rounded
                      : Icons.volume_down_rounded,
                  onPressed: () => _showVoiceVolumeDialog(),
                  tooltip: context.l10n.voiceVolume,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.tonal,
                ),
                AppIconButton(
                  icon: _voiceChatManager!.isMuted
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  onPressed: () => _voiceChatManager!.toggleMute(),
                  tooltip: _voiceChatManager!.isMuted
                      ? context.l10n.unmute
                      : context.l10n.mute,
                  size: AppIconButtonSize.sm,
                  style: _voiceChatManager!.isMuted
                      ? AppIconButtonStyle.destructive
                      : AppIconButtonStyle.tonal,
                ),
                AppIconButton(
                  icon: Icons.call_end_rounded,
                  onPressed: () => _voiceChatManager!.leave(),
                  tooltip: context.l10n.leaveVoice,
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.destructive,
                ),
              ],
            )
          : AppActionButton(
              onPressed: _joinVoice,
              loading: _joiningVoice,
              icon: Icons.call_rounded,
              label: _joiningVoice ? context.l10n.joining : context.l10n.join,
              style: AppActionButtonStyle.tonal,
            ),
    );
  }

  Future<void> _joinVoice() async {
    final manager = _voiceChatManager;
    if (manager == null || _joiningVoice || !_canUseVoiceChat) return;
    final l10n = context.l10n;
    setState(() {
      _joiningVoice = true;
    });
    try {
      await manager
          .join(clientOperationId: newClientOperationId())
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException(l10n.joinVoiceTimeout),
          );
    } catch (e, stackTrace) {
      debugPrint('WebRTC voice join failed: $e');
      debugPrint('$stackTrace');
      if (mounted) {
        AppNotifications.showError(context, l10n.joinVoiceFailed('$e'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _joiningVoice = false;
        });
      }
    }
  }

  void _showVoiceVolumeDialog() {
    final manager = _voiceChatManager;
    if (manager == null) return;
    final l10n = context.l10n;
    final theme = Theme.of(context);
    var volume = manager.remoteVolume;
    unawaited(
      AppDialogs.showStyledDialog<void>(
        context: context,
        title: l10n.voiceVolume,
        icon: const Icon(Icons.volume_up_rounded),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSlider(
                value: volume,
                min: VoiceChatVolumeRange.min,
                max: VoiceChatVolumeRange.max,
                divisions: 40,
                label: '${(volume * 100).round()}%',
                onChanged: (value) {
                  setDialogState(() => volume = value);
                  manager.setRemoteVolume(value);
                },
              ),
              Center(
                child: Text(
                  '${(volume * 100).round()}%',
                  style: theme.textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.voiceVolumeHint,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: const [],
      ),
    );
  }

  Future<void> _pickChatImage() async {
    if (!_canSendChatMessages) return;
    try {
      final image = await pickLocalImageUpload(context);
      if (image == null || !mounted || !_canSendChatMessages) return;
      setState(() => _selectedChatImage = image);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.chooseImageFailed('$e'),
        );
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (!_canSendChatMessages) return;
    final content = text.trim();
    final selectedImage = _selectedChatImage;
    if (content.isEmpty && selectedImage == null) return;
    if (_sendingChatMessage) return;

    setState(() => _sendingChatMessage = true);
    try {
      final images = <StoredImageInfo>[];
      final replyToMessageId = _replyingToMessage?.id ?? '';
      if (selectedImage != null) {
        images.add(
          await _chatGateway.uploadImage(
            widget.room.roomId,
            selectedImage.upload,
          ),
        );
      }
      if (!mounted || !_canSendChatMessages) return;
      final message = await _chatGateway.send(
        widget.room.roomId,
        content: content,
        images: images,
        replyToMessageId: replyToMessageId,
        mentions: _pendingChatMentions,
      );
      final entry = RoomRealtimeChatEntry.fromHistory(message);
      if (mounted) {
        _messageController.clear();
        setState(() {
          _mergeChatMessage(entry, addToTimeline: true);
          _selectedChatImage = null;
          _replyingToMessage = null;
          _pendingChatMentions = [];
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Send message error: $e');
      if (mounted) {
        AppNotifications.showError(context, context.l10n.sendFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _sendingChatMessage = false);
    }
  }
}
