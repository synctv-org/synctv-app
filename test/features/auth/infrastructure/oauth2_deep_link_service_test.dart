import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_deep_link_service.dart';

void main() {
  group('OAuth2DeepLinkService callback transport', () {
    test('uses ASWebAuthenticationSession on Apple platforms', () {
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.macOS),
        OAuth2CallbackTransport.appleAuthenticationSession,
      );
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.iOS),
        OAuth2CallbackTransport.appleAuthenticationSession,
      );
    });

    test('uses loopback callbacks on desktop browser platforms', () {
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.windows),
        OAuth2CallbackTransport.loopback,
      );
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.linux),
        OAuth2CallbackTransport.loopback,
      );
    });

    test('uses app links on other mobile platforms', () {
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.android),
        OAuth2CallbackTransport.appLink,
      );
      expect(
        OAuth2DeepLinkService.callbackTransportFor(TargetPlatform.fuchsia),
        OAuth2CallbackTransport.appLink,
      );
    });

    test('creates loopback sessions without a configured app link origin', () {
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.windows,
          hasMobileOrigin: false,
        ),
        isTrue,
      );
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.linux,
          hasMobileOrigin: false,
        ),
        isTrue,
      );
    });

    test('requires a configured app link origin for Apple sessions', () {
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.macOS,
          hasMobileOrigin: false,
        ),
        isFalse,
      );
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.iOS,
          hasMobileOrigin: true,
        ),
        isTrue,
      );
    });

    test('requires a configured app link origin for app-link sessions', () {
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.android,
          hasMobileOrigin: false,
        ),
        isFalse,
      );
      expect(
        OAuth2DeepLinkService.canCreateSessionFor(
          TargetPlatform.fuchsia,
          hasMobileOrigin: true,
        ),
        isTrue,
      );
    });
  });
}
