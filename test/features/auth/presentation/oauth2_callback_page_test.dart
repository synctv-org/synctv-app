import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/presentation/oauth2_callback_page.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  testWidgets('failed dispatch retries without exposing credentials', (
    tester,
  ) async {
    final dispatcher = _CallbackDispatcher()..failuresRemaining = 2;
    await tester.pumpWidget(_callbackApp(dispatcher));
    expect(tester.takeException(), isNull);
    expect(find.text('Unable to return authorization'), findsOneWidget);
    expect(find.textContaining('secret-code'), findsNothing);
    expect(find.text('Authorization complete'), findsNothing);
    final retry = tester
        .widget<FilledButton>(find.byType(FilledButton))
        .onPressed!;
    retry();
    await tester.pump();
    expect(dispatcher.dispatchCount, 2);
    expect(find.text('Retry'), findsOneWidget);
    retry();
    retry();
    await tester.pump();
    expect(dispatcher.dispatchCount, 3);
    expect(find.text('Authorization complete'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('retained retry ignores covered and disposed pages', (
    tester,
  ) async {
    final dispatcher = _CallbackDispatcher()..failuresRemaining = 10;
    await tester.pumpWidget(_callbackApp(dispatcher));
    final retry = tester
        .widget<FilledButton>(find.byType(FilledButton))
        .onPressed!;
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(MaterialPageRoute<void>(builder: (_) => const Scaffold()));
    await tester.pumpAndSettle();
    retry();
    expect(dispatcher.dispatchCount, 1);
    navigator.pop();
    await tester.pumpAndSettle();
    retry();
    expect(dispatcher.dispatchCount, 2);
    await tester.pumpWidget(const SizedBox());
    retry();
    expect(dispatcher.dispatchCount, 2);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'zh']) {
    testWidgets('failed callback retry is reachable at 3x $locale', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 300)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final dispatcher = _CallbackDispatcher()..failuresRemaining = 1;
      await tester.pumpWidget(_callbackApp(dispatcher, locale: locale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(
        tester.getBottomRight(find.byType(FilledButton)).dy,
        lessThanOrEqualTo(300),
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(dispatcher.dispatchCount, 2);
      expect(find.byType(FilledButton), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets('callback content remains reachable $locale/$scale', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(320, 300)
          ..devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final dispatcher = _CallbackDispatcher();
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: OAuth2CallbackPage(dispatcher: dispatcher),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final message = find.text(
          tester
              .element(find.byType(OAuth2CallbackPage))
              .l10n
              .oauth2CallbackCompleteMessage,
        );
        final scrollable = tester.state<ScrollableState>(
          find.byType(Scrollable),
        );
        scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
        await tester.pumpAndSettle();
        expect(tester.getBottomRight(message).dy, lessThanOrEqualTo(300));
        expect(tester.getBottomRight(message).dy, greaterThan(0));
        expect(dispatcher.dispatchCount, 1);
      });
    }
  }
  test('generates only the OAuth2 callback route', () {
    final callbackRoute = generateOAuth2CallbackRoute(
      const RouteSettings(
        name: '/oauth2/callback?code=authorization-code&state=state',
      ),
      dispatcher: _CallbackDispatcher(),
    );

    expect(callbackRoute, isA<MaterialPageRoute<void>>());
    expect(
      generateOAuth2CallbackRoute(
        const RouteSettings(name: '/'),
        dispatcher: _CallbackDispatcher(),
      ),
      isNull,
    );
    expect(
      generateOAuth2CallbackRoute(
        const RouteSettings(name: '/oauth2/callback/'),
        dispatcher: _CallbackDispatcher(),
      ),
      isNull,
    );
  });

  testWidgets('renders the callback page and dispatches it once', (
    tester,
  ) async {
    final dispatcher = _CallbackDispatcher();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: OAuth2CallbackPage(dispatcher: dispatcher),
      ),
    );

    expect(dispatcher.dispatchCount, 1);
    expect(find.text('Authorization complete'), findsOneWidget);
    expect(
      find.text('You can close this window and return to SyncTV.'),
      findsOneWidget,
    );

    await tester.pump();
    expect(dispatcher.dispatchCount, 1);
  });
}

final class _CallbackDispatcher implements OAuth2CallbackDispatcher {
  int dispatchCount = 0;
  int failuresRemaining = 0;

  @override
  void dispatch() {
    dispatchCount++;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw StateError('callback?code=secret-code');
    }
  }
}

Widget _callbackApp(_CallbackDispatcher dispatcher, {String locale = 'en'}) =>
    MaterialApp(
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: OAuth2CallbackPage(dispatcher: dispatcher),
    );
