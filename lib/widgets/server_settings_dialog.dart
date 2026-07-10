import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

Future<bool?> showServerSettingsDialog({required BuildContext context}) {
  return showAppBottomSheet<bool>(
    context: context,
    constraints: const BoxConstraints(maxWidth: 720),
    builder: (context) => const _ServerSettingsSheet(),
  );
}

class _ServerSettingsSheet extends StatefulWidget {
  const _ServerSettingsSheet();

  @override
  State<_ServerSettingsSheet> createState() => _ServerSettingsSheetState();
}

class _ServerSettingsSheetState extends State<_ServerSettingsSheet> {
  final _controller = TextEditingController();
  var _changed = false;
  var _busy = false;
  ServerInfo? _serverInfo;
  Object? _serverInfoError;
  var _loadingServerInfo = true;

  @override
  void initState() {
    super.initState();
    _loadServerInfo();
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
      final info = await SyncTvService.getServerInfo(refresh: refresh);
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
      MessageUtils.showWarning(context, context.l10n.serverAddressRequired);
      return;
    }

    setState(() => _busy = true);
    try {
      final profile = await SyncTvService.addServer(input);
      _controller.clear();
      _changed = true;
      if (mounted) {
        MessageUtils.showSuccess(
          context,
          context.l10n.serverConnected(profile.name),
        );
      }
      setState(() {});
    } on SyncTvApiException catch (error) {
      if (mounted) {
        MessageUtils.showError(context, error.message);
      }
    } catch (error) {
      if (mounted) {
        MessageUtils.showError(
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

  Future<void> _activateServer(SyncTvServerProfile profile) async {
    setState(() => _busy = true);
    try {
      await SyncTvService.activateServer(profile.serverId);
      await SyncTvService.syncServerTime(refresh: true);
      await _loadServerInfo(refresh: true);
      _changed = true;
      if (mounted) {
        MessageUtils.showSuccess(
          context,
          context.l10n.serverSwitched(profile.name),
        );
      }
      setState(() {});
    } catch (error) {
      if (mounted) {
        MessageUtils.showError(
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

  Future<void> _removeServer(SyncTvServerProfile profile) async {
    if (profile.isBuiltIn) {
      MessageUtils.showWarning(context, context.l10n.builtInServerCannotRemove);
      return;
    }
    setState(() => _busy = true);
    try {
      await SyncTvService.removeServer(profile.serverId);
      _changed = true;
      if (mounted) {
        MessageUtils.showSuccess(context, context.l10n.serverRemoved);
      }
      setState(() {});
    } catch (error) {
      if (mounted) {
        MessageUtils.showError(
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
    final servers = SyncTvService.servers;
    final activeServer = SyncTvService.activeServer;

    return AppBottomSheetFrame(
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
                  onPressed: () => Navigator.pop(context, _changed),
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
              onRefresh: _busy ? null : () => _loadServerInfo(refresh: true),
            ),
            const SizedBox(height: 16),
            ChatUtils.createFormField(
              context: context,
              label: l10n.serverAddress,
              controller: _controller,
              hintText: l10n.serverAddressExample,
              prefixIcon: Icons.link_rounded,
              onSubmitted: (_) => _busy ? null : _addServer(),
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
                  active: profile.serverId == activeServer?.serverId,
                  canRemove: !_busy && !profile.isBuiltIn,
                  busy: _busy,
                  onActivate: () => _activateServer(profile),
                  onRemove: () => _removeServer(profile),
                ),
              ),
          ],
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
  final SyncTvServerProfile? fallback;
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
    final serverId = (info?.serverId.trim().isNotEmpty ?? false)
        ? info!.serverId.trim()
        : fallback?.serverId ?? '';
    final endpoint = fallback?.activeEndpoint ?? SyncTvService.baseUrl;

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
                if (serverId.isNotEmpty) ...[
                  _MetaLine(icon: Icons.fingerprint_rounded, text: serverId),
                  const SizedBox(height: 4),
                ],
                if (endpoint.isNotEmpty)
                  _MetaLine(
                    icon: Icons.radio_button_checked_rounded,
                    text: endpoint,
                  ),
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

  final SyncTvServerProfile profile;
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
          _MetaLine(icon: Icons.fingerprint_rounded, text: profile.serverId),
          const SizedBox(height: 6),
          ...profile.endpoints.map(
            (endpoint) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _MetaLine(
                icon: endpoint == profile.activeEndpoint
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                text: endpoint,
              ),
            ),
          ),
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
