import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/services/bilibili_geetest_service.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum _ProviderKind { alist, cloudreve, emby, bilibili }

List<String> _mergeInstanceNames(List<String> remoteInstances) {
  final names = <String>[''];
  for (final instance in remoteInstances) {
    final trimmed = instance.trim();
    if (trimmed.isNotEmpty && !names.contains(trimmed)) {
      names.add(trimmed);
    }
  }
  return names;
}

String _providerInstanceLabel(String instanceName, String localInstanceLabel) {
  return instanceName.isEmpty ? localInstanceLabel : instanceName;
}

String _hashAlistPassword(String password) {
  const salt = 'https://github.com/alist-org/alist';
  return sha256.convert(utf8.encode('$password-$salt')).toString();
}

class PlatformBindingDialog extends StatefulWidget {
  final int initialIndex;

  const PlatformBindingDialog({super.key, this.initialIndex = 0});

  static Future<void> show(BuildContext context, {int initialIndex = 0}) {
    return showAppDialog<void>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final accent = theme.colorScheme.primary;
        return AppDialogFrame(
          maxWidth: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDialogHeader(
                title: Text(dialogContext.l10n.accountBinding),
                icon: Icons.link_rounded,
                color: accent,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  child: PlatformBindingDialog(initialIndex: initialIndex),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<PlatformBindingDialog> createState() => _PlatformBindingDialogState();
}

class _PlatformBindingDialogState extends State<PlatformBindingDialog>
    with SingleTickerProviderStateMixin {
  static const _providers = [
    _ProviderSpec(
      kind: _ProviderKind.alist,
      label: 'AList',
      tabLabel: 'AList',
      icon: Icons.cloud_circle_rounded,
      emptyIcon: Icons.cloud_off_rounded,
      color: Colors.amber,
    ),
    _ProviderSpec(
      kind: _ProviderKind.cloudreve,
      label: 'Cloudreve',
      tabLabel: 'Cloudreve',
      icon: Icons.cloud_rounded,
      emptyIcon: Icons.cloud_off_rounded,
      color: Colors.teal,
    ),
    _ProviderSpec(
      kind: _ProviderKind.emby,
      label: 'Emby',
      tabLabel: 'Emby',
      icon: Icons.video_library_rounded,
      emptyIcon: Icons.videocam_off_rounded,
      color: Colors.green,
    ),
    _ProviderSpec(
      kind: _ProviderKind.bilibili,
      label: 'Bilibili',
      tabLabel: 'Bilibili',
      icon: Icons.tv_rounded,
      emptyIcon: Icons.live_tv_rounded,
      color: Color(0xFFFB7299),
    ),
  ];

  late TabController _tabController;
  final Map<_ProviderKind, List<_ProviderBindItem>> _binds = {
    for (final provider in _ProviderKind.values) provider: [],
  };
  final Map<_ProviderKind, bool> _loading = {
    for (final provider in _ProviderKind.values) provider: true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _providers.length,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, _providers.length - 1),
    );
    for (final provider in _providers) {
      _loadBinds(provider.kind);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBinds(_ProviderKind kind, {bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) setState(() => _loading[kind] = true);
    try {
      final list = switch (kind) {
        _ProviderKind.alist =>
          (await SyncTvService.getAllAlistBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.host.isNotEmpty ? bind.host : bind.username,
                  subtitle: bind.username,
                ),
              )
              .toList(),
        _ProviderKind.emby =>
          (await SyncTvService.getAllEmbyBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.host,
                  subtitle: bind.userId,
                ),
              )
              .toList(),
        _ProviderKind.cloudreve =>
          (await SyncTvService.getAllCloudreveBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.host,
                  subtitle: bind.email,
                ),
              )
              .toList(),
        _ProviderKind.bilibili =>
          (await SyncTvService.getAllBilibiliBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: context.l10n.bilibiliBound,
                  subtitle: bind.id,
                ),
              )
              .toList(),
      };
      if (mounted) setState(() => _binds[kind] = list);
    } catch (e) {
      if (mounted && showLoading) {
        MessageUtils.showError(
          context,
          context.l10n.loadProviderBindingsFailed(_spec(kind).label, '$e'),
        );
      }
    } finally {
      if (mounted && showLoading) setState(() => _loading[kind] = false);
    }
  }

  Future<void> _unbind(_ProviderKind kind, _ProviderBindItem item) async {
    final provider = _spec(kind);
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.confirmUnbind,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text(context.l10n.confirmUnbindProvider(provider.label)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.unbind,
        ),
      ],
    );

    if (confirm != true) return;

    if (mounted) {
      setState(() {
        _binds[kind]?.removeWhere(
          (bind) =>
              bind.serverId == item.serverId &&
              bind.instanceName == item.instanceName,
        );
      });
    }

    try {
      switch (kind) {
        case _ProviderKind.alist:
          await SyncTvService.logoutAList(
            item.serverId,
            instanceName: item.instanceName,
          );
        case _ProviderKind.emby:
          await SyncTvService.logoutEmby(
            item.serverId,
            instanceName: item.instanceName,
          );
        case _ProviderKind.cloudreve:
          await SyncTvService.logoutCloudreve(
            item.serverId,
            instanceName: item.instanceName,
          );
        case _ProviderKind.bilibili:
          await SyncTvService.logoutBilibili(instanceName: item.instanceName);
      }
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.unboundSuccessfully);
      await _loadBinds(kind, showLoading: false);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.unbindFailed('$e'));
      await _loadBinds(kind, showLoading: false);
    }
  }

  void _showAdd(_ProviderKind kind) {
    final provider = _spec(kind);
    if (kind == _ProviderKind.bilibili) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Bilibili'),
        icon: const Icon(Icons.tv_rounded, color: Color(0xFFFB7299)),
        iconColor: const Color(0xFFFB7299),
        content: _BilibiliLoginDialog(
          instanceNamesLoader: () =>
              SyncTvService.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }

    _showProviderFormDialog(
      context: context,
      title: context.l10n.bindProvider(provider.label),
      icon: Icon(provider.icon, color: provider.color),
      iconColor: provider.color,
      content: _PasswordAccountDialog(
        kind: kind,
        instanceNamesLoader: () => SyncTvService.listAvailableProviderInstances(
          providerType: _providerType(kind),
        ),
        onSuccess: () => _loadBinds(kind, showLoading: false),
      ),
    );
  }

  Future<void> _showProviderFormDialog({
    required BuildContext context,
    required String title,
    required Icon icon,
    required Color iconColor,
    required Widget content,
  }) {
    return showAppDialog<void>(
      context: context,
      builder: (dialogContext) {
        final size = MediaQuery.sizeOf(dialogContext);
        return AppDialogFrame(
          maxWidth: 520,
          maxHeight: size.height * 0.94,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: size.height * 0.94,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppDialogHeader(
                  title: Text(title),
                  icon: icon.icon ?? Icons.info_outline_rounded,
                  color: iconColor,
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 14),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showInfo(_ProviderKind kind, _ProviderBindItem item) async {
    try {
      final provider = _spec(kind);
      final rows = await _loadAccountRows(kind, item);
      if (!mounted) return;
      ChatUtils.showStyledDialog(
        context: context,
        title: context.l10n.providerDetails(provider.label),
        icon: Icon(provider.icon, color: provider.color),
        iconColor: provider.color,
        content: _AccountInfoView(rows: rows),
        actions: [
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context),
            text: context.l10n.close,
          ),
        ],
      );
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, context.l10n.loadDetailsFailed('$e'));
      }
    }
  }

  Future<List<(String, String)>> _loadAccountRows(
    _ProviderKind kind,
    _ProviderBindItem item,
  ) async {
    final l10n = context.l10n;
    switch (kind) {
      case _ProviderKind.alist:
        final info = await SyncTvService.getAlistAccount(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          (l10n.username, info.username),
          (l10n.rootDirectory, info.basePath),
          (l10n.server, item.serverId),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.emby:
        final info = await SyncTvService.getEmbyAccount(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          (l10n.username, info.name),
          (l10n.userId, info.id),
          (l10n.server, item.serverId),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.cloudreve:
        final info = await SyncTvService.getCloudreveAccount(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          (l10n.username, info.nickname),
          ('Email', info.email),
          (l10n.userId, info.id),
          (l10n.server, item.serverId),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.bilibili:
        final info = await SyncTvService.getBilibiliAccount(
          instanceName: item.instanceName,
        );
        return [
          (
            l10n.loginStatus,
            info.isLogin ? l10n.loggedIn : l10n.loggedOutStatus,
          ),
          (l10n.username, info.username),
          (l10n.bilibiliVip, info.isVip ? l10n.yes : l10n.no),
          (l10n.server, item.serverId),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
    }
  }

  String _providerType(_ProviderKind kind) {
    return switch (kind) {
      _ProviderKind.alist => 'alist',
      _ProviderKind.emby => 'emby',
      _ProviderKind.cloudreve => 'cloudreve',
      _ProviderKind.bilibili => 'bilibili',
    };
  }

  _ProviderSpec _spec(_ProviderKind kind) {
    return _providers.firstWhere((provider) => provider.kind == kind);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final availableHeight = AppMetrics.dialogMaxHeight(context, null) * 0.72;

    return SizedBox(
      height: availableHeight.clamp(460.0, 560.0),
      width: double.maxFinite,
      child: Column(
        children: [
          AppPanelSurface(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(4),
            child: AppTabBar(
              controller: _tabController,
              labelColor: isDark ? Colors.white : theme.primaryColor,
              unselectedLabelColor: theme.hintColor,
              indicator: appTabPillIndicator(
                borderRadius: BorderRadius.circular(6),
                color: theme.scaffoldBackgroundColor,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                for (final provider in _providers) Tab(text: provider.tabLabel),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AppTabBarView(
              controller: _tabController,
              children: [
                for (final provider in _providers)
                  _ProviderBindList(
                    provider: provider,
                    items: _binds[provider.kind] ?? const [],
                    isLoading: _loading[provider.kind] ?? true,
                    onAdd: () => _showAdd(provider.kind),
                    onInfo: (item) => _showInfo(provider.kind, item),
                    onUnbind: (item) => _unbind(provider.kind, item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSpec {
  final _ProviderKind kind;
  final String label;
  final String tabLabel;
  final IconData icon;
  final IconData emptyIcon;
  final Color color;

  const _ProviderSpec({
    required this.kind,
    required this.label,
    required this.tabLabel,
    required this.icon,
    required this.emptyIcon,
    required this.color,
  });
}

class _ProviderBindItem {
  final String id;
  final String serverId;
  final String instanceName;
  final String title;
  final String subtitle;

  const _ProviderBindItem({
    required this.id,
    required this.serverId,
    required this.instanceName,
    required this.title,
    required this.subtitle,
  });
}

class _ProviderBindList extends StatelessWidget {
  final _ProviderSpec provider;
  final List<_ProviderBindItem> items;
  final bool isLoading;
  final ValueChanged<_ProviderBindItem> onUnbind;
  final ValueChanged<_ProviderBindItem> onInfo;
  final VoidCallback onAdd;

  const _ProviderBindList({
    required this.provider,
    required this.items,
    required this.isLoading,
    required this.onUnbind,
    required this.onInfo,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppLoadingIndicator();
    final theme = Theme.of(context);
    if (provider.kind == _ProviderKind.bilibili) {
      final item = items.firstOrNull;
      return _BilibiliSingleBindView(
        provider: provider,
        item: item,
        onBind: onAdd,
        onInfo: item == null ? null : () => onInfo(item),
        onUnbind: item == null ? null : () => onUnbind(item),
      );
    }

    return Column(
      children: [
        Expanded(
          child: items.isEmpty
              ? AppEmptyMessage(
                  icon: provider.emptyIcon,
                  message: provider.kind == _ProviderKind.bilibili
                      ? context.l10n.bilibiliNotBound
                      : context.l10n.noBoundProviderAccounts(provider.label),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final serverId = item.serverId.isNotEmpty
                        ? item.serverId
                        : item.id;
                    final title = _itemTitle(context, item, serverId);
                    final instanceLabel = _providerInstanceLabel(
                      item.instanceName,
                      context.l10n.localInstance,
                    );
                    return AppPanelSurface(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.72,
                        ),
                      ),
                      child: Row(
                        children: [
                          AppIconBadge(
                            icon: provider.icon,
                            color: provider.color,
                            size: 42,
                            backgroundAlpha: 0.12,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _ProviderTinyChip(
                                      icon: Icons.account_tree_rounded,
                                      label: instanceLabel,
                                      color: provider.color,
                                    ),
                                    _ProviderTinyChip(
                                      icon: Icons.tag_rounded,
                                      label: serverId,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppIconButton(
                            icon: Icons.info_outline,
                            onPressed: () => onInfo(item),
                            tooltip: context.l10n.details,
                            style: AppIconButtonStyle.tonal,
                          ),
                          const SizedBox(width: 4),
                          AppIconButton(
                            icon: Icons.link_off_rounded,
                            onPressed: () => onUnbind(item),
                            tooltip: context.l10n.unbind,
                            style: AppIconButtonStyle.destructive,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: onAdd,
              icon: provider.kind == _ProviderKind.bilibili
                  ? Icons.link_rounded
                  : Icons.add_rounded,
              label: items.isEmpty
                  ? context.l10n.bindProvider(provider.label)
                  : context.l10n.rebindProvider(provider.label),
              style: AppActionButtonStyle.tonal,
            ),
          ),
        ),
      ],
    );
  }

  String _itemTitle(
    BuildContext context,
    _ProviderBindItem item,
    String serverId,
  ) {
    if (item.title.isNotEmpty) return item.title;
    if (item.subtitle.isNotEmpty) return item.subtitle;
    return context.l10n.providerAccount(provider.label, serverId);
  }
}

class _BilibiliSingleBindView extends StatelessWidget {
  final _ProviderSpec provider;
  final _ProviderBindItem? item;
  final VoidCallback onBind;
  final VoidCallback? onInfo;
  final VoidCallback? onUnbind;

  const _BilibiliSingleBindView({
    required this.provider,
    required this.item,
    required this.onBind,
    required this.onInfo,
    required this.onUnbind,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bound = item != null;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AppPanelSurface(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: provider.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: provider.color.withValues(alpha: 0.2)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIconBadge(
                        icon: provider.icon,
                        color: provider.color,
                        size: 46,
                        backgroundAlpha: 0.14,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bound
                                  ? context.l10n.bilibiliBound
                                  : context.l10n.bindProvider('Bilibili'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bound
                                  ? context.l10n.bilibiliBoundDescription
                                  : context.l10n.bilibiliBindingDescription,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (bound) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ProviderTinyChip(
                          icon: Icons.account_tree_rounded,
                          label: _providerInstanceLabel(
                            item!.instanceName,
                            context.l10n.localInstance,
                          ),
                          color: provider.color,
                        ),
                        if (item!.serverId.isNotEmpty)
                          _ProviderTinyChip(
                            icon: Icons.tag_rounded,
                            label: item!.serverId,
                            color: theme.colorScheme.secondary,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            if (bound) ...[
              Expanded(
                child: AppActionButton(
                  onPressed: onInfo,
                  icon: Icons.info_outline_rounded,
                  label: context.l10n.viewStatus,
                  style: AppActionButtonStyle.outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppActionButton(
                  onPressed: onBind,
                  icon: Icons.sync_rounded,
                  label: context.l10n.rebind,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppActionButton(
                  onPressed: onUnbind,
                  icon: Icons.link_off_rounded,
                  label: context.l10n.unbind,
                  style: AppActionButtonStyle.tonal,
                ),
              ),
            ] else
              Expanded(
                child: AppActionButton(
                  onPressed: onBind,
                  icon: Icons.link_rounded,
                  label: context.l10n.bindProvider('Bilibili'),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ProviderTinyChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ProviderTinyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(999),
      icon: icon,
      iconSize: 13,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      textStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _PasswordAccountDialog extends StatefulWidget {
  final _ProviderKind kind;
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  const _PasswordAccountDialog({
    required this.kind,
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  @override
  State<_PasswordAccountDialog> createState() => _PasswordAccountDialogState();
}

class _PasswordAccountDialogState extends State<_PasswordAccountDialog> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secretController = TextEditingController();
  final _otpCodeController = TextEditingController();
  final _otpSecretController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _useApiKey = false;
  bool _loadingInstances = true;
  bool _isLoading = false;

  bool get _isAlist => widget.kind == _ProviderKind.alist;
  bool get _isEmby => widget.kind == _ProviderKind.emby;
  bool get _isCloudreve => widget.kind == _ProviderKind.cloudreve;
  String get _label => switch (widget.kind) {
    _ProviderKind.alist => 'AList',
    _ProviderKind.cloudreve => 'Cloudreve',
    _ProviderKind.emby => 'Emby',
    _ProviderKind.bilibili => 'Bilibili',
  };

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretController.dispose();
    _otpCodeController.dispose();
    _otpSecretController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final remoteInstances = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      MessageUtils.showError(
        context,
        context.l10n.loadMediaSourceInstancesFailed('$e'),
      );
    }
  }

  Future<void> _submit() async {
    final host = _normalizeProviderHost(
      _hostController.text,
      port: _portController.text,
    );
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final apiKey = _secretController.text.trim();
    final otpCode = _otpCodeController.text.trim();
    final otpSecret = _otpSecretController.text.trim();

    if (host.isEmpty ||
        username.isEmpty ||
        (_isEmby && _useApiKey ? apiKey.isEmpty : password.isEmpty)) {
      MessageUtils.showError(context, context.l10n.completeAllFields);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isAlist) {
        await SyncTvService.loginAList(
          host,
          username,
          _hashAlistPassword(password),
          otpCode: otpCode,
          otpSecret: otpSecret,
          instanceName: _instanceName,
        );
      } else if (_isCloudreve) {
        await SyncTvService.loginCloudreve(
          host,
          username,
          password,
          instanceName: _instanceName,
        );
      } else {
        await SyncTvService.loginEmbyInfo(
          host,
          username,
          password,
          apiKey: _useApiKey ? apiKey : '',
          instanceName: _instanceName,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
      MessageUtils.showSuccess(context, context.l10n.boundSuccessfully);
      widget.onSuccess();
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, context.l10n.bindingFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _normalizeProviderHost(String value, {String port = ''}) {
    final normalizedUrl = DirectUrlSourceConfig.normalizeUrlInput(value);
    final normalized = switch (normalizedUrl) {
      final value when !value.contains('://') && value.isNotEmpty =>
        'http://$value',
      _ => normalizedUrl,
    };
    final parsed = Uri.tryParse(normalized);
    final trimmedPort = port.trim();
    if (trimmedPort.isEmpty || parsed == null || parsed.hasPort) {
      return normalized;
    }
    return parsed.replace(port: int.tryParse(trimmedPort)).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providerColor = _isAlist
        ? Colors.amber
        : _isCloudreve
        ? Colors.teal
        : Colors.green;
    final availableHeight = AppMetrics.dialogMaxHeight(context, null);
    final maxHeight = (availableHeight * 0.70).clamp(
      420.0,
      _isAlist ? 540.0 : 500.0,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AppSingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isAlist)
                    _ProviderNotice(
                      icon: Icons.warning_amber_rounded,
                      text: context.l10n.alistVersionRequirement,
                      color: Colors.amber,
                    ),
                  _ProviderFormSection(
                    icon: Icons.hub_outlined,
                    title: context.l10n.connectionTarget,
                    color: providerColor,
                    children: [
                      _ProviderInstanceSelector(
                        instanceNames: _instanceNames,
                        selected: _instanceName,
                        loading: _loadingInstances,
                        onChanged: (value) =>
                            setState(() => _instanceName = value),
                      ),
                      const SizedBox(height: 12),
                      ChatUtils.createFormField(
                        context: context,
                        label: context.l10n.providerAddress(_label),
                        controller: _hostController,
                        hintText: context.l10n.providerAddressHint,
                        prefixIcon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                        enableSuggestions: false,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                      const SizedBox(height: 12),
                      ChatUtils.createFormField(
                        context: context,
                        label: context.l10n.port,
                        controller: _portController,
                        hintText: _isAlist
                            ? '5244'
                            : _isCloudreve
                            ? '5212'
                            : '8096',
                        prefixIcon: Icons.settings_ethernet_rounded,
                        keyboardType: TextInputType.number,
                        enableSuggestions: false,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ProviderFormSection(
                    icon: Icons.person_outline_rounded,
                    title: context.l10n.loginCredentials,
                    color: providerColor,
                    children: [
                      ChatUtils.createFormField(
                        context: context,
                        label: _isCloudreve ? 'Email' : context.l10n.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      if (_isEmby) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppSegmentedControl<bool>(
                            segments: [
                              ButtonSegment(
                                value: false,
                                icon: const Icon(Icons.lock_outline_rounded),
                                label: Text(context.l10n.password),
                              ),
                              const ButtonSegment(
                                value: true,
                                icon: Icon(Icons.key_rounded),
                                label: Text('API Key'),
                              ),
                            ],
                            value: _useApiKey,
                            onChanged: (selected) =>
                                setState(() => _useApiKey = selected),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_useApiKey)
                        ChatUtils.createFormField(
                          context: context,
                          label: 'API Key',
                          controller: _secretController,
                          prefixIcon: Icons.key_rounded,
                          obscureText: true,
                        )
                      else
                        ChatUtils.createFormField(
                          context: context,
                          label: context.l10n.password,
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                        ),
                    ],
                  ),
                  if (_isAlist) ...[
                    const SizedBox(height: 14),
                    _ProviderFormSection(
                      icon: Icons.shield_outlined,
                      title: context.l10n.twoFactorAuthentication,
                      color: theme.colorScheme.secondary,
                      children: [
                        ChatUtils.createFormField(
                          context: context,
                          label: context.l10n.oneTimeCode,
                          controller: _otpCodeController,
                          hintText: context.l10n.oneTimeCodeHint,
                          prefixIcon: Icons.pin_outlined,
                        ),
                        const SizedBox(height: 12),
                        ChatUtils.createFormField(
                          context: context,
                          label: 'TOTP Secret',
                          controller: _otpSecretController,
                          hintText: context.l10n.totpSecretHint,
                          prefixIcon: Icons.shield_outlined,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppDivider(
            height: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 2),
            child: _DialogActions(
              isLoading: _isLoading,
              onSubmit: _submit,
              submitText: context.l10n.login,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderNotice extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _ProviderNotice({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppInfoBanner(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      icon: icon,
      iconSize: 18,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      border: Border.all(color: color.withValues(alpha: 0.24)),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProviderFormSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<Widget> children;

  const _ProviderFormSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _BilibiliLoginDialog extends StatefulWidget {
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  const _BilibiliLoginDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  @override
  State<_BilibiliLoginDialog> createState() => _BilibiliLoginDialogState();
}

class _BilibiliLoginDialogState extends State<_BilibiliLoginDialog>
    with SingleTickerProviderStateMixin {
  Timer? _pollTimer;
  late final TabController _loginTabController;
  String _url = '';
  String _key = '';
  String _statusText = '';
  bool _isLoading = false;
  bool _checkingStatus = false;
  bool _isExpired = false;
  bool _qrStarted = false;
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;
  int _activeLoginTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loginTabController = TabController(length: 2, vsync: this);
    _loginTabController.addListener(_handleLoginTabChanged);
    _loadInstances();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _loginTabController
      ..removeListener(_handleLoginTabChanged)
      ..dispose();
    super.dispose();
  }

  void _handleLoginTabChanged() {
    final nextIndex = _loginTabController.index;
    if (nextIndex == _activeLoginTabIndex) return;
    _activeLoginTabIndex = nextIndex;
    if (nextIndex == 0) {
      if (!_qrStarted && !_loadingInstances) {
        _startLogin();
      } else {
        _resumeQrPolling();
      }
    } else {
      _pauseQrPolling();
    }
  }

  Future<void> _loadInstances() async {
    try {
      final remoteInstances = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
      if (_loginTabController.index == 0 && !_qrStarted) {
        await _startLogin();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingInstances = false;
        _statusText = context.l10n.loadMediaSourceInstancesFailed('$e');
        _isLoading = false;
      });
    }
  }

  Future<void> _startLogin() async {
    _pauseQrPolling();
    setState(() {
      _qrStarted = true;
      _url = '';
      _key = '';
      _statusText = context.l10n.creatingLoginLink;
      _isLoading = true;
      _isExpired = false;
    });

    try {
      final response = await SyncTvService.startBilibiliQrLogin(
        instanceName: _instanceName,
      );
      if (!mounted) return;
      setState(() {
        _url = response.url;
        _key = response.key;
        _statusText = context.l10n.completeBilibiliLogin;
        _isLoading = false;
      });
      _resumeQrPolling();
      await _checkStatus();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusText = context.l10n.createLoginLinkFailed('$e');
        _isLoading = false;
      });
    }
  }

  void _pauseQrPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void _resumeQrPolling() {
    if (!mounted ||
        _loginTabController.index != 0 ||
        _key.isEmpty ||
        _isExpired ||
        _pollTimer != null) {
      return;
    }
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkStatus(),
    );
  }

  Future<void> _checkStatus() async {
    if (_key.isEmpty ||
        _checkingStatus ||
        _loginTabController.index != 0 ||
        _isExpired) {
      return;
    }
    _checkingStatus = true;
    try {
      final status = await SyncTvService.checkBilibiliQrLogin(
        _key,
        instanceName: _instanceName,
      );
      if (!mounted) return;
      switch (status) {
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS:
          _pollTimer?.cancel();
          MessageUtils.showSuccess(context, context.l10n.boundSuccessfully);
          widget.onSuccess();
          Navigator.pop(context);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_EXPIRED:
          _pollTimer?.cancel();
          setState(() {
            _statusText = context.l10n.loginLinkExpired;
            _isExpired = true;
          });
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SCANNED:
          setState(() => _statusText = context.l10n.qrScannedConfirmLogin);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_NOT_SCANNED:
          setState(() => _statusText = context.l10n.waitingForQrScan);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_UNSPECIFIED:
          setState(() => _statusText = context.l10n.waitingForBilibiliStatus);
      }
    } catch (e) {
      if (!mounted) return;
      if (_isRateLimitError(e)) {
        _pollTimer?.cancel();
        setState(() => _statusText = context.l10n.bilibiliStatusRateLimited);
        return;
      }
      setState(() => _statusText = context.l10n.checkLoginStatusFailed('$e'));
    } finally {
      _checkingStatus = false;
    }
  }

  bool _isRateLimitError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('429') ||
        text.contains('too many requests') ||
        text.contains('rate limit');
  }

  Future<void> _openLoginUrl() async {
    if (_url.isEmpty) return;
    final uri = Uri.parse(_url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      MessageUtils.showError(context, context.l10n.openLoginLinkFailed);
    }
  }

  Future<void> _copyLoginUrl() async {
    if (_url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _url));
    if (mounted) {
      MessageUtils.showSuccess(context, context.l10n.loginLinkCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProviderInstanceSelector(
            instanceNames: _instanceNames,
            selected: _instanceName,
            loading: _loadingInstances,
            onChanged: (value) {
              if (value == _instanceName) return;
              _pauseQrPolling();
              setState(() {
                _instanceName = value;
                _qrStarted = false;
                _url = '';
                _key = '';
                _isExpired = false;
                _isLoading = false;
                _statusText = context.l10n.switchToQrPrompt;
              });
              if (_loginTabController.index == 0) _startLogin();
            },
          ),
          const SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppPanelSurface(
                height: 48,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                child: AppTabBar(
                  controller: _loginTabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      height: 48,
                      icon: const Icon(Icons.qr_code_2_rounded),
                      text: context.l10n.qrCode,
                    ),
                    Tab(
                      height: 48,
                      icon: const Icon(Icons.sms_rounded),
                      text: context.l10n.verificationCode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 374,
                child: AppTabBarView(
                  controller: _loginTabController,
                  children: [
                    _buildQrLogin(Theme.of(context)),
                    AnimatedBuilder(
                      animation: _loginTabController,
                      builder: (context, _) {
                        return _BilibiliSmsLoginPanel(
                          key: ValueKey(_instanceName),
                          instanceName: _instanceName,
                          active: _loginTabController.index == 1,
                          onSuccess: () {
                            MessageUtils.showSuccess(
                              context,
                              context.l10n.boundSuccessfully,
                            );
                            widget.onSuccess();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrLogin(ThemeData theme) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            padding: const EdgeInsets.all(10),
            icon: _isExpired ? Icons.refresh_rounded : Icons.qr_code_2_rounded,
            color: const Color(0xFFFB7299),
            backgroundColor: const Color(0xFFFB7299).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFFB7299).withValues(alpha: 0.2),
            ),
            iconSize: 22,
            title: Text(
              _statusText.isEmpty ? context.l10n.switchToQrPrompt : _statusText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          if (_url.isNotEmpty)
            AppPanelSurface(
              padding: const EdgeInsets.all(10),
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  AppPanelSurface(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: QrImageView(
                      data: _url,
                      version: QrVersions.auto,
                      size: 144,
                      gapless: false,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppSelectableText(
                    _url,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.copy_rounded,
                label: context.l10n.copyLink,
                onTap: _url.isEmpty ? null : _copyLoginUrl,
              ),
              _SecondaryActionButton(
                icon: Icons.open_in_new_rounded,
                label: context.l10n.openLogin,
                onTap: _url.isEmpty ? null : _openLoginUrl,
              ),
              if (_isExpired)
                _SecondaryActionButton(
                  icon: Icons.refresh_rounded,
                  label: context.l10n.regenerate,
                  onTap: _startLogin,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ChatUtils.createCancelButton(context),
          ),
        ],
      ),
    );
  }
}

class _BilibiliSmsLoginPanel extends StatefulWidget {
  final String instanceName;
  final bool active;
  final VoidCallback onSuccess;

  const _BilibiliSmsLoginPanel({
    super.key,
    required this.instanceName,
    required this.active,
    required this.onSuccess,
  });

  @override
  State<_BilibiliSmsLoginPanel> createState() => _BilibiliSmsLoginPanelState();
}

class _BilibiliSmsLoginPanelState extends State<_BilibiliSmsLoginPanel> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  BilibiliSmsLoginInfo? _session;
  String _statusText = '';
  bool _starting = false;
  bool _sending = false;
  bool _loggingIn = false;
  bool _smsSent = false;

  bool get _busy => _starting || _sending || _loggingIn;

  @override
  void initState() {
    super.initState();
    if (widget.active) _startSession();
  }

  @override
  void didUpdateWidget(covariant _BilibiliSmsLoginPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.instanceName != widget.instanceName) {
      setState(() {
        _smsSent = false;
        _session = null;
        _statusText = widget.active
            ? context.l10n.preparingSecurityVerification
            : context.l10n.switchToCodePrompt;
        _starting = widget.active;
        _sending = false;
        _loggingIn = false;
      });
      if (widget.active) _startSession();
      return;
    }
    if (!oldWidget.active && widget.active && _session == null && !_starting) {
      _startSession();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    setState(() {
      _starting = true;
      _smsSent = false;
      _session = null;
      _statusText = context.l10n.preparingSecurityVerification;
    });
    try {
      final session = await SyncTvService.startBilibiliSmsLogin(
        instanceName: widget.instanceName,
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _starting = false;
        _statusText = context.l10n.enterPhoneForSecurityVerification;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _statusText = context.l10n.prepareSecurityVerificationFailed('$e');
      });
    }
  }

  Future<void> _sendSms() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      MessageUtils.showWarning(context, context.l10n.enterPhoneNumber);
      return;
    }
    var session = _session;
    if (session == null) {
      await _startSession();
      if (!mounted) return;
      session = _session;
    }
    if (session == null) return;

    setState(() {
      _sending = true;
      _statusText = context.l10n.completeBilibiliSecurityVerification;
    });

    try {
      final result = await BilibiliGeetestService.verify(
        context,
        gt: session.gt,
        challenge: session.challenge,
      );
      final nextSession = await SyncTvService.sendBilibiliSms(
        session: session,
        phone: phone,
        validate: result.validate,
      );
      if (!mounted) return;
      setState(() {
        _session = nextSession;
        _sending = false;
        _smsSent = true;
        _statusText = context.l10n.smsCodeSent;
      });
    } catch (e) {
      if (!mounted) return;
      final expired = _isExpiredSessionError(e);
      setState(() {
        _sending = false;
        if (expired) {
          _session = null;
          _smsSent = false;
          _statusText = context.l10n.verificationSessionExpired;
        } else {
          _statusText = context.l10n.sendSmsFailed('$e');
        }
      });
    }
  }

  Future<void> _login() async {
    final session = _session;
    final code = _codeController.text.trim();
    if (session == null) {
      MessageUtils.showWarning(context, context.l10n.sendSmsFirst);
      return;
    }
    if (code.isEmpty) {
      MessageUtils.showWarning(context, context.l10n.enterSmsCode);
      return;
    }

    setState(() {
      _loggingIn = true;
      _statusText = context.l10n.completingBilibiliBinding;
    });
    try {
      await SyncTvService.loginBilibiliSms(
        sessionToken: session.sessionToken,
        code: code,
      );
      if (!mounted) return;
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      final expired = _isExpiredSessionError(e);
      setState(() {
        _loggingIn = false;
        if (expired) {
          _session = null;
          _smsSent = false;
          _statusText = context.l10n.loginSessionExpired;
        } else {
          _statusText = context.l10n.bindingFailed('$e');
        }
      });
    }
  }

  bool _isExpiredSessionError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('invalid or expired') ||
        text.contains('expired') ||
        text.contains('session');
  }

  @override
  Widget build(BuildContext context) {
    return AppSingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            padding: const EdgeInsets.all(10),
            icon: Icons.sms_rounded,
            color: const Color(0xFFFB7299),
            backgroundColor: const Color(0xFFFB7299).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFFB7299).withValues(alpha: 0.2),
            ),
            iconSize: 22,
            title: Text(
              _statusText.isEmpty
                  ? context.l10n.switchToCodePrompt
                  : _statusText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          ChatUtils.createFormField(
            context: context,
            label: context.l10n.phoneNumber,
            controller: _phoneController,
            hintText: context.l10n.bilibiliPhoneHint,
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          ChatUtils.createFormField(
            context: context,
            label: context.l10n.smsVerificationCode,
            controller: _codeController,
            hintText: _smsSent
                ? context.l10n.enterReceivedCode
                : context.l10n.enterCodeAfterSms,
            prefixIcon: Icons.pin_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.refresh_rounded,
                label: context.l10n.verifyAgain,
                onTap: _busy ? null : _startSession,
              ),
              _SecondaryActionButton(
                icon: Icons.send_to_mobile_rounded,
                label: context.l10n.sendSms,
                onTap: _busy ? null : _sendSms,
              ),
              AppActionButton(
                onPressed: _busy ? null : _login,
                icon: Icons.login_rounded,
                label: context.l10n.bind,
                loading: _loggingIn,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ChatUtils.createCancelButton(context),
          ),
        ],
      ),
    );
  }
}

class _ProviderInstanceSelector extends StatelessWidget {
  final List<String> instanceNames;
  final String selected;
  final bool loading;
  final ValueChanged<String> onChanged;

  const _ProviderInstanceSelector({
    required this.instanceNames,
    required this.selected,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final value = instanceNames.contains(selected)
        ? selected
        : (instanceNames.isEmpty ? '' : instanceNames.first);
    return AppSelect<String>(
      value: value,
      label: context.l10n.mediaSourceInstance,
      prefixIcon: loading ? null : Icons.account_tree_rounded,
      options: {
        for (final instanceName in instanceNames)
          _providerInstanceLabel(instanceName, context.l10n.localInstance):
              instanceName,
      },
      enabled: !loading,
      onChanged: loading ? null : (value) => onChanged(value ?? ''),
    );
  }
}

class _AccountInfoView extends StatelessWidget {
  final List<(String, String)> rows;

  const _AccountInfoView({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          _InfoRow(label: row.$1, value: row.$2),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: TextStyle(color: theme.hintColor)),
        ),
        Expanded(
          child: AppSelectableText(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _DialogActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitText;

  const _DialogActions({
    required this.isLoading,
    required this.onSubmit,
    required this.submitText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: AppLoadingIndicator(
                  size: AppLoadingSize.sm,
                  centered: false,
                ),
              )
            : ChatUtils.createConfirmButton(
                context,
                onSubmit,
                text: submitText,
              ),
      ],
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final theme = Theme.of(context);
    return AppInkSurface(
      color: enabled
          ? theme.primaryColor.withValues(alpha: 0.08)
          : theme.disabledColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: enabled ? theme.primaryColor : theme.disabledColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: enabled ? theme.primaryColor : theme.disabledColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
