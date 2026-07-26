import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';

void main() {
  testWidgets('TikTok binding keeps Cookie hidden and submits instance scope', (
    tester,
  ) async {
    String? submittedCookie;
    String? submittedInstance;
    var successCount = 0;
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TikTokAccountBindingForm(
            instanceNamesLoader: () async => const ['tiktok-edge'],
            onSuccess: () => successCount += 1,
            onBind:
                ({
                  required label,
                  required cookie,
                  required instanceName,
                }) async {
                  expect(label, 'Browser session');
                  submittedCookie = cookie;
                  submittedInstance = instanceName;
                },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cookieField = find.byKey(const Key('tiktok-bind-cookie'));
    expect(cookieField, findsOneWidget);
    expect(tester.widget<AppTextField>(cookieField).obscureText, isTrue);

    await tester.enterText(cookieField, 'sessionid=secret; tt_chain_token=x');
    await tester.tap(find.text('Default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('tiktok-edge').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tiktok-bind-submit')));
    await tester.pumpAndSettle();

    expect(submittedCookie, 'sessionid=secret; tt_chain_token=x');
    expect(submittedInstance, 'tiktok-edge');
    expect(successCount, 1);
  });
}
