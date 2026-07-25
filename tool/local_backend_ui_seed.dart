// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/services/synctv_service.dart';

void main() {
  test(
    'create local UI test user and room',
    () async {
      const baseUrl = String.fromEnvironment(
        'SYNCTV_SMOKE_BASE_URL',
        defaultValue: 'http://127.0.0.1:8080',
      );
      final stamp = DateTime.now().microsecondsSinceEpoch;
      final username = 'uiadmin$stamp';
      final password = 'UiAdmin$stamp-A9';

      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(baseUrl);
      await SyncTvService.registerWithDirectPassword(
        username: username,
        password: password,
      );
      final room = await SyncTvService.createRoom(
        'UI Coverage $stamp',
        description: 'Generated for complete local App UI coverage',
      );

      print('UI_SEED_USERNAME=$username');
      print('UI_SEED_PASSWORD=$password');
      print('UI_SEED_ROOM_ID=${room.roomId}');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
