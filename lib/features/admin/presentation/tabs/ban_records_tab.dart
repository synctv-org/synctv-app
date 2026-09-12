part of '../admin_settings_page.dart';

class AdminBanRecordsTab extends StatefulWidget {
  const AdminBanRecordsTab({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<AdminBanRecordsTab> createState() => _AdminBanRecordsTabState();
}

class _AdminBanRecordsTabState extends State<AdminBanRecordsTab> {
  bool _isLoading = true;
  int _loadGeneration = 0;
  admin_enum.BanTargetType _targetType =
      admin_enum.BanTargetType.BAN_TARGET_TYPE_UNSPECIFIED;
  bool? _active = true;
  String _search = '';
  String _userId = '';
  String _roomId = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  List<AdminBanRecord> _records = const [];
  final _searchController = TextEditingController();
  final Set<(admin_enum.BanTargetType, String)> _unbanning = {};

  bool _initialized = false;

  @override
  void didUpdateWidget(covariant AdminBanRecordsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      unawaited(_loadRecords(silent: true));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadRecords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords({bool silent = false}) async {
    final generation = ++_loadGeneration;
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await adminGateway.adminListBanRecordsPage(
        page: _page,
        pageSize: _pageSize,
        targetType: _targetType,
        active: _active,
        userId: _userId,
        roomId: _roomId,
      );
      if (!mounted || generation != _loadGeneration) return;
      final lastPage = math.max(1, (data.total + _pageSize - 1) ~/ _pageSize);
      if (_page > lastPage) {
        setState(() => _page = lastPage);
        await _loadRecords();
        return;
      }
      setState(() {
        _records = data.records;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadBanRecordsFailed('$e'),
      );
    }
  }

  void _applyBanSearch(String value) {
    final normalized = value.trim();
    final isUserId = normalized.startsWith('usr_') && normalized.length > 4;
    final isRoomId = normalized.startsWith('room_') && normalized.length > 5;
    if (normalized.isNotEmpty && !isUserId && !isRoomId) {
      AppNotifications.showWarning(context, context.l10n.userOrRoomIdHint);
      return;
    }
    setState(() {
      _search = normalized;
      _userId = isUserId ? normalized : '';
      _roomId = isRoomId ? normalized : '';
      _page = 1;
    });
    _loadRecords();
  }

  Future<void> _unbanRecord(AdminBanRecord record) async {
    if (!mounted) return;
    final isUserBan =
        record.targetType == admin_enum.BanTargetType.BAN_TARGET_TYPE_USER;
    final targetName = isUserBan
        ? (record.username.isEmpty ? record.userId : record.username)
        : (record.roomName.isEmpty ? record.roomId : record.roomName);
    final targetId = isUserBan ? record.userId : record.roomId;
    if (targetId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.banRecordMissingTargetId,
      );
      return;
    }

    final key = (record.targetType, targetId);
    if (_unbanning.contains(key)) return;
    setState(() => _unbanning.add(key));
    try {
      final confirmed = await AppDialogs.showStyledDialog<bool>(
        context: context,
        title: isUserBan ? context.l10n.unbanUser : context.l10n.unbanRoom,
        icon: const Icon(Icons.lock_open_rounded, color: Colors.green),
        content: Text(context.l10n.confirmUnban(targetName)),
        actions: [
          AppDialogs.createCancelButton(context),
          const SizedBox(width: 8),
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: context.l10n.unban,
          ),
        ],
      );
      if (confirmed != true || !mounted) return;

      if (isUserBan) {
        await adminGateway.adminBanUser(targetId, false);
      } else {
        await adminGateway.adminBanRoom(targetId, false);
      }
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.unbanned);
      await _loadRecords(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.unbanFailed('$e'));
    } finally {
      if (mounted) setState(() => _unbanning.remove(key));
    }
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return _AdminPagedList(
      header: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppSelect<admin_enum.BanTargetType>(
                value: _targetType,
                options: {
                  context.l10n.allTargets:
                      admin_enum.BanTargetType.BAN_TARGET_TYPE_UNSPECIFIED,
                  context.l10n.users:
                      admin_enum.BanTargetType.BAN_TARGET_TYPE_USER,
                  context.l10n.rooms:
                      admin_enum.BanTargetType.BAN_TARGET_TYPE_ROOM,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _targetType = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              AppSelect<bool?>(
                value: _active,
                options: {
                  context.l10n.allStatuses: null,
                  context.l10n.active: true,
                  context.l10n.revokedOrExpired: false,
                },
                onChanged: (value) {
                  setState(() {
                    _active = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              AppSelect<int>(
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
                  _loadRecords();
                },
              ),
              SizedBox(
                width: 260,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: context.l10n.userOrRoomIdHint,
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) {
                      _applyBanSearch('');
                    }
                  },
                  onSubmitted: _applyBanSearch,
                ),
              ),
              if (_search.isNotEmpty)
                AppChip(
                  label: Text(_search),
                  avatar: const Icon(Icons.close_rounded, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    _applyBanSearch('');
                  },
                ),
              AppIconButton(
                tooltip: context.l10n.refresh,
                icon: Icons.refresh_rounded,
                onPressed: () => _loadRecords(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadRecords();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadRecords();
                },
        ),
      ],
      loading: _isLoading,
      itemCount: _records.length,
      emptyMessage: context.l10n.noBanRecords,
      itemBuilder: (context, index) {
        final record = _records[index];
        final target =
            record.targetType == admin_enum.BanTargetType.BAN_TARGET_TYPE_USER
            ? '${record.username} (${record.userId})'
            : '${record.roomName} (${record.roomId})';
        return _AdminPanelCard(
          isDark: isDark,
          child: AppTile(
            prefix: Icon(
              record.isActive
                  ? Icons.block_rounded
                  : Icons.check_circle_outline,
              color: record.isActive ? Colors.red : Colors.green,
            ),
            title: Text(target),
            subtitle: Text(
              context.l10n.banRecordSummary(
                record.reason.isEmpty ? context.l10n.noReason : record.reason,
                record.bannedByUsername,
                _formatTimestamp(record.startsAt),
              ),
            ),
            suffix: record.isActive
                ? AppIconButton(
                    tooltip: context.l10n.unban,
                    icon: Icons.lock_open_rounded,
                    onPressed:
                        _unbanning.contains((
                          record.targetType,
                          record.targetType ==
                                  admin_enum.BanTargetType.BAN_TARGET_TYPE_USER
                              ? record.userId
                              : record.roomId,
                        ))
                        ? null
                        : () => _unbanRecord(record),
                  )
                : Text(context.l10n.ended),
          ),
        );
      },
    );
  }
}
