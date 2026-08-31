part of '../admin_settings_page.dart';

class UserManagementTab extends StatefulWidget {
  const UserManagementTab({super.key});

  @override
  State<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<UserManagementTab> {
  List<SyncTvUser> _users = [];
  bool _isLoading = true;
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchQuery = '';
  common_enum.UserStatus _statusFilter =
      common_enum.UserStatus.USER_STATUS_UNSPECIFIED;
  common_enum.UserRole _roleFilter = common_enum.UserRole.USER_ROLE_UNSPECIFIED;
  bool? _bannedFilter;
  admin_enum.UserListSortBy _sortBy =
      admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  final Set<String> _selectedUserIds = {};
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
      _loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await adminGateway.adminListUsersPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchQuery,
        status: _statusFilter,
        role: _roleFilter,
        isBanned: _bannedFilter,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );

      if (!mounted) return;

      setState(() {
        _users = data.users;
        _total = data.total;
        _selectedUserIds.removeWhere(
          (id) => !_users.any((user) => user.id == id),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppNotifications.showError(context, context.l10n.loadUsersFailed('$e'));
      }
    }
  }

  Future<void> _addUser() async {
    final l10n = context.l10n;
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    var role = common_enum.UserRole.USER_ROLE_USER;
    var status = common_enum.UserStatus.USER_STATUS_ACTIVE;

    await AppDialogs.showStyledDialog(
      context: context,
      title: l10n.addUser,
      icon: const Icon(Icons.person_add, color: Color(0xFF5D5FEF)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDialogs.createFormField(
            context: context,
            label: l10n.username,
            controller: usernameController,
            hintText: l10n.usernameRequired,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          AppDialogs.createFormField(
            context: context,
            label: l10n.email,
            controller: emailController,
            hintText: l10n.optional,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppDialogs.createFormField(
            context: context,
            label: l10n.password,
            controller: passwordController,
            hintText: l10n.passwordRequired,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          AppSelect<common_enum.UserRole>(
            value: role,
            label: l10n.role,
            options: {
              l10n.user: common_enum.UserRole.USER_ROLE_USER,
              l10n.administrator: common_enum.UserRole.USER_ROLE_ADMIN,
            },
            onChanged: (value) {
              if (value != null) role = value;
            },
          ),
          const SizedBox(height: 12),
          AppSelect<common_enum.UserStatus>(
            value: status,
            label: l10n.status,
            options: {
              l10n.active: common_enum.UserStatus.USER_STATUS_ACTIVE,
              l10n.banned: common_enum.UserStatus.USER_STATUS_BANNED,
            },
            onChanged: (val) =>
                status = val ?? common_enum.UserStatus.USER_STATUS_ACTIVE,
          ),
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(context, () async {
          if (usernameController.text.isEmpty ||
              passwordController.text.isEmpty) {
            AppNotifications.showWarning(
              context,
              l10n.usernameAndPasswordRequired,
            );
            return;
          }
          try {
            await adminGateway.adminAddUser(
              usernameController.text,
              passwordController.text,
              role,
              email: emailController.text.trim(),
              status: status,
            );
            if (!mounted) return;
            Navigator.pop(context);
            AppNotifications.showSuccess(context, l10n.userCreated);
            _loadUsers(silent: true);
          } catch (e) {
            if (!mounted) return;
            AppNotifications.showError(context, l10n.createUserFailed('$e'));
          }
        }, text: l10n.create),
      ],
    );
  }

  Future<void> _deleteUser(SyncTvUser user) async {
    final l10n = context.l10n;
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.deleteUser,
      icon: const Icon(Icons.warning, color: Colors.red),
      content: _destructiveDialogContent(
        l10n.permanentlyDeleteUser(user.username),
        [
          l10n.deleteUserClearsAccountData,
          l10n.deleteUserAffectsRelatedData,
          l10n.deleteUserRevokesOnlineAccess,
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await adminGateway.adminDeleteUser(user.id);
        if (!mounted) return;
        AppNotifications.showSuccess(context, l10n.userDeleted);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        AppNotifications.showError(context, l10n.deleteUserFailed('$e'));
      }
    }
  }

  Future<void> _toggleAdmin(SyncTvUser user) async {
    final l10n = context.l10n;
    final isAdmin = user.role.hasSystemAdminPrivileges;
    if (user.role.isSystemRoot) {
      AppNotifications.showWarning(context, l10n.rootUserCannotBeDemoted);
      return;
    }
    final action = isAdmin
        ? l10n.removeAdministratorRole
        : l10n.makeAdministrator;

    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.changePermissions,
      icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF5D5FEF)),
      content: Text(l10n.confirmUserRoleAction(user.username, action)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.confirm,
        ),
      ],
    );

    if (confirm == true) {
      try {
        if (isAdmin) {
          await adminGateway.adminRemoveAdmin(user.id);
        } else {
          await adminGateway.adminAddAdmin(user.id);
        }
        if (!mounted) return;
        AppNotifications.showSuccess(context, l10n.operationSucceeded);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        AppNotifications.showError(context, l10n.operationFailed('$e'));
      }
    }
  }

  Future<void> _banUser(SyncTvUser user, bool ban) async {
    final l10n = context.l10n;
    final action = ban ? l10n.ban : l10n.unban;
    final reasonController = TextEditingController();
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.userAction(action),
      icon: Icon(
        ban ? Icons.block : Icons.check_circle,
        color: ban ? Colors.red : Colors.green,
      ),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.confirmUserAction(action, user.username)),
                const SizedBox(height: 12),
                AppDialogs.createFormField(
                  context: context,
                  label: l10n.banReason,
                  controller: reasonController,
                  hintText: l10n.optional,
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text(l10n.confirmUserAction(action, user.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.confirm,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await adminGateway.adminBanUser(
          user.id,
          ban,
          reason: reasonController.text.trim(),
        );
        if (!mounted) return;
        AppNotifications.showSuccess(context, l10n.operationSucceeded);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        AppNotifications.showError(context, l10n.operationFailed('$e'));
      }
    }
  }

  void _toggleUserSelection(String userId, bool selected) {
    setState(() {
      if (selected) {
        _selectedUserIds.add(userId);
      } else {
        _selectedUserIds.remove(userId);
      }
    });
  }

  Future<void> _batchBanUsers() async {
    if (_selectedUserIds.isEmpty) return;
    final l10n = context.l10n;
    final reasonController = TextEditingController();
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.batchBanUsers,
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.usersWillBeBanned(_selectedUserIds.length)),
          const SizedBox(height: 12),
          AppDialogs.createFormField(
            context: context,
            label: l10n.banReason,
            controller: reasonController,
            hintText: l10n.optional,
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
          text: l10n.ban,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await adminGateway.adminBatchBanUsers(
        _selectedUserIds.toList(),
        reason: reasonController.text.trim(),
      );
      if (!mounted) return;
      _showBatchResult(l10n.batchBanCompleted, result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.batchBanFailed('$e'));
    }
  }

  Future<void> _batchDeleteUsers() async {
    if (_selectedUserIds.isEmpty) return;
    final l10n = context.l10n;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.batchDeleteUsers,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        l10n.usersWillBeDeleted(_selectedUserIds.length),
        [
          l10n.batchDeleteUsersClearsAccountData,
          l10n.batchDeleteUsersAffectsRelatedData,
          l10n.batchDeleteBackupOnly,
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await adminGateway.adminBatchDeleteUsers(
        _selectedUserIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult(l10n.batchDeleteCompleted, result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.batchDeleteFailed('$e'));
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

  Future<void> _showUserDetails(SyncTvUser user) async {
    try {
      final results = await Future.wait([
        adminGateway.adminGetUser(user.id),
        adminGateway.adminGetUserPreferences(user.id),
      ]);
      if (!mounted) return;
      final detail = results[0] as SyncTvUser;
      final preferences = results[1] as AccountPreferences;
      final l10n = context.l10n;
      await AppDialogs.showStyledDialog(
        context: context,
        title: detail.username,
        icon: const Icon(Icons.person_rounded, color: Color(0xFF5D5FEF)),
        content: SizedBox(
          width: 620,
          height: 520,
          child: AppDefaultTabController(
            length: 4,
            child: Column(
              children: [
                AppTabBar(
                  tabs: [
                    Tab(text: l10n.profile),
                    Tab(text: l10n.rooms),
                    Tab(text: l10n.reports),
                    Tab(text: l10n.preferences),
                  ],
                ),
                Expanded(
                  child: AppTabBarView(
                    children: [
                      _buildUserProfileDetails(detail),
                      _buildUserRoomsPanel(user.id),
                      _buildUserReportsPanel(detail),
                      _buildUserPreferencesPanel(user.id, preferences),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [_closeButton(context)],
      );
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.loadUserDetailsFailed('$e'),
      );
    }
  }

  Widget _buildUserReportsPanel(SyncTvUser user) {
    return AppDefaultTabController(
      length: 2,
      child: Column(
        children: [
          AppTabBar(
            tabs: [
              Tab(text: context.l10n.reportsAgainstUser),
              Tab(text: context.l10n.reportsByUser),
            ],
          ),
          Expanded(
            child: AppTabBarView(
              children: [
                ContentReportsView(
                  title: '',
                  initialTargetType: admin_enum
                      .ContentReportTargetType
                      .CONTENT_REPORT_TARGET_TYPE_USER,
                  initialTargetUserId: user.id,
                  initialScope: admin_enum
                      .ContentReportScope
                      .CONTENT_REPORT_SCOPE_TARGET_USER,
                  showTargetTypeTabs: false,
                ),
                ContentReportsView(
                  title: '',
                  initialReporterUserId: user.id,
                  showTargetTypeTabs: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileDetails(SyncTvUser detail) {
    return AppListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _InfoLine(context.l10n.userId, detail.id),
        _InfoLine(context.l10n.email, detail.email ?? '-'),
        _InfoLine(context.l10n.role, _systemRoleText(context, detail.role)),
        _InfoLine(context.l10n.status, _userStatusText(context, detail.status)),
        _InfoLine(context.l10n.createdAt, _formatTimestamp(detail.createdAt)),
        if (detail.updatedAt > 0)
          _InfoLine(context.l10n.updatedAt, _formatTimestamp(detail.updatedAt)),
        if (detail.isBanned) ...[
          _InfoLine(context.l10n.bannedAt, _formatTimestamp(detail.bannedAt)),
          if (detail.bannedBy.isNotEmpty)
            _InfoLine(context.l10n.bannedBy, detail.bannedBy),
          if (detail.bannedReason.isNotEmpty)
            _InfoLine(context.l10n.banReason, detail.bannedReason),
        ],
      ],
    );
  }

  Widget _buildUserRoomsPanel(String userId) {
    var rooms = <SyncTvRoom>[];
    var total = 0;
    var page = 1;
    var pageSize = 20;
    final searchController = TextEditingController();
    var search = '';
    var status = common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
    bool? isBanned;
    var sortBy = admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT;
    var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;
    var loading = true;
    var initialized = false;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> loadRooms() async {
          setDialogState(() => loading = true);
          try {
            final data = await adminGateway.adminListUserRoomsPage(
              userId,
              page: page,
              pageSize: pageSize,
              search: search,
              status: status,
              isBanned: isBanned,
              sortBy: sortBy,
              sortDirection: sortDirection,
            );
            if (!context.mounted) return;
            setDialogState(() {
              rooms = data.rooms;
              total = data.total;
              loading = false;
            });
          } catch (e) {
            if (!context.mounted) return;
            setDialogState(() => loading = false);
            AppNotifications.showError(
              context,
              context.l10n.loadUserRoomsFailed('$e'),
            );
          }
        }

        if (!initialized) {
          initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) loadRooms();
          });
        }

        final pageCount = total <= 0 ? 1 : ((total + pageSize - 1) ~/ pageSize);
        return Column(
          children: [
            AppSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: AppSearchField(
                      controller: searchController,
                      hintText: context.l10n.searchRooms,
                      onChanged: (value) {
                        if (value.isEmpty && search.isNotEmpty) {
                          search = '';
                          page = 1;
                          loadRooms();
                        }
                      },
                      onSubmitted: (value) {
                        search = value.trim();
                        page = 1;
                        loadRooms();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppSelect<common_enum.RoomStatus>(
                    value: status,
                    options: {
                      context.l10n.allStatuses:
                          common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                      context.l10n.active:
                          common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                      context.l10n.closed:
                          common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      status = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  AppSelect<bool?>(
                    value: isBanned,
                    options: {
                      context.l10n.allBanStates: null,
                      context.l10n.bannedOnly: true,
                      context.l10n.notBanned: false,
                    },
                    onChanged: (value) {
                      isBanned = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  AppSelect<admin_enum.RoomListSortBy>(
                    value: sortBy,
                    options: {
                      context.l10n.createdAt: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_CREATED_AT,
                      context.l10n.updatedAt: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_UPDATED_AT,
                      context.l10n.recentActivity: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                      context.l10n.roomName:
                          admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      sortBy = value;
                      page = 1;
                      loadRooms();
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
                      loadRooms();
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
                      loadRooms();
                    },
                  ),
                  AppIconButton(
                    tooltip: context.l10n.refresh,
                    icon: Icons.refresh_rounded,
                    onPressed: loadRooms,
                  ),
                ],
              ),
            ),
            _AdminPager(
              page: page,
              pageSize: pageSize,
              total: total,
              onPrevious: page <= 1
                  ? null
                  : () {
                      page -= 1;
                      loadRooms();
                    },
              onNext: page >= pageCount
                  ? null
                  : () {
                      page += 1;
                      loadRooms();
                    },
            ),
            Expanded(
              child: loading
                  ? const AppLoadingIndicator()
                  : rooms.isEmpty
                  ? AppEmptyMessage(message: context.l10n.noRooms)
                  : AppListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return AppTile(
                          prefix: Icon(
                            Icons.meeting_room_outlined,
                            color: room.isBanned
                                ? Colors.red
                                : _roomStatusColor(room.status),
                          ),
                          title: Text(
                            room.roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${room.roomId} · ${room.isBanned ? context.l10n.banned : _roomStatusText(context, room.status)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserPreferencesPanel(
    String userId,
    AccountPreferences initialPreferences,
  ) {
    AccountPreferences preferences = initialPreferences;
    var notifications = preferences.notifications;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> savePreferences({
          bool? twoFactorEnabled,
          NotificationPreferences? nextNotifications,
        }) async {
          try {
            final updated = await adminGateway.adminUpdateUserPreferences(
              userId,
              twoFactorEnabled: twoFactorEnabled,
              notifications: nextNotifications,
            );
            if (!context.mounted) return;
            setDialogState(() {
              preferences = updated;
              notifications = updated.notifications;
            });
            AppNotifications.showSuccess(
              context,
              context.l10n.preferencesUpdated,
            );
          } catch (e) {
            if (!context.mounted) return;
            AppNotifications.showError(
              context,
              context.l10n.savePreferencesFailed('$e'),
            );
          }
        }

        Widget notificationSwitch(
          String title,
          bool value,
          NotificationPreferences Function(bool value) update,
        ) {
          return AppSwitchTile(
            value: value,
            title: Text(title),
            onChanged: (value) {
              final next = update(value);
              setDialogState(() => notifications = next);
              savePreferences(nextNotifications: next);
            },
          );
        }

        return AppListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            AppSwitchTile(
              value: preferences.twoFactorEnabled,
              title: Text(context.l10n.multiFactorAuthentication),
              subtitle: Text(
                context.l10n.authenticationFactorsSummary(
                  preferences.eligibleFactorCount,
                  preferences.canUsePassword
                      ? context.l10n.available
                      : context.l10n.unavailable,
                  preferences.canUseEmail
                      ? context.l10n.available
                      : context.l10n.unavailable,
                  preferences.canUsePasskey
                      ? context.l10n.available
                      : context.l10n.unavailable,
                ),
              ),
              onChanged: (value) => savePreferences(twoFactorEnabled: value),
            ),
            const AppDivider(height: 20),
            notificationSwitch(
              context.l10n.roomInvitationInAppNotification,
              notifications.roomInvitationInApp,
              (value) => notifications.copyWith(roomInvitationInApp: value),
            ),
            notificationSwitch(
              context.l10n.roomEventInAppNotification,
              notifications.roomEventInApp,
              (value) => notifications.copyWith(roomEventInApp: value),
            ),
            notificationSwitch(
              context.l10n.systemAnnouncementInAppNotification,
              notifications.systemAnnouncementInApp,
              (value) => notifications.copyWith(systemAnnouncementInApp: value),
            ),
            notificationSwitch(
              context.l10n.roomInvitationEmail,
              notifications.roomInvitationEmail,
              (value) => notifications.copyWith(roomInvitationEmail: value),
            ),
            notificationSwitch(
              context.l10n.roomEventEmail,
              notifications.roomEventEmail,
              (value) => notifications.copyWith(roomEventEmail: value),
            ),
            notificationSwitch(
              context.l10n.systemAnnouncementEmail,
              notifications.systemAnnouncementEmail,
              (value) => notifications.copyWith(systemAnnouncementEmail: value),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameUser(SyncTvUser user) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: user.username);
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.changeUsername,
      icon: const Icon(
        Icons.drive_file_rename_outline_rounded,
        color: Color(0xFF5D5FEF),
      ),
      content: AppDialogs.createFormField(
        context: context,
        label: l10n.newUsername,
        controller: controller,
        hintText: l10n.usernameLengthHint,
        prefixIcon: Icons.person_outline,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.save,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminUpdateUsername(user.id, controller.text.trim());
      if (!mounted) return;
      AppNotifications.showSuccess(context, l10n.usernameUpdated);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.changeUsernameFailed('$e'));
    }
  }

  Future<void> _resetPassword(SyncTvUser user) async {
    final l10n = context.l10n;
    final password = TextEditingController();
    final reason = TextEditingController();
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.resetPassword,
      icon: const Icon(Icons.lock_reset_rounded, color: Colors.orange),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDialogs.createFormField(
            context: context,
            label: l10n.newPassword,
            controller: password,
            hintText: l10n.passwordMinimumLength(8),
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          AppDialogs.createFormField(
            context: context,
            label: l10n.auditReason,
            controller: reason,
            hintText: l10n.optional,
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
          text: l10n.reset,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminUpdatePassword(
        user.id,
        password.text,
        reason: reason.text.trim(),
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, l10n.passwordReset);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.resetPasswordFailed('$e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AdminToolbarWrap(
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
                        _loadUsers();
                      },
                      hint: context.l10n.searchUsers,
                      icon: Icons.search,
                    ),
                  ),
                  _AdminToolbarItem(
                    width: 104,
                    child: _AdminPanelCard(
                      isDark: isDark,
                      child: AppInkSurface(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        onTap: _addUser,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_add_rounded,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.add,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _AdminToolbarItem(
                    width: 44,
                    child: AppIconButton(
                      tooltip: context.l10n.selectCurrentPage,
                      icon: Icons.select_all_rounded,
                      onPressed: _users.isEmpty
                          ? null
                          : () {
                              setState(() {
                                _selectedUserIds.addAll(
                                  _users.map((user) => user.id),
                                );
                              });
                            },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _AdminToolbarWrap(
                  items: [
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<common_enum.UserStatus>(
                        value: _statusFilter,
                        options: {
                          context.l10n.allStatuses:
                              common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
                          context.l10n.active:
                              common_enum.UserStatus.USER_STATUS_ACTIVE,
                          context.l10n.banned:
                              common_enum.UserStatus.USER_STATUS_BANNED,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _statusFilter = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<common_enum.UserRole>(
                        value: _roleFilter,
                        options: {
                          context.l10n.allRoles:
                              common_enum.UserRole.USER_ROLE_UNSPECIFIED,
                          'Root': common_enum.UserRole.USER_ROLE_ROOT,
                          context.l10n.administrator:
                              common_enum.UserRole.USER_ROLE_ADMIN,
                          context.l10n.user:
                              common_enum.UserRole.USER_ROLE_USER,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _roleFilter = value;
                            _page = 1;
                          });
                          _loadUsers();
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
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 126,
                      child: AppSelect<admin_enum.UserListSortBy>(
                        value: _sortBy,
                        options: {
                          context.l10n.createdAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_CREATED_AT,
                          context.l10n.updatedAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_UPDATED_AT,
                          context.l10n.username: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_USERNAME,
                          context.l10n.email:
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                          context.l10n.status: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_STATUS,
                          context.l10n.role:
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_ROLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _sortBy = value;
                            _page = 1;
                          });
                          _loadUsers();
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
                          _loadUsers();
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
                          _loadUsers();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_selectedUserIds.isNotEmpty) _buildUserBatchBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadUsers();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadUsers();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : AppListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final isAdmin = user.role.hasSystemAdminPrivileges;
                    final isBanned =
                        user.status ==
                        common_enum.UserStatus.USER_STATUS_BANNED;

                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckbox(
                              value: _selectedUserIds.contains(user.id),
                              semanticsLabel: context.l10n.selectUser,
                              onChanged: (value) =>
                                  _toggleUserSelection(user.id, value),
                            ),
                            AppAvatar(
                              name: user.username,
                              radius: 24,
                              backgroundColor: isAdmin
                                  ? Colors.amber.withValues(alpha: 0.2)
                                  : theme.primaryColor.withValues(alpha: 0.1),
                              foregroundColor: isAdmin
                                  ? Colors.amber.shade800
                                  : theme.primaryColor,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        title: Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            context.l10n.userListSummary(
                              user.id,
                              _systemRoleText(context, user.role),
                              _userStatusText(context, user.status),
                              user.connectionCount > 0
                                  ? context.l10n.connectionCount(
                                      user.connectionCount,
                                    )
                                  : context.l10n.offline,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBanned) ...[
                              AppIconButton(
                                icon: Icons.check_circle_outline,
                                iconSize: 24,
                                tooltip: context.l10n.unban,
                                onPressed: () => _banUser(user, false),
                              ),
                            ] else ...[
                              AppIconButton(
                                icon: Icons.info_outline,
                                iconSize: 22,
                                tooltip: context.l10n.details,
                                onPressed: () => _showUserDetails(user),
                              ),
                              AppIconButton(
                                icon: Icons.report_gmailerrorred_outlined,
                                iconSize: 22,
                                tooltip: context.l10n.viewReports,
                                onPressed: () => _openContentReportsViewer(
                                  context,
                                  title: context.l10n.userReports(
                                    user.username,
                                  ),
                                  targetType: admin_enum
                                      .ContentReportTargetType
                                      .CONTENT_REPORT_TARGET_TYPE_USER,
                                  targetUserId: user.id,
                                  scope: admin_enum
                                      .ContentReportScope
                                      .CONTENT_REPORT_SCOPE_TARGET_USER,
                                ),
                              ),
                              AppIconButton(
                                icon: Icons.edit_outlined,
                                iconSize: 22,
                                tooltip: context.l10n.rename,
                                onPressed: () => _renameUser(user),
                              ),
                              AppIconButton(
                                icon: Icons.lock_reset_rounded,
                                iconSize: 22,
                                tooltip: context.l10n.resetPassword,
                                onPressed: () => _resetPassword(user),
                              ),
                              AppIconButton(
                                icon: Icons.block,
                                iconSize: 22,
                                style: AppIconButtonStyle.destructive,
                                tooltip: context.l10n.ban,
                                onPressed: () => _banUser(user, true),
                              ),
                              AppIconButton(
                                icon: isAdmin
                                    ? Icons.admin_panel_settings
                                    : Icons.admin_panel_settings_outlined,
                                iconSize: 22,
                                tooltip: isAdmin
                                    ? context.l10n.removeAdministratorRole
                                    : context.l10n.makeAdministrator,
                                onPressed: () => _toggleAdmin(user),
                              ),
                            ],
                            AppIconButton(
                              icon: Icons.delete_outline,
                              iconSize: 22,
                              style: AppIconButtonStyle.destructive,
                              tooltip: context.l10n.deleteUser,
                              onPressed: () => _deleteUser(user),
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

  Widget _buildUserBatchBar(ThemeData theme, bool isDark) {
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
            child: Text(context.l10n.usersSelected(_selectedUserIds.length)),
          ),
          AppActionButton(
            onPressed: () => setState(_selectedUserIds.clear),
            label: context.l10n.clear,
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanUsers,
            icon: Icons.block_rounded,
            label: context.l10n.ban,
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteUsers,
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
