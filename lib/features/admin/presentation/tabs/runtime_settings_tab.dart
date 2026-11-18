part of '../admin_settings_page.dart';

class _RuntimeSettingConflict implements Exception {}

class RuntimeSettingsSectionsTab extends StatefulWidget {
  const RuntimeSettingsSectionsTab({super.key});

  @override
  State<RuntimeSettingsSectionsTab> createState() =>
      _RuntimeSettingsSectionsTabState();
}

class _RuntimeSettingsSectionsTabState
    extends State<RuntimeSettingsSectionsTab> {
  bool _isLoading = true;
  bool _isLoadingSection = false;
  RuntimeSettingsModel? _settings;
  String? _selectedSection;
  final Set<String> _savingSettings = <String>{};
  final Set<String> _settingIntents = <String>{};
  final _settingWrites = SerialAsyncOperationCoordinator();
  int _loadGeneration = 0;
  bool _testEmailOpen = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadSettings(refresh: false);
    });
  }

  Future<void> _loadSettings({
    bool silent = false,
    bool refresh = false,
  }) async {
    if (!mounted || _savingSettings.isNotEmpty) return;
    final loadGeneration = ++_loadGeneration;
    if (!silent) setState(() => _isLoading = true);
    try {
      final settings = await adminGateway.runtimeGetSettings(refresh: refresh);
      if (!mounted || loadGeneration != _loadGeneration) return;
      setState(() {
        _settings = settings;
        final visibleSections = settings.sections
            .where(
              (section) =>
                  ProviderDistributionPolicy.current.allowsOAuth2 ||
                  section.name != 'oauth2',
            )
            .toList(growable: false);
        _selectedSection =
            _selectedSection ??
            (visibleSections.isEmpty ? null : visibleSections.first.name);
        _isLoading = false;
        _isLoadingSection = false;
      });
    } catch (e) {
      if (!mounted || loadGeneration != _loadGeneration) return;
      setState(() {
        _isLoading = false;
        _isLoadingSection = false;
      });
      AppNotifications.showError(
        context,
        context.l10n.loadSettingsFailed('$e'),
      );
    }
  }

  Future<void> _selectSection(String? sectionName) async {
    if (sectionName == null || sectionName == _selectedSection) return;
    setState(() {
      _selectedSection = sectionName;
    });
  }

  Future<void> _refreshSelectedSection({
    bool silent = false,
    bool refresh = true,
  }) async {
    if (!mounted || _savingSettings.isNotEmpty) return;
    final l10n = context.l10n;
    final sectionName = _selectedSection;
    if (sectionName == null) return;
    final loadGeneration = ++_loadGeneration;
    if (!silent) setState(() => _isLoadingSection = true);
    try {
      final settings = await adminGateway.runtimeGetSettings(refresh: refresh);
      if (!mounted || loadGeneration != _loadGeneration) return;
      setState(() {
        _settings = settings;
        _isLoading = false;
        _isLoadingSection = false;
      });
    } catch (e) {
      if (!mounted || loadGeneration != _loadGeneration) return;
      setState(() {
        _isLoading = false;
        _isLoadingSection = false;
      });
      AppNotifications.showError(context, l10n.refreshSettingsFailed('$e'));
    }
  }

  Future<bool> _updateSetting(
    RuntimeSettingsSection section,
    String key,
    dynamic nextValue,
  ) async {
    if (!mounted) return false;
    final l10n = context.l10n;
    final settingId = '${section.name}.$key';
    if (_savingSettings.contains(settingId)) return false;
    ++_loadGeneration;
    setState(() {
      _savingSettings.add(settingId);
      _isLoading = false;
      _isLoadingSection = false;
    });

    try {
      final current = _settings;
      if (current == null) throw StateError('settings are not loaded');
      final gateway = adminGateway;
      final updated = await _settingWrites.run(() async {
        if (!mounted) return null;
        final latest = _settings?.section(section.name);
        if (latest == null ||
            latest.settings.containsKey(key) !=
                section.settings.containsKey(key) ||
            !const DeepCollectionEquality().equals(
              latest.settings[key],
              section.settings[key],
            )) {
          throw _RuntimeSettingConflict();
        }
        final updated = await gateway.runtimeUpdateSettingInSection(
          section.name,
          key,
          identical(nextValue, _clearRuntimeSettingValue) ? null : nextValue,
        );
        if (mounted) {
          // Publish the response before the next queued write checks its draft.
          setState(() {
            _settings = (_settings ?? current).replaceSection(updated);
          });
        }
        return updated;
      });
      if (!mounted || updated == null) return false;
      setState(() {
        _savingSettings.remove(settingId);
      });
      AppNotifications.showSuccess(context, l10n.settingsUpdated);
      return true;
    } catch (e) {
      if (!mounted) return false;
      setState(() => _savingSettings.remove(settingId));
      AppNotifications.showError(
        context,
        e is _RuntimeSettingConflict
            ? l10n.runtimeSettingChanged
            : l10n.updateSettingsFailed('$e'),
      );
      return false;
    }
  }

  bool get _canInteract => mounted && ModalRoute.of(context)?.isCurrent == true;

  Future<void> _runSettingIntent(
    RuntimeSettingsSection section,
    String key,
    Future<void> Function() operation,
  ) async {
    final id = '${section.name}.$key';
    if (!_canInteract ||
        _savingSettings.contains(id) ||
        !_settingIntents.add(id)) {
      return;
    }
    try {
      await operation();
    } finally {
      _settingIntents.remove(id);
    }
  }

  Future<void> _editSetting(
    RuntimeSettingsSection section,
    String key,
    dynamic value,
  ) => _runSettingIntent(section, key, () async {
    final descriptor = settingDescriptor(
      context.l10n,
      section.name,
      key,
      value,
    );
    final normalizedValue = _normalizedSettingValue(section.name, key, value);

    if (normalizedValue is bool) {
      final confirmed = await _confirmRiskIfNeeded(descriptor);
      if (!_canInteract || !confirmed) return;
      await _updateSetting(section, key, !normalizedValue);
      return;
    }

    await showAppDialog<dynamic>(
      context: context,
      builder: (dialogContext) => _SettingEditorSheet(
        descriptor: descriptor,
        sectionName: section.name,
        settingKey: key,
        value: normalizedValue,
        onSave: (nextValue) async {
          final confirmed = await _confirmRiskIfNeeded(
            descriptor,
            sourceContext: dialogContext,
          );
          if (!mounted ||
              !dialogContext.mounted ||
              !confirmed ||
              ModalRoute.of(dialogContext)?.isCurrent != true) {
            return false;
          }
          return _updateSetting(section, key, nextValue);
        },
      ),
    );
  });

  Future<void> _editOAuth2Provider(
    RuntimeSettingsSection section,
    Map<String, dynamic> providers,
    String? name,
  ) => _runSettingIntent(section, 'providers', () async {
    final l10n = context.l10n;
    final current = name == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(providers[name] as Map? ?? const {});
    final result = await showAppDialog<_OAuth2ProviderEditResult>(
      context: context,
      builder: (context) => _OAuth2ProviderEditorSheet(
        initialName: name,
        initialValue: current,
        existingNames: providers.keys.toSet(),
      ),
    );
    if (!_canInteract || result == null) return;

    final descriptor = settingDescriptor(
      l10n,
      'oauth2',
      'providers',
      providers,
    );
    final confirmed = await _confirmRiskIfNeeded(descriptor);
    if (!_canInteract || !confirmed) return;

    final next = Map<String, dynamic>.from(providers);
    if (name != null && name != result.name) next.remove(name);
    next[result.name] = result.value;
    await _updateSetting(
      section,
      'providers',
      _oauth2ProvidersToProtoList(next),
    );
  });

  Future<void> _deleteOAuth2Provider(
    RuntimeSettingsSection section,
    Map<String, dynamic> providers,
    String name,
  ) => _runSettingIntent(section, 'providers', () async {
    final l10n = context.l10n;
    final confirmed = await _confirmRuntimeChange(
      title: l10n.deleteLoginProvider,
      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      content: Text(l10n.confirmDeleteLoginProvider(name)),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!_canInteract || !confirmed) return;
    final next = Map<String, dynamic>.from(providers)..remove(name);
    await _updateSetting(
      section,
      'providers',
      _oauth2ProvidersToProtoList(next),
    );
  });

  Future<bool> _confirmRiskIfNeeded(
    SettingDescriptor descriptor, {
    BuildContext? sourceContext,
  }) async {
    final warning = descriptor.warning;
    if (warning == null || warning.isEmpty) return true;
    return _confirmRuntimeChange(
      sourceContext: sourceContext,
      title: context.l10n.confirmChanges,
      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
      content: Text(warning),
      confirmLabel: context.l10n.confirmChanges,
    );
  }

  Future<bool> _confirmRuntimeChange({
    BuildContext? sourceContext,
    required String title,
    required Widget icon,
    required Widget content,
    required String confirmLabel,
    bool destructive = false,
  }) async {
    final origin = sourceContext ?? context;
    if (!mounted ||
        !origin.mounted ||
        ModalRoute.of(origin)?.isCurrent != true) {
      return false;
    }
    var closing = false;
    final confirmed = await showAppDialog<bool>(
      context: origin,
      builder: (dialogContext) {
        void finish(bool value) {
          if (closing ||
              !dialogContext.mounted ||
              ModalRoute.of(dialogContext)?.isCurrent != true) {
            return;
          }
          closing = true;
          Navigator.pop(dialogContext, value);
        }

        return AppConfirmDialog(
          title: title,
          icon: icon,
          content: content,
          confirmLabel: confirmLabel,
          destructive: destructive,
          onConfirm: () => finish(true),
          onCancel: () => finish(false),
        );
      },
    );
    return confirmed == true;
  }

  Future<void> _sendTestEmail() async {
    if (!mounted || _testEmailOpen) return;
    _testEmailOpen = true;
    try {
      final message = await showAppDialog<String>(
        context: context,
        builder: (_) => const SendTestEmailDialog(),
      );
      if (!mounted || message == null) return;
      AppNotifications.showSuccess(
        context,
        message.isEmpty ? context.l10n.testEmailSent : message,
      );
    } finally {
      _testEmailOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isLoading) return const AppLoadingIndicator();

    final sections = (_settings?.sections ?? const <RuntimeSettingsSection>[])
        .where(
          (section) =>
              ProviderDistributionPolicy.current.allowsOAuth2 ||
              section.name != 'oauth2',
        )
        .toList(growable: false);
    final selected = sections
        .where((section) => section.name == _selectedSection)
        .firstOrNull;
    final entries = selected == null
        ? <MapEntry<String, dynamic>>[]
        : (selected.settings.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)));
    final useTwoPane =
        AppBreakpoints.widthOf(context) >=
        AppBreakpoints.expandedStart *
            math.max(1, MediaQuery.textScalerOf(context).scale(14) / 14);
    final toolbar = Padding(
      padding: EdgeInsets.fromLTRB(
        useTwoPane ? 16 : 0,
        16,
        useTwoPane ? 16 : 0,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: useTwoPane
                ? Text(
                    context.l10n.runtimeSettings,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : _SettingsSectionDropdown(
                    sections: sections,
                    selectedSection: _selectedSection,
                    enabled: !_isLoadingSection,
                    onChanged: _selectSection,
                  ),
          ),
          const SizedBox(width: 12),
          AppIconButton(
            tooltip: context.l10n.refreshAll,
            icon: Icons.sync_rounded,
            style: AppIconButtonStyle.tonal,
            onPressed: _isLoadingSection || _savingSettings.isNotEmpty
                ? null
                : () => _loadSettings(silent: true, refresh: true),
          ),
        ],
      ),
    );

    final isOAuth2Section =
        selected?.name == 'oauth2' &&
        selected!.settings.containsKey('providers');
    final oauth2Providers = isOAuth2Section
        ? _oauth2ProvidersFromValue(
            _normalizedSettingValue(
              selected.name,
              'providers',
              selected.settings['providers'],
            ),
          )
        : <String, dynamic>{};

    final settingsList = selected == null || entries.isEmpty
        ? AppListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (!useTwoPane) toolbar,
              AppEmptyMessage(message: context.l10n.noSettings),
            ],
          )
        : isOAuth2Section
        ? AppListView(
            padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
            children: [
              if (!useTwoPane) toolbar,
              _SettingsSectionHeader(
                sectionName: selected.name,
                entryCount: oauth2Providers.length,
                isLoading: _isLoadingSection,
                action: AppActionButton(
                  icon: Icons.add_rounded,
                  label: context.l10n.addLoginProvider,
                  onPressed: _savingSettings.contains('oauth2.providers')
                      ? null
                      : () => _editOAuth2Provider(
                          selected,
                          oauth2Providers,
                          null,
                        ),
                ),
                onRefresh: _isLoadingSection || _savingSettings.isNotEmpty
                    ? null
                    : () => _refreshSelectedSection(refresh: true),
              ),
              _OAuth2ProvidersList(
                providers: oauth2Providers,
                saving: _savingSettings.contains('oauth2.providers'),
                onEdit: (name) =>
                    _editOAuth2Provider(selected, oauth2Providers, name),
                onDelete: (name) =>
                    _deleteOAuth2Provider(selected, oauth2Providers, name),
              ),
              if (selected.settings.containsKey('allowedRedirectUrls'))
                _AdminPanelCard(
                  isDark: isDark,
                  child: _SettingTile(
                    descriptor: settingDescriptor(
                      context.l10n,
                      selected.name,
                      'allowedRedirectUrls',
                      selected.settings['allowedRedirectUrls'],
                    ),
                    value: _normalizedSettingValue(
                      selected.name,
                      'allowedRedirectUrls',
                      selected.settings['allowedRedirectUrls'],
                    ),
                    saving: _savingSettings.contains(
                      'oauth2.allowedRedirectUrls',
                    ),
                    onEdit: () => _editSetting(
                      selected,
                      'allowedRedirectUrls',
                      selected.settings['allowedRedirectUrls'],
                    ),
                  ),
                ),
            ],
          )
        : AppListView.builder(
            padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
            itemCount: entries.length + (useTwoPane ? 1 : 2),
            itemBuilder: (context, index) {
              if (!useTwoPane) {
                if (index == 0) return toolbar;
                index -= 1;
              }
              if (index == 0) {
                return _SettingsSectionHeader(
                  sectionName: selected.name,
                  entryCount: entries.length,
                  isLoading: _isLoadingSection,
                  action: selected.name == 'email'
                      ? AppActionButton(
                          icon: Icons.outgoing_mail,
                          label: context.l10n.sendTestEmail,
                          onPressed: _sendTestEmail,
                          style: AppActionButtonStyle.tonal,
                        )
                      : null,
                  onRefresh: _isLoadingSection || _savingSettings.isNotEmpty
                      ? null
                      : () => _refreshSelectedSection(refresh: true),
                );
              }
              final entry = entries[index - 1];
              final normalized = _normalizedSettingValue(
                selected.name,
                entry.key,
                entry.value,
              );
              final descriptor = settingDescriptor(
                context.l10n,
                selected.name,
                entry.key,
                normalized,
              );
              final settingId = '${selected.name}.${entry.key}';
              return _AdminPanelCard(
                isDark: isDark,
                child: _SettingTile(
                  descriptor: descriptor,
                  value: normalized,
                  saving: _savingSettings.contains(settingId),
                  onEdit: () => _editSetting(selected, entry.key, normalized),
                ),
              );
            },
          );

    if (!useTwoPane) return settingsList;

    return Column(
      children: [
        toolbar,
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 240,
                child: AppListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 24),
                  children: [
                    for (final section in sections)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _SettingsSectionButton(
                          sectionName: section.name,
                          selected: section.name == _selectedSection,
                          count: section.settings.length,
                          onTap: _isLoadingSection
                              ? null
                              : () => _selectSection(section.name),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: settingsList),
            ],
          ),
        ),
      ],
    );
  }

  dynamic _normalizedSettingValue(String group, String key, dynamic value) {
    final descriptor = settingDescriptor(context.l10n, group, key, value);
    if (value is String) {
      switch (descriptor.kind) {
        case SettingEditorKind.permissionList:
          // Protobuf uint64 strings must not pass through JSON's Web numbers.
          return value;
        case SettingEditorKind.oauth2Providers:
        case SettingEditorKind.iceServers:
        case SettingEditorKind.stringList:
        case SettingEditorKind.smtpCredentials:
        case SettingEditorKind.smtpProxy:
        case SettingEditorKind.map:
        case SettingEditorKind.list:
          try {
            return jsonDecode(value);
          } catch (_) {
            if (descriptor.kind == SettingEditorKind.stringList) {
              return value
                  .split(RegExp(r'[\n,]'))
                  .map((item) => item.trim())
                  .where((item) => item.isNotEmpty)
                  .toList();
            }
          }
          break;
        case SettingEditorKind.boolean:
        case SettingEditorKind.enumChoice:
        case SettingEditorKind.number:
        case SettingEditorKind.text:
        case SettingEditorKind.optionalText:
          break;
      }
    }
    return value;
  }
}

String _settingSummary(
  AppLocalizations l10n,
  dynamic value,
  SettingDescriptor descriptor,
) {
  if (value == null) return l10n.notConfigured;
  switch (descriptor.kind) {
    case SettingEditorKind.boolean:
      return value == true ? l10n.enabled : l10n.disabled;
    case SettingEditorKind.oauth2Providers:
      final map = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      if (map.isEmpty) return l10n.noExternalLoginConfigured;
      final enabled = map.values.where((entry) {
        if (entry is! Map) return false;
        final provider = Map<String, dynamic>.from(entry);
        final type = _oauth2ProviderType(provider);
        return _oauth2ProviderHasClientId(
          type,
          _oauth2ProviderConfig(provider),
        );
      }).length;
      return l10n.oauthProviderSummary(map.length, enabled);
    case SettingEditorKind.iceServers:
      final list = value is List ? value : const [];
      return list.isEmpty
          ? l10n.noIceServersConfigured
          : l10n.iceServerCount(list.length);
    case SettingEditorKind.smtpCredentials:
      final credentials = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      final username = (credentials['username'] ?? '').toString();
      return username.isEmpty
          ? l10n.authenticationDisabled
          : l10n.configuredUser(username);
    case SettingEditorKind.smtpProxy:
      final proxy = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      final url = (proxy['url'] ?? '').toString();
      return url.isEmpty ? l10n.directConnection : url;
    case SettingEditorKind.optionalText:
      return value.toString();
    case SettingEditorKind.stringList:
    case SettingEditorKind.list:
      final list = _valueAsStringList(value);
      return list.isEmpty ? l10n.emptyList : list.join(', ');
    case SettingEditorKind.permissionList:
      final permissions = _permissionsFromValue(value).toList()..sort();
      if (permissions.isEmpty) return l10n.noPermissions;
      return permissions
          .map((permission) => settingPermissionLabel(l10n, permission))
          .join(', ');
    case SettingEditorKind.enumChoice:
      return descriptor.choices
          .firstWhere(
            (choice) => choice.value == value.toString(),
            orElse: () => SettingChoice(value.toString(), value.toString(), ''),
          )
          .label;
    case SettingEditorKind.map:
      final map = value is Map ? value : const {};
      return map.isEmpty
          ? l10n.emptyObject
          : l10n.configurationCount(map.length);
    case SettingEditorKind.number:
    case SettingEditorKind.text:
      if (descriptor.secret && value.toString().isNotEmpty) {
        return l10n.configured;
      }
      return value.toString().isEmpty ? l10n.notConfigured : value.toString();
  }
}

List<String> _valueAsStringList(dynamic value) {
  if (value is List) {
    return value
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return <String>[];
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
    } catch (_) {}
    return trimmed
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return <String>[];
}

Set<String> _permissionsFromValue(dynamic value) {
  if (value is List || value is String && value.trim().startsWith('[')) {
    return _valueAsStringList(value).toSet();
  }
  final bits = _permissionBits(value);
  return {
    for (final entry in runtimePermissionBits.entries)
      if ((bits & BigInt.from(entry.value)) != BigInt.zero) entry.key,
  };
}

BigInt _permissionBits(dynamic value) =>
    BigInt.tryParse(value?.toString() ?? '', radix: 10) ?? BigInt.zero;

String _permissionsToBits(dynamic value, {required dynamic originalValue}) {
  final names = value is Set<String>
      ? value
      : value is Iterable
      ? value.map((item) => item.toString()).toSet()
      : _permissionsFromValue(value);
  final knownMask = runtimePermissionBits.values.fold(
    BigInt.zero,
    (mask, bit) => mask | BigInt.from(bit),
  );
  // Retain permissions introduced by newer servers when editing known bits.
  var bits = _permissionBits(originalValue) & ~knownMask;
  for (final name in names) {
    bits |= BigInt.from(runtimePermissionBits[name] ?? 0);
  }
  return bits.toString();
}

class _SettingsSectionDropdown extends StatelessWidget {
  final List<RuntimeSettingsSection> sections;
  final String? selectedSection;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _SettingsSectionDropdown({
    required this.sections,
    required this.selectedSection,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSelect<String>(
      value: selectedSection,
      label: context.l10n.settings,
      prefixIcon: Icons.folder_outlined,
      options: {
        for (final section in sections)
          settingsSectionLabel(context.l10n, section.name): section.name,
      },
      enabled: enabled,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsSectionButton extends StatelessWidget {
  final String sectionName;
  final bool selected;
  final int count;
  final VoidCallback? onTap;

  const _SettingsSectionButton({
    required this.sectionName,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              settingsSectionLabel(context.l10n, sectionName),
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            count.toString(),
            style: theme.textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  final String sectionName;
  final int entryCount;
  final bool isLoading;
  final Widget? action;
  final VoidCallback? onRefresh;

  const _SettingsSectionHeader({
    required this.sectionName,
    required this.entryCount,
    required this.isLoading,
    this.action,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settingsSectionLabel(context.l10n, sectionName),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.configurableSettingsCount(entryCount),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    final controls = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ?action,
        AppIconButton(
          tooltip: context.l10n.refreshCurrentSection,
          icon: Icons.refresh_rounded,
          loading: isLoading,
          style: AppIconButtonStyle.tonal,
          onPressed: onRefresh,
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
          if (constraints.maxWidth < 640 * math.max(1, scale)) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [title, const SizedBox(height: 12), controls],
            );
          }
          return Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 12),
              controls,
            ],
          );
        },
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final SettingDescriptor descriptor;
  final dynamic value;
  final bool saving;
  final VoidCallback onEdit;

  const _SettingTile({
    required this.descriptor,
    required this.value,
    required this.saving,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBool =
        descriptor.kind == SettingEditorKind.boolean && value is bool;
    return _AdminRecordTile(
      contentPadding: const EdgeInsets.all(14),
      prefix: AppIconBadge(
        icon: descriptor.icon,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primaryContainer.withValues(
          alpha: 0.65,
        ),
        size: 42,
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        descriptor.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            descriptor.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _settingSummary(context.l10n, value, descriptor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          if (descriptor.warning != null) ...[
            const SizedBox(height: 10),
            _InlineWarning(text: descriptor.warning!),
          ],
        ],
      ),
      actions: [
        if (saving)
          const SizedBox.square(
            dimension: 22,
            child: AppLoadingIndicator(
              size: AppLoadingSize.sm,
              centered: false,
            ),
          )
        else if (isBool)
          AppSwitch(
            value: value == true,
            semanticsLabel: descriptor.title,
            onChanged: (_) => onEdit(),
          )
        else
          AppIconButton(
            tooltip: context.l10n.edit,
            icon: Icons.edit_outlined,
            style: AppIconButtonStyle.tonal,
            onPressed: onEdit,
          ),
      ],
    );
  }
}

class _InlineWarning extends StatelessWidget {
  final String text;

  const _InlineWarning({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInfoBanner(
      icon: Icons.warning_amber_rounded,
      color: AppColors.warningDeep,
      backgroundColor: const Color(0xFFFFF3CD),
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: const Color(0xFFE0A800).withValues(alpha: 0.35),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      iconSize: 18,
      title: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF6B4E00),
        ),
      ),
    );
  }
}

class _SettingsDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClose;

  const _SettingsDialogHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(22, 20, 14, 16),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      border: Border(
        bottom: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(
            icon: icon,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primaryContainer.withValues(
              alpha: 0.78,
            ),
            size: 44,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
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

class _SettingsDialogActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final bool saving;

  const _SettingsDialogActions({
    required this.onCancel,
    required this.onConfirm,
    this.saving = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppSafeArea(
      top: false,
      child: AppPanelSurface(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.zero,
        clipBehavior: Clip.none,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 12,
          runSpacing: 8,
          children: [
            AppActionButton(
              onPressed: onCancel,
              label: context.l10n.cancel,
              style: AppActionButtonStyle.outlined,
            ),
            AppActionButton(
              label: context.l10n.save,
              onPressed: onConfirm,
              loading: saving,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsEditorFrame extends StatelessWidget {
  const _SettingsEditorFrame({
    required this.formKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.onConfirm,
    required this.child,
    this.warning,
    this.saving = false,
  });

  final GlobalKey<FormState> formKey;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final VoidCallback? onConfirm;
  final bool saving;
  final Widget child;
  final String? warning;

  @override
  Widget build(BuildContext context) => AppDialogFrame(
    maxWidth: 780,
    maxHeight: 760,
    child: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SettingsDialogHeader(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    onClose: onClose,
                  ),
                  if (warning != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
                      child: _InlineWarning(text: warning!),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                    child: child,
                  ),
                ],
              ),
            ),
          ),
          _SettingsDialogActions(
            onCancel: onClose,
            onConfirm: onConfirm,
            saving: saving,
          ),
        ],
      ),
    ),
  );
}

class _SettingEditorSheet extends StatefulWidget {
  final SettingDescriptor descriptor;
  final String sectionName;
  final String settingKey;
  final dynamic value;
  final Future<bool> Function(dynamic value) onSave;

  const _SettingEditorSheet({
    required this.descriptor,
    required this.sectionName,
    required this.settingKey,
    required this.value,
    required this.onSave,
  });

  @override
  State<_SettingEditorSheet> createState() => _SettingEditorSheetState();
}

class _SettingEditorSheetState extends State<_SettingEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _closing = false;
  bool _saving = false;
  late dynamic _value;
  final Map<String, TextEditingController> _controllers = {};
  bool _optionalConfigEnabled = false;
  bool _nestedCredentialsEnabled = false;

  @override
  void initState() {
    super.initState();
    _value = _deepCopySettingValue(widget.value);
    _optionalConfigEnabled =
        widget.descriptor.kind == SettingEditorKind.optionalText
        ? _value != null
        : _value is Map;
    if (widget.descriptor.kind == SettingEditorKind.smtpProxy &&
        _value is Map) {
      _nestedCredentialsEnabled = (_value as Map)['credentials'] is Map;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String id, [String initial = '']) {
    return _controllers.putIfAbsent(
      id,
      () => TextEditingController(text: initial),
    );
  }

  void _finish([dynamic result]) {
    if (!mounted || _closing || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _closing = true;
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsEditorFrame(
      formKey: _formKey,
      icon: widget.descriptor.icon,
      title: widget.descriptor.title,
      subtitle: widget.descriptor.description,
      warning: widget.descriptor.warning,
      onClose: _finish,
      onConfirm: _saving ? null : _save,
      saving: _saving && ModalRoute.of(context)?.isCurrent == true,
      child: AbsorbPointer(
        absorbing: _saving,
        child: ExcludeFocus(excluding: _saving, child: _buildEditor()),
      ),
    );
  }

  Widget _buildEditor() {
    switch (widget.descriptor.kind) {
      case SettingEditorKind.number:
        return _NumberSettingEditor(
          controller: _controller('number', _value?.toString() ?? ''),
          section: widget.sectionName,
          settingKey: widget.settingKey,
        );
      case SettingEditorKind.text:
        return _TextSettingEditor(
          controller: _controller('text', _value?.toString() ?? ''),
          secret: widget.descriptor.secret,
        );
      case SettingEditorKind.optionalText:
        return _buildOptionalTextEditor();
      case SettingEditorKind.enumChoice:
        return _EnumSettingEditor(
          choices: widget.descriptor.choices,
          value: _value?.toString() ?? '',
          onChanged: (value) => setState(() => _value = value),
        );
      case SettingEditorKind.stringList:
        return _StringListSettingEditor(
          values: _valueAsStringList(_value),
          label: context.l10n.entry,
          hintText: _stringListHint(widget.sectionName, widget.settingKey),
          onChanged: (values) => setState(() => _value = values),
        );
      case SettingEditorKind.permissionList:
        return _PermissionListSettingEditor(
          values: _permissionsFromValue(_value),
          permissions: widget.descriptor.permissions ?? knownSettingPermissions,
          onChanged: (values) =>
              setState(() => _value = values.toList()..sort()),
        );
      case SettingEditorKind.oauth2Providers:
        return _OAuth2ProvidersEditor(
          providers: _oauth2ProvidersFromValue(_value),
          onChanged: (providers) => setState(() => _value = providers),
        );
      case SettingEditorKind.iceServers:
        return _IceServersEditor(
          servers: _iceServersFromValue(_value),
          onChanged: (servers) => setState(() => _value = servers),
        );
      case SettingEditorKind.smtpCredentials:
        return _buildSmtpCredentialsEditor();
      case SettingEditorKind.smtpProxy:
        return _buildSmtpProxyEditor();
      case SettingEditorKind.map:
        return _StructuredValueEditor(
          value: _value is Map
              ? Map<String, dynamic>.from(_value)
              : <String, dynamic>{},
          onChanged: (value) => setState(() => _value = value),
        );
      case SettingEditorKind.list:
        return _StringListSettingEditor(
          values: _valueAsStringList(_value),
          label: context.l10n.entry,
          hintText: context.l10n.enterEntry,
          onChanged: (values) => setState(() => _value = values),
        );
      case SettingEditorKind.boolean:
        return AppSwitchTile(
          value: _value == true,
          onChanged: (value) => setState(() => _value = value),
          title: Text(widget.descriptor.title),
          subtitle: Text(widget.descriptor.description),
        );
    }
  }

  Future<void> _save() async {
    if (!mounted ||
        _closing ||
        _saving ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    dynamic result = _value;
    switch (widget.descriptor.kind) {
      case SettingEditorKind.number:
        final raw = _controller('number').text.trim();
        result = parseRuntimeSettingNumber(
          widget.sectionName,
          widget.settingKey,
          raw,
        );
        if (result == null) return;
        break;
      case SettingEditorKind.text:
        result = _controller('text').text.trim();
        break;
      case SettingEditorKind.optionalText:
        result = _optionalTextUpdateValue();
        break;
      case SettingEditorKind.stringList:
        result = _valueAsStringList(_value);
        break;
      case SettingEditorKind.oauth2Providers:
      case SettingEditorKind.iceServers:
        result = _value;
        break;
      case SettingEditorKind.permissionList:
        result = _permissionsToBits(_value, originalValue: widget.value);
        break;
      case SettingEditorKind.smtpCredentials:
        result = _smtpCredentialsUpdateValue();
        break;
      case SettingEditorKind.smtpProxy:
        result = _smtpProxyUpdateValue();
        break;
      case SettingEditorKind.map:
      case SettingEditorKind.list:
      case SettingEditorKind.enumChoice:
      case SettingEditorKind.boolean:
        result = _value;
        break;
    }
    setState(() => _saving = true);
    try {
      final saved = await widget.onSave(result);
      if (saved && mounted && !_closing) {
        final route = ModalRoute.of(context);
        if (route?.isActive == true) {
          _closing = true;
          final navigator = Navigator.of(context);
          if (route!.isCurrent) {
            navigator.pop(result);
          } else {
            navigator.removeRoute(route, result);
          }
        }
      }
    } finally {
      if (mounted && !_closing) setState(() => _saving = false);
    }
  }

  Widget _buildOptionalTextEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(widget.descriptor.title),
          subtitle: Text(widget.descriptor.description),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller('optionalText', _value?.toString() ?? ''),
            label: context.l10n.content,
            prefixIcon: Icons.edit_outlined,
            autocorrect: false,
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.enterSettingValue(widget.descriptor.title)
                : null,
          ),
        ],
      ],
    );
  }

  dynamic _optionalTextUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    return _controller('optionalText').text.trim();
  }

  Widget _buildSmtpCredentialsEditor() {
    final current = _value is Map
        ? Map<String, dynamic>.from(_value as Map)
        : const <String, dynamic>{};
    final currentUsername = (current['username'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(context.l10n.enableSmtpAuthentication),
          subtitle: Text(context.l10n.enableSmtpAuthenticationDescription),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller('credentialsUsername', currentUsername),
            label: context.l10n.username,
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.smtpUsernameRequired
                : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _controller('credentialsPassword'),
            label: context.l10n.password,
            hintText: currentUsername.isEmpty
                ? context.l10n.passwordRequired
                : context.l10n.emptyKeepsCurrentPassword,
            prefixIcon: Icons.password_rounded,
            obscureText: true,
            autocorrect: false,
            validator: (value) {
              final username = _controller('credentialsUsername').text.trim();
              final usernameChanged = username != currentUsername;
              if ((currentUsername.isEmpty || usernameChanged) &&
                  (value == null || value.isEmpty)) {
                return context.l10n.passwordRequiredForNewCredentials;
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSmtpProxyEditor() {
    final current = _value is Map
        ? Map<String, dynamic>.from(_value as Map)
        : const <String, dynamic>{};
    final credentials = current['credentials'] is Map
        ? Map<String, dynamic>.from(current['credentials'] as Map)
        : const <String, dynamic>{};
    final currentUsername = (credentials['username'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(context.l10n.enableSmtpProxy),
          subtitle: Text(context.l10n.enableSmtpProxyDescription),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller(
              'proxyUrl',
              (current['url'] ?? '').toString(),
            ),
            label: context.l10n.socks5ProxyAddress,
            hintText: 'socks5://proxy.example.com:1080',
            prefixIcon: Icons.route_outlined,
            keyboardType: TextInputType.url,
            autocorrect: false,
            validator: (value) {
              final url = value?.trim() ?? '';
              return isValidRuntimeSmtpProxyUrl(url)
                  ? null
                  : context.l10n.socks5ProxyAddressRequired;
            },
          ),
          const SizedBox(height: 12),
          AppSwitchTile(
            value: _nestedCredentialsEnabled,
            onChanged: (value) =>
                setState(() => _nestedCredentialsEnabled = value),
            title: Text(context.l10n.proxyRequiresAuthentication),
            subtitle: Text(context.l10n.proxyAuthenticationDescription),
          ),
          if (_nestedCredentialsEnabled) ...[
            const SizedBox(height: 12),
            AppTextField(
              controller: _controller('proxyUsername', currentUsername),
              label: context.l10n.proxyUsername,
              prefixIcon: Icons.manage_accounts_outlined,
              validator: (value) {
                final username = value?.trim() ?? '';
                if (username.isEmpty) return context.l10n.proxyUsernameRequired;
                return utf8.encode(username).length > 255
                    ? context.l10n.smtpProxyCredentialTooLong
                    : null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _controller('proxyPassword'),
              label: context.l10n.proxyPassword,
              hintText: currentUsername.isEmpty
                  ? context.l10n.passwordRequired
                  : context.l10n.emptyKeepsCurrentPassword,
              prefixIcon: Icons.key_outlined,
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                final username = _controller('proxyUsername').text.trim();
                if (utf8.encode(value ?? '').length > 255) {
                  return context.l10n.smtpProxyCredentialTooLong;
                }
                final usernameChanged = username != currentUsername;
                if ((currentUsername.isEmpty || usernameChanged) &&
                    (value == null || value.isEmpty)) {
                  return context.l10n.passwordRequiredForNewCredentials;
                }
                return null;
              },
            ),
          ],
        ],
      ],
    );
  }

  dynamic _smtpCredentialsUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    final password = _controller('credentialsPassword').text;
    return {
      'username': _controller('credentialsUsername').text.trim(),
      if (password.isNotEmpty) 'password': password,
    };
  }

  dynamic _smtpProxyUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    final password = _controller('proxyPassword').text;
    return {
      'url': _controller('proxyUrl').text.trim(),
      if (_nestedCredentialsEnabled)
        'credentials': {
          'username': _controller('proxyUsername').text.trim(),
          if (password.isNotEmpty) 'password': password,
        },
    };
  }

  String _stringListHint(String group, String key) {
    if (group == 'cors') return 'https://app.example.com';
    if (group == 'email') return '@example.com';
    return context.l10n.enterEntry;
  }
}

final class _ClearRuntimeSettingValue {
  const _ClearRuntimeSettingValue();
}

const _clearRuntimeSettingValue = _ClearRuntimeSettingValue();

dynamic _deepCopySettingValue(dynamic value) {
  if (value is Map || value is List) return jsonDecode(jsonEncode(value));
  return value;
}

class _NumberSettingEditor extends StatelessWidget {
  final TextEditingController controller;
  final String section;
  final String settingKey;

  const _NumberSettingEditor({
    required this.controller,
    required this.section,
    required this.settingKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: context.l10n.value,
      prefixIcon: Icons.pin_outlined,
      keyboardType: TextInputType.numberWithOptions(
        decimal: !isIntegerRuntimeSetting(section, settingKey),
        signed: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context.l10n.valueRequired;
        }
        return parseRuntimeSettingNumber(section, settingKey, value) == null
            ? isIntegerRuntimeSetting(section, settingKey)
                  ? context.l10n.validRuntimeIntegerRequired
                  : context.l10n.validNumberRequired
            : null;
      },
    );
  }
}

class _TextSettingEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool secret;

  const _TextSettingEditor({required this.controller, required this.secret});

  @override
  State<_TextSettingEditor> createState() => _TextSettingEditorState();
}

class _TextSettingEditorState extends State<_TextSettingEditor> {
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: context.l10n.content,
      prefixIcon: Icons.edit_outlined,
      obscureText: widget.secret,
      minLines: widget.secret ? 1 : null,
      maxLines: widget.secret ? 1 : 4,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }
}

class _EnumSettingEditor extends StatelessWidget {
  final List<SettingChoice> choices;
  final String value;
  final ValueChanged<String> onChanged;

  const _EnumSettingEditor({
    required this.choices,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final choice in choices)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: AppTile(
                onPressed: () => onChanged(choice.value),
                prefix: Icon(
                  value == choice.value
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(choice.label),
                subtitle: Text(choice.description),
              ),
            ),
          ),
      ],
    );
  }
}

class _StringListSettingEditor extends StatefulWidget {
  final List<String> values;
  final String label;
  final String hintText;
  final ValueChanged<List<String>> onChanged;

  const _StringListSettingEditor({
    required this.values,
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<_StringListSettingEditor> createState() =>
      _StringListSettingEditorState();
}

class _StringListSettingEditorState extends State<_StringListSettingEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      for (final value in widget.values) TextEditingController(text: value),
    ];
    if (_controllers.isEmpty) _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _emit() {
    widget.onChanged(
      _controllers
          .map((controller) => controller.text.trim())
          .where((value) => value.isNotEmpty)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < _controllers.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _controllers[index],
                    label: '${widget.label} ${index + 1}',
                    hintText: widget.hintText,
                    onChanged: (_) => _emit(),
                  ),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  tooltip: context.l10n.delete,
                  icon: Icons.remove_rounded,
                  style: AppIconButtonStyle.destructive,
                  onPressed: _controllers.length == 1
                      ? null
                      : () {
                          setState(() {
                            _controllers.removeAt(index).dispose();
                          });
                          _emit();
                        },
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: context.l10n.add,
            onPressed: () {
              setState(() => _controllers.add(TextEditingController()));
              _emit();
            },
            style: AppActionButtonStyle.outlined,
          ),
        ),
      ],
    );
  }
}

class _PermissionListSettingEditor extends StatelessWidget {
  final Set<String> values;
  final List<String> permissions;
  final ValueChanged<Set<String>> onChanged;

  const _PermissionListSettingEditor({
    required this.values,
    required this.permissions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final permission in permissions)
          AppChip(
            label: Text(settingPermissionLabel(context.l10n, permission)),
            selected: values.contains(permission),
            onSelected: (selected) {
              final next = {...values};
              if (selected) {
                next.add(permission);
              } else {
                next.remove(permission);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}

Map<String, dynamic> _oauth2ProvidersFromValue(dynamic value) {
  List<dynamic> list;
  if (value is Map) {
    final providers = value['providers'];
    if (providers is List) return _oauth2ProvidersFromList(providers);
    return Map<String, dynamic>.from(value);
  }
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return _oauth2ProvidersFromValue(decoded);
      if (decoded is List) {
        list = decoded;
        return _oauth2ProvidersFromList(list);
      }
    } catch (_) {}
  }
  if (value is List) return _oauth2ProvidersFromList(value);
  return <String, dynamic>{};
}

Map<String, dynamic> _oauth2ProvidersFromList(List<dynamic> providers) {
  return {
    for (final provider in providers)
      if (provider is Map)
        (provider['name'] ?? '').toString(): Map<String, dynamic>.from(
          provider,
        ),
  }..remove('');
}

Map<String, dynamic> _oauth2ProviderConfig(Map<String, dynamic> value) {
  final type = _oauth2ProviderType(value);
  final preferred = value[_oauth2ProviderConfigField(type)];
  if (preferred is Map) return Map<String, dynamic>.from(preferred);
  return <String, dynamic>{};
}

bool _oauth2ProviderHasClientId(String type, Map<String, dynamic> config) {
  if (type == 'apple') {
    return [
      config['webClientId'],
      config['nativeClientId'],
    ].any((value) => value?.toString().trim().isNotEmpty ?? false);
  }
  return config['clientId']?.toString().trim().isNotEmpty ?? false;
}

String _oauth2ProviderType(Map<String, dynamic> value) {
  for (final type in oauth2ProviderTypes) {
    if (value[type] is Map) return type;
  }
  return 'oidc';
}

String _oauth2ProviderConfigField(String type) {
  return oauth2ProviderTypes.contains(type) ? type : 'oidc';
}

List<Map<String, dynamic>> _oauth2ProvidersToProtoList(
  Map<String, dynamic> providers,
) {
  return providers.entries
      .map((entry) {
        final value = entry.value is Map
            ? Map<String, dynamic>.from(entry.value)
            : <String, dynamic>{};
        final type = _oauth2ProviderType(value);
        final config = _oauth2ProviderConfig(value);
        return <String, dynamic>{
          'name': entry.key,
          'enableSignup': value['enableSignup'] == true,
          'signupNeedReview': value['signupNeedReview'] == true,
          _oauth2ProviderConfigField(type): config,
        };
      })
      .toList(growable: false);
}

List<Map<String, dynamic>> _iceServersFromValue(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) return _iceServersFromValue(decoded);
    } catch (_) {}
  }
  return <Map<String, dynamic>>[];
}

class _OAuth2ProvidersEditor extends StatelessWidget {
  final Map<String, dynamic> providers;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _OAuth2ProvidersEditor({
    required this.providers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final entries = providers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entries.isEmpty)
          _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: context.l10n.noLoginProviders,
            message: context.l10n.noLoginProvidersDescription,
          )
        else
          for (final entry in entries)
            _OAuth2ProviderCard(
              name: entry.key,
              value: entry.value is Map
                  ? Map<String, dynamic>.from(entry.value)
                  : <String, dynamic>{},
              onEdit: () => _editProvider(context, entry.key),
              onDelete: () {
                final next = Map<String, dynamic>.from(providers)
                  ..remove(entry.key);
                onChanged(next);
              },
            ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: context.l10n.addLoginProvider,
            onPressed: () => _editProvider(context, null),
          ),
        ),
      ],
    );
  }

  Future<void> _editProvider(BuildContext context, String? name) async {
    final current = name == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(providers[name] as Map? ?? const {});
    final result = await showAppDialog<_OAuth2ProviderEditResult>(
      context: context,
      builder: (context) => _OAuth2ProviderEditorSheet(
        initialName: name,
        initialValue: current,
        existingNames: providers.keys.toSet(),
      ),
    );
    if (result == null) return;
    final next = Map<String, dynamic>.from(providers);
    if (name != null && name != result.name) next.remove(name);
    next[result.name] = result.value;
    onChanged(next);
  }
}

class _OAuth2ProvidersList extends StatelessWidget {
  final Map<String, dynamic> providers;
  final bool saving;
  final ValueChanged<String> onEdit;
  final ValueChanged<String> onDelete;

  const _OAuth2ProvidersList({
    required this.providers,
    required this.saving,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final entries = providers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (saving)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: AppLinearProgress(),
          ),
        if (entries.isEmpty)
          _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: context.l10n.noLoginProviders,
            message: context.l10n.addLoginProviderHint,
          )
        else
          for (final entry in entries)
            _OAuth2ProviderCard(
              name: entry.key,
              value: entry.value is Map
                  ? Map<String, dynamic>.from(entry.value)
                  : <String, dynamic>{},
              onEdit: saving ? null : () => onEdit(entry.key),
              onDelete: saving ? null : () => onDelete(entry.key),
            ),
      ],
    );
  }
}

class _OAuth2ProviderCard extends StatelessWidget {
  final String name;
  final Map<String, dynamic> value;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _OAuth2ProviderCard({
    required this.name,
    required this.value,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providerType = _oauth2ProviderType(value);
    final config = _oauth2ProviderConfig(value);
    final hasClientId = _oauth2ProviderHasClientId(providerType, config);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.login_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.loginProviderSummary(
                      oauth2ProviderTypeLabels[providerType] ?? providerType,
                      hasClientId
                          ? context.l10n.clientConfigured
                          : context.l10n.clientIdMissing,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        label: value['enableSignup'] == true
                            ? context.l10n.signupAllowed
                            : context.l10n.loginBindingOnly,
                        icon: value['enableSignup'] == true
                            ? Icons.person_add_alt_1_outlined
                            : Icons.login_rounded,
                      ),
                      if (value['signupNeedReview'] == true)
                        _StatusChip(
                          label: context.l10n.signupRequiresReview,
                          icon: Icons.fact_check_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            AppIconButton(
              tooltip: context.l10n.edit,
              icon: Icons.edit_outlined,
              onPressed: onEdit,
            ),
            AppIconButton(
              tooltip: context.l10n.delete,
              icon: Icons.delete_outline_rounded,
              style: AppIconButtonStyle.destructive,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      borderRadius: BorderRadius.circular(999),
      icon: icon,
      iconSize: 14,
      color: theme.colorScheme.onSecondaryContainer,
      backgroundColor: theme.colorScheme.secondaryContainer.withValues(
        alpha: 0.7,
      ),
      label: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _OAuth2ProviderEditResult {
  final String name;
  final Map<String, dynamic> value;

  const _OAuth2ProviderEditResult(this.name, this.value);
}

class _OAuth2ProviderEditorSheet extends StatefulWidget {
  final String? initialName;
  final Map<String, dynamic> initialValue;
  final Set<String> existingNames;

  const _OAuth2ProviderEditorSheet({
    required this.initialName,
    required this.initialValue,
    required this.existingNames,
  });

  @override
  State<_OAuth2ProviderEditorSheet> createState() =>
      _OAuth2ProviderEditorSheetState();
}

class _OAuth2ProviderEditorSheetState
    extends State<_OAuth2ProviderEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _closing = false;

  void _finish([_OAuth2ProviderEditResult? result]) {
    if (!mounted || _closing || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _closing = true;
    Navigator.pop(context, result);
  }

  late final TextEditingController _name;
  late final TextEditingController _clientId;
  late final TextEditingController _clientSecret;
  late final TextEditingController _appleWebClientId;
  late final TextEditingController _appleWebClientSecret;
  late final TextEditingController _appleNativeClientId;
  late final TextEditingController _appleNativeClientSecret;
  late final TextEditingController _tenant;
  late final TextEditingController _endpoint;
  late final TextEditingController _issuer;
  late final TextEditingController _authUrl;
  late final TextEditingController _tokenUrl;
  late final TextEditingController _userinfoUrl;
  late final TextEditingController _jwksUrl;
  late final String _initialType;
  late final String _initialClientId;
  late final String _initialAppleWebClientId;
  late final String _initialAppleNativeClientId;
  late String _type;
  late bool _enableSignup;
  late bool _signupNeedReview;

  @override
  void initState() {
    super.initState();
    final config = _oauth2ProviderConfig(widget.initialValue);
    _type = _oauth2ProviderType(widget.initialValue);
    if (!oauth2ProviderTypes.contains(_type)) _type = 'oidc';
    _initialType = _type;
    _initialClientId = (config['clientId'] ?? '').toString();
    _initialAppleWebClientId = (config['webClientId'] ?? '').toString();
    _initialAppleNativeClientId = (config['nativeClientId'] ?? '').toString();
    _enableSignup = widget.initialValue['enableSignup'] == true;
    _signupNeedReview = widget.initialValue['signupNeedReview'] == true;
    _name = TextEditingController(text: widget.initialName ?? _type);
    _clientId = TextEditingController(
      text: (config['clientId'] ?? '').toString(),
    );
    _clientSecret = TextEditingController(
      text: (config['clientSecret'] ?? '').toString(),
    );
    _appleWebClientId = TextEditingController(
      text: (config['webClientId'] ?? '').toString(),
    );
    _appleWebClientSecret = TextEditingController(
      text: (config['webClientSecret'] ?? '').toString(),
    );
    _appleNativeClientId = TextEditingController(
      text: (config['nativeClientId'] ?? '').toString(),
    );
    _appleNativeClientSecret = TextEditingController(
      text: (config['nativeClientSecret'] ?? '').toString(),
    );
    _tenant = TextEditingController(
      text: (config['tenant'] ?? 'common').toString(),
    );
    _endpoint = TextEditingController(
      text: (config['endpoint'] ?? '').toString(),
    );
    _issuer = TextEditingController(text: (config['issuer'] ?? '').toString());
    _authUrl = TextEditingController(
      text: (config['authUrl'] ?? '').toString(),
    );
    _tokenUrl = TextEditingController(
      text: (config['tokenUrl'] ?? '').toString(),
    );
    _userinfoUrl = TextEditingController(
      text: (config['userinfoUrl'] ?? '').toString(),
    );
    _jwksUrl = TextEditingController(
      text: (config['jwksUrl'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _clientId.dispose();
    _clientSecret.dispose();
    _appleWebClientId.dispose();
    _appleWebClientSecret.dispose();
    _appleNativeClientId.dispose();
    _appleNativeClientSecret.dispose();
    _tenant.dispose();
    _endpoint.dispose();
    _issuer.dispose();
    _authUrl.dispose();
    _tokenUrl.dispose();
    _userinfoUrl.dispose();
    _jwksUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsEditorFrame(
      formKey: _formKey,
      icon: Icons.login_rounded,
      title: widget.initialName == null
          ? context.l10n.addExternalLogin
          : context.l10n.editExternalLogin,
      subtitle: context.l10n.externalLoginEditorDescription,
      onClose: _finish,
      onConfirm: _save,
      child: Column(
        children: [
          AppTextField(
            controller: _name,
            label: context.l10n.instanceName,
            helperText: context.l10n.instanceNameFormatHint,
            prefixIcon: Icons.badge_outlined,
            validator: _validateProviderName,
            onChanged: (_) => setState(() {}),
            autocorrect: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
          ),
          const SizedBox(height: 12),
          AppSelect<String>(
            value: _type,
            label: context.l10n.providerType,
            prefixIcon: Icons.account_tree_outlined,
            options: {
              for (final type in oauth2ProviderTypes)
                oauth2ProviderTypeLabels[type] ?? type: type,
            },
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _type = value;
                if (widget.initialName == null &&
                    (_name.text.trim().isEmpty ||
                        oauth2ProviderTypes.contains(_name.text.trim()))) {
                  _name.text = value;
                }
              });
            },
          ),
          const SizedBox(height: 12),
          if (_type == 'apple') ...[
            _oauthTextField(
              _appleWebClientId,
              'Apple Services ID',
              Icons.language_outlined,
              onChanged: (_) => setState(() {}),
              hintText: 'org.example.app.web',
            ),
            const SizedBox(height: 12),
            _oauthSecretField(
              _appleWebClientSecret,
              'Apple Services ID Secret',
              _canPreserveAppleWebClientSecret,
              required: false,
            ),
            const SizedBox(height: 12),
            _oauthTextField(
              _appleNativeClientId,
              'Apple App ID (Bundle ID)',
              Icons.phone_iphone_outlined,
              onChanged: (_) => setState(() {}),
              hintText: 'org.example.app',
            ),
            const SizedBox(height: 12),
            _oauthSecretField(
              _appleNativeClientSecret,
              'Apple App ID Secret',
              _canPreserveAppleNativeClientSecret,
              required: false,
            ),
          ] else ...[
            _oauthTextField(
              _clientId,
              'Client ID',
              Icons.key_outlined,
              required: true,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            _oauthSecretField(
              _clientSecret,
              'Client Secret',
              _canPreserveClientSecret,
            ),
          ],
          if (_type == 'microsoft') ...[
            const SizedBox(height: 12),
            _oauthTextField(
              _tenant,
              'Microsoft Tenant',
              Icons.domain_outlined,
              required: true,
              hintText: 'common',
            ),
          ],
          const SizedBox(height: 12),
          if (_type == 'logto') ...[
            const SizedBox(height: 12),
            _oauthTextField(
              _endpoint,
              'Logto Endpoint',
              Icons.hub_outlined,
              required: true,
              hintText: 'https://auth.example.com',
              validator: _validateHttpUrl,
            ),
          ],
          if (_type == 'feishu') ...[
            const SizedBox(height: 12),
            _oauthTextField(
              _endpoint,
              'Feishu Endpoint',
              Icons.hub_outlined,
              hintText: 'https://open.feishu.cn',
              validator: _validateOptionalHttpUrl,
            ),
          ],
          if (_type == 'oidc' || _type == 'casdoor') ...[
            const SizedBox(height: 12),
            _oauthTextField(
              _issuer,
              'Issuer',
              Icons.verified_outlined,
              required: true,
              hintText: 'https://issuer.example.com',
              validator: _validateHttpUrl,
            ),
            const SizedBox(height: 12),
            _oauthTextField(
              _authUrl,
              context.l10n.authorizationEndpoint,
              Icons.open_in_browser_rounded,
              hintText: context.l10n.emptyUsesOidcDiscovery,
              validator: _validateOptionalHttpUrl,
            ),
            const SizedBox(height: 12),
            _oauthTextField(
              _tokenUrl,
              context.l10n.tokenEndpoint,
              Icons.token_outlined,
              hintText: context.l10n.emptyUsesOidcDiscovery,
              validator: _validateOptionalHttpUrl,
            ),
            const SizedBox(height: 12),
            _oauthTextField(
              _userinfoUrl,
              context.l10n.userInfoEndpoint,
              Icons.person_search_outlined,
              hintText: context.l10n.emptyUsesOidcDiscovery,
              validator: _validateOptionalHttpUrl,
            ),
            const SizedBox(height: 12),
            _oauthTextField(
              _jwksUrl,
              context.l10n.jwksEndpoint,
              Icons.security_rounded,
              hintText: context.l10n.emptyUsesOidcDiscovery,
              validator: _validateOptionalHttpUrl,
            ),
          ],
          const SizedBox(height: 8),
          AppSwitchTile(
            value: _enableSignup,
            onChanged: (value) => setState(() => _enableSignup = value),
            title: Text(context.l10n.allowProviderSignup),
            subtitle: Text(context.l10n.allowProviderSignupDescription),
          ),
          AppSwitchTile(
            value: _signupNeedReview,
            onChanged: _enableSignup
                ? (value) => setState(() => _signupNeedReview = value)
                : null,
            title: Text(context.l10n.signupRequiresReview),
          ),
        ],
      ),
    );
  }

  Widget _oauthTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    String? hintText,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      onChanged: onChanged,
      prefixIcon: icon,
      validator:
          validator ??
          (required
              ? (value) => (value == null || value.trim().isEmpty)
                    ? context.l10n.fieldRequired(label)
                    : null
              : null),
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }

  Widget _oauthSecretField(
    TextEditingController controller,
    String label,
    bool canPreserve, {
    bool required = true,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      helperText: canPreserve ? context.l10n.emptyKeepsCurrentValue : null,
      prefixIcon: Icons.password_outlined,
      obscureText: true,
      validator: (value) =>
          required && (value == null || value.trim().isEmpty) && !canPreserve
          ? context.l10n.clientSecretRequired
          : null,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }

  String? _validateProviderName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return context.l10n.instanceNameRequired;
    if (name.length > 64) return context.l10n.instanceNameTooLong(64);
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(name)) {
      return context.l10n.instanceNameFormatHint;
    }
    if (name != widget.initialName && widget.existingNames.contains(name)) {
      return context.l10n.instanceNameExists;
    }
    return null;
  }

  String? _validateHttpUrl(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return context.l10n.urlRequired;
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return context.l10n.validUrlRequired;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return context.l10n.httpUrlRequired;
    }
    return null;
  }

  String? _validateOptionalHttpUrl(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    return _validateHttpUrl(raw);
  }

  bool get _canPreserveClientSecret =>
      widget.initialName != null &&
      _name.text.trim() == widget.initialName &&
      _type == _initialType &&
      _clientId.text.trim() == _initialClientId;

  bool get _canPreserveAppleProviderIdentity =>
      widget.initialName != null &&
      _name.text.trim() == widget.initialName &&
      _type == _initialType;

  bool get _canPreserveAppleWebClientSecret =>
      _canPreserveAppleProviderIdentity &&
      _appleWebClientId.text.trim() == _initialAppleWebClientId;

  bool get _canPreserveAppleNativeClientSecret =>
      _canPreserveAppleProviderIdentity &&
      _appleNativeClientId.text.trim() == _initialAppleNativeClientId;

  void _save() {
    if (!mounted || _closing || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final config = <String, dynamic>{};
    if (_type == 'apple') {
      config['webClientId'] = _appleWebClientId.text.trim();
      config['nativeClientId'] = _appleNativeClientId.text.trim();
      final webClientSecret = _appleWebClientSecret.text;
      if (webClientSecret.trim().isNotEmpty ||
          !_canPreserveAppleWebClientSecret) {
        config['webClientSecret'] = webClientSecret;
      }
      final nativeClientSecret = _appleNativeClientSecret.text;
      if (nativeClientSecret.trim().isNotEmpty ||
          !_canPreserveAppleNativeClientSecret) {
        config['nativeClientSecret'] = nativeClientSecret;
      }
    } else {
      config['clientId'] = _clientId.text.trim();
      final clientSecret = _clientSecret.text;
      if (clientSecret.trim().isNotEmpty || !_canPreserveClientSecret) {
        config['clientSecret'] = clientSecret;
      }
    }
    if (_type == 'microsoft') {
      config['tenant'] = _tenant.text.trim();
    }
    if (_type == 'logto') {
      config['endpoint'] = _endpoint.text.trim();
    }
    if (_type == 'feishu' && _endpoint.text.trim().isNotEmpty) {
      config['endpoint'] = _endpoint.text.trim();
    }
    if (_type == 'oidc' || _type == 'casdoor') {
      config['issuer'] = _issuer.text.trim();
      for (final entry in {
        'authUrl': _authUrl.text.trim(),
        'tokenUrl': _tokenUrl.text.trim(),
        'userinfoUrl': _userinfoUrl.text.trim(),
        'jwksUrl': _jwksUrl.text.trim(),
      }.entries) {
        if (entry.value.isNotEmpty) config[entry.key] = entry.value;
      }
    }
    _finish(
      _OAuth2ProviderEditResult(_name.text.trim(), {
        'enableSignup': _enableSignup,
        'signupNeedReview': _enableSignup && _signupNeedReview,
        _oauth2ProviderConfigField(_type): config,
      }),
    );
  }
}

class _IceServersEditor extends StatelessWidget {
  final List<Map<String, dynamic>> servers;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const _IceServersEditor({required this.servers, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (servers.isEmpty)
          _EmptySettingsNotice(
            icon: Icons.settings_input_antenna_rounded,
            title: context.l10n.noIceServersConfigured,
            message: context.l10n.noIceServersDescription,
          )
        else
          for (var index = 0; index < servers.length; index++)
            _IceServerCard(
              index: index,
              value: servers[index],
              onChanged: (value) {
                final next = [...servers];
                next[index] = value;
                onChanged(next);
              },
              onDelete: () {
                final next = [...servers]..removeAt(index);
                onChanged(next);
              },
            ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: context.l10n.addIceServer,
            onPressed: () {
              onChanged([
                ...servers,
                {
                  'urls': ['stun:stun.l.google.com:19302'],
                },
              ]);
            },
          ),
        ),
      ],
    );
  }
}

class _IceServerCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> value;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback onDelete;

  const _IceServerCard({
    required this.index,
    required this.value,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_IceServerCard> createState() => _IceServerCardState();
}

class _IceServerCardState extends State<_IceServerCard> {
  late final TextEditingController _urls;
  late final TextEditingController _username;
  late final TextEditingController _credential;

  @override
  void initState() {
    super.initState();
    final urls = widget.value['urls'];
    _urls = TextEditingController(
      text: urls is List ? urls.map((item) => item.toString()).join('\n') : '',
    );
    _username = TextEditingController(
      text: (widget.value['username'] ?? '').toString(),
    );
    _credential = TextEditingController(
      text: (widget.value['credential'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _urls.dispose();
    _username.dispose();
    _credential.dispose();
    super.dispose();
  }

  void _emit() {
    final next = <String, dynamic>{
      'urls': _urls.text
          .split(RegExp(r'[\n,]'))
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList(),
    };
    if (_username.text.trim().isNotEmpty) {
      next['username'] = _username.text.trim();
    }
    if (_credential.text.isNotEmpty) next['credential'] = _credential.text;
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.iceServerNumber(widget.index + 1),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppIconButton(
                  tooltip: context.l10n.delete,
                  icon: Icons.delete_outline_rounded,
                  style: AppIconButtonStyle.destructive,
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            AppTextField(
              controller: _urls,
              label: 'URL',
              helperText: context.l10n.iceServerUrlsHint,
              prefixIcon: Icons.link_rounded,
              minLines: 1,
              maxLines: 4,
              onChanged: (_) => _emit(),
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              validator: (value) {
                final urls =
                    value
                        ?.split(RegExp(r'[\n,]'))
                        .map((url) => url.trim())
                        .where((url) => url.isNotEmpty)
                        .toList() ??
                    const [];
                if (urls.isEmpty) return context.l10n.atLeastOneUrlRequired;
                final invalid = urls.where(
                  (url) =>
                      !(url.startsWith('stun:') ||
                          url.startsWith('turn:') ||
                          url.startsWith('turns:')),
                );
                return invalid.isNotEmpty
                    ? context.l10n.iceServerUrlSchemeRequired
                    : null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _username,
              label: context.l10n.username,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => _emit(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _credential,
              label: context.l10n.credential,
              prefixIcon: Icons.password_outlined,
              obscureText: true,
              onChanged: (_) => _emit(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StructuredValueEditor extends StatelessWidget {
  final Map<String, dynamic> value;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _StructuredValueEditor({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final entries = value.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DynamicValueField(
              name: entry.key,
              value: entry.value,
              onChanged: (nextValue) {
                final next = Map<String, dynamic>.from(value);
                next[entry.key] = nextValue;
                onChanged(next);
              },
            ),
          ),
      ],
    );
  }
}

class _DynamicValueField extends StatefulWidget {
  final String name;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const _DynamicValueField({
    required this.name,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_DynamicValueField> createState() => _DynamicValueFieldState();
}

class _DynamicValueFieldState extends State<_DynamicValueField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    if (value is bool) {
      return AppSwitchTile(
        value: value,
        onChanged: widget.onChanged,
        title: Text(humanizeSettingKey(widget.name)),
      );
    }
    return AppTextField(
      controller: _controller,
      label: humanizeSettingKey(widget.name),
      obscureText: isSecretKey(widget.name),
      keyboardType: value is num ? TextInputType.number : TextInputType.text,
      onChanged: (raw) {
        if (value is int) {
          widget.onChanged(int.tryParse(raw) ?? value);
        } else if (value is double || value is num) {
          widget.onChanged(num.tryParse(raw) ?? value);
        } else {
          widget.onChanged(raw);
        }
      },
    );
  }
}

class _EmptySettingsNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptySettingsNotice({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: icon,
      title: title,
      subtitle: message,
      padding: const EdgeInsets.all(18),
      iconSize: 32,
    );
  }
}
