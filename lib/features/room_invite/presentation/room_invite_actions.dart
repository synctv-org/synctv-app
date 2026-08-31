import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';

Future<void> copyRoomInviteLink(BuildContext context, SyncTvRoom room) async {
  try {
    final endpoint = DependencyScope.read<ServerConnectionGateway>(context)
        .activeServer
        ?.endpoint;
    if (endpoint == null) throw StateError('No active server');
    final link = RoomInviteService.createInviteLink(
      room: room,
      serverEndpoint: endpoint,
    );
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) {
      AppNotifications.showInfo(context, context.l10n.inviteLinkCopied);
    }
  } catch (error) {
    if (context.mounted) {
      AppNotifications.showError(context, error.toString());
    }
  }
}
