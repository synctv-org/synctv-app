import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/services/p2p_media_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'security mode defaults to standard and persists origin sampling',
    () async {
      SharedPreferences.setMockInitialValues({});

      await P2pMediaPreferences.load();
      expect(
        P2pMediaPreferences.securityMode.value,
        P2pMediaSecurityMode.standard,
      );
      expect(
        P2pMediaPreferences.cacheSizeMiB.value,
        P2pMediaPreferences.defaultCacheSizeMiB,
      );

      await P2pMediaPreferences.setSecurityMode(
        P2pMediaSecurityMode.sampledOrigin,
      );
      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString('playback.p2p_media_security_mode'),
        P2pMediaSecurityMode.sampledOrigin.name,
      );

      await P2pMediaPreferences.setCacheSizeMiB(512);
      expect(preferences.getInt('playback.p2p_media_cache_size_mib'), 512);
      expect(
        () => P2pMediaPreferences.setCacheSizeMiB(63),
        throwsArgumentError,
      );
    },
  );
}
