@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/providers/infrastructure/desktop_web_verification_client_web.dart';
import 'package:web/web.dart' as web;

void main() {
  const client = NativeDesktopWebVerificationClient();

  test('uses an isolated iframe and cleans up after cancellation', () async {
    final root = web.document.documentElement as web.HTMLElement;
    final previousOverflow = root.style.overflow;
    final verification = client.verify(
      html: '<html></html>',
      bridgeName: 'SyncTVGeetest',
      title: 'Bilibili verification',
      windowWidth: 460,
      windowHeight: 620,
      timeout: const Duration(seconds: 2),
      browserPath: 'provider_verification.html',
      browserFragmentParameters: const {
        'gt': 'gt value',
        'challenge': 'challenge/value',
      },
    );

    final overlay = web.document.querySelector(
      '[data-synctv-provider-verification]',
    );
    expect(overlay, isNotNull);
    expect(root.style.overflow, 'hidden');

    final frame = overlay!.querySelector('iframe') as web.HTMLIFrameElement;
    expect(frame.sandbox.contains('allow-scripts'), isTrue);
    expect(frame.sandbox.contains('allow-same-origin'), isFalse);
    final uri = Uri.parse(frame.src);
    expect(uri.path, endsWith('/provider_verification.html'));
    expect(uri.fragment, contains('gt=gt+value'));
    expect(uri.fragment, contains('challenge=challenge%2Fvalue'));
    expect(uri.fragment, contains('token='));

    await expectLater(
      client.verify(
        html: '<html></html>',
        bridgeName: 'SyncTVGeetest',
        title: 'Second verification',
        windowWidth: 460,
        windowHeight: 620,
        timeout: const Duration(seconds: 2),
        browserPath: 'provider_verification.html',
      ),
      throwsA(isA<StateError>()),
    );

    (overlay.querySelector('button') as web.HTMLButtonElement).click();
    await expectLater(verification, throwsA(isA<StateError>()));
    await Future<void>.delayed(Duration.zero);

    expect(
      web.document.querySelector('[data-synctv-provider-verification]'),
      isNull,
    );
    expect(root.style.overflow, previousOverflow);
  });

  test('requires an explicit browser verification page', () async {
    await expectLater(
      client.verify(
        html: '<html></html>',
        bridgeName: 'SyncTVGeetest',
        title: 'Bilibili verification',
        windowWidth: 460,
        windowHeight: 620,
        timeout: const Duration(seconds: 1),
      ),
      throwsUnsupportedError,
    );
  });
}
