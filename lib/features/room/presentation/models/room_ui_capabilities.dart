import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

final class RoomUiCapabilities {
  RoomUiCapabilities({
    required SyncTvRoom room,
    required SyncTvUser? currentUser,
    required AdminRoomMember? selfMember,
  }) : _permissions = selfMember?.permissions ?? room.myPermissions,
       isRoomCreator =
           currentUser?.id.isNotEmpty == true &&
           currentUser!.id == room.creatorId,
       isSystemAdmin = currentUser?.role.hasSystemAdminPrivileges ?? false;

  final int _permissions;
  final bool isRoomCreator;
  final bool isSystemAdmin;

  bool allows(int permission) =>
      isRoomCreator || isSystemAdmin || (_permissions & permission) != 0;

  bool get canSendChatMessages =>
      allows(RoomEffectivePermissions.sendChatMessages);
  bool get canManageOwnMedia => allows(RoomEffectivePermissions.manageOwnMedia);
  bool get canBrowseLibrary => allows(RoomEffectivePermissions.browseLibrary);
  bool get canViewMembers => allows(RoomEffectivePermissions.viewMembers);
  bool get canViewChatHistory =>
      allows(RoomEffectivePermissions.viewChatHistory);
  bool get canUseVoiceChat => allows(RoomEffectivePermissions.useVoiceChat);
  bool get canUseP2pMedia => allows(RoomEffectivePermissions.useP2pMedia);
  bool get canDeleteMedia => allows(RoomEffectivePermissions.deleteMedia);
  bool get canReorderMedia => allows(RoomEffectivePermissions.reorderMedia);
  bool get canClearMedia => allows(RoomEffectivePermissions.clearMedia);
  bool get canManageLiveStreams =>
      allows(RoomEffectivePermissions.manageLiveStreams);
  bool get canControlPlaybackState =>
      allows(RoomEffectivePermissions.controlPlaybackState);
  bool get canNavigatePlayback =>
      allows(RoomEffectivePermissions.navigatePlayback);
  bool get canReviewJoinRequests =>
      allows(RoomEffectivePermissions.reviewJoinRequests);
  bool get canRemoveMembers => allows(RoomEffectivePermissions.removeMembers);
  bool get canManageMemberPermissions =>
      allows(RoomEffectivePermissions.manageMemberPermissions);
  bool get canAddMembers => allows(RoomEffectivePermissions.addMembers);
  bool get canManageRoomSettings =>
      allows(RoomEffectivePermissions.manageRoomSettings);
  bool get canDeleteChatMessages =>
      allows(RoomEffectivePermissions.deleteChatMessages);
  bool get canDeleteRoom => allows(RoomEffectivePermissions.deleteRoom);
  bool get canViewPlaybackHistory =>
      allows(RoomEffectivePermissions.viewPlaybackHistory);
}
