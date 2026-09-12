import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/binding/bilibili_geetest_flow.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/provider_instance_options.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'binding_widgets.dart';
part 'bilibili_sms_login_panel.dart';
part 'bilibili_binding_view.dart';
part 'provider_bind_list.dart';
part 'provider_account_info_dialog.dart';
part 'provider_unbind_dialog.dart';
part 'nextcloud_account_dialog.dart';
part 'oauth_binding_forms.dart';
part 'server_account_dialogs.dart';

enum _ProviderKind {
  alist,
  cloudreve,
  emby,
  bilibili,
  twitch,
  fnos,
  qnap,
  synology,
  nextcloud,
  seafile,
  truenas,
  youtube,
  douyin,
  tiktok,
}

enum _EmbyCredentialMode { password, apiKey, passwordless }

String _providerKindType(_ProviderKind kind) {
  return switch (kind) {
    _ProviderKind.alist => 'alist',
    _ProviderKind.emby => 'emby',
    _ProviderKind.cloudreve => 'cloudreve',
    _ProviderKind.bilibili => 'bilibili',
    _ProviderKind.twitch => 'twitch',
    _ProviderKind.fnos => 'fnos',
    _ProviderKind.qnap => 'qnap',
    _ProviderKind.synology => 'synology',
    _ProviderKind.nextcloud => 'nextcloud',
    _ProviderKind.seafile => 'seafile',
    _ProviderKind.truenas => 'truenas',
    _ProviderKind.youtube => 'youtube',
    _ProviderKind.douyin => 'douyin',
    _ProviderKind.tiktok => 'tiktok',
  };
}

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
  final String? initialProviderType;
  final ProviderDistributionPolicy distributionPolicy;

  const PlatformBindingDialog({
    super.key,
    this.initialIndex = 0,
    this.initialProviderType,
    this.distributionPolicy = ProviderDistributionPolicy.current,
  });

  static Future<void> show(
    BuildContext context, {
    int initialIndex = 0,
    String? initialProviderType,
  }) {
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
                title: Text(dialogContext.l10n.manageConnections),
                icon: Icons.link_rounded,
                color: accent,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  child: PlatformBindingDialog(
                    initialIndex: initialIndex,
                    initialProviderType: initialProviderType,
                  ),
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
  static const _allProviders = [
    _ProviderSpec(
      kind: _ProviderKind.alist,
      label: 'AList',
      tabLabel: 'AList',
      emptyIcon: Icons.cloud_off_rounded,
    ),
    _ProviderSpec(
      kind: _ProviderKind.cloudreve,
      label: 'Cloudreve',
      tabLabel: 'Cloudreve',
      emptyIcon: Icons.cloud_off_rounded,
    ),
    _ProviderSpec(
      kind: _ProviderKind.emby,
      label: 'Emby',
      tabLabel: 'Emby',
      emptyIcon: Icons.videocam_off_rounded,
    ),
    _ProviderSpec(
      kind: _ProviderKind.bilibili,
      label: 'Bilibili',
      tabLabel: 'Bilibili',
      emptyIcon: Icons.live_tv_rounded,
    ),
    _ProviderSpec(
      kind: _ProviderKind.twitch,
      label: 'Twitch',
      tabLabel: 'Twitch',
      emptyIcon: Icons.live_tv_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.fnos,
      label: 'FNOS',
      tabLabel: 'FNOS',
      emptyIcon: Icons.storage_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.qnap,
      label: 'QNAP',
      tabLabel: 'QNAP',
      emptyIcon: Icons.storage_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.synology,
      label: 'Synology DSM',
      tabLabel: 'Synology',
      emptyIcon: Icons.storage_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.nextcloud,
      label: 'Nextcloud',
      tabLabel: 'Nextcloud',
      emptyIcon: Icons.cloud_off_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.seafile,
      label: 'Seafile',
      tabLabel: 'Seafile',
      emptyIcon: Icons.cloud_off_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.truenas,
      label: 'TrueNAS',
      tabLabel: 'TrueNAS',
      emptyIcon: Icons.storage_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.youtube,
      label: 'YouTube',
      tabLabel: 'YouTube',
      emptyIcon: Icons.smart_display_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.douyin,
      label: 'Douyin',
      tabLabel: 'Douyin',
      emptyIcon: Icons.music_video_outlined,
    ),
    _ProviderSpec(
      kind: _ProviderKind.tiktok,
      label: 'TikTok',
      tabLabel: 'TikTok',
      emptyIcon: Icons.music_video_outlined,
    ),
  ];

  List<_ProviderSpec> get _providers => _allProviders
      .where(
        (provider) => widget.distributionPolicy.allowsProvider(
          _providerKindType(provider.kind),
        ),
      )
      .toList(growable: false);

  late TabController _tabController;
  final Map<_ProviderKind, List<_ProviderBindItem>> _binds = {
    for (final provider in _ProviderKind.values) provider: [],
  };
  final Map<_ProviderKind, bool> _loading = {
    for (final provider in _ProviderKind.values) provider: true,
  };
  final Map<_ProviderKind, int> _loadGenerations = {};
  final Map<_ProviderKind, String> _loadErrors = {};
  final Set<_ProviderKind> _refreshing = {};
  bool _bindingsInitialized = false;
  bool _showingInfo = false;
  final Map<_ProviderKind, _ProviderUnbindPhase> _unbinding = {};

  @override
  void initState() {
    super.initState();
    final requestedProviderIndex = widget.initialProviderType == null
        ? widget.initialIndex
        : _providers.indexWhere(
            (provider) =>
                _providerKindType(provider.kind) == widget.initialProviderType,
          );
    _tabController = TabController(
      length: _providers.length,
      vsync: this,
      initialIndex: (requestedProviderIndex < 0 ? 0 : requestedProviderIndex)
          .clamp(0, _providers.length - 1),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bindingsInitialized) return;
    _bindingsInitialized = true;
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
    final loadGeneration = (_loadGenerations[kind] ?? 0) + 1;
    _loadGenerations[kind] = loadGeneration;
    final l10n = context.l10n;
    setState(() {
      _loading[kind] = showLoading;
      if (showLoading) {
        _refreshing.remove(kind);
      } else {
        _refreshing.add(kind);
      }
      _loadErrors.remove(kind);
    });
    try {
      final list = switch (kind) {
        _ProviderKind.alist =>
          (await providerGateway.getAllAlistBindInfos())
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
          (await providerGateway.getAllEmbyBindInfos())
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
          (await providerGateway.getAllCloudreveBindInfos())
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
          (await providerGateway.getAllBilibiliBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: l10n.bilibiliBound,
                  subtitle: bind.id,
                ),
              )
              .toList(),
        _ProviderKind.twitch =>
          (await providerGateway.getAllTwitchBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.login,
                  subtitle: [
                    bind.twitchUserId,
                    if (bind.scopes.isNotEmpty) bind.scopes.join(', '),
                  ].join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.fnos =>
          (await providerGateway.getAllFnosBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.endpoint,
                  subtitle: bind.mediaAvailable
                      ? '${bind.username} · Media'
                      : bind.username,
                ),
              )
              .toList(),
        _ProviderKind.qnap =>
          (await providerGateway.getAllQnapBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.serverName.isEmpty
                      ? bind.endpoint
                      : bind.serverName,
                  subtitle: [
                    bind.username,
                    if (bind.version.isNotEmpty) bind.version,
                    if (bind.supportRtt) 'RTT',
                  ].join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.synology =>
          (await providerGateway.getAllSynologyBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.endpoint,
                  subtitle: bind.videoStationAvailable
                      ? '${bind.username} · Video Station'
                      : bind.username,
                ),
              )
              .toList(),
        _ProviderKind.nextcloud =>
          (await providerGateway.getAllNextcloudBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.endpoint,
                  subtitle: [
                    bind.username,
                    if (bind.version.isNotEmpty) bind.version,
                    if (bind.edition.isNotEmpty) bind.edition,
                  ].where((value) => value.isNotEmpty).join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.seafile =>
          (await providerGateway.getAllSeafileBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.endpoint,
                  subtitle: [
                    bind.username,
                    if (bind.version.isNotEmpty) bind.version,
                  ].join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.truenas =>
          (await providerGateway.getAllTrueNasBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.endpoint,
                  subtitle: [
                    bind.hostname,
                    if (bind.version.isNotEmpty) bind.version,
                  ].join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.youtube =>
          (await providerGateway.getAllYoutubeBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.label,
                  subtitle: [
                    if (bind.hasVisitorData) 'Visitor Data',
                    if (bind.hasPoToken) 'PO Token',
                    if (bind.hasCookie) 'Cookie',
                  ].join(' · '),
                ),
              )
              .toList(),
        _ProviderKind.douyin =>
          (await providerGateway.getAllDouyinBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.label,
                  subtitle: bind.hasCookie ? 'Cookie configured' : 'Cookie',
                ),
              )
              .toList(),
        _ProviderKind.tiktok =>
          (await providerGateway.getAllTikTokBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.label,
                  subtitle: bind.hasCookie ? 'Cookie configured' : 'Cookie',
                ),
              )
              .toList(),
      };
      if (mounted && _loadGenerations[kind] == loadGeneration) {
        setState(() {
          _binds[kind] = list;
          _loadErrors.remove(kind);
        });
      }
    } catch (e) {
      if (mounted && _loadGenerations[kind] == loadGeneration) {
        setState(() => _loadErrors[kind] = '$e');
      }
    } finally {
      if (mounted && _loadGenerations[kind] == loadGeneration) {
        setState(() {
          _loading[kind] = false;
          _refreshing.remove(kind);
        });
      }
    }
  }

  bool _isCurrentProvider(_ProviderKind kind) =>
      mounted &&
      ModalRoute.of(context)?.isCurrent == true &&
      _providers[_tabController.index].kind == kind;

  bool _canUseBindings(_ProviderKind kind) =>
      _isCurrentProvider(kind) &&
      _loading[kind] != true &&
      !_refreshing.contains(kind) &&
      !_loadErrors.containsKey(kind) &&
      !_unbinding.containsKey(kind);

  // Account callbacks belong to the exact loaded snapshot, including its labels.
  bool _hasCurrentBinding(_ProviderKind kind, _ProviderBindItem item) =>
      _binds[kind]?.contains(item) ?? false;

  void _retryBindings(_ProviderKind kind) {
    if (!_isCurrentProvider(kind) ||
        _loading[kind] == true ||
        _refreshing.contains(kind) ||
        !_loadErrors.containsKey(kind)) {
      return;
    }
    _loadBinds(kind);
  }

  Future<void> _unbind(_ProviderKind kind, _ProviderBindItem item) async {
    if (!_canUseBindings(kind) || !_hasCurrentBinding(kind, item)) return;
    final gateway = providerGateway;
    setState(() => _unbinding[kind] = _ProviderUnbindPhase.confirming);
    try {
      final confirmed = await _confirmProviderUnbind(
        context,
        _spec(kind).label,
        item,
      );
      if (confirmed != true || !_isCurrentProvider(kind)) return;
      if (!_hasCurrentBinding(kind, item)) return;
      setState(() => _unbinding[kind] = _ProviderUnbindPhase.submitting);
      _loadGenerations[kind] = (_loadGenerations[kind] ?? 0) + 1;
      await _unbindProviderAccount(gateway, kind, item);
      if (!mounted) return;
      setState(() {
        _binds[kind]?.removeWhere(
          (bind) =>
              bind.serverId == item.serverId &&
              bind.instanceName == item.instanceName,
        );
      });
      if (_isCurrentProvider(kind)) {
        AppNotifications.showSuccess(context, context.l10n.unboundSuccessfully);
      }
      await _loadBinds(kind, showLoading: false);
    } catch (error) {
      if (!mounted) return;
      if (_isCurrentProvider(kind)) {
        AppNotifications.showError(
          context,
          context.l10n.unbindFailed('$error'),
        );
      }
      await _loadBinds(kind, showLoading: false);
    } finally {
      if (mounted) setState(() => _unbinding.remove(kind));
    }
  }

  void _showAdd(_ProviderKind kind) {
    if (!_canUseBindings(kind)) return;
    final provider = _spec(kind);
    if (kind == _ProviderKind.bilibili) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Bilibili'),
        icon: const Icon(Icons.tv_rounded, color: Color(0xFFFB7299)),
        iconColor: const Color(0xFFFB7299),
        content: _BilibiliLoginDialog(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.twitch) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Twitch'),
        icon: const Icon(Icons.live_tv_rounded, color: Color(0xFF9146FF)),
        iconColor: const Color(0xFF9146FF),
        content: TwitchAccountBindingForm(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.emby) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Emby'),
        icon: Icon(provider.icon, color: provider.color),
        iconColor: provider.color,
        content: EmbyAccountBindingForm(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.youtube) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('YouTube'),
        icon: const Icon(Icons.smart_display_rounded, color: Color(0xFFFF0033)),
        iconColor: const Color(0xFFFF0033),
        content: YoutubeAccountBindingForm(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.douyin) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Douyin'),
        icon: const Icon(Icons.music_video_rounded, color: Color(0xFF00D4C6)),
        iconColor: const Color(0xFF00D4C6),
        content: DouyinAccountBindingForm(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.tiktok) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('TikTok'),
        icon: const Icon(Icons.music_video_rounded, color: Color(0xFFFE2C55)),
        iconColor: const Color(0xFFFE2C55),
        content: TikTokAccountBindingForm(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.fnos) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('FNOS'),
        icon: const Icon(Icons.storage_rounded, color: Color(0xFF087F5B)),
        iconColor: const Color(0xFF087F5B),
        content: _FnosAccountDialog(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.qnap) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('QNAP'),
        icon: const Icon(Icons.storage_rounded, color: Color(0xFF0076A8)),
        iconColor: const Color(0xFF0076A8),
        content: _QnapAccountDialog(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.synology) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Synology DSM'),
        icon: const Icon(Icons.video_library_rounded, color: Color(0xFF1578D3)),
        iconColor: const Color(0xFF1578D3),
        content: _SynologyAccountDialog(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
                providerType: _providerType(kind),
              ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
      );
      return;
    }
    if (kind == _ProviderKind.nextcloud) {
      _showProviderFormDialog(
        context: context,
        title: context.l10n.bindProvider('Nextcloud'),
        icon: const Icon(Icons.cloud_outlined, color: Color(0xFF0082C9)),
        iconColor: const Color(0xFF0082C9),
        content: _NextcloudAccountDialog(
          instanceNamesLoader: () =>
              providerGateway.listAvailableProviderInstances(
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
        instanceNamesLoader: () => providerGateway
            .listAvailableProviderInstances(providerType: _providerType(kind)),
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
                  title: Text(
                    title,
                    style: Theme.of(dialogContext).textTheme.titleMedium,
                  ),
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
    if (!_canUseBindings(kind) ||
        !_hasCurrentBinding(kind, item) ||
        _showingInfo) {
      return;
    }
    final provider = _spec(kind);
    final gateway = providerGateway;
    final l10n = context.l10n;
    _showingInfo = true;
    try {
      await showAppDialog<void>(
        context: context,
        builder: (_) => _ProviderAccountInfoDialog(
          title: l10n.providerDetails(provider.label),
          loadRows: () => _loadProviderAccountRows(gateway, l10n, kind, item),
        ),
      );
    } finally {
      _showingInfo = false;
    }
  }

  String _providerType(_ProviderKind kind) {
    return _providerKindType(kind);
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
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 14),
              labelColor: isDark ? Colors.white : theme.primaryColor,
              unselectedLabelColor: theme.hintColor,
              indicator: appTabPillIndicator(
                borderRadius: BorderRadius.circular(6),
                color: theme.scaffoldBackgroundColor,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                for (final provider in _providers)
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          provider.icon,
                          key: ValueKey(
                            'binding-provider-icon-${_providerKindType(provider.kind)}',
                          ),
                          size: 16,
                          color: provider.color,
                        ),
                        const SizedBox(width: 7),
                        Text(provider.tabLabel),
                      ],
                    ),
                  ),
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
                    isRefreshing: _refreshing.contains(provider.kind),
                    error: _loadErrors[provider.kind],
                    onRetry: () => _retryBindings(provider.kind),
                    isUnbinding: _unbinding.containsKey(provider.kind),
                    isSubmitting:
                        _unbinding[provider.kind] ==
                        _ProviderUnbindPhase.submitting,
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
  final IconData emptyIcon;

  MediaProviderBrand get brand => mediaProviderBrand(_providerKindType(kind));
  IconData get icon => brand.icon;
  Color get color => brand.color;

  const _ProviderSpec({
    required this.kind,
    required this.label,
    required this.tabLabel,
    required this.emptyIcon,
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
