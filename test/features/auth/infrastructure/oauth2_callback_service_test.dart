import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';

void main() {
  group('OAuth2CallbackService callback transport', () {
    test('uses flutter_web_auth_2 on Android, Windows, and Linux', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.android,
        TargetPlatform.linux,
        TargetPlatform.windows,
      ]) {
        expect(
          OAuth2CallbackService.callbackTransportFor(platform),
          OAuth2CallbackTransport.flutterWebAuth2,
        );
      }
    });

    test('uses cancellable AuthenticationServices sessions on Apple', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      ]) {
        expect(
          OAuth2CallbackService.callbackTransportFor(platform),
          OAuth2CallbackTransport.darwinAuthenticationSession,
        );
      }
    });

    test('marks Fuchsia as unsupported', () {
      expect(
        OAuth2CallbackService.callbackTransportFor(TargetPlatform.fuchsia),
        OAuth2CallbackTransport.unsupported,
      );
      expect(
        OAuth2CallbackService.canCreateSessionFor(
          TargetPlatform.fuchsia,
          hasMobileOrigin: true,
        ),
        isFalse,
      );
    });

    test('creates desktop sessions without a mobile callback origin', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        expect(
          OAuth2CallbackService.canCreateSessionFor(
            platform,
            hasMobileOrigin: false,
          ),
          isTrue,
        );
      }
    });

    test('requires a callback origin on Android and Apple platforms', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      ]) {
        expect(
          OAuth2CallbackService.canCreateSessionFor(
            platform,
            hasMobileOrigin: false,
          ),
          isFalse,
        );
        expect(
          OAuth2CallbackService.canCreateSessionFor(
            platform,
            hasMobileOrigin: true,
          ),
          isTrue,
        );
      }
    });

    test('uses a system browser and full loopback URL on desktop', () {
      final redirectUri = Uri.parse('http://127.0.0.1:49152/oauth2/callback');

      for (final platform in <TargetPlatform>[
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        final options = OAuth2CallbackService.optionsFor(platform, redirectUri);
        expect(
          OAuth2CallbackService.callbackUrlSchemeFor(platform, redirectUri),
          redirectUri.toString(),
        );
        expect(options.useWebview, isFalse);
        expect(options.timeout, 300);
        expect(options.landingPageHtml, contains('SyncTV'));
      }
    });

    test('uses HTTPS host and path options on mobile and Apple platforms', () {
      final redirectUri = Uri.parse('https://app.syncs.tv/oauth2/callback');

      for (final platform in <TargetPlatform>[
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      ]) {
        final options = OAuth2CallbackService.optionsFor(platform, redirectUri);
        expect(
          OAuth2CallbackService.callbackUrlSchemeFor(platform, redirectUri),
          'https',
        );
        expect(options.httpsHost, 'app.syncs.tv');
        expect(options.httpsPath, '/oauth2/callback');
      }
    });
  });
}
