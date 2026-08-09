import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<bool?> showServerSettingsDialog({
  required BuildContext context,
  bool requireServer = false,
  String initialAddress = '',
}) {
  return showAppBottomSheet<bool>(
    context: context,
    constraints: const BoxConstraints(maxWidth: 720),
    isDismissible: !requireServer,
    enableDrag: !requireServer,
    showDragHandle: !requireServer,
    builder: (context) => _ServerSettingsSheet(
      requireServer: requireServer,
      initialAddress: initialAddress,
    ),
  );
}

class _ServerSettingsSheet extends StatefulWidget {
  const _ServerSettingsSheet({
    required this.requireServer,
    required this.initialAddress,
  });

  final bool requireServer;
  final String initialAddress;

  @override
  State<_ServerSettingsSheet> createState() => _ServerSettingsSheetState();
}

class _ServerSettingsSheetState extends State<_ServerSettingsSheet> {
  ServerConnectionGateway get _gateway =>
      DependencyScope.read<ServerConnectionGateway>(context);

  final _controller = TextEditingController();
  var _changed = false;
  var _busy = false;
  var _allowInsecureTls = false;
  ServerInfo? _serverInfo;
  Object? _serverInfoError;
  var _loadingServerInfo = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialAddress;
    if (_gateway.activeServer == null) {
      _loadingServerInfo = false;
    } else {
      _loadServerInfo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadServerInfo({bool refresh = false}) async {
    setState(() {
      _loadingServerInfo = true;
      _serverInfoError = null;
    });
    try {
      final info = await _gateway.getServerInfo(refresh: refresh);
      if (!mounted) return;
      setState(() {
        _serverInfo = info;
        _loadingServerInfo = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _serverInfoError = error;
        _loadingServerInfo = false;
      });
    }
  }

  Future<void> _addServer() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.serverAddressRequired);
      return;
    }

    setState(() => _busy = true);
    try {
      final profile = await _gateway.addServer(
        input,
        allowInsecureTls: _allowInsecureTls,
      );
      await _gateway.syncServerTime(refresh: true);
      if (!mounted) return;
      await _loadServerInfo(refresh: true);
      _controller.clear();
      _allowInsecureTls = false;
      _changed = true;
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.serverConnected(profile.name),
        );
      }
      if (widget.requireServer && mounted) {
        Navigator.pop(context, true);
        return;
      }
      setState(() {});
    } on ServerConnectionException catch (error) {
      if (mounted) {
        AppNotifications.showError(context, error.message);
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.serverConnectFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _activateServer(ServerConnectionProfile profile) async {
    setState(() => _busy = true);
    try {
      await _gateway.activateServer(profile.endpoint);
      await _gateway.syncServerTime(refresh: true);
      await _loadServerInfo(refresh: true);
      _changed = true;
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.serverSwitched(profile.name),
        );
      }
      setState(() {});
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.serverSwitchFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _removeServer(ServerConnectionProfile profile) async {
    if (profile.isBuiltIn) {
      AppNotifications.showWarning(
        context,
        context.l10n.builtInServerCannotRemove,
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await _gateway.removeServer(profile.endpoint);
      _changed = true;
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.serverRemoved);
      }
      setState(() {});
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.serverRemoveFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final servers = _gateway.servers;
    final activeServer = _gateway.activeServer;

    return PopScope(
      canPop: !widget.requireServer || activeServer != null,
      child: AppBottomSheetFrame(
        child: AppSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.dns_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.server,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  AppActionButton(
                    onPressed: widget.requireServer && activeServer == null
                        ? null
                        : () => Navigator.pop(context, _changed),
                    label: l10n.done,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _CurrentServerInfoCard(
                info: _serverInfo,
                fallback: activeServer,
                loading: _loadingServerInfo,
                error: _serverInfoError,
                onRefresh: _busy || activeServer == null
                    ? null
                    : () => _loadServerInfo(refresh: true),
              ),
              const SizedBox(height: 16),
              AppDialogs.createFormField(
                context: context,
                label: l10n.serverAddress,
                controller: _controller,
                hintText: l10n.serverAddressExample,
                prefixIcon: Icons.link_rounded,
                onSubmitted: (_) => _busy ? null : _addServer(),
              ),
              const SizedBox(height: 10),
              AppPanelSurface(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.42,
                ),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.65,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _busy
                        ? null
                        : () => setState(
                            () => _allowInsecureTls = !_allowInsecureTls,
                          ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.gpp_maybe_outlined,
                            color: _allowInsecureTls
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.allowInsecureTls,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  l10n.allowInsecureTlsDescription,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Semantics(
                            label: l10n.allowInsecureTls,
                            toggled: _allowInsecureTls,
                            child: Switch.adaptive(
                              value: _allowInsecureTls,
                              onChanged: _busy
                                  ? null
                                  : (value) => setState(
                                      () => _allowInsecureTls = value,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.serverAutoDiscoverDescription,
                      style: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppActionButton(
                    onPressed: _busy ? null : _addServer,
                    icon: Icons.add_link_rounded,
                    label: l10n.add,
                    loading: _busy,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                l10n.savedServers,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              if (servers.isEmpty)
                _EmptyServerState(isDark: isDark)
              else
                ...servers.map(
                  (profile) => _ServerProfileTile(
                    profile: profile,
                    active: profile.endpoint == activeServer?.endpoint,
                    canRemove: !_busy && !profile.isBuiltIn,
                    busy: _busy,
                    onActivate: () => _activateServer(profile),
                    onRemove: () => _removeServer(profile),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyServerState extends StatelessWidget {
  const _EmptyServerState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppInfoBanner(
        icon: Icons.dns_outlined,
        title: Text(
          context.l10n.noSavedServers,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        padding: const EdgeInsets.all(16),
        backgroundColor: isDark
            ? Colors.white10
            : Colors.black.withValues(alpha: 0.04),
        border: Border.all(color: Colors.transparent),
      ),
    );
  }
}

class _CurrentServerInfoCard extends StatelessWidget {
  const _CurrentServerInfoCard({
    required this.info,
    required this.fallback,
    required this.loading,
    required this.error,
    required this.onRefresh,
  });

  final ServerInfo? info;
  final ServerConnectionProfile? fallback;
  final bool loading;
  final Object? error;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final serverName = (info?.serverName.trim().isNotEmpty ?? false)
        ? info!.serverName.trim()
        : fallback?.name ?? l10n.currentServer;
    final declaredServerId = (info?.serverId.trim().isNotEmpty ?? false)
        ? info!.serverId.trim()
        : fallback?.declaredServerId ?? '';
    final endpoint =
        fallback?.endpoint ??
        DependencyScope.read<ServerConnectionGateway>(context).serverBaseUrl;

    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: primary.withValues(alpha: isDark ? 0.16 : 0.09),
      border: Border.all(color: primary.withValues(alpha: 0.24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loading
              ? AppIconBadge(
                  icon: Icons.hub_rounded,
                  color: primary,
                  iconColor: Colors.transparent,
                  size: 34,
                  iconSize: 20,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  ),
                )
              : AppIconBadge(
                  icon: Icons.hub_rounded,
                  color: primary,
                  size: 34,
                  iconSize: 20,
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serverName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                if (declaredServerId.isNotEmpty) ...[
                  _MetaLine(
                    icon: Icons.fingerprint_rounded,
                    text: l10n.serverDeclaredId(declaredServerId),
                  ),
                  const SizedBox(height: 4),
                ],
                if (endpoint.isNotEmpty)
                  _MetaLine(
                    icon: Icons.radio_button_checked_rounded,
                    text: endpoint,
                  ),
                if (endpoint.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.serverAddressIdentityDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
                if (error != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.serverInfoFailed(error.toString()),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppIconButton(
            tooltip: l10n.refreshServerInfo,
            onPressed: loading ? null : onRefresh,
            icon: Icons.refresh_rounded,
            loading: loading,
          ),
        ],
      ),
    );
  }
}

class _ServerProfileTile extends StatelessWidget {
  const _ServerProfileTile({
    required this.profile,
    required this.active,
    required this.canRemove,
    required this.busy,
    required this.onActivate,
    required this.onRemove,
  });

  final ServerConnectionProfile profile;
  final bool active;
  final bool canRemove;
  final bool busy;
  final VoidCallback onActivate;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final background = active
        ? primary.withValues(alpha: isDark ? 0.18 : 0.10)
        : isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.035);

    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      color: background,
      border: Border.all(
        color: active ? primary.withValues(alpha: 0.45) : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                active ? Icons.check_circle_rounded : Icons.dns_outlined,
                size: 20,
                color: active
                    ? primary
                    : isDark
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (profile.isBuiltIn) ...[
                      const SizedBox(width: 8),
                      _ServerBadge(
                        label: l10n.builtInLabel,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
              if (!active)
                AppIconButton(
                  tooltip: l10n.switchServer,
                  onPressed: busy ? null : onActivate,
                  icon: Icons.login_rounded,
                ),
              if (!profile.isBuiltIn)
                AppIconButton(
                  tooltip: canRemove ? l10n.remove : l10n.processing,
                  onPressed: canRemove ? onRemove : null,
                  icon: Icons.delete_outline_rounded,
                  style: AppIconButtonStyle.destructive,
                ),
            ],
          ),
          const SizedBox(height: 8),
          _MetaLine(icon: Icons.link_rounded, text: profile.endpoint),
          if (profile.allowInsecureTls) ...[
            const SizedBox(height: 6),
            _MetaLine(icon: Icons.gpp_maybe_outlined, text: l10n.tlsUnverified),
          ],
          if (profile.declaredServerId.isNotEmpty) ...[
            const SizedBox(height: 6),
            _MetaLine(
              icon: Icons.fingerprint_rounded,
              text: l10n.serverDeclaredId(profile.declaredServerId),
            ),
          ],
        ],
      ),
    );
  }
}

class _ServerBadge extends StatelessWidget {
  const _ServerBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      borderRadius: BorderRadius.circular(999),
      color: color,
      backgroundColor: color.withValues(alpha: 0.12),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: AppSelectableText(
            text,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
