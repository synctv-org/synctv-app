part of '../admin_settings_page.dart';

class AdminProviderTab extends StatefulWidget {
  const AdminProviderTab({super.key});

  @override
  State<AdminProviderTab> createState() => _AdminProviderTabState();
}

class _AdminProviderTabState extends State<AdminProviderTab> {
  bool _isLoading = true;
  String _providerType = '';
  String _search = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  bool? _enabledFilter;
  bool? _tlsFilter;
  provider_common_enum.ProviderInstanceListSortBy _sortBy = provider_common_enum
      .ProviderInstanceListSortBy
      .PROVIDER_INSTANCE_LIST_SORT_BY_NAME;
  provider_common_enum.SortDirection _sortDirection =
      provider_common_enum.SortDirection.SORT_DIRECTION_ASC;
  List<AdminProviderInstance> _instances = const [];
  List<String> _backends = const [];
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
      _loadInstances();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        adminGateway.adminListProviderInstancesPage(
          page: _page,
          pageSize: _pageSize,
          providerType: _providerType,
          search: _search,
          enabled: _enabledFilter,
          tls: _tlsFilter,
          sortBy: _sortBy,
          sortDirection: _sortDirection,
        ),
        _providerType.isEmpty
            ? Future<List<String>>.value(const [])
            : adminGateway.listProviderBackends(_providerType),
      ]);
      if (!mounted) return;
      final instancesPage = results[0] as AdminProviderInstancesPage;
      setState(() {
        _instances = instancesPage.instances;
        _total = instancesPage.total;
        _backends = results[1] as List<String>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadProviderInstancesFailed('$e'),
      );
    }
  }

  Future<void> _editInstance([AdminProviderInstance? instance]) async {
    final l10n = context.l10n;
    final editing = instance != null;
    final result = await showAppDialog<_ProviderInstanceEditResult>(
      context: context,
      builder: (context) => _ProviderInstanceEditorDialog(
        instance: instance,
        selectedFilter: _providerType,
      ),
    );
    if (result == null) return;
    if (!mounted) return;

    try {
      if (editing) {
        await adminGateway.adminUpdateProviderInstance(
          name: instance.name,
          endpoint: result.endpoint,
          comment: result.clearComment ? null : result.comment,
          timeoutSeconds: result.timeoutSeconds,
          tls: result.tls,
          insecureTls: result.insecureTls,
          providers: result.providers,
          jwtSecret: result.clearJwtSecret || result.jwtSecret.isEmpty
              ? null
              : result.jwtSecret,
          customCa: result.clearCustomCa || result.customCa.isEmpty
              ? null
              : result.customCa,
          clearComment: result.clearComment,
          clearJwtSecret: result.clearJwtSecret,
          clearCustomCa: result.clearCustomCa,
        );
      } else {
        await adminGateway.adminAddProviderInstance(
          name: result.name,
          endpoint: result.endpoint,
          providers: result.providers,
          comment: result.comment,
          timeoutSeconds: result.timeoutSeconds,
          tls: result.tls,
          insecureTls: result.insecureTls,
          jwtSecret: result.jwtSecret.isEmpty ? null : result.jwtSecret,
          customCa: result.customCa.isEmpty ? null : result.customCa,
        );
      }
      if (!mounted) return;
      AppNotifications.showSuccess(
        context,
        editing ? l10n.providerInstanceUpdated : l10n.providerInstanceCreated,
      );
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        l10n.saveProviderInstanceFailed('$e'),
      );
    }
  }

  Future<void> _deleteInstance(AdminProviderInstance instance) async {
    final l10n = context.l10n;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: l10n.deleteProvider,
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: Text(l10n.confirmDeleteProvider(instance.name)),
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
      await adminGateway.adminDeleteProviderInstance(instance.name);
      if (!mounted) return;
      AppNotifications.showSuccess(context, l10n.providerInstanceDeleted);
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, l10n.deleteProviderFailed('$e'));
    }
  }

  Future<void> _toggleEnabled(AdminProviderInstance instance) async {
    try {
      await adminGateway.adminSetProviderInstanceEnabled(
        instance.name,
        !instance.enabled,
      );
      if (!mounted) return;
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.operationFailed('$e'));
    }
  }

  Future<void> _reconnect(AdminProviderInstance instance) async {
    try {
      await adminGateway.adminReconnectProviderInstance(instance.name);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.reconnectStarted);
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.reconnectFailed('$e'));
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
                    width: 260,
                    child: AppSearchField(
                      controller: _searchController,
                      hintText: context.l10n.searchProviderInstances,
                      onChanged: (value) {
                        if (value.isEmpty && _search.isNotEmpty) {
                          setState(() {
                            _search = '';
                            _page = 1;
                          });
                          _loadInstances();
                        }
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _search = value.trim();
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                  ),
                  _AdminToolbarItem(
                    width: 44,
                    child: AppIconButton(
                      tooltip: context.l10n.add,
                      icon: Icons.add_circle_outline_rounded,
                      onPressed: () => _editInstance(),
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
                      child: AppSelect<bool?>(
                        value: _enabledFilter,
                        options: {
                          context.l10n.allStatuses: null,
                          context.l10n.enabled: true,
                          context.l10n.disabled: false,
                        },
                        onChanged: (value) {
                          setState(() {
                            _enabledFilter = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<bool?>(
                        value: _tlsFilter,
                        options: {
                          context.l10n.allTlsStates: null,
                          context.l10n.tlsEnabled: true,
                          context.l10n.tlsDisabled: false,
                        },
                        onChanged: (value) {
                          setState(() {
                            _tlsFilter = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<String>(
                        value: _providerType,
                        options: {
                          context.l10n.allTypes: '',
                          for (final type in _providerTypeOptions(
                            selectedFilter: _providerType,
                          ))
                            _providerTypeLabel(type): type,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _providerType = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 126,
                      child:
                          AppSelect<
                            provider_common_enum.ProviderInstanceListSortBy
                          >(
                            value: _sortBy,
                            options: {
                              context.l10n.sortByName: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
                              context.l10n.sortByEndpoint: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT,
                              context.l10n.sortByCreatedAt: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
                              context.l10n.sortByUpdatedAt: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
                            },
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _sortBy = value;
                                _page = 1;
                              });
                              _loadInstances();
                            },
                          ),
                    ),
                    _AdminToolbarItem(
                      width: 44,
                      child: AppIconButton(
                        tooltip:
                            _sortDirection ==
                                provider_common_enum
                                    .SortDirection
                                    .SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            _sortDirection ==
                                provider_common_enum
                                    .SortDirection
                                    .SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          setState(() {
                            _sortDirection =
                                _sortDirection ==
                                    provider_common_enum
                                        .SortDirection
                                        .SORT_DIRECTION_DESC
                                ? provider_common_enum
                                      .SortDirection
                                      .SORT_DIRECTION_ASC
                                : provider_common_enum
                                      .SortDirection
                                      .SORT_DIRECTION_DESC;
                            _page = 1;
                          });
                          _loadInstances();
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
                          _loadInstances();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_providerType.isNotEmpty) _buildBackendsBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadInstances();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadInstances();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : _instances.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.noProviderInstances,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _instances.length,
                  itemBuilder: (context, index) {
                    final instance = _instances[index];
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: _ProviderInstanceTile(
                        instance: instance,
                        onToggleEnabled: () => _toggleEnabled(instance),
                        onEdit: () => _editInstance(instance),
                        onReconnect: () => _reconnect(instance),
                        onDelete: () => _deleteInstance(instance),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBackendsBar(ThemeData theme, bool isDark) {
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: _backends.isEmpty
                ? Text(
                    context.l10n.noAvailableBackends,
                    style: TextStyle(color: theme.hintColor),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final backend in _backends)
                        AppChip(
                          label: Text(backend),
                          avatar: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: backend));
                            AppNotifications.showSuccess(
                              context,
                              context.l10n.backendCopied,
                            );
                          },
                        ),
                    ],
                  ),
          ),
          AppIconButton(
            tooltip: context.l10n.refreshBackends,
            icon: Icons.refresh_rounded,
            onPressed: () => _loadInstances(silent: true),
          ),
        ],
      ),
    );
  }
}

class _ProviderInstanceTile extends StatelessWidget {
  final AdminProviderInstance instance;
  final VoidCallback onToggleEnabled;
  final VoidCallback onEdit;
  final VoidCallback onReconnect;
  final VoidCallback onDelete;

  const _ProviderInstanceTile({
    required this.instance,
    required this.onToggleEnabled,
    required this.onEdit,
    required this.onReconnect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _providerStatusText(context, instance.status);
    final tlsText = !instance.tls
        ? context.l10n.tlsDisabled
        : instance.insecureTls
        ? context.l10n.tlsUnverified
        : context.l10n.tlsVerified;
    final timeText = context.l10n.providerInstanceTimes(
      _formatTimestamp(instance.createdAt),
      _formatTimestamp(instance.updatedAt),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSwitch(
            value: instance.enabled,
            semanticsLabel: context.l10n.enableProviderInstance,
            onChanged: (_) => onToggleEnabled(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        instance.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ProviderMetaChip(
                      label: instance.enabled
                          ? context.l10n.enabled
                          : context.l10n.disabled,
                      icon: instance.enabled
                          ? Icons.power_settings_new_rounded
                          : Icons.power_off_rounded,
                      color: instance.enabled
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppSelectableText(
                  instance.endpoint,
                  maxLines: 1,
                  style: TextStyle(color: theme.hintColor),
                ),
                if (instance.comment.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    instance.comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ProviderMetaChip(
                      label: statusText,
                      icon: _providerStatusIcon(instance.status),
                      color: _providerStatusColor(theme, instance.status),
                    ),
                    _ProviderMetaChip(
                      label: '${instance.timeoutSeconds}s',
                      icon: Icons.timer_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    _ProviderMetaChip(
                      label: tlsText,
                      icon: instance.tls
                          ? Icons.verified_user_outlined
                          : Icons.no_encryption_outlined,
                      color: instance.tls && !instance.insecureTls
                          ? Colors.green
                          : Colors.orange,
                    ),
                    for (final provider in instance.providers)
                      _ProviderMetaChip(
                        label: provider,
                        icon: Icons.category_outlined,
                        color: theme.colorScheme.secondary,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  timeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Wrap(
            spacing: 2,
            children: [
              AppIconButton(
                tooltip: context.l10n.edit,
                icon: Icons.edit_outlined,
                onPressed: onEdit,
              ),
              AppIconButton(
                tooltip: context.l10n.reconnect,
                icon: Icons.sync_rounded,
                onPressed: onReconnect,
              ),
              AppIconButton(
                tooltip: context.l10n.delete,
                icon: Icons.delete_outline,
                style: AppIconButtonStyle.destructive,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderMetaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _ProviderMetaChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      iconSize: 14,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      borderSide: BorderSide(color: color.withValues(alpha: 0.18)),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 140),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ProviderInstanceEditResult {
  final String name;
  final String endpoint;
  final String comment;
  final int timeoutSeconds;
  final List<String> providers;
  final bool tls;
  final bool insecureTls;
  final String jwtSecret;
  final String customCa;
  final bool clearComment;
  final bool clearJwtSecret;
  final bool clearCustomCa;

  const _ProviderInstanceEditResult({
    required this.name,
    required this.endpoint,
    required this.comment,
    required this.timeoutSeconds,
    required this.providers,
    required this.tls,
    required this.insecureTls,
    required this.jwtSecret,
    required this.customCa,
    required this.clearComment,
    required this.clearJwtSecret,
    required this.clearCustomCa,
  });
}

class _ProviderInstanceEditorDialog extends StatefulWidget {
  final AdminProviderInstance? instance;
  final String selectedFilter;

  const _ProviderInstanceEditorDialog({
    required this.instance,
    required this.selectedFilter,
  });

  @override
  State<_ProviderInstanceEditorDialog> createState() =>
      _ProviderInstanceEditorDialogState();
}

class _ProviderInstanceEditorDialogState
    extends State<_ProviderInstanceEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _endpointController;
  late final TextEditingController _commentController;
  late final TextEditingController _timeoutController;
  late final TextEditingController _jwtSecretController;
  late final TextEditingController _customCaController;
  late final Set<String> _selectedProviders;
  late bool _tls;
  late bool _insecureTls;
  bool _clearComment = false;
  bool _clearJwtSecret = false;
  bool _clearCustomCa = false;
  bool _submitted = false;

  bool get _editing => widget.instance != null;

  @override
  void initState() {
    super.initState();
    final instance = widget.instance;
    _nameController = TextEditingController(text: instance?.name ?? '');
    _endpointController = TextEditingController(text: instance?.endpoint ?? '');
    _commentController = TextEditingController(text: instance?.comment ?? '');
    _timeoutController = TextEditingController(
      text: (instance?.timeoutSeconds ?? 30).toString(),
    );
    _jwtSecretController = TextEditingController();
    _customCaController = TextEditingController();
    _selectedProviders = <String>{
      ...?instance?.providers,
      if (instance == null && widget.selectedFilter.isNotEmpty)
        widget.selectedFilter,
    };
    _tls = instance?.tls ?? true;
    _insecureTls = instance?.insecureTls ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _endpointController.dispose();
    _commentController.dispose();
    _timeoutController.dispose();
    _jwtSecretController.dispose();
    _customCaController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    final name = _nameController.text.trim();
    final endpoint = _endpointController.text.trim();
    final timeout = int.tryParse(_timeoutController.text.trim());
    final providers = _selectedProviders.toList(growable: false)..sort();
    if (!_editing && name.isEmpty) return;
    if (endpoint.isEmpty) return;
    if (providers.isEmpty) return;
    if (timeout == null || timeout <= 0) return;
    Navigator.pop(
      context,
      _ProviderInstanceEditResult(
        name: name,
        endpoint: endpoint,
        comment: _commentController.text.trim(),
        timeoutSeconds: timeout,
        providers: providers,
        tls: _tls,
        insecureTls: _insecureTls,
        jwtSecret: _jwtSecretController.text.trim(),
        customCa: _customCaController.text.trim(),
        clearComment: _clearComment,
        clearJwtSecret: _clearJwtSecret,
        clearCustomCa: _clearCustomCa,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact =
        AppBreakpoints.widthOf(context) < AppBreakpoints.expandedStart;
    final title = _editing
        ? context.l10n.editProviderInstance
        : context.l10n.addProviderInstance;
    return AppDialogFrame(
      maxWidth: 860,
      maxHeight: 760,
      child: Column(
        children: [
          _ProviderEditorHeader(
            title: title,
            subtitle: _editing
                ? widget.instance!.name
                : context.l10n.configureProviderNode,
            editing: _editing,
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: AppSingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 18 : 24,
                22,
                isCompact ? 18 : 24,
                24,
              ),
              child: isCompact
                  ? Column(children: _editorSections(theme, compact: true))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(children: _primarySections(theme)),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          flex: 5,
                          child: Column(children: _secondarySections(theme)),
                        ),
                      ],
                    ),
            ),
          ),
          _ProviderEditorFooter(
            editing: _editing,
            onCancel: () => Navigator.pop(context),
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  List<Widget> _editorSections(ThemeData theme, {required bool compact}) => [
    ..._primarySections(theme),
    ..._secondarySections(theme),
  ];

  List<Widget> _primarySections(ThemeData theme) => [
    _ProviderEditorSection(
      icon: Icons.badge_outlined,
      title: context.l10n.basicInformation,
      children: [
        AppTextField(
          controller: _nameController,
          label: context.l10n.instanceName,
          hintText: 'provider_main',
          prefixIcon: Icons.badge_outlined,
          enabled: !_editing,
          errorText:
              _submitted && !_editing && _nameController.text.trim().isEmpty
              ? context.l10n.instanceNameRequired
              : null,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _endpointController,
          label: 'Endpoint',
          hintText: 'https://provider.example.com',
          prefixIcon: Icons.link_rounded,
          keyboardType: TextInputType.url,
          errorText: _submitted && _endpointController.text.trim().isEmpty
              ? context.l10n.endpointRequired
              : null,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _timeoutController,
          label: context.l10n.requestTimeout,
          prefixIcon: Icons.timer_outlined,
          suffix: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              widthFactor: 1,
              child: Text(context.l10n.secondsShort),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText:
              _submitted &&
                  ((int.tryParse(_timeoutController.text.trim()) ?? 0) <= 0)
              ? context.l10n.positiveIntegerRequired
              : null,
        ),
      ],
    ),
    const SizedBox(height: 16),
    _ProviderEditorSection(
      icon: Icons.category_outlined,
      title: context.l10n.capabilityTypes,
      description: context.l10n.capabilityTypesDescription,
      children: [
        _ProviderTypeSelector(
          selectedProviders: _selectedProviders,
          options: _providerTypeOptions(
            selectedFilter: widget.selectedFilter,
            selectedProviders: _selectedProviders,
          ),
          hasError: _submitted && _selectedProviders.isEmpty,
          onChanged: (provider, selected) => setState(() {
            if (selected) {
              _selectedProviders.add(provider);
            } else {
              _selectedProviders.remove(provider);
            }
          }),
        ),
      ],
    ),
    const SizedBox(height: 16),
  ];

  List<Widget> _secondarySections(ThemeData theme) => [
    _ProviderEditorSection(
      icon: Icons.security_rounded,
      title: context.l10n.connectionSecurity,
      description: context.l10n.connectionSecurityDescription,
      children: [
        _ProviderOptionSwitch(
          icon: Icons.verified_user_outlined,
          title: context.l10n.enableTls,
          subtitle: _tls
              ? context.l10n.providerTlsConnection
              : context.l10n.providerPlainConnection,
          value: _tls,
          onChanged: (value) => setState(() {
            _tls = value;
            if (!_tls) _insecureTls = false;
          }),
        ),
        const SizedBox(height: 10),
        _ProviderOptionSwitch(
          icon: Icons.warning_amber_rounded,
          title: context.l10n.allowInsecureTls,
          subtitle: context.l10n.allowInsecureTlsDescription,
          value: _insecureTls,
          enabled: _tls,
          danger: true,
          onChanged: (value) => setState(() => _insecureTls = value),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _jwtSecretController,
          label: 'JWT Secret',
          hintText: _editing
              ? context.l10n.emptyKeepsCurrentValue
              : context.l10n.optional,
          prefixIcon: Icons.key_rounded,
          enabled: !_clearJwtSecret,
          obscureText: true,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
        ),
        if (_editing)
          AppCheckboxTile(
            value: _clearJwtSecret,
            onChanged: (value) => setState(() {
              _clearJwtSecret = value;
              if (_clearJwtSecret) _jwtSecretController.clear();
            }),
            title: Text(context.l10n.clearJwtSecret),
          ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _customCaController,
          label: 'Custom CA',
          hintText: _editing
              ? context.l10n.pemEmptyKeepsCurrent
              : context.l10n.pemOptional,
          prefixIcon: Icons.verified_outlined,
          enabled: !_clearCustomCa,
          minLines: 4,
          maxLines: 7,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
        ),
        if (_editing)
          AppCheckboxTile(
            value: _clearCustomCa,
            onChanged: (value) => setState(() {
              _clearCustomCa = value;
              if (_clearCustomCa) _customCaController.clear();
            }),
            title: Text(context.l10n.clearCustomCa),
          ),
      ],
    ),
    const SizedBox(height: 16),
    _ProviderEditorSection(
      icon: Icons.notes_rounded,
      title: context.l10n.notes,
      children: [
        AppTextField(
          controller: _commentController,
          label: context.l10n.notes,
          hintText: context.l10n.providerNotesHint,
          prefixIcon: Icons.notes_rounded,
          enabled: !_clearComment,
          minLines: 2,
          maxLines: 4,
        ),
        if (_editing)
          AppCheckboxTile(
            value: _clearComment,
            onChanged: (value) => setState(() {
              _clearComment = value;
              if (_clearComment) _commentController.clear();
            }),
            title: Text(context.l10n.clearNotes),
          ),
      ],
    ),
  ];
}

class _ProviderEditorHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool editing;
  final VoidCallback onClose;

  const _ProviderEditorHeader({
    required this.title,
    required this.subtitle,
    required this.editing,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.42),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          AppIconBadge(
            icon: Icons.hub_rounded,
            color: theme.colorScheme.primary,
            iconColor: theme.colorScheme.onPrimary,
            backgroundColor: theme.colorScheme.primary,
            size: 46,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _ProviderMetaChip(
            label: editing ? context.l10n.edit : context.l10n.add,
            icon: editing ? Icons.edit_outlined : Icons.add_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          AppIconButton(
            tooltip: context.l10n.close,
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ProviderEditorSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<Widget> children;

  const _ProviderEditorSection({
    required this.icon,
    required this.title,
    this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ProviderOptionSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final bool danger;
  final ValueChanged<bool> onChanged;

  const _ProviderOptionSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.enabled = true,
    this.danger = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger ? theme.colorScheme.error : theme.colorScheme.primary;
    return AppPanelSurface(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: color.withValues(alpha: danger && value ? 0.09 : 0.04),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.14)),
      child: Row(
        children: [
          Icon(icon, color: enabled ? color : theme.disabledColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: enabled ? null : theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: enabled
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
          AppSwitch(
            value: enabled && value,
            semanticsLabel: title,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}

class _ProviderEditorFooter extends StatelessWidget {
  final bool editing;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _ProviderEditorFooter({
    required this.editing,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      border: Border(
        top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              editing
                  ? context.l10n.providerEditFooterHint
                  : context.l10n.providerCreateFooterHint,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          AppActionButton(
            onPressed: onCancel,
            label: context.l10n.cancel,
            style: AppActionButtonStyle.outlined,
          ),
          const SizedBox(width: 10),
          AppActionButton(
            onPressed: onSubmit,
            icon: editing ? Icons.save_outlined : Icons.add_rounded,
            label: editing ? context.l10n.save : context.l10n.create,
          ),
        ],
      ),
    );
  }
}

IconData _providerStatusIcon(int status) {
  switch (status) {
    case 1:
      return Icons.cloud_done_outlined;
    case 2:
      return Icons.cloud_off_outlined;
    case 3:
      return Icons.error_outline_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

Color _providerStatusColor(ThemeData theme, int status) {
  switch (status) {
    case 1:
      return Colors.green;
    case 2:
      return theme.hintColor;
    case 3:
      return Colors.redAccent;
    default:
      return theme.colorScheme.primary;
  }
}
