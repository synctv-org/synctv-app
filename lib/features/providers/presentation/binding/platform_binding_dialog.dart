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
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'binding_widgets.dart';
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
                  title: context.l10n.bilibiliBound,
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
      if (mounted) setState(() => _binds[kind] = list);
    } catch (e) {
      if (mounted && showLoading) {
        AppNotifications.showError(
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
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.confirmUnbind,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text(context.l10n.confirmUnbindProvider(provider.label)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
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
          await providerGateway.logoutAList(item.serverId);
        case _ProviderKind.emby:
          await providerGateway.logoutEmby(item.serverId);
        case _ProviderKind.cloudreve:
          await providerGateway.logoutCloudreve(item.serverId);
        case _ProviderKind.bilibili:
          await providerGateway.logoutBilibili();
        case _ProviderKind.twitch:
          await providerGateway.unbindTwitch(item.serverId);
        case _ProviderKind.fnos:
          await providerGateway.logoutFnos(item.serverId);
        case _ProviderKind.qnap:
          await providerGateway.logoutQnap(item.serverId);
        case _ProviderKind.synology:
          await providerGateway.logoutSynology(item.serverId);
        case _ProviderKind.nextcloud:
          await providerGateway.logoutNextcloud(item.serverId);
        case _ProviderKind.seafile:
          await providerGateway.logoutSeafile(item.serverId);
        case _ProviderKind.truenas:
          await providerGateway.logoutTrueNas(item.serverId);
        case _ProviderKind.youtube:
          await providerGateway.unbindYoutube(item.serverId);
        case _ProviderKind.douyin:
          await providerGateway.unbindDouyin(item.serverId);
        case _ProviderKind.tiktok:
          await providerGateway.unbindTikTok(item.serverId);
      }
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.unboundSuccessfully);
      await _loadBinds(kind, showLoading: false);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.unbindFailed('$e'));
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
      AppDialogs.showStyledDialog(
        context: context,
        title: context.l10n.providerDetails(provider.label),
        icon: Icon(provider.icon, color: provider.color),
        iconColor: provider.color,
        content: _AccountInfoView(rows: rows),
        actions: [
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.pop(context),
            text: context.l10n.close,
          ),
        ],
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.loadDetailsFailed('$e'),
        );
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
        final info = await providerGateway.getAlistAccount(
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
        final info = await providerGateway.getEmbyAccount(
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
        final info = await providerGateway.getCloudreveAccount(
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
        final info = await providerGateway.getBilibiliAccount(
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
      case _ProviderKind.twitch:
        return [
          (l10n.username, item.title),
          (l10n.userId, item.subtitle),
          (l10n.server, item.serverId),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.fnos:
        return [
          (l10n.server, item.title),
          (l10n.username, item.subtitle),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.qnap:
        final capabilities = await providerGateway.getQnapCapabilities(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          (l10n.server, item.title),
          (l10n.username, item.subtitle),
          (
            'Real-time transcoding',
            capabilities.supportRtt ? l10n.yes : l10n.no,
          ),
          (
            'Hardware transcoding',
            capabilities.hardwareTranscode ? l10n.yes : l10n.no,
          ),
          ('QTranscode', capabilities.qtranscode ? l10n.yes : l10n.no),
          (
            'Multimedia Codec',
            capabilities.multimediaCodec ? l10n.yes : l10n.no,
          ),
          ('HD Station', capabilities.hdStationSupport ? l10n.yes : l10n.no),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.synology:
        return [
          (l10n.server, item.title),
          (l10n.username, item.subtitle),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.nextcloud:
        final binds = await providerGateway.getAllNextcloudBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          (l10n.server, bind.endpoint),
          (l10n.username, bind.username),
          if (bind.userId.isNotEmpty) (l10n.userId, bind.userId),
          if (bind.version.isNotEmpty) ('Version', bind.version),
          if (bind.edition.isNotEmpty) ('Edition', bind.edition),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.seafile:
        final binds = await providerGateway.getAllSeafileBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          (l10n.server, bind.endpoint),
          (l10n.username, bind.username),
          if (bind.version.isNotEmpty) ('Version', bind.version),
          if (bind.features.isNotEmpty) ('Features', bind.features.join(', ')),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.truenas:
        final binds = await providerGateway.getAllTrueNasBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          (l10n.server, bind.endpoint),
          ('Hostname', bind.hostname),
          if (bind.version.isNotEmpty) ('Version', bind.version),
          if (bind.systemProduct.isNotEmpty) ('System', bind.systemProduct),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.youtube:
        final binds = await providerGateway.getAllYoutubeBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          ('Label', bind.label),
          ('Visitor Data', bind.hasVisitorData ? 'Configured' : 'Empty'),
          ('PO Token', bind.hasPoToken ? 'Configured' : 'Empty'),
          ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.douyin:
        final binds = await providerGateway.getAllDouyinBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          ('Label', bind.label),
          ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
      case _ProviderKind.tiktok:
        final binds = await providerGateway.getAllTikTokBindInfos();
        final bind = binds.firstWhere(
          (candidate) =>
              candidate.serverId == item.serverId &&
              candidate.providerInstanceName == item.instanceName,
        );
        return [
          ('Label', bind.label),
          ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
          (
            l10n.instance,
            _providerInstanceLabel(item.instanceName, l10n.localInstance),
          ),
        ];
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
