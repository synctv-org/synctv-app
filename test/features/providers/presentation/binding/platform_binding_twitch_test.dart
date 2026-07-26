import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('Twitch binding hides secrets and submits integrity context', (
    tester,
  ) async {
    String? token;
    String? submittedDeviceId;
    String? integrity;
    String? instance;
    var successCount = 0;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TwitchAccountBindingForm(
            instanceNamesLoader: () async => const ['twitch-edge'],
            onSuccess: () => successCount += 1,
            onBind:
                ({
                  required authToken,
                  required deviceId,
                  required clientIntegrity,
                  required instanceName,
                }) async {
                  token = authToken;
                  submittedDeviceId = deviceId;
                  integrity = clientIntegrity;
                  instance = instanceName;
                },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final tokenField = find.byKey(const Key('twitch-bind-token'));
    final integrityField = find.byKey(const Key('twitch-bind-integrity'));
    expect(tester.widget<AppTextField>(tokenField).obscureText, isTrue);
    expect(tester.widget<AppTextField>(integrityField).obscureText, isTrue);

    await tester.enterText(tokenField, 'oauth-secret');
    await tester.enterText(
      find.byKey(const Key('twitch-bind-device-id')),
      'device-1',
    );
    await tester.enterText(integrityField, 'integrity-secret');
    await tester.tap(find.text('Local instance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('twitch-edge').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(token, 'oauth-secret');
    expect(submittedDeviceId, 'device-1');
    expect(integrity, 'integrity-secret');
    expect(instance, 'twitch-edge');
    expect(successCount, 1);
    await tester.pump(const Duration(seconds: 4));
  });
}
