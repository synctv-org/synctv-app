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

  String roomAdminPermissionLabel(int permission) => switch (permission) {
    RoomAdminPermissions.sendChatMessages => sendChatAndDanmaku,
    RoomAdminPermissions.manageOwnMedia => addMedia,
    RoomAdminPermissions.browseLibrary => browseLibraryList,
    RoomAdminPermissions.viewMembers => viewMemberList,
    RoomAdminPermissions.viewChatHistory => viewChatHistory,
    RoomAdminPermissions.useVoiceChat => voiceChat,
    RoomAdminPermissions.deleteMedia => deleteMedia,
    RoomAdminPermissions.reorderMedia => roomPermissionReorderMedia,
    RoomAdminPermissions.clearMedia => roomPermissionClearMedia,
    RoomAdminPermissions.manageLiveStreams => roomPermissionManageLiveStreams,
    RoomAdminPermissions.controlPlaybackState => playbackControl,
    RoomAdminPermissions.navigatePlayback => roomPermissionNavigatePlayback,
    RoomAdminPermissions.reviewJoinRequests => roomPermissionReviewJoinRequests,
    RoomAdminPermissions.removeMembers => roomPermissionRemoveMembers,
    RoomAdminPermissions.manageMemberPermissions =>
      roomPermissionManageMemberPermissions,
    RoomAdminPermissions.addMembers => roomPermissionAddMembers,
    RoomAdminPermissions.manageRoomSettings => roomPermissionManageRoomSettings,
    RoomAdminPermissions.deleteChatMessages => roomPermissionDeleteChatMessages,
    RoomAdminPermissions.deleteRoom => deleteRoom,
    RoomAdminPermissions.viewPlaybackHistory => viewPlaybackHistory,
    RoomAdminPermissions.useP2pMedia => p2pMedia,
    _ => permission.toString(),
  };
}
