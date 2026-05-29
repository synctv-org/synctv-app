import 'package:flutter/material.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';

Future<bool?> showServerSettingsDialog({
  required BuildContext context,
}) {
  final controller = TextEditingController();
  var changed = false;
  var busy = false;

  Future<void> addServer(StateSetter setDialogState) async {
    final input = controller.text.trim();
    if (input.isEmpty) {
      MessageUtils.showWarning(context, '请输入服务器地址');
      return;
    }

    setDialogState(() => busy = true);
    try {
      final profile = await WatchTogetherService.addServer(input);
      controller.clear();
      changed = true;
      if (context.mounted) {
        MessageUtils.showSuccess(context, '已连接 ${profile.name}');
      }
      setDialogState(() {});
    } on SyncTvApiException catch (error) {
      if (context.mounted) {
        MessageUtils.showError(context, error.message);
      }
    } catch (error) {
      if (context.mounted) {
        MessageUtils.showError(context, '无法连接服务器: $error');
      }
    } finally {
      setDialogState(() => busy = false);
    }
  }

  Future<void> activateServer(
    StateSetter setDialogState,
    SyncTvServerProfile profile,
  ) async {
    setDialogState(() => busy = true);
    try {
      await WatchTogetherService.activateServer(profile.serverId);
      changed = true;
      if (context.mounted) {
        MessageUtils.showSuccess(context, '已切换到 ${profile.name}');
      }
      setDialogState(() {});
    } catch (error) {
      if (context.mounted) {
        MessageUtils.showError(context, '切换服务器失败: $error');
      }
    } finally {
      setDialogState(() => busy = false);
    }
  }

  Future<void> removeServer(
    StateSetter setDialogState,
    SyncTvServerProfile profile,
  ) async {
    setDialogState(() => busy = true);
    try {
      await WatchTogetherService.removeServer(profile.serverId);
      changed = true;
      if (context.mounted) {
        MessageUtils.showSuccess(context, '服务器已移除');
      }
      setDialogState(() {});
    } catch (error) {
      if (context.mounted) {
        MessageUtils.showError(context, '移除服务器失败: $error');
      }
    } finally {
      setDialogState(() => busy = false);
    }
  }

  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 720),
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final servers = WatchTogetherService.servers;
        final activeServer = WatchTogetherService.activeServer;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SingleChildScrollView(
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
                          '服务器',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, changed),
                        child: const Text('完成'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ChatUtils.createFormField(
                    context: context,
                    label: '服务器地址',
                    controller: controller,
                    hintText: '例如: https://tv.example.com',
                    prefixIcon: Icons.link_rounded,
                    onSubmitted: (_) => busy ? null : addServer(setDialogState),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '添加地址后会自动识别服务器，不需要填写回调地址、Code 或 server_id。',
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
                      FilledButton.icon(
                        onPressed:
                            busy ? null : () => addServer(setDialogState),
                        icon: busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.add_link_rounded, size: 18),
                        label: const Text('添加'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '已保存服务器',
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
                        canRemove: !busy && !profile.isDefault,
                        busy: busy,
                        onActivate: () =>
                            activateServer(setDialogState, profile),
                        onRemove: () => removeServer(setDialogState, profile),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ).whenComplete(controller.dispose);
}

class _EmptyServerState extends StatelessWidget {
  const _EmptyServerState({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '还没有保存的服务器。添加服务器后即可登录和浏览公开房间。',
        style: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final background = active
        ? primary.withValues(alpha: isDark ? 0.18 : 0.10)
        : isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.035);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? primary.withValues(alpha: 0.45) : Colors.transparent,
        ),
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
                    if (profile.isDefault) ...[
                      const SizedBox(width: 8),
                      _ServerBadge(
                        label: '默认',
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ],
                ),
              ),
              if (!active)
                IconButton(
                  tooltip: '切换',
                  onPressed: busy ? null : onActivate,
                  icon: const Icon(Icons.login_rounded, size: 20),
                ),
              IconButton(
                tooltip: profile.isDefault
                    ? '默认服务器不可移除'
                    : canRemove
                        ? '移除'
                        : '正在处理',
                onPressed: canRemove ? onRemove : null,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MetaLine(
            icon: Icons.fingerprint_rounded,
            text: profile.serverId,
          ),
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
  const _ServerBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
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
  const _MetaLine({
    required this.icon,
    required this.text,
  });

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
          child: SelectableText(
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
