import 'package:flutter/material.dart';
import 'package:synctv_app/services/room_invite_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';

Future<String?> prepareRoomInviteTarget({
  required BuildContext context,
  required String value,
}) async {
  final invite = RoomInviteService.parse(value);
  final serverId = invite.serverId;
  if (serverId == null || serverId.isEmpty) return invite.roomId;

  final matches = RoomInviteService.matchingServers(serverId);
  if (matches.isEmpty) {
    if (!context.mounted) return null;
    final changed = await _showMissingServerDialog(context);
    if (changed == true && context.mounted) {
      final addedMatches = RoomInviteService.matchingServers(serverId);
      if (addedMatches.isNotEmpty) {
        await _activateBestEndpoint(context, addedMatches);
        return invite.roomId;
      }
    }
    return null;
  }

  if (!context.mounted) return null;
  await _activateBestEndpoint(context, matches);
  return invite.roomId;
}

Future<bool?> _showMissingServerDialog(BuildContext context) {
  return ChatUtils.showStyledDialog<bool>(
    context: context,
    title: '需要添加服务器',
    icon: Icon(Icons.travel_explore_rounded,
        color: Theme.of(context).primaryColor),
    content: const Text(
      '这个邀请来自另一个 SyncTV 服务器。请先添加该服务器地址，客户端会自动识别身份后继续加入房间。',
    ),
    actions: [
      ChatUtils.createCancelButton(context),
      const SizedBox(width: 8),
      ChatUtils.createConfirmButton(
        context,
        () async {
          final changed = await showServerSettingsDialog(context: context);
          if (context.mounted) Navigator.pop(context, changed == true);
        },
        text: '添加服务器',
      ),
    ],
  );
}

Future<void> _activateBestEndpoint(
  BuildContext context,
  List<SyncTvServerProfile> matches,
) async {
  final profile = matches.first;
  if (profile.endpoints.length <= 1) {
    await WatchTogetherService.activateServer(profile.serverId);
    return;
  }

  final endpoint = await _chooseEndpoint(context, profile);
  if (endpoint == null) return;
  await WatchTogetherService.activateServerEndpoint(profile.serverId, endpoint);
}

Future<String?> _chooseEndpoint(
  BuildContext context,
  SyncTvServerProfile profile,
) {
  return ChatUtils.showStyledDialog<String>(
    context: context,
    title: '选择访问地址',
    icon: Icon(Icons.route_rounded, color: Theme.of(context).primaryColor),
    content: SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          ...profile.endpoints.map(
            (endpoint) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppTile(
                selected: endpoint == profile.activeEndpoint,
                prefix: Icon(
                  endpoint == profile.activeEndpoint
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(endpoint),
                onPressed: () => Navigator.pop(context, endpoint),
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      ChatUtils.createCancelButton(context),
    ],
  );
}

Future<String?> parseInviteOrShowError({
  required BuildContext context,
  required String value,
}) async {
  try {
    return await prepareRoomInviteTarget(context: context, value: value);
  } on FormatException {
    if (context.mounted) MessageUtils.showWarning(context, '请输入房间ID或邀请链接');
    return null;
  } catch (error) {
    if (context.mounted) MessageUtils.showError(context, '处理邀请失败: $error');
    return null;
  }
}
