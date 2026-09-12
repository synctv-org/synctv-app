import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

import 'local_backend_test_auth.dart';

void main() {
  test(
    'local room password projections agree after credential changes',
    () async {
      const baseUrl = String.fromEnvironment('SYNCTV_SMOKE_BASE_URL');
      const rootPassword = String.fromEnvironment('SYNCTV_SMOKE_ROOT_PASSWORD');
      const roomId = String.fromEnvironment('SYNCTV_SMOKE_ROOM_ID');
      const clear = bool.fromEnvironment('SYNCTV_SMOKE_CLEAR_PASSWORD');
      if (baseUrl.isEmpty || rootPassword.isEmpty || roomId.isEmpty) {
        throw StateError(
          'Explicit local test server, credentials and room ID are required',
        );
      }
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(baseUrl);
      await loginLocalRoot(rootPassword);
      final original = await SyncTvService.getRoomInfo(roomId);
      if (clear) {
        await SyncTvService.updateRoomPassword(roomId, null);
      }
      final expected = clear ? false : true;
      expect((await SyncTvService.getRoomInfo(roomId)).needPassword, expected);
      expect((await SyncTvService.adminGetRoom(roomId)).needPassword, expected);
      final discovered = await SyncTvService.discoverRooms(
        search: original.roomName,
      );
      expect(
        discovered.rooms
            .singleWhere((room) => room.roomId == roomId)
            .needPassword,
        expected,
      );
      final mine = await SyncTvService.getMyRoomsPage(refresh: true);
      expect(
        mine.rooms.singleWhere((room) => room.roomId == roomId).needPassword,
        expected,
      );
      final managed = await SyncTvService.adminListRoomsPage(
        search: original.roomName,
      );
      expect(
        managed.rooms.singleWhere((room) => room.roomId == roomId).needPassword,
        expected,
      );
      await SyncTvService.logout();
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
