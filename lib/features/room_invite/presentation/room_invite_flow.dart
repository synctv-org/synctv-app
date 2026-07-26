import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';

Future<String?> prepareRoomInviteTarget({
  required BuildContext context,
  required String value,
}) async {
  final invite = RoomInviteService.parse(value);
  final endpoint = invite.serverEndpoint;
  if (endpoint == null || endpoint.isEmpty) return invite.roomId;

  final gateway = DependencyScope.read<ServerConnectionGateway>(context);
  var matches = gateway.servers
      .where(
        (server) => RoomInviteService.matchesServerEndpoint(
          inviteEndpoint: endpoint,
          serverEndpoint: server.endpoint,
        ),
      )
      .toList(growable: false);
  if (matches.isEmpty) {
    if (!context.mounted) return null;
    final changed = await _showMissingServerDialog(context, endpoint);
    if (changed == true && context.mounted) {
      matches = gateway.servers
          .where(
            (server) => RoomInviteService.matchesServerEndpoint(
              inviteEndpoint: endpoint,
              serverEndpoint: server.endpoint,
            ),
          )
          .toList(growable: false);
      if (matches.isNotEmpty) {
        await _activateServer(gateway, matches.first);
        return invite.roomId;
      }
    }
    return null;
  }

  if (!context.mounted) return null;
  await _activateServer(gateway, matches.first);
  return invite.roomId;
}

Future<bool?> _showMissingServerDialog(BuildContext context, String endpoint) {
  return AppDialogs.showStyledDialog<bool>(
    context: context,
    title: context.l10n.serverRequiredForInvite,
    icon: Icon(
      Icons.travel_explore_rounded,
      color: Theme.of(context).primaryColor,
    ),
    content: Text(context.l10n.serverRequiredForInviteDescription),
    actions: [
      AppDialogs.createCancelButton(context),
      const SizedBox(width: 8),
      AppDialogs.createConfirmButton(context, () async {
        final changed = await showServerSettingsDialog(
          context: context,
          initialAddress: endpoint,
        );
        if (context.mounted) Navigator.pop(context, changed == true);
      }, text: context.l10n.addServer),
    ],
  );
}

Future<void> _activateServer(
  ServerConnectionGateway gateway,
  ServerConnectionProfile profile,
) async {
  await gateway.activateServer(profile.endpoint);
  await gateway.syncServerTime(refresh: true);
}

Future<String?> parseInviteOrShowError({
  required BuildContext context,
  required String value,
}) async {
  try {
    return await prepareRoomInviteTarget(context: context, value: value);
  } on FormatException {
    if (context.mounted) {
      AppNotifications.showWarning(
        context,
        context.l10n.roomIdOrInviteRequired,
      );
    }
    return null;
  } catch (error) {
    if (context.mounted) {
      AppNotifications.showError(
        context,
        context.l10n.processInviteFailed('$error'),
      );
    }
    return null;
  }
}
