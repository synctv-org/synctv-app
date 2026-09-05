import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/models/room_ui_capabilities.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

void main() {
  group('RoomUiCapabilities', () {
    test('uses the latest self member effective permissions', () {
      final restricted = _capabilities(
        permissions: RoomEffectivePermissions.viewChatHistory,
      );
      expect(restricted.canViewChatHistory, isTrue);
      expect(restricted.canSendChatMessages, isFalse);
      expect(restricted.canBrowseLibrary, isFalse);
      expect(restricted.canControlPlaybackState, isFalse);
      expect(restricted.canNavigatePlayback, isFalse);

      final expanded = _capabilities(
        permissions:
            RoomEffectivePermissions.viewChatHistory |
            RoomEffectivePermissions.sendChatMessages |
            RoomEffectivePermissions.browseLibrary |
            RoomEffectivePermissions.controlPlaybackState |
            RoomEffectivePermissions.navigatePlayback,
      );
      expect(expanded.canViewChatHistory, isTrue);
      expect(expanded.canSendChatMessages, isTrue);
      expect(expanded.canBrowseLibrary, isTrue);
      expect(expanded.canControlPlaybackState, isTrue);
      expect(expanded.canNavigatePlayback, isTrue);
    });

    test('keeps management permissions independent', () {
      final capabilities = _capabilities(
        permissions:
            RoomEffectivePermissions.removeMembers |
            RoomEffectivePermissions.deleteMedia |
            RoomEffectivePermissions.viewPlaybackHistory,
      );

      expect(capabilities.canRemoveMembers, isTrue);
      expect(capabilities.canDeleteMedia, isTrue);
      expect(capabilities.canViewPlaybackHistory, isTrue);
      expect(capabilities.canManageMemberPermissions, isFalse);
      expect(capabilities.canClearMedia, isFalse);
      expect(capabilities.canManageRoomSettings, isFalse);
    });

    test('uses discovery permissions before the self snapshot arrives', () {
      final capabilities = RoomUiCapabilities(
        room: _room(
          myPermissions:
              RoomEffectivePermissions.browseLibrary |
              RoomEffectivePermissions.viewMembers,
        ),
        currentUser: _user(),
        selfMember: null,
      );

      expect(capabilities.canBrowseLibrary, isTrue);
      expect(capabilities.canViewMembers, isTrue);
      expect(capabilities.canSendChatMessages, isFalse);
    });

    test(
      'retains discovery permissions while refreshing the self snapshot',
      () {
        final capabilities = RoomUiCapabilities(
          room: _room(myPermissions: RoomAdminPermissions.all),
          currentUser: _user(),
          selfMember: null,
        );

        expect(capabilities.canBrowseLibrary, isTrue);
        expect(capabilities.canViewMembers, isTrue);
        expect(capabilities.canControlPlaybackState, isTrue);
        expect(capabilities.canManageRoomSettings, isTrue);
      },
    );

    test('room creator retains room capabilities', () {
      final capabilities = RoomUiCapabilities(
        room: _room(creatorId: 'user-1'),
        currentUser: _user(id: 'user-1'),
        selfMember: _member(permissions: 0),
      );

      expect(capabilities.isRoomCreator, isTrue);
      expect(capabilities.canManageRoomSettings, isTrue);
      expect(capabilities.canManageMemberPermissions, isTrue);
      expect(capabilities.canRemoveMembers, isTrue);
      expect(capabilities.canControlPlaybackState, isTrue);
    });

    test('system administrator retains room capabilities', () {
      final capabilities = RoomUiCapabilities(
        room: _room(),
        currentUser: _user(role: common_enum.UserRole.USER_ROLE_ADMIN),
        selfMember: _member(permissions: 0),
      );

      expect(capabilities.isSystemAdmin, isTrue);
      expect(capabilities.canManageRoomSettings, isTrue);
      expect(capabilities.canDeleteRoom, isTrue);
      expect(capabilities.canManageLiveStreams, isTrue);
      expect(capabilities.canDeleteChatMessages, isTrue);
    });
  });
}

RoomUiCapabilities _capabilities({required int permissions}) {
  return RoomUiCapabilities(
    room: _room(),
    currentUser: _user(),
    selfMember: _member(permissions: permissions),
  );
}

SyncTvRoom _room({String creatorId = 'creator', int myPermissions = 0}) {
  return SyncTvRoom(
    roomId: 'room-1',
    roomName: 'Test room',
    creatorId: creatorId,
    myPermissions: myPermissions,
  );
}

SyncTvUser _user({String id = 'user-1', common_enum.UserRole? role}) {
  return SyncTvUser(
    id: id,
    username: 'member',
    role: AccountUserRole(role ?? common_enum.UserRole.USER_ROLE_USER),
  );
}

AdminRoomMember _member({required int permissions}) {
  return AdminRoomMember(
    roomId: 'room-1',
    userId: 'user-1',
    username: 'member',
    role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
    permissions: permissions,
    addedPermissions: 0,
    removedPermissions: 0,
    adminAddedPermissions: 0,
    adminRemovedPermissions: 0,
    joinedAt: 0,
    isOnline: true,
  );
}
