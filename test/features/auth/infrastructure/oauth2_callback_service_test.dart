import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';

void main() {
  group('OAuth2CallbackService callback transport', () {
    test('uses flutter_web_auth_2 on Android and Linux', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.android,
        TargetPlatform.linux,
      ]) {
        expect(
          OAuth2CallbackService.callbackTransportFor(platform),
          OAuth2CallbackTransport.flutterWebAuth2,
        );
      }
    });

    test('uses an owned loopback HTTP server on Windows', () {
      expect(
        OAuth2CallbackService.callbackTransportFor(TargetPlatform.windows),
        OAuth2CallbackTransport.loopbackHttpServer,
      );
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

    test('creates IPv4 desktop callback URIs', () async {
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      for (final platform in <TargetPlatform>[
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        debugDefaultTargetPlatformOverride = platform;

        final session = await OAuth2CallbackService.createSession();
        try {
          final redirectUri = Uri.parse(session.redirectUrl);

          expect(redirectUri.scheme, 'http');
          expect(redirectUri.host, '127.0.0.1');
          expect(redirectUri.port, greaterThan(0));
          expect(redirectUri.path, '/oauth2/callback');
        } finally {
          await session.close();
        }
      }
    });

    test('receives and closes a Windows loopback callback', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final browserLaunched = Completer<void>();
      late Uri launchedAuthorizationUrl;
      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (authorizationUrl) async {
          launchedAuthorizationUrl = authorizationUrl;
          browserLaunched.complete();
          return true;
        },
      );
      addTearDown(session.close);

      const expectedState = 'expected-state';
      final authorizationUrl = Uri.parse(
        'https://auth.example.com/authorize',
      );
      final authorization = session.authorize(
        authorizationUrl: authorizationUrl,
        expectedState: expectedState,
      );
      await browserLaunched.future;
      expect(launchedAuthorizationUrl, authorizationUrl);

      final callbackUri = Uri.parse(session.redirectUrl).replace(
        queryParameters: const {
          'code': 'authorization-code',
          'state': expectedState,
        },
      );
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final request = await client.getUrl(callbackUri);
      final response = await request.close();
      final responseBody = await utf8.decoder.bind(response).join();

      final payload = await authorization;
      expect(response.statusCode, HttpStatus.ok);
      expect(responseBody, contains('SyncTV'));
      expect(payload.code, 'authorization-code');
      expect(payload.state, expectedState);
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

    test('uses a system browser and full loopback URL on Linux', () {
      final redirectUri = Uri.parse('http://127.0.0.1:49152/oauth2/callback');
      final options = OAuth2CallbackService.optionsFor(
        TargetPlatform.linux,
        redirectUri,
      );

      expect(
        OAuth2CallbackService.callbackUrlSchemeFor(
          TargetPlatform.linux,
          redirectUri,
        ),
        redirectUri.toString(),
      );
      expect(options.useWebview, isFalse);
      expect(options.timeout, 300);
      expect(options.landingPageHtml, contains('SyncTV'));
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
