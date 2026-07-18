import 'package:flutter/widgets.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/models/synctv_models.dart';

export 'package:synctv_app/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension RoomPermissionLocalizations on AppLocalizations {
  String roomMemberPermissionLabel(int permission) => switch (permission) {
    RoomMemberPermissions.chat => sendChatAndDanmaku,
    RoomMemberPermissions.createMediaResource => addMedia,
    RoomMemberPermissions.viewMediaResources => viewMediaList,
    RoomMemberPermissions.viewMemberList => viewMemberList,
    RoomMemberPermissions.viewChatHistory => viewChatHistory,
    RoomMemberPermissions.useWebRTC => webrtcCalls,
    _ => permission.toString(),
  };
}
