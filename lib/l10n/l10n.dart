import 'package:flutter/widgets.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

export 'package:synctv_app/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension RoomPermissionLocalizations on AppLocalizations {
  String roomMemberPermissionLabel(int permission) => switch (permission) {
    RoomMemberPermissions.sendChatMessages => sendChatAndDanmaku,
    RoomMemberPermissions.manageOwnMedia => addMedia,
    RoomMemberPermissions.browseLibrary => browseLibraryList,
    RoomMemberPermissions.viewMembers => viewMemberList,
    RoomMemberPermissions.viewChatHistory => viewChatHistory,
    RoomMemberPermissions.useVoiceChat => voiceChat,
    RoomMemberPermissions.useP2pMedia => p2pMedia,
    _ => permission.toString(),
  };
}
