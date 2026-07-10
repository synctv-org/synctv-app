import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/room_invite_service.dart';
import 'package:synctv_app/utils/message_utils.dart';

Future<void> copyRoomInviteLink(BuildContext context, SyncTvRoom room) async {
  try {
    final link = RoomInviteService.createInviteLink(room);
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) {
      MessageUtils.showInfo(context, context.l10n.inviteLinkCopied);
    }
  } catch (error) {
    if (context.mounted) {
      MessageUtils.showError(context, error.toString());
    }
  }
}
