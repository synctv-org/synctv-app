// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import 'local_backend_test_auth.dart';

void main() {
  test('seed a restricted local room member', () async {
    const roomId = String.fromEnvironment(
      'SYNCTV_MEMBER_ROOM_ID',
      defaultValue: 'room_4',
    );
    const username = String.fromEnvironment(
      'SYNCTV_MEMBER_USERNAME',
      defaultValue: 'restricted_member',
    );
    const password = String.fromEnvironment(
      'SYNCTV_MEMBER_PASSWORD',
      defaultValue: 'RestrictedMemberPass2026!',
    );
    const rootPassword = String.fromEnvironment(
      'SYNCTV_SMOKE_ROOT_PASSWORD',
      defaultValue: 'LocalDevRootPass2026!',
    );

    SharedPreferences.setMockInitialValues({});
    await SyncTvService.init();
    await SyncTvService.setBaseUrl('http://127.0.0.1:8080');
    await loginLocalRoot(rootPassword);
    final users = await SyncTvService.adminListUsersPage(search: username);
    if (!users.users.any((user) => user.username == username)) {
      await SyncTvService.adminAddUser(
        username,
        password,
        common_enum.UserRole.USER_ROLE_USER.value,
      );
    }

    await SyncTvService.logout();
    await loginLocalPasswordUser(username, password);
    final member = await SyncTvService.getMe(refresh: true);

    await SyncTvService.logout();
    await loginLocalRoot(rootPassword);
    final existing = await SyncTvService.getRoomMemberDetailsPage(
      roomId,
      search: username,
    );
    if (!existing.members.any((item) => item.userId == member.id)) {
      await SyncTvService.addRoomMember(roomId, member.id, role: 3);
    }
    await SyncTvService.adminSetRoomMemberRole(roomId, member.id, 2);
    await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
      roomId,
      member.id,
      role: 2,
      adminRemovedPermissions:
          RoomEffectivePermissions.viewPlaybackHistory |
          RoomEffectivePermissions.useVoiceChat |
          RoomEffectivePermissions.useP2pMedia,
    );

    print('RESTRICTED_MEMBER_USERNAME=$username');
    print('RESTRICTED_MEMBER_PASSWORD=$password');
    print('RESTRICTED_MEMBER_USER_ID=${member.id}');
  });
}
