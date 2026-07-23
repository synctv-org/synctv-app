import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/services/p2p_media_preferences.dart';
import 'package:synctv_app/widgets/p2p_media_settings_fields.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    P2pMediaPreferences.enabled.value = true;
    P2pMediaPreferences.securityMode.value = P2pMediaSecurityMode.standard;
    P2pMediaPreferences.cacheSizeMiB.value =
        P2pMediaPreferences.defaultCacheSizeMiB;
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
          FLocalizations.delegate,
        ],
        home: FTheme(
          data: FThemes.blue.light.desktop,
          child: const Scaffold(body: P2pMediaSettingsFields()),
        ),
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

    expect(
      P2pMediaPreferences.securityMode.value,
      P2pMediaSecurityMode.sampledOrigin,
    );
    expect(find.textContaining('Compares 10%'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('playback.p2p_media_security_mode'),
      P2pMediaSecurityMode.sampledOrigin.name,
    );

    await tester.tap(find.text('128 MiB'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('512 MiB'));
    await tester.pumpAndSettle();

    expect(P2pMediaPreferences.cacheSizeMiB.value, 512);
    expect(preferences.getInt('playback.p2p_media_cache_size_mib'), 512);
  });
}
