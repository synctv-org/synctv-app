import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/room_invite_service.dart';
import 'package:synctv_app/utils/message_utils.dart';

Future<void> copyRoomInviteLink(BuildContext context, WRoom room) async {
  final link = RoomInviteService.createInviteLink(room);
  await Clipboard.setData(ClipboardData(text: link));
  if (context.mounted) {
    MessageUtils.showInfo(context, '邀请链接已复制');
  }
}
