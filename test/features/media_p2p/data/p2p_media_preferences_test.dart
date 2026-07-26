import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/data/shared_preferences_p2p_media_preferences_store.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'security mode defaults to standard and persists origin sampling',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = P2pMediaPreferencesController(
        store: const SharedPreferencesP2pMediaPreferencesStore(),
      );

      await preferences.load();
      expect(preferences.securityMode, P2pMediaSecurityMode.standard);
      expect(
        preferences.cacheSizeMiB,
        P2pMediaPreferenceValues.defaultCacheSizeMiB,
      );

      await preferences.setSecurityMode(P2pMediaSecurityMode.sampledOrigin);
      final storage = await SharedPreferences.getInstance();
      expect(
        storage.getString('playback.p2p_media_security_mode'),
        P2pMediaSecurityMode.sampledOrigin.name,
      );

      await preferences.setCacheSizeMiB(512);
      expect(storage.getInt('playback.p2p_media_cache_size_mib'), 512);
      expect(() => preferences.setCacheSizeMiB(63), throwsArgumentError);
    },
  );
}
