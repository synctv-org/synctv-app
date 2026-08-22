import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/presentation/oauth2_callback_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  test('generates only the OAuth2 callback route', () {
    final callbackRoute = generateOAuth2CallbackRoute(
      const RouteSettings(
        name: '/oauth2/callback?code=authorization-code&state=state',
      ),
    );

    expect(callbackRoute, isA<MaterialPageRoute<void>>());
    expect(generateOAuth2CallbackRoute(const RouteSettings(name: '/')), isNull);
    expect(
      generateOAuth2CallbackRoute(
        const RouteSettings(name: '/oauth2/callback/'),
      ),
      isNull,
    );
  });

  testWidgets('renders the callback page and dispatches it once', (
    tester,
  ) async {
    var dispatchCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: OAuth2CallbackPage(onLoaded: () => dispatchCount += 1),
      ),
    );

    expect(dispatchCount, 1);
    expect(find.text('Authorization complete'), findsOneWidget);
    expect(
      find.text('You can close this window and return to SyncTV.'),
      findsOneWidget,
    );

    await tester.pump();
    expect(dispatchCount, 1);
  });
}
