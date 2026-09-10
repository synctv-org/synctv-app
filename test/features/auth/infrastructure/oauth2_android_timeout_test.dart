import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';

void main() {
  testWidgets(
    'Android uses the requested timeout and ignores a late plugin result',
    (tester) async {
      const channel = MethodChannel('flutter_web_auth_2');
      final pending = Completer<String>();
      var requests = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'authenticate') {
          requests++;
          return pending.future;
        }
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      final session = await OAuth2CallbackService.createSession(
        authorizationTimeout: const Duration(milliseconds: 20),
      );
      Object? outcome;
      var completions = 0;
      final operation = session
          .authorize(
            authorizationUrl: Uri.parse('https://example.test/authorize'),
            expectedState: 'test-state',
          )
          .then<void>(
            (value) {
              outcome = value;
              completions++;
            },
            onError: (Object error) {
              outcome = error;
              completions++;
            },
          );
      await tester.pump();
      expect(requests, 1);
      await tester.pump(const Duration(milliseconds: 19));
      expect(completions, 0);
      await tester.pump(const Duration(milliseconds: 1));
      final timedOut = outcome is OAuth2AuthorizationTimedOut;
      pending.complete('${session.redirectUrl}?code=late&state=test-state');
      await tester.pump();
      await operation;
      await session.close();
      expect(timedOut, isTrue);
      expect(outcome, isA<OAuth2AuthorizationTimedOut>());
      expect(completions, 1);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
    // Run with --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://example.test.
    skip: !OAuth2CallbackConfig.hasMobileOrigin,
  );
}
