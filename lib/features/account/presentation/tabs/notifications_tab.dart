part of '../account_center_page.dart';

mixin _AccountNotificationsTab on _AccountCenterPageBase {
  Widget _buildNotificationsTab(ThemeData theme) {
    final page = _notifications;
    final loadError = _loadError(_AccountCenterPageBase._moduleNotifications);
    final items = page?.notifications ?? const <UserNotificationItem>[];
    final unreadSelectableIds = items
        .where((item) => !item.isRead && item.hasValidId)
        .map((item) => item.id)
        .toSet();
    final selectedUnreadCount = _selectedNotificationIds
        .where(unreadSelectableIds.contains)
        .length;
    final total = page?.total ?? 0;
    final maxPage = _notificationMaxPage(total);
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  // Left-align the toolbar rows like every other tab; the default
                  // centered the unread summary under the tab strip.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          context.l10n.unreadTotalSummary(
                            page?.unreadCount ?? 0,
                            total,
                          ),
                        ),
                        if (_loadingNotifications)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: AppLoadingIndicator(
                                size: AppLoadingSize.sm,
                                centered: false,
                              ),
                            ),
                          ),
                        if (_selectedNotificationIds.isNotEmpty) ...[
                          AppActionButton(
                            onPressed: () => setState(
                              () => _selectedNotificationIds.clear(),
                            ),
                            icon: Icons.close_rounded,
                            label: context.l10n.selectedCount(
                              _selectedNotificationIds.length,
                            ),
                            wrapLabel: true,
                            style: AppActionButtonStyle.text,
                          ),
                          AppIconButton(
                            onPressed:
                                _notificationMutationInFlight ||
                                    selectedUnreadCount == 0
                                ? null
                                : _markSelectedRead,
                            icon: Icons.mark_email_read_rounded,
                            tooltip:
                                context.l10n.markSelectedUnreadNotifications,
                          ),
                        ] else
                          AppIconButton(
                            onPressed: unreadSelectableIds.isEmpty
                                ? null
                                : () => setState(() {
                                    _selectedNotificationIds
                                      ..clear()
                                      ..addAll(unreadSelectableIds);
                                  }),
                            icon: Icons.select_all_rounded,
                            tooltip:
                                context.l10n.selectCurrentUnreadNotifications,
                          ),
                        AppIconButton(
                          onPressed:
                              _notificationMutationInFlight || items.isEmpty
                              ? null
                              : _markAllRead,
                          icon: Icons.done_all_rounded,
                          tooltip: context.l10n.markAllRead,
                        ),
                        AppIconButton(
                          onPressed:
                              _notificationMutationInFlight || items.isEmpty
                              ? null
                              : _deleteAllRead,
                          icon: Icons.delete_sweep_rounded,
                          tooltip: context.l10n.deleteReadNotifications,
                          style: AppIconButtonStyle.destructive,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppSearchField(
                      controller: _notificationSearchController,
                      hintText: context.l10n.searchTitleOrContent,
                      onChanged: (value) {
                        if (value.isEmpty) _reloadNotificationsFromFirstPage();
                      },
                      onSubmitted: (_) => _reloadNotificationsFromFirstPage(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _NotificationFilterChip(
                          label: context.l10n.all,
                          selected: _notificationReadFilter == null,
                          onSelected: () {
                            setState(() => _notificationReadFilter = null);
                            _reloadNotificationsFromFirstPage();
                          },
                        ),
                        _NotificationFilterChip(
                          label: context.l10n.unread,
                          selected: _notificationReadFilter == false,
                          onSelected: () {
                            setState(() => _notificationReadFilter = false);
                            _reloadNotificationsFromFirstPage();
                          },
                        ),
                        _NotificationFilterChip(
                          label: context.l10n.read,
                          selected: _notificationReadFilter == true,
                          onSelected: () {
                            setState(() => _notificationReadFilter = true);
                            _reloadNotificationsFromFirstPage();
                          },
                        ),
                        AppSelect<client_enum.NotificationType?>(
                          value: _notificationTypeFilter,
                          hintText: context.l10n.notificationType,
                          options: {
                            context.l10n.allTypes: null,
                            context.l10n.roomInvitation: client_enum
                                .NotificationType
                                .NOTIFICATION_TYPE_ROOM_INVITATION,
                            context.l10n.systemAnnouncement: client_enum
                                .NotificationType
                                .NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT,
                            context.l10n.roomEvent: client_enum
                                .NotificationType
                                .NOTIFICATION_TYPE_ROOM_EVENT,
                            context.l10n.passwordResetNotification: client_enum
                                .NotificationType
                                .NOTIFICATION_TYPE_PASSWORD_RESET,
                            if (_showEmailBindingControls)
                              context.l10n.emailBinding: client_enum
                                  .NotificationType
                                  .NOTIFICATION_TYPE_EMAIL_BIND,
                          },
                          onChanged: (value) {
                            setState(() => _notificationTypeFilter = value);
                            _reloadNotificationsFromFirstPage();
                          },
                        ),
                        AppSelect<client_enum.NotificationListSortBy>(
                          value: _notificationSortBy,
                          options: {
                            context.l10n.createdAt: client_enum
                                .NotificationListSortBy
                                .NOTIFICATION_LIST_SORT_BY_CREATED_AT,
                            context.l10n.updatedAt: client_enum
                                .NotificationListSortBy
                                .NOTIFICATION_LIST_SORT_BY_UPDATED_AT,
                            context.l10n.title: client_enum
                                .NotificationListSortBy
                                .NOTIFICATION_LIST_SORT_BY_TITLE,
                          },
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _notificationSortBy = value);
                            _reloadNotificationsFromFirstPage();
                          },
                        ),
                        AppIconButton(
                          onPressed: () {
                            setState(() {
                              _notificationSortDirection =
                                  _notificationSortDirection ==
                                      client_enum
                                          .SortDirection
                                          .SORT_DIRECTION_DESC
                                  ? client_enum.SortDirection.SORT_DIRECTION_ASC
                                  : client_enum
                                        .SortDirection
                                        .SORT_DIRECTION_DESC;
                            });
                            _reloadNotificationsFromFirstPage();
                          },
                          icon:
                              _notificationSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_DESC
                              ? Icons.south_rounded
                              : Icons.north_rounded,
                          tooltip:
                              _notificationSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_DESC
                              ? context.l10n.descending
                              : context.l10n.ascending,
                          style: AppIconButtonStyle.outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppPaginationBar(
                      padding: EdgeInsets.zero,
                      label: context.l10n.pageSizeTotalSummary(
                        _notificationPage,
                        _AccountCenterPageBase._notificationPageSize,
                        total,
                      ),
                      onPrevious:
                          _loadingNotifications || _notificationPage <= 1
                          ? null
                          : () => _reloadNotifications(
                              page: _notificationPage - 1,
                            ),
                      onNext:
                          _loadingNotifications || _notificationPage >= maxPage
                          ? null
                          : () => _reloadNotifications(
                              page: _notificationPage + 1,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      body: _loadingNotifications && page == null
          ? const AppLoadingIndicator()
          : loadError != null && page == null
          ? AppSingleChildScrollView(
              primary: true,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _LoadErrorBanner(
                    title: context.l10n.notificationsTemporarilyUnavailable,
                    moduleInfo:
                        _moduleInfo[_AccountCenterPageBase
                            ._moduleNotifications],
                    message: loadError,
                    onRetry: _reloadNotifications,
                  ),
                ),
              ),
            )
          : items.isEmpty
          ? AppEmptyMessage(message: context.l10n.noNotifications)
          : AppRefreshIndicator(
              onRefresh: _reloadNotifications,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cap = _contentCap(constraints.maxWidth);
                  return AppListView.separated(
                    primary: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = _selectedNotificationIds.contains(
                        item.id,
                      );
                      final selectable = item.hasValidId;
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cap),
                          child: _Section(
                            child: AppTile(
                              contentPadding: EdgeInsets.zero,
                              selected: selected,
                              onPressed: selected
                                  ? () {
                                      if (!selectable) return;
                                      setState(() {
                                        _selectedNotificationIds.remove(
                                          item.id,
                                        );
                                      });
                                    }
                                  : () => _openNotification(item),
                              onLongPress: selectable
                                  ? () => setState(() {
                                      if (selected) {
                                        _selectedNotificationIds.remove(
                                          item.id,
                                        );
                                      } else {
                                        _selectedNotificationIds.add(item.id);
                                      }
                                    })
                                  : null,
                              prefix: AppCheckbox(
                                value: selected,
                                semanticsLabel: context.l10n.selectNotification,
                                onChanged: selectable
                                    ? (value) => setState(() {
                                        if (value) {
                                          _selectedNotificationIds.add(item.id);
                                        } else {
                                          _selectedNotificationIds.remove(
                                            item.id,
                                          );
                                        }
                                      })
                                    : null,
                              ),
                              title: Text(
                                item.title.isEmpty
                                    ? _notificationType(item.type)
                                    : item.title,
                                style: TextStyle(
                                  fontWeight: item.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.content.isNotEmpty)
                                    Text(item.content),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatTimestampSeconds(item.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                              stackedSuffix: true,
                              suffix: Wrap(
                                spacing: 2,
                                children: [
                                  AppIconButton(
                                    onPressed: selected
                                        ? null
                                        : () => _openNotification(item),
                                    icon: Icons.open_in_new_rounded,
                                    tooltip: context.l10n.viewDetails,
                                    size: AppIconButtonSize.sm,
                                  ),
                                  if (!item.isRead)
                                    AppIconButton(
                                      onPressed:
                                          selected ||
                                              _notificationMutationInFlight
                                          ? null
                                          : () => _markRead(item),
                                      icon: Icons.mark_email_read_rounded,
                                      tooltip: context.l10n.markRead,
                                      size: AppIconButtonSize.sm,
                                    ),
                                  AppIconButton(
                                    onPressed:
                                        selected ||
                                            _notificationMutationInFlight
                                        ? null
                                        : () => _deleteNotification(item),
                                    icon: Icons.delete_outline_rounded,
                                    tooltip: context.l10n.delete,
                                    size: AppIconButtonSize.sm,
                                    style: AppIconButtonStyle.destructive,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
