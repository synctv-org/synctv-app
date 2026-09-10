import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/features/room_invite/presentation/web_room_invite_dialog.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
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
    if (kIsWeb) {
      await showWebRoomInviteDialog(context: context, invite: invite);
      return null;
    }
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
        return context.mounted ? invite.roomId : null;
      }
    }
    return null;
  }

  if (!context.mounted) return null;
  await _activateServer(gateway, matches.first);
  return context.mounted ? invite.roomId : null;
}

Future<bool?> _showMissingServerDialog(
  BuildContext context,
  String endpoint,
) async {
  var completed = false;
  final confirmed = await showAppDialog<bool>(
    context: context,
    builder: (dialogContext) {
      void finish(bool confirmed) {
        if (completed ||
            !dialogContext.mounted ||
            ModalRoute.of(dialogContext)?.isCurrent != true) {
          return;
        }
        completed = true;
        Navigator.of(dialogContext).pop(confirmed);
      }

      return AppDialog(
        constraints: const BoxConstraints(maxWidth: 520),
        title: Text(
          dialogContext.l10n.serverRequiredForInvite,
          style: Theme.of(dialogContext).textTheme.titleMedium,
        ),
        icon: const Icon(Icons.travel_explore_rounded),
        body: Text(dialogContext.l10n.serverRequiredForInviteDescription),
        actions: [
          AppActionButton(
            label: dialogContext.l10n.cancel,
            wrapLabel: true,
            style: AppActionButtonStyle.outlined,
            onPressed: () => finish(false),
          ),
          AppActionButton(
            label: dialogContext.l10n.addServer,
            wrapLabel: true,
            onPressed: () => finish(true),
          ),
        ],
      );
    },
  );
  if (confirmed != true || !context.mounted) return false;
  return showServerSettingsDialog(context: context, initialAddress: endpoint);
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
