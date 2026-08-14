import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/data/shared_preferences_p2p_media_preferences_store.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/presentation/p2p_media_settings_fields.dart';

import '../../../test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late P2pMediaPreferencesController preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'playback.p2p_media_enabled': true,
    });
    preferences = P2pMediaPreferencesController(
      store: const SharedPreferencesP2pMediaPreferencesStore(),
    );
    await preferences.load();
  });

  testWidgets('renders and persists the selected P2P security mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
        ],
        builder: buildThemedTestApp,
        home: Scaffold(body: P2pMediaSettingsFields(preferences: preferences)),
      ),
    );

    expect(find.text('Peer data validation'), findsOneWidget);
    expect(find.text('Standard'), findsOneWidget);
    expect(find.text('Cache capacity'), findsOneWidget);
    expect(find.text('128 MiB'), findsOneWidget);
    expect(find.textContaining('expire after 10 minutes'), findsOneWidget);
    expect(
      find.textContaining('Validation adds no network traffic'),
      findsOneWidget,
    );
    expect(
      find.textContaining('scheduling can still race origins and peers'),
      findsOneWidget,
    );

    await tester.tap(find.text('Standard'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Origin sampling'));
    await tester.pumpAndSettle();

    expect(preferences.securityMode, P2pMediaSecurityMode.sampledOrigin);
    expect(find.textContaining('Compares 10%'), findsOneWidget);
    final storage = await SharedPreferences.getInstance();
    expect(
      storage.getString('playback.p2p_media_security_mode'),
      P2pMediaSecurityMode.sampledOrigin.name,
    );

    await tester.tap(find.text('128 MiB'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('512 MiB'));
    await tester.pumpAndSettle();

    expect(preferences.cacheSizeMiB, 512);
    expect(storage.getInt('playback.p2p_media_cache_size_mib'), 512);
  });
}
