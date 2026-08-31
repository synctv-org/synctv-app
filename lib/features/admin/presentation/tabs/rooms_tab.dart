part of '../admin_settings_page.dart';

class RoomManagementTab extends StatefulWidget {
  const RoomManagementTab({super.key});

  @override
  State<RoomManagementTab> createState() => _RoomManagementTabState();
}

class _RoomManagementTabState extends State<RoomManagementTab> {
  List<SyncTvRoom> _rooms = [];
  List<RoomCategoryInfo> _categories = const [];
  List<RoomLabelInfo> _labels = const [];
  bool _isLoading = true;
  bool _isLoadingTaxonomy = false;
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchQuery = '';
  String _categoryFilter = '';
  final Set<String> _labelFilters = {};
  common_enum.RoomStatus _statusFilter =
      common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
  bool? _bannedFilter;
  admin_enum.RoomListSortBy _sortBy =
      admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  final Set<String> _selectedRoomIds = {};
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadTaxonomy();
      _loadRooms();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRooms({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await adminGateway.adminListRoomsPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchQuery,
        categoryId: _categoryFilter,
        labelIds: _labelFilters.toList(growable: false),
        status: _statusFilter,
        isBanned: _bannedFilter,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );

      if (!mounted) return;

      setState(() {
        _rooms = data.rooms;
        _total = data.total;
        _selectedRoomIds.removeWhere(
          (id) => !_rooms.any((room) => room.roomId == id),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppNotifications.showError(context, context.l10n.loadRoomsFailed('$e'));
      }
    }
  }

  Future<void> _loadTaxonomy() async {
    if (_isLoadingTaxonomy) return;
    setState(() => _isLoadingTaxonomy = true);
    try {
      final results = await Future.wait([
        adminGateway.adminListRoomCategories(
          includeDisabled: true,
          refresh: true,
        ),
        adminGateway.adminListRoomLabels(includeDisabled: true, refresh: true),
      ]);
      if (!mounted) return;
      final categories = results[0].cast<RoomCategoryInfo>().toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomCategoryDisplay(a).compareTo(_roomCategoryDisplay(b));
        });
      final labels = results[1].cast<RoomLabelInfo>().toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomLabelDisplay(a).compareTo(_roomLabelDisplay(b));
        });
      setState(() {
        _categories = categories;
        _labels = labels;
        _labelFilters.removeWhere(
          (id) => !_availableFilterLabels.any((label) => label.id == id),
        );
        _isLoadingTaxonomy = false;
      });
    } catch (e) {
      debugPrint('Failed to load admin room taxonomy filters: $e');
      if (!mounted) return;
      setState(() => _isLoadingTaxonomy = false);
    }
  }

  List<RoomLabelInfo> get _availableFilterLabels {
    if (_categoryFilter.isEmpty) return _labels;
    return _labels
        .where((label) => label.categoryId == _categoryFilter)
        .toList(growable: false);
  }

  Future<void> _showRoomLabelFilterDialog() async {
    if (_labels.isEmpty) {
      await _loadTaxonomy();
    }
    if (!mounted) return;
    final selectedIds = Set<String>.from(_labelFilters);
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.filterLabels,
      icon: const Icon(Icons.sell_outlined, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final theme = Theme.of(dialogContext);
          final labels = _availableFilterLabels;
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labels.isEmpty)
                    Text(
                      _categoryFilter.isEmpty
                          ? context.l10n.noLabelsAvailable
                          : context.l10n.noLabelsForCategory,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: labels
                          .map((label) {
                            final selected = selectedIds.contains(label.id);
                            final color = parseRoomLabelColor(
                              label.color,
                              theme.colorScheme.primary,
                            );
                            return AppChip(
                              selected: selected,
                              style: selected
                                  ? AppChipStyle.filled
                                  : AppChipStyle.outlined,
                              onSelected: (value) => setDialogState(() {
                                if (value) {
                                  selectedIds.add(label.id);
                                } else {
                                  selectedIds.remove(label.id);
                                }
                              }),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(_roomLabelDisplay(label)),
                                ],
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () => Navigator.pop(context, false),
          icon: Icons.filter_alt_off_rounded,
          label: context.l10n.clear,
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.apply,
        ),
      ],
    );
    if (confirmed == null) return;
    setState(() {
      _labelFilters
        ..clear()
        ..addAll(confirmed ? selectedIds : const <String>{});
      _page = 1;
    });
    _loadRooms();
  }

  Future<void> _banRoom(SyncTvRoom room, bool ban) async {
    final action = ban ? context.l10n.ban : context.l10n.unban;
    final reasonController = TextEditingController();
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.roomAction(action),
      icon: Icon(
        ban ? Icons.block : Icons.check_circle,
        color: ban ? Colors.red : Colors.green,
      ),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.confirmRoomAction(action, room.roomName)),
                const SizedBox(height: 12),
                AppDialogs.createFormField(
                  context: context,
                  label: context.l10n.banReason,
                  controller: reasonController,
                  hintText: context.l10n.optional,
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text(context.l10n.confirmRoomAction(action, room.roomName)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: action,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await adminGateway.adminBanRoom(
          room.roomId,
          ban,
          reason: reasonController.text.trim(),
        );
        if (!mounted) return;
        AppNotifications.showSuccess(context, context.l10n.operationSucceeded);
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        AppNotifications.showError(context, context.l10n.operationFailed('$e'));
      }
    }
  }

  Future<void> _deleteRoom(SyncTvRoom room) async {
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteRoom,
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteRoom(room.roomName),
        [
          context.l10n.allMembersLoseAccess,
          context.l10n.roomDataWillBeCleared,
          context.l10n.watchingMembersWillExit,
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await adminGateway.adminDeleteRoom(room.roomId);
        if (!mounted) return;
        AppNotifications.showSuccess(context, context.l10n.roomDeleted);
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        AppNotifications.showError(
          context,
          context.l10n.deleteEntryFailed('$e'),
        );
      }
    }
  }

  void _toggleRoomSelection(String roomId, bool selected) {
    setState(() {
      if (selected) {
        _selectedRoomIds.add(roomId);
      } else {
        _selectedRoomIds.remove(roomId);
      }
    });
  }

  Future<void> _batchBanRooms() async {
    if (_selectedRoomIds.isEmpty) return;
    final reasonController = TextEditingController();
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.batchBanRooms,
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.roomsWillBeBanned(_selectedRoomIds.length)),
          const SizedBox(height: 12),
          AppDialogs.createFormField(
            context: context,
            label: context.l10n.banReason,
            controller: reasonController,
            hintText: context.l10n.optional,
            prefixIcon: Icons.edit_note_rounded,
          ),
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.ban,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await adminGateway.adminBatchBanRooms(
        _selectedRoomIds.toList(),
        reason: reasonController.text.trim(),
      );
      if (!mounted) return;
      _showBatchResult(context.l10n.batchBanCompleted, result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.batchBanFailed('$e'));
    }
  }

  Future<void> _batchDeleteRooms() async {
    if (_selectedRoomIds.isEmpty) return;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.batchDeleteRooms,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.roomsWillBeDeleted(_selectedRoomIds.length),
        [
          context.l10n.relatedMembersLoseAccess,
          context.l10n.roomDataWillBeCleared,
          context.l10n.batchDeleteBackupOnly,
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await adminGateway.adminBatchDeleteRooms(
        _selectedRoomIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult(context.l10n.batchDeleteCompleted, result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.batchDeleteFailed('$e'));
    }
  }

  void _showBatchResult(String title, AdminBatchOperationResult result) {
    final failedItems = result.results.where((item) => !item.success).toList();
    final message = failedItems.isEmpty
        ? context.l10n.batchResultSuccess(title, result.succeeded)
        : context.l10n.batchResultMixed(title, result.succeeded, result.failed);
    if (failedItems.isEmpty) {
      AppNotifications.showSuccess(context, message);
      return;
    }
    final detail = failedItems
        .take(3)
        .map((item) => '${item.id}: ${item.error}')
        .join('\n');
    AppNotifications.showWarning(context, '$message\n$detail');
  }

  Widget _destructiveDialogContent(String title, List<String> impacts) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(impact, style: theme.textTheme.bodySmall)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showRoomDetails(SyncTvRoom room) async {
    try {
      final detail = await adminGateway.adminGetRoom(room.roomId);
      if (!mounted) return;
      final passwordController = TextEditingController();
      var passwordAction = _RoomPasswordAction.keep;
      await AppDialogs.showStyledDialog(
        context: context,
        title: context.l10n.roomInformation,
        icon: const Icon(Icons.meeting_room_rounded, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SizedBox(
              width: 560,
              child: AppSingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _RoomCoverPreview(room: detail),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.roomName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail.roomId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        AppAvatar(
                          name: detail.creator,
                          imageUrl: detail.creatorAvatarUrl,
                          radius: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoLine(
                            context.l10n.creator,
                            '${detail.creator} (${detail.creatorId})',
                          ),
                        ),
                      ],
                    ),
                    if (detail.description.isNotEmpty)
                      _InfoLine(context.l10n.description, detail.description),
                    if (detail.category != null)
                      _InfoLine(
                        context.l10n.category,
                        _roomCategoryDisplay(detail.category!),
                      ),
                    if (detail.labels.isNotEmpty)
                      _InfoLine(
                        context.l10n.labels,
                        detail.labels.map(_roomLabelDisplay).join('、'),
                      ),
                    _InfoLine(
                      context.l10n.memberCountLabel,
                      detail.memberCount.toString(),
                    ),
                    _InfoLine(context.l10n.status, _roomStatusLabel(detail)),
                    _InfoLine(
                      context.l10n.creatorStatus,
                      _userStatusText(context, detail.creatorStatus),
                    ),
                    _InfoLine(
                      context.l10n.resourceAvailability,
                      _resourceAvailabilityText(context, detail.availability),
                    ),
                    _InfoLine(
                      context.l10n.createdAt,
                      _formatTimestamp(detail.createdAt),
                    ),
                    _InfoLine(
                      context.l10n.updatedAt,
                      _formatTimestamp(detail.updatedAt),
                    ),
                    if (detail.version > 0)
                      _InfoLine(
                        context.l10n.version,
                        detail.version.toString(),
                      ),
                    const SizedBox(height: 16),
                    AppDivider(
                      color: Theme.of(context).dividerColor
                          .withValues(alpha: 0.65),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.roomPassword,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    AppSelect<_RoomPasswordAction>(
                      value: passwordAction,
                      label: context.l10n.passwordAction,
                      options: {
                        context.l10n.keepUnchanged: _RoomPasswordAction.keep,
                        context.l10n.setNewPassword: _RoomPasswordAction.update,
                        context.l10n.clearPassword: _RoomPasswordAction.clear,
                      },
                      onChanged: (value) => setDialogState(() {
                        passwordAction = value ?? _RoomPasswordAction.keep;
                        if (passwordAction != _RoomPasswordAction.update) {
                          passwordController.clear();
                        }
                      }),
                    ),
                    if (passwordAction == _RoomPasswordAction.update) ...[
                      const SizedBox(height: 12),
                      AppDialogs.createFormField(
                        context: dialogContext,
                        label: context.l10n.newPassword,
                        controller: passwordController,
                        hintText: context.l10n.newPassword,
                        prefixIcon: Icons.lock_outline,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          AppActionButton(
            onPressed: () async {
              final nextPassword = passwordController.text.trim();
              if (passwordAction == _RoomPasswordAction.update &&
                  nextPassword.isEmpty) {
                AppNotifications.showWarning(
                  context,
                  context.l10n.newPasswordRequired,
                );
                return;
              }
              try {
                switch (passwordAction) {
                  case _RoomPasswordAction.keep:
                    Navigator.pop(context);
                    return;
                  case _RoomPasswordAction.update:
                    await adminGateway.adminUpdateRoomPassword(
                      detail.roomId,
                      nextPassword,
                    );
                  case _RoomPasswordAction.clear:
                    await adminGateway.adminUpdateRoomPassword(
                      detail.roomId,
                      '',
                    );
                }
                if (!mounted) return;
                Navigator.pop(context);
                AppNotifications.showSuccess(
                  context,
                  context.l10n.roomPasswordUpdated,
                );
                _loadRooms(silent: true);
              } catch (e) {
                if (mounted) {
                  AppNotifications.showError(
                    context,
                    context.l10n.updateRoomPasswordFailed('$e'),
                  );
                }
              }
            },
            icon: Icons.password_rounded,
            label: context.l10n.savePassword,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _showRoomChatHistory(detail);
            },
            icon: Icons.forum_outlined,
            label: context.l10n.chatHistory,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _editRoomTaxonomy(detail);
            },
            icon: Icons.category_outlined,
            label: context.l10n.categoriesAndLabels,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _openContentReportsViewer(
                context,
                title: context.l10n.roomReports(detail.roomName),
                targetType: admin_enum
                    .ContentReportTargetType
                    .CONTENT_REPORT_TARGET_TYPE_ROOM,
                targetRoomId: detail.roomId,
                scope: admin_enum
                    .ContentReportScope
                    .CONTENT_REPORT_SCOPE_TARGET_ROOM,
              );
            },
            icon: Icons.report_gmailerrorred_outlined,
            label: context.l10n.reportRecords,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRoom(detail);
            },
            icon: Icons.delete_outline_rounded,
            label: context.l10n.deleteRoom,
            style: AppActionButtonStyle.destructive,
          ),
          _closeButton(context),
        ],
      );
      passwordController.dispose();
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.loadRoomDetailsFailed('$e'),
      );
    }
  }

  String _roomCategoryDisplay(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _roomLabelDisplay(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  Future<void> _editRoomTaxonomy(SyncTvRoom room) async {
    try {
      final results = await Future.wait([
        adminGateway.adminListRoomCategories(
          includeDisabled: false,
          refresh: true,
        ),
        adminGateway.adminListRoomLabels(includeDisabled: false, refresh: true),
      ]);
      if (!mounted) return;
      final categories =
          results[0]
              .cast<RoomCategoryInfo>()
              .where((category) => category.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _roomCategoryDisplay(a).compareTo(_roomCategoryDisplay(b));
            });
      final labels =
          results[1]
              .cast<RoomLabelInfo>()
              .where((label) => label.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _roomLabelDisplay(a).compareTo(_roomLabelDisplay(b));
            });
      var selectedCategoryId = room.category?.id ?? '';
      if (selectedCategoryId.isNotEmpty &&
          categories.every((category) => category.id != selectedCategoryId)) {
        selectedCategoryId = '';
      }
      final selectedLabelIds = room.labels.map((label) => label.id).toSet();

      List<RoomLabelInfo> availableLabels() {
        if (selectedCategoryId.isEmpty) return labels;
        return labels
            .where((label) => label.categoryId == selectedCategoryId)
            .toList(growable: false);
      }

      void pruneSelectedLabels() {
        final availableIds = availableLabels().map((label) => label.id).toSet();
        selectedLabelIds.removeWhere((id) => !availableIds.contains(id));
      }

      pruneSelectedLabels();
      final confirmed = await AppDialogs.showStyledDialog<bool>(
        context: context,
        title: context.l10n.categoriesAndLabels,
        icon: const Icon(Icons.category_outlined, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final theme = Theme.of(dialogContext);
            final visibleLabels = availableLabels();
            return SizedBox(
              width: 560,
              child: AppSingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSelect<String?>(
                      value: selectedCategoryId.isEmpty
                          ? null
                          : selectedCategoryId,
                      label: context.l10n.roomCategory,
                      hintText: context.l10n.noCategory,
                      prefixIcon: Icons.category_outlined,
                      clearable: true,
                      options: {
                        context.l10n.noCategory: null,
                        for (final category in categories)
                          _roomCategoryDisplay(category): category.id,
                      },
                      onChanged: (value) => setDialogState(() {
                        selectedCategoryId = value ?? '';
                        pruneSelectedLabels();
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.roomLabels,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (visibleLabels.isEmpty)
                      Text(
                        selectedCategoryId.isEmpty
                            ? context.l10n.noLabelsAvailable
                            : context.l10n.noLabelsForCategory,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: visibleLabels
                            .map((label) {
                              final selected = selectedLabelIds.contains(
                                label.id,
                              );
                              final color = parseRoomLabelColor(
                                label.color,
                                theme.colorScheme.primary,
                              );
                              return AppChip(
                                selected: selected,
                                onSelected: (value) => setDialogState(() {
                                  if (value) {
                                    selectedLabelIds.add(label.id);
                                  } else {
                                    selectedLabelIds.remove(label.id);
                                  }
                                }),
                                style: selected
                                    ? AppChipStyle.filled
                                    : AppChipStyle.outlined,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(_roomLabelDisplay(label)),
                                  ],
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          AppDialogs.createCancelButton(context),
          const SizedBox(width: 8),
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: context.l10n.save,
          ),
        ],
      );
      if (confirmed != true) return;
      final labelIds = availableLabels()
          .where((label) => selectedLabelIds.contains(label.id))
          .map((label) => label.id)
          .toList(growable: false);
      await adminGateway.adminUpdateRoomTaxonomy(
        room.roomId,
        categoryId: selectedCategoryId.isEmpty ? null : selectedCategoryId,
        clearCategory: selectedCategoryId.isEmpty,
        labelIds: labelIds,
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.categoriesLabelsSaved);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.saveCategoriesLabelsFailed('$e'),
      );
    }
  }

  Future<void> _showRoomChatHistory(SyncTvRoom room) async {
    await showAppDialog<void>(
      context: context,
      builder: (_) => _RoomChatHistoryDialog(room: room),
    );
  }

  Future<void> _showRoomMembers(SyncTvRoom room) async {
    final searchController = TextEditingController();
    var page = 1;
    var pageSize = 20;
    var roleFilter = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED;
    var sortBy =
        admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
    var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;

    try {
      final data = await adminGateway.adminListRoomMembersPage(
        room.roomId,
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      if (!mounted) return;
      var members = data.members;
      var total = data.total;
      var onlineMemberCount = data.onlineMemberCount;
      var connectionCount = data.connectionCount;
      var loading = false;
      await AppDialogs.showStyledDialog(
        context: context,
        title: context.l10n.roomMembers,
        icon: const Icon(Icons.group_rounded, color: Color(0xFF5D5FEF)),
        content: SizedBox(
          width: 620,
          height: 560,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              Future<void> loadMembers() async {
                setDialogState(() => loading = true);
                try {
                  final next = await adminGateway.adminListRoomMembersPage(
                    room.roomId,
                    page: page,
                    pageSize: pageSize,
                    search: searchController.text.trim(),
                    role:
                        roleFilter ==
                            common_enum
                                .RoomMemberRole
                                .ROOM_MEMBER_ROLE_UNSPECIFIED
                        ? null
                        : roleFilter,
                    sortBy: sortBy,
                    sortDirection: sortDirection,
                  );
                  if (!context.mounted) return;
                  setDialogState(() {
                    members = next.members;
                    total = next.total;
                    onlineMemberCount = next.onlineMemberCount;
                    connectionCount = next.connectionCount;
                    loading = false;
                  });
                } catch (e) {
                  if (!context.mounted) return;
                  setDialogState(() => loading = false);
                  AppNotifications.showError(
                    context,
                    context.l10n.loadMembersFailed('$e'),
                  );
                }
              }

              Future<void> updateMemberRemarkName(
                AdminRoomMember member,
              ) async {
                final value = await _showRoomMemberTextDialog(
                  title: context.l10n.remarkName,
                  label: context.l10n.remarkName,
                  initialValue: member.remarkName,
                  icon: Icons.drive_file_rename_outline_rounded,
                );
                if (value == null || value == member.remarkName) return;
                try {
                  await adminGateway.adminUpdateRoomMemberRemarkName(
                    room.roomId,
                    member.userId,
                    value,
                  );
                  await loadMembers();
                  if (!context.mounted) return;
                  AppNotifications.showSuccess(
                    context,
                    context.l10n.remarkNameUpdated,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  AppNotifications.showError(
                    context,
                    context.l10n.updateRemarkNameFailed('$e'),
                  );
                }
              }

              Future<void> updateMemberDisplayTag(
                AdminRoomMember member,
              ) async {
                final value = await _showRoomMemberTextDialog(
                  title: context.l10n.displayLabel,
                  label: context.l10n.displayLabel,
                  initialValue: member.displayTag,
                  icon: Icons.sell_outlined,
                );
                if (value == null || value == member.displayTag) return;
                try {
                  await adminGateway.adminUpdateRoomMemberDisplayTag(
                    room.roomId,
                    member.userId,
                    value,
                  );
                  await loadMembers();
                  if (!context.mounted) return;
                  AppNotifications.showSuccess(
                    context,
                    context.l10n.displayLabelUpdated,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  AppNotifications.showError(
                    context,
                    context.l10n.updateDisplayLabelFailed('$e'),
                  );
                }
              }

              final totalPages = total <= 0 ? 1 : ((total - 1) ~/ pageSize) + 1;
              final canPrev = page > 1;
              final canNext = page < totalPages;

              return Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 190,
                        child: AppSearchField(
                          controller: searchController,
                          hintText: context.l10n.searchMembers,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              page = 1;
                              loadMembers();
                            }
                          },
                          onSubmitted: (_) {
                            page = 1;
                            loadMembers();
                          },
                        ),
                      ),
                      AppSelect<common_enum.RoomMemberRole>(
                        value: roleFilter,
                        options: {
                          context.l10n.allRoles: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_UNSPECIFIED,
                          context.l10n.creator: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_CREATOR,
                          context.l10n.administrator:
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                          context.l10n.member: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_MEMBER,
                          context.l10n.guest:
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          roleFilter = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppSelect<admin_enum.RoomMemberListSortBy>(
                        value: sortBy,
                        options: {
                          context.l10n.joinedAt: admin_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                          context.l10n.username: admin_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                          context.l10n.role: admin_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          sortBy = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppIconButton(
                        tooltip:
                            sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          sortDirection =
                              sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                              : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppSelect<int>(
                        value: pageSize,
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          pageSize = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppIconButton(
                        tooltip: context.l10n.refresh,
                        icon: Icons.refresh_rounded,
                        onPressed: loadMembers,
                      ),
                      AppActionButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _addRoomMember(room);
                        },
                        icon: Icons.person_add_alt_rounded,
                        label: context.l10n.addMember,
                        style: AppActionButtonStyle.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.l10n.memberAdminSummary(
                        total,
                        onlineMemberCount,
                        connectionCount,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: loading
                        ? const AppLoadingIndicator()
                        : members.isEmpty
                        ? AppEmptyMessage(message: context.l10n.noMembers)
                        : AppListView.builder(
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              final remarkName = member.remarkName.trim();
                              final displayTag = member.displayTag.trim();
                              final username = member.username.isEmpty
                                  ? member.userId
                                  : member.username;
                              final title = remarkName.isEmpty
                                  ? username
                                  : remarkName;
                              final subtitleParts = [
                                if (remarkName.isNotEmpty) username,
                                member.userId,
                                _roomMemberRoleText(context, member.role),
                                if (displayTag.isNotEmpty) displayTag,
                                member.isOnline
                                    ? context.l10n.roomConnections(
                                        member.connectionCount,
                                      )
                                    : context.l10n.offline,
                                _formatTimestamp(member.joinedAt),
                              ];
                              return AppTile(
                                prefix: Icon(
                                  member.isOnline
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: member.isOnline ? Colors.green : null,
                                ),
                                title: Text(title),
                                subtitle: Text(subtitleParts.join(' · ')),
                                suffix: Wrap(
                                  spacing: 4,
                                  children: [
                                    AppIconButton(
                                      tooltip: context.l10n.remarkName,
                                      icon: Icons
                                          .drive_file_rename_outline_rounded,
                                      onPressed: () async {
                                        await updateMemberRemarkName(member);
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.displayLabel,
                                      icon: Icons.sell_outlined,
                                      onPressed: () async {
                                        await updateMemberDisplayTag(member);
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.toggleAdministrator,
                                      icon: Icons.admin_panel_settings_outlined,
                                      onPressed: () async {
                                        final nextRole =
                                            member.role ==
                                                common_enum
                                                    .RoomMemberRole
                                                    .ROOM_MEMBER_ROLE_ADMIN
                                            ? common_enum
                                                  .RoomMemberRole
                                                  .ROOM_MEMBER_ROLE_MEMBER
                                            : common_enum
                                                  .RoomMemberRole
                                                  .ROOM_MEMBER_ROLE_ADMIN;
                                        await adminGateway
                                            .adminSetRoomMemberRole(
                                              room.roomId,
                                              member.userId,
                                              nextRole,
                                            );
                                        await loadMembers();
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.permissionOverrides,
                                      icon: Icons.tune_rounded,
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await _editRoomMemberPermissionOverrides(
                                          room,
                                          member,
                                        );
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.kick,
                                      icon: Icons.logout_rounded,
                                      style: AppIconButtonStyle.destructive,
                                      onPressed: () async {
                                        final cooldown =
                                            await _askKickCooldownSeconds();
                                        if (cooldown == null) return;
                                        await adminGateway.adminKickRoomMember(
                                          room.roomId,
                                          member.userId,
                                          kickCooldownSeconds: cooldown,
                                        );
                                        await loadMembers();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  AppPaginationBar(
                    padding: EdgeInsets.zero,
                    label: context.l10n.memberPageSummary(
                      total,
                      page,
                      totalPages,
                    ),
                    onPrevious: canPrev
                        ? () {
                            page -= 1;
                            loadMembers();
                          }
                        : null,
                    onNext: canNext
                        ? () {
                            page += 1;
                            loadMembers();
                          }
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
        actions: [_closeButton(context)],
      );
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.loadMembersFailed('$e'));
    }
  }

  Future<void> _addRoomMember(SyncTvRoom room) async {
    final controller = TextEditingController();
    var role = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER;
    var notify = true;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.addMember,
      icon: const Icon(Icons.person_add_alt_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDialogs.createFormField(
                context: context,
                label: context.l10n.userId,
                controller: controller,
                hintText: 'usr_...',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              AppSelect<common_enum.RoomMemberRole>(
                value: role,
                label: context.l10n.roomRole,
                options: {
                  context.l10n.member:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                  context.l10n.administrator:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                },
                onChanged: (value) => setDialogState(
                  () => role =
                      value ??
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                ),
              ),
              const SizedBox(height: 12),
              AppSwitchTile(
                title: Text(context.l10n.notifyMember),
                value: notify,
                onChanged: (value) => setDialogState(() => notify = value),
              ),
            ],
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.add,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminAddRoomMember(
        room.roomId,
        controller.text.trim(),
        role: role,
        notify: notify,
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.memberAdded);
      _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.addMemberFailed('$e'));
    }
  }

  Future<String?> _showRoomMemberTextDialog({
    required String title,
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    final controller = TextEditingController(text: initialValue);
    void submit() => Navigator.pop(context, controller.text.trim());

    return AppDialogs.showStyledDialog<String>(
      context: context,
      title: title,
      icon: Icon(icon, color: const Color(0xFF5D5FEF)),
      content: SizedBox(
        width: 360,
        child: AppTextField(
          controller: controller,
          label: label,
          autofocus: true,
          maxLength: 64,
          onSubmitted: (_) => submit(),
        ),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          submit,
          text: context.l10n.save,
        ),
      ],
    ).whenComplete(controller.dispose);
  }

  Future<int?> _askKickCooldownSeconds() async {
    final controller = TextEditingController(text: '60');
    final value = await AppDialogs.showStyledDialog<int>(
      context: context,
      title: context.l10n.kickMember,
      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      content: AppDialogs.createFormField(
        context: context,
        label: context.l10n.cooldownSeconds,
        controller: controller,
        hintText: '1 - 2592000',
        prefixIcon: Icons.timer_outlined,
        keyboardType: TextInputType.number,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(context, () {
          final seconds = int.tryParse(controller.text.trim());
          if (seconds == null || seconds < 1 || seconds > 2592000) {
            AppNotifications.showWarning(
              context,
              context.l10n.cooldownSecondsRange,
            );
            return;
          }
          Navigator.pop(context, seconds);
        }, text: context.l10n.kick),
      ],
    );
    return value;
  }

  Future<void> _editRoomMemberPermissionOverrides(
    SyncTvRoom room,
    AdminRoomMember member,
  ) async {
    final result = await _showPermissionOverrideDialog(member);
    if (result == null) {
      await _showRoomMembers(room);
      return;
    }
    try {
      await adminGateway.adminUpdateRoomMemberPermissionOverrides(
        room.roomId,
        member.userId,
        role: member.role,
        addedPermissions: result.addedPermissions,
        removedPermissions: result.removedPermissions,
        adminAddedPermissions: result.adminAddedPermissions,
        adminRemovedPermissions: result.adminRemovedPermissions,
      );
      if (!mounted) return;
      AppNotifications.showSuccess(
        context,
        context.l10n.memberPermissionsUpdated,
      );
      await _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.updatePermissionsFailed('$e'),
      );
      await _showRoomMembers(room);
    }
  }

  Future<_PermissionOverrideResult?> _showPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN;
    var added = isAdmin
        ? member.adminAddedPermissions
        : member.addedPermissions;
    var removed = isAdmin
        ? member.adminRemovedPermissions
        : member.removedPermissions;
    final permissions = isAdmin
        ? RoomAdminPermissions.values
        : RoomMemberPermissions.values;

    return AppDialogs.showStyledDialog<_PermissionOverrideResult>(
      context: context,
      title: context.l10n.permissionOverrides,
      icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          void setOverride(int flag, _PermissionOverrideMode mode) {
            setDialogState(() {
              added &= ~flag;
              removed &= ~flag;
              switch (mode) {
                case _PermissionOverrideMode.inherit:
                  break;
                case _PermissionOverrideMode.allow:
                  added |= flag;
                case _PermissionOverrideMode.deny:
                  removed |= flag;
              }
            });
          }

          return SizedBox(
            width: 460,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 520),
              child: AppListView(
                shrinkWrap: true,
                children: permissions
                    .map(
                      (permission) => _permissionOverrideRow(
                        isAdmin
                            ? context.l10n.roomAdminPermissionLabel(permission)
                            : context.l10n.roomMemberPermissionLabel(
                                permission,
                              ),
                        permission,
                        added,
                        removed,
                        setOverride,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () {
            Navigator.pop(
              context,
              const _PermissionOverrideResult(
                addedPermissions: 0,
                removedPermissions: 0,
                adminAddedPermissions: 0,
                adminRemovedPermissions: 0,
              ),
            );
          },
          label: context.l10n.clearOverrides,
          style: AppActionButtonStyle.text,
        ),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(context, () {
          Navigator.pop(
            context,
            _PermissionOverrideResult(
              addedPermissions: isAdmin ? 0 : added,
              removedPermissions: isAdmin ? 0 : removed,
              adminAddedPermissions: isAdmin ? added : 0,
              adminRemovedPermissions: isAdmin ? removed : 0,
            ),
          );
        }, text: context.l10n.save),
      ],
    );
  }

  Widget _permissionOverrideRow(
    String title,
    int flag,
    int added,
    int removed,
    void Function(int flag, _PermissionOverrideMode mode) onChanged,
  ) {
    final mode = (added & flag) != 0
        ? _PermissionOverrideMode.allow
        : (removed & flag) != 0
        ? _PermissionOverrideMode.deny
        : _PermissionOverrideMode.inherit;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          AppSegmentedControl<_PermissionOverrideMode>(
            segments: [
              ButtonSegment(
                value: _PermissionOverrideMode.inherit,
                label: Text(context.l10n.inherit),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.allow,
                label: Text(context.l10n.allow),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.deny,
                label: Text(context.l10n.deny),
              ),
            ],
            value: mode,
            onChanged: (selection) => onChanged(flag, selection),
          ),
        ],
      ),
    );
  }

  Future<void> _editRoomSettings(SyncTvRoom room) async {
    try {
      final settings = await adminGateway.adminGetRoomSettings(room.roomId);
      if (!mounted) return;
      final maxMembers = TextEditingController(
        text: settings.maxMembers.toString(),
      );
      bool requirePassword = settings.requirePassword;
      bool requireApproval = settings.requireApproval;
      bool allowGuestJoin = settings.allowGuestJoin;
      bool chatEnabled = settings.chatEnabled;
      final confirmed = await AppDialogs.showStyledDialog<bool>(
        context: context,
        title: context.l10n.roomSettings,
        icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSwitchTile(
                    value: requirePassword,
                    onChanged: (value) =>
                        setDialogState(() => requirePassword = value),
                    title: Text(context.l10n.requiresPassword),
                  ),
                  AppSwitchTile(
                    value: requireApproval,
                    onChanged: (value) =>
                        setDialogState(() => requireApproval = value),
                    title: Text(context.l10n.joinRequiresApproval),
                  ),
                  AppSwitchTile(
                    value: allowGuestJoin,
                    onChanged: (value) =>
                        setDialogState(() => allowGuestJoin = value),
                    title: Text(context.l10n.allowGuestJoin),
                  ),
                  AppSwitchTile(
                    value: chatEnabled,
                    onChanged: (value) =>
                        setDialogState(() => chatEnabled = value),
                    title: Text(context.l10n.chat),
                  ),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.maximumMembers,
                    controller: maxMembers,
                    hintText: '100',
                    prefixIcon: Icons.groups_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          AppActionButton(
            onPressed: () async {
              await adminGateway.adminResetRoomSettings(room.roomId);
              if (!mounted) return;
              Navigator.pop(context, false);
              AppNotifications.showSuccess(
                context,
                context.l10n.roomSettingsReset,
              );
            },
            label: context.l10n.reset,
            style: AppActionButtonStyle.text,
          ),
          AppDialogs.createCancelButton(context),
          const SizedBox(width: 8),
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: context.l10n.save,
          ),
        ],
      );
      if (confirmed != true) return;
      if (!mounted) return;
      settings.requirePassword = requirePassword;
      settings.requireApproval = requireApproval;
      settings.allowGuestJoin = allowGuestJoin;
      settings.chatEnabled = chatEnabled;
      settings.maxMembers =
          int.tryParse(maxMembers.text.trim()) ?? settings.maxMembers;
      await adminGateway.adminUpdateRoomSettings(room.roomId, settings);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.roomSettingsSaved);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.saveRoomSettingsFailed('$e'),
      );
    }
  }

  String _getStatusText(common_enum.RoomStatus status) {
    switch (status) {
      case common_enum.RoomStatus.ROOM_STATUS_ACTIVE:
        return context.l10n.active;
      case common_enum.RoomStatus.ROOM_STATUS_CLOSED:
        return context.l10n.closed;
      default:
        return context.l10n.unknown;
    }
  }

  Color _getStatusColor(common_enum.RoomStatus status) {
    switch (status) {
      case common_enum.RoomStatus.ROOM_STATUS_ACTIVE:
        return Colors.green;
      case common_enum.RoomStatus.ROOM_STATUS_CLOSED:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _roomStatusLabel(SyncTvRoom room) {
    return room.isBanned ? context.l10n.banned : _getStatusText(room.status);
  }

  Color _roomStatusColorForRoom(SyncTvRoom room) {
    return room.isBanned ? Colors.red : _getStatusColor(room.status);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: _AdminToolbarWrap(
            items: [
              _AdminToolbarItem(
                width: 240,
                child: _buildStyledTextField(
                  controller: _searchController,
                  onSubmitted: (val) {
                    setState(() {
                      _searchQuery = val;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                  hint: context.l10n.searchRooms,
                  icon: Icons.search,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<String?>(
                  value: _categoryFilter.isEmpty ? null : _categoryFilter,
                  hintText: context.l10n.allCategories,
                  prefixIcon: Icons.category_outlined,
                  clearable: true,
                  enabled: !_isLoadingTaxonomy && _categories.isNotEmpty,
                  options: {
                    context.l10n.allCategories: null,
                    for (final category in _categories)
                      _roomCategoryDisplay(category): category.id,
                  },
                  onChanged: (value) {
                    setState(() {
                      _categoryFilter = value ?? '';
                      _labelFilters.removeWhere(
                        (id) => !_availableFilterLabels.any(
                          (label) => label.id == id,
                        ),
                      );
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppActionButton(
                  onPressed: _isLoadingTaxonomy
                      ? null
                      : _showRoomLabelFilterDialog,
                  icon: Icons.sell_outlined,
                  label: _labelFilters.isEmpty
                      ? context.l10n.labels
                      : context.l10n.selectedLabels(_labelFilters.length),
                  style: _labelFilters.isEmpty
                      ? AppActionButtonStyle.outlined
                      : AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<common_enum.RoomStatus>(
                  value: _statusFilter,
                  options: {
                    context.l10n.allStatuses:
                        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                    context.l10n.active:
                        common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                    context.l10n.closed:
                        common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                  },
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _statusFilter = val;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<bool?>(
                  value: _bannedFilter,
                  options: {
                    context.l10n.allBanStates: null,
                    context.l10n.bannedOnly: true,
                    context.l10n.notBanned: false,
                  },
                  onChanged: (value) {
                    setState(() {
                      _bannedFilter = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 126,
                child: AppSelect<admin_enum.RoomListSortBy>(
                  value: _sortBy,
                  options: {
                    context.l10n.createdAt:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                    context.l10n.updatedAt:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                    context.l10n.recentActivity: admin_enum
                        .RoomListSortBy
                        .ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                    context.l10n.roomName:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _sortBy = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 44,
                child: AppIconButton(
                  tooltip:
                      _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? context.l10n.descending
                      : context.l10n.ascending,
                  icon:
                      _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? Icons.south_rounded
                      : Icons.north_rounded,
                  onPressed: () {
                    setState(() {
                      _sortDirection =
                          _sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                          : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 96,
                child: AppSelect<int>(
                  value: _pageSize,
                  options: {
                    context.l10n.itemsPerPage(20): 20,
                    context.l10n.itemsPerPage(50): 50,
                    context.l10n.itemsPerPage(100): 100,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _pageSize = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              if (_categoryFilter.isNotEmpty || _labelFilters.isNotEmpty)
                _AdminToolbarItem(
                  width: 44,
                  child: AppIconButton(
                    tooltip: context.l10n.clearRoomTaxonomyFilters,
                    icon: Icons.filter_alt_off_rounded,
                    onPressed: () {
                      setState(() {
                        _categoryFilter = '';
                        _labelFilters.clear();
                        _page = 1;
                      });
                      _loadRooms();
                    },
                    style: AppIconButtonStyle.tonal,
                  ),
                ),
              _AdminToolbarItem(
                width: 44,
                child: AppIconButton(
                  tooltip: context.l10n.selectCurrentPage,
                  icon: Icons.select_all_rounded,
                  onPressed: _rooms.isEmpty
                      ? null
                      : () {
                          setState(() {
                            _selectedRoomIds.addAll(
                              _rooms.map((room) => room.roomId),
                            );
                          });
                        },
                ),
              ),
            ],
          ),
        ),
        if (_selectedRoomIds.isNotEmpty) _buildRoomBatchBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadRooms();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadRooms();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : _rooms.isEmpty
              ? AppEmptyMessage(message: context.l10n.noRooms)
              : AppListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    final statusColor = _roomStatusColorForRoom(room);
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        prefix: AppCheckbox(
                          value: _selectedRoomIds.contains(room.roomId),
                          semanticsLabel: context.l10n.selectRoom,
                          onChanged: (value) =>
                              _toggleRoomSelection(room.roomId, value),
                        ),
                        title: Text(
                          room.roomName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              AppBadge(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: statusColor,
                                borderSide: BorderSide(
                                  color: statusColor.withValues(alpha: 0.50),
                                ),
                                label: Text(
                                  _roomStatusLabel(room),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'ID: ${room.roomId}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.hintColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!room.isBanned)
                              AppIconButton(
                                icon: Icons.block,
                                iconSize: 22,
                                tooltip: context.l10n.ban,
                                style: AppIconButtonStyle.destructive,
                                onPressed: () => _banRoom(room, true),
                              )
                            else
                              AppIconButton(
                                icon: Icons.check_circle,
                                iconSize: 22,
                                tooltip: context.l10n.unban,
                                onPressed: () => _banRoom(room, false),
                              ),
                            AppActionButton(
                              icon: Icons.info_outline_rounded,
                              label: context.l10n.roomInformation,
                              size: AppActionButtonSize.sm,
                              style: AppActionButtonStyle.tonal,
                              onPressed: () => _showRoomDetails(room),
                            ),
                            AppIconButton(
                              icon: Icons.group_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.members,
                              onPressed: () => _showRoomMembers(room),
                            ),
                            AppIconButton(
                              icon: Icons.forum_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.chatHistory,
                              onPressed: () => _showRoomChatHistory(room),
                            ),
                            AppIconButton(
                              icon: Icons.report_gmailerrorred_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.reports,
                              onPressed: () => _openContentReportsViewer(
                                context,
                                title: context.l10n.roomReports(room.roomName),
                                targetType: admin_enum
                                    .ContentReportTargetType
                                    .CONTENT_REPORT_TARGET_TYPE_ROOM,
                                targetRoomId: room.roomId,
                                scope: admin_enum
                                    .ContentReportScope
                                    .CONTENT_REPORT_SCOPE_TARGET_ROOM,
                              ),
                            ),
                            AppIconButton(
                              icon: Icons.tune_rounded,
                              iconSize: 22,
                              tooltip: context.l10n.settings,
                              onPressed: () => _editRoomSettings(room),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRoomBatchBar(ThemeData theme, bool isDark) {
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(context.l10n.roomsSelected(_selectedRoomIds.length)),
          ),
          AppActionButton(
            onPressed: () => setState(_selectedRoomIds.clear),
            label: context.l10n.clear,
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanRooms,
            icon: Icons.block_rounded,
            label: context.l10n.ban,
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteRooms,
            icon: Icons.delete_outline_rounded,
            label: context.l10n.delete,
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required Function(String) onSubmitted,
    required String hint,
    required IconData icon,
  }) {
    return AppSearchField(
      controller: controller,
      hintText: hint,
      icon: icon,
      onSubmitted: onSubmitted,
    );
  }
}
