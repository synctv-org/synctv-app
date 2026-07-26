import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';

void main() {
  testWidgets('YouTube binding accepts Cookie as the only session credential', (
    tester,
  ) async {
    String? submittedCookie;
    var successCount = 0;
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: YoutubeAccountBindingForm(
            instanceNamesLoader: () async => const [],
            onSuccess: () => successCount += 1,
            onBind:
                ({
                  required label,
                  required visitorData,
                  required poToken,
                  required cookie,
                  required instanceName,
                }) async {
                  expect(label, 'Browser session');
                  expect(visitorData, isEmpty);
                  expect(poToken, isEmpty);
                  expect(instanceName, isEmpty);
                  submittedCookie = cookie;
                },
          ),
        ),
      ),
    );
    await tester.pump();

    final cookieField = find.byKey(const Key('youtube-bind-cookie'));
    expect(cookieField, findsOneWidget);
    expect(tester.widget<AppTextField>(cookieField).obscureText, isTrue);

    await tester.enterText(
      cookieField,
      'LOGIN_INFO=login; SAPISID=session-secret',
    );
    await tester.tap(find.byKey(const Key('youtube-bind-submit')));
    await tester.pumpAndSettle();

    expect(submittedCookie, 'LOGIN_INFO=login; SAPISID=session-secret');
    expect(successCount, 1);
  });
}
