import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/services/room_invite_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';

Future<String?> prepareRoomInviteTarget({
  required BuildContext context,
  required String value,
}) async {
  final invite = RoomInviteService.parse(value);
  final endpoint = invite.serverEndpoint;
  if (endpoint == null || endpoint.isEmpty) return invite.roomId;

  final matches = RoomInviteService.matchingServers(endpoint);
  if (matches.isEmpty) {
    if (!context.mounted) return null;
    final changed = await _showMissingServerDialog(context, endpoint);
    if (changed == true && context.mounted) {
      final addedMatches = RoomInviteService.matchingServers(endpoint);
      if (addedMatches.isNotEmpty) {
        await _activateServer(addedMatches.first);
        return invite.roomId;
      }
    }
    return null;
  }

  if (!context.mounted) return null;
  await _activateServer(matches.first);
  return invite.roomId;
}

Future<bool?> _showMissingServerDialog(BuildContext context, String endpoint) {
  return ChatUtils.showStyledDialog<bool>(
    context: context,
    title: context.l10n.serverRequiredForInvite,
    icon: Icon(
      Icons.travel_explore_rounded,
      color: Theme.of(context).primaryColor,
    ),
    content: Text(context.l10n.serverRequiredForInviteDescription),
    actions: [
      ChatUtils.createCancelButton(context),
      const SizedBox(width: 8),
      ChatUtils.createConfirmButton(context, () async {
        final changed = await showServerSettingsDialog(
          context: context,
          initialAddress: endpoint,
        );
        if (context.mounted) Navigator.pop(context, changed == true);
      }, text: context.l10n.addServer),
    ],
  );
}

Future<void> _activateServer(SyncTvServerProfile profile) async {
  await SyncTvService.activateServer(profile.endpoint);
  await SyncTvService.syncServerTime(refresh: true);
}

Future<String?> parseInviteOrShowError({
  required BuildContext context,
  required String value,
}) async {
  try {
    return await prepareRoomInviteTarget(context: context, value: value);
  } on FormatException {
    if (context.mounted) {
      MessageUtils.showWarning(context, context.l10n.roomIdOrInviteRequired);
    }
    return null;
  } catch (error) {
    if (context.mounted) {
      MessageUtils.showError(
        context,
        context.l10n.processInviteFailed('$error'),
      );
    }
    return null;
  }
}
