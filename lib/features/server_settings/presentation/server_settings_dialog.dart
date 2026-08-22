import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<bool?> showServerSettingsDialog({
  required BuildContext context,
  bool requireServer = false,
  String initialAddress = '',
  VoidCallback? onServerChanged,
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
      onServerChanged: onServerChanged,
    ),
  );
}

class _ServerSettingsSheet extends StatefulWidget {
  const _ServerSettingsSheet({
    required this.requireServer,
    required this.initialAddress,
    this.onServerChanged,
  });

  final bool requireServer;
  final String initialAddress;
  final VoidCallback? onServerChanged;

  @override
  State<_ServerSettingsSheet> createState() => _ServerSettingsSheetState();
}

class _ServerSettingsSheetState extends State<_ServerSettingsSheet> {
  static const _serverInfoTimeout = Duration(seconds: 8);

  ServerConnectionGateway get _gateway =>
      DependencyScope.read<ServerConnectionGateway>(context);

  var _changed = false;
  var _busy = false;
  ServerInfo? _serverInfo;
  Object? _serverInfoError;
  var _loadingServerInfo = true;
  var _serverInfoRequestRevision = 0;

  @override
  void initState() {
    super.initState();
    if (_gateway.activeServer == null) {
      _loadingServerInfo = false;
    } else {
      _loadServerInfo();
    }
  }

  @override
  void dispose() {
    _serverInfoRequestRevision++;
    super.dispose();
  }

  Future<void> _loadServerInfo({bool refresh = false}) async {
    final endpoint = _gateway.activeServer?.endpoint;
    if (endpoint == null) {
      if (mounted) {
        setState(() {
          _serverInfo = null;
          _serverInfoError = null;
          _loadingServerInfo = false;
        });
      }
      return;
    }
    final requestRevision = ++_serverInfoRequestRevision;
    setState(() {
      _serverInfo = null;
      _loadingServerInfo = true;
      _serverInfoError = null;
    });
    try {
      final info = await _gateway
          .getServerInfo(refresh: refresh)
          .timeout(_serverInfoTimeout);
      if (!_isCurrentServerInfoRequest(requestRevision, endpoint)) return;
      setState(() {
        _serverInfo = info;
        _loadingServerInfo = false;
      });
    } catch (error) {
      if (!_isCurrentServerInfoRequest(requestRevision, endpoint)) return;
      setState(() {
        _serverInfoError = error;
        _loadingServerInfo = false;
      });
    }
  }

  bool _isCurrentServerInfoRequest(int revision, String endpoint) =>
      mounted &&
      revision == _serverInfoRequestRevision &&
      _gateway.activeServer?.endpoint == endpoint;

  void _refreshActiveServerMetadata() {
    unawaited(_loadServerInfo(refresh: true));
    unawaited(_syncServerTime());
  }

  Future<void> _syncServerTime() async {
    try {
      await _gateway.syncServerTime(refresh: true);
    } catch (error) {
      debugPrint('Failed to synchronize server time: $error');
    }
  }

  Future<void> _openAddServerDialog() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final profile = await showAppDialog<ServerConnectionProfile>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _AddServerDialog(initialAddress: widget.initialAddress),
      );
      if (!mounted || profile == null) return;

      _changed = true;
      widget.onServerChanged?.call();
      AppNotifications.showSuccess(
        context,
        context.l10n.serverConnected(profile.name),
      );
      unawaited(_syncServerTime());
      if (widget.requireServer) {
        Navigator.pop(context, true);
      } else {
        unawaited(_loadServerInfo(refresh: true));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _activateServer(ServerConnectionProfile profile) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await _gateway.activateServer(profile.endpoint);
      if (!mounted) return;
      _changed = true;
      widget.onServerChanged?.call();
      AppNotifications.showSuccess(
        context,
        context.l10n.serverSwitched(profile.name),
      );
      setState(() => _busy = false);
      _refreshActiveServerMetadata();
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.serverSwitchFailed(error.toString()),
        );
      }
    } finally {
      if (mounted && _busy) {
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
      if (!mounted) return;
      _changed = true;
      widget.onServerChanged?.call();
      AppNotifications.showSuccess(context, context.l10n.serverRemoved);
      setState(() => _busy = false);
      if (_gateway.activeServer != null) {
        _refreshActiveServerMetadata();
      } else {
        _serverInfoRequestRevision++;
        setState(() {
          _serverInfo = null;
          _serverInfoError = null;
          _loadingServerInfo = false;
        });
      }
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
                  if (!kIsWeb) ...[
                    Flexible(
                      child: AppActionButton(
                        onPressed: _busy ? null : _openAddServerDialog,
                        icon: Icons.add_link_rounded,
                        label: l10n.addServer,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: AppActionButton(
                      onPressed: widget.requireServer && activeServer == null
                          ? null
                          : () => Navigator.pop(context, _changed),
                      label: l10n.done,
                    ),
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
              if (!kIsWeb) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

class _AddServerDialog extends StatefulWidget {
  const _AddServerDialog({required this.initialAddress});

  final String initialAddress;

  @override
  State<_AddServerDialog> createState() => _AddServerDialogState();
}

class _AddServerDialogState extends State<_AddServerDialog> {
  ServerConnectionGateway get _gateway =>
      DependencyScope.read<ServerConnectionGateway>(context);

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  var _busy = false;
  var _allowInsecureTls = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAddress);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
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
      if (mounted) Navigator.pop(context, profile);
    } on ServerConnectionException catch (error) {
      if (mounted) AppNotifications.showError(context, error.message);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.serverConnectFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return PopScope(
      canPop: !_busy,
      child: AppDialogFrame(
        maxWidth: 520,
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter, meta: true):
                _SubmitAddServerIntent(),
            SingleActivator(LogicalKeyboardKey.enter, control: true):
                _SubmitAddServerIntent(),
          },
          child: Actions(
            actions: {
              _SubmitAddServerIntent: CallbackAction<_SubmitAddServerIntent>(
                onInvoke: (_) {
                  _submit();
                  return null;
                },
              ),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppDialogHeader(
                  title: Text(l10n.addServer),
                  icon: Icons.add_link_rounded,
                  onClose: _busy ? null : () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: l10n.serverAddress,
                        controller: _controller,
                        focusNode: _focusNode,
                        hintText: l10n.serverAddressExample,
                        prefixIcon: Icons.link_rounded,
                        enabled: !_busy,
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 14),
                      AppPanelSurface(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.42),
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
                                    () =>
                                        _allowInsecureTls = !_allowInsecureTls,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.allowInsecureTls,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          l10n.allowInsecureTlsDescription,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppActionButton(
                            onPressed: _busy
                                ? null
                                : () => Navigator.pop(context),
                            label: l10n.cancel,
                          ),
                          const SizedBox(width: 8),
                          AppActionButton(
                            onPressed: _busy ? null : _submit,
                            icon: Icons.add_link_rounded,
                            label: l10n.add,
                            loading: _busy,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _SubmitAddServerIntent extends Intent {
  const _SubmitAddServerIntent();
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
