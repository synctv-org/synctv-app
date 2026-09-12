part of '../admin_settings_page.dart';

class AdministratorsTab extends StatefulWidget {
  const AdministratorsTab({super.key, this.isActive = true});

  final bool isActive;

  @override
  State<AdministratorsTab> createState() => _AdministratorsTabState();
}

class _AdministratorsTabState extends State<AdministratorsTab> {
  List<SyncTvUser> _admins = const [];
  String _currentUserId = '';
  int _adminTotal = 0;
  int _adminPage = 1;
  int _adminPageSize = 20;
  String _adminSearch = '';
  admin_enum.UserListSortBy _adminSortBy =
      admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _adminSortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  bool _isLoading = true;
  int _loadGeneration = 0;
  final _adminSearchController = TextEditingController();

  int get _adminPageCount =>
      _adminTotal <= 0 ? 1 : ((_adminTotal - 1) ~/ _adminPageSize) + 1;

  bool _initialized = false;

  @override
  void didUpdateWidget(covariant AdministratorsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      unawaited(_load(silent: true));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load();
    });
  }

  @override
  void dispose() {
    _adminSearchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    final generation = ++_loadGeneration;
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        adminGateway.adminListAdminsPage(
          page: _adminPage,
          pageSize: _adminPageSize,
          search: _adminSearch,
          sortBy: _adminSortBy,
          sortDirection: _adminSortDirection,
        ),
        adminGateway.getMe(),
      ]);
      if (!mounted || generation != _loadGeneration) return;
      final adminsPage = results[0] as AdminsPage;
      final lastPage = math.max(
        1,
        (adminsPage.total + _adminPageSize - 1) ~/ _adminPageSize,
      );
      if (_adminPage > lastPage) {
        setState(() => _adminPage = lastPage);
        await _load();
        return;
      }
      final currentUser = results[1] as SyncTvUser;
      setState(() {
        _admins = adminsPage.admins;
        _currentUserId = currentUser.id;
        _adminTotal = adminsPage.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadAdministratorsFailed('$e'),
      );
    }
  }

  Future<void> _addAdmin() async {
    final mode = await AppDialogs.showStyledDialog<String>(
      context: context,
      title: context.l10n.addAdministrator,
      icon: const Icon(
        Icons.admin_panel_settings_rounded,
        color: Color(0xFF5D5FEF),
      ),
      content: SizedBox(
        width: 420,
        child: Text(context.l10n.addAdministratorDescription),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        Builder(
          builder: (buttonContext) => AppActionButton(
            onPressed: () {
              if (!buttonContext.mounted ||
                  ModalRoute.of(buttonContext)?.isCurrent != true) {
                return;
              }
              Navigator.pop(buttonContext, 'existing');
            },
            icon: Icons.person_search_rounded,
            label: context.l10n.promoteExistingUser,
            style: AppActionButtonStyle.tonal,
          ),
        ),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, 'new'),
          text: context.l10n.createAdministrator,
        ),
      ],
    );
    if (!mounted) return;
    if (mode == 'existing') {
      await _promoteExistingUser();
      return;
    }
    if (mode != 'new') return;

    await _showAdministratorDialog(promoteExisting: false);
  }

  Future<void> _promoteExistingUser() =>
      _showAdministratorDialog(promoteExisting: true);

  Future<void> _showAdministratorDialog({required bool promoteExisting}) async {
    final added = await showAppDialog<bool>(
      context: context,
      builder: (_) => AddAdministratorDialog(promoteExisting: promoteExisting),
    );
    if (added != true || !mounted) return;
    AppNotifications.showSuccess(context, context.l10n.administratorAdded);
    await _load(silent: true);
  }

  Future<void> _removeAdmin(SyncTvUser user) async {
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.removeAdministrator,
      icon: const Icon(Icons.remove_moderator_outlined, color: Colors.red),
      content: Text(context.l10n.confirmRemoveAdmin(user.username)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.remove,
        ),
      ],
    );
    if (confirmed != true || !mounted) return;
    try {
      await adminGateway.adminRemoveAdmin(user.id);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.administratorRemoved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.removeFailed('$e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isLoading) return const AppLoadingIndicator();

    return AppRefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: AppListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AdminPanelCard(
            isDark: isDark,
            child: Column(
              children: [
                AppTile(
                  title: Text(context.l10n.administrators),
                  subtitle: Text(context.l10n.administratorCount(_adminTotal)),
                  suffix: AppIconButton(
                    tooltip: context.l10n.addAdministrator,
                    icon: Icons.add_moderator_outlined,
                    onPressed: _addAdmin,
                  ),
                ),
                AppDivider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.08),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        child: AppSearchField(
                          controller: _adminSearchController,
                          hintText: context.l10n.searchAdministrators,
                          onChanged: (value) {
                            if (value.isEmpty && _adminSearch.isNotEmpty) {
                              setState(() {
                                _adminSearch = '';
                                _adminPage = 1;
                              });
                              _load(silent: true);
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _adminSearch = value.trim();
                              _adminPage = 1;
                            });
                            _load(silent: true);
                          },
                        ),
                      ),
                      AppSelect<admin_enum.UserListSortBy>(
                        value: _adminSortBy,
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
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminSortBy = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      AppIconButton(
                        tooltip:
                            _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          setState(() {
                            _adminSortDirection =
                                _adminSortDirection ==
                                    admin_enum.SortDirection.SORT_DIRECTION_DESC
                                ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                                : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      AppSelect<int>(
                        value: _adminPageSize,
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminPageSize = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      AppIconButton(
                        tooltip: context.l10n.refresh,
                        icon: Icons.refresh_rounded,
                        onPressed: () => _load(silent: true),
                      ),
                    ],
                  ),
                ),
                if (_admins.isEmpty)
                  AppEmptyMessage(message: context.l10n.noAdministrators)
                else
                  for (final admin in _admins)
                    Builder(
                      builder: (context) {
                        final removeDisabledReason = _adminRemoveDisabledReason(
                          admin,
                        );
                        return AppTile(
                          prefix: AppAvatar(name: admin.username),
                          title: Text(admin.username),
                          subtitle: Text(admin.id),
                          suffix: AppIconButton(
                            tooltip:
                                removeDisabledReason ??
                                context.l10n.removeAdministrator,
                            icon: Icons.remove_circle_outline,
                            style: removeDisabledReason == null
                                ? AppIconButtonStyle.destructive
                                : AppIconButtonStyle.ghost,
                            onPressed: removeDisabledReason == null
                                ? () => _removeAdmin(admin)
                                : null,
                          ),
                        );
                      },
                    ),
                AppPaginationBar(
                  label: context.l10n.pageOf(_adminPage, _adminPageCount),
                  onPrevious: _adminPage <= 1
                      ? null
                      : () {
                          setState(() => _adminPage -= 1);
                          _load(silent: true);
                        },
                  onNext: _adminPage >= _adminPageCount
                      ? null
                      : () {
                          setState(() => _adminPage += 1);
                          _load(silent: true);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _adminRemoveDisabledReason(SyncTvUser admin) {
    if (_currentUserId.isNotEmpty && admin.id == _currentUserId) {
      return context.l10n.cannotRemoveCurrentAdministrator;
    }
    if (_adminTotal <= 1) {
      return context.l10n.keepAtLeastOneAdministrator;
    }
    return null;
  }
}
