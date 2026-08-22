import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';

void main() {
  group('OAuth2CallbackService callback transport', () {
    test('uses flutter_web_auth_2 on Android', () {
      expect(
        OAuth2CallbackService.callbackTransportFor(TargetPlatform.android),
        OAuth2CallbackTransport.flutterWebAuth2,
      );
    });

    test('uses an owned loopback HTTP server on desktop platforms', () {
      for (final platform in <TargetPlatform>[
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        expect(
          OAuth2CallbackService.callbackTransportFor(platform),
          OAuth2CallbackTransport.loopbackHttpServer,
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

    test('web callbacks stay on the deployment origin', () {
      expect(
        OAuth2CallbackService.webRedirectUri(
          Uri.parse('https://app.example.test/room?id=1#player'),
        ),
        Uri.parse('https://app.example.test/oauth2/callback'),
      );
      expect(
        OAuth2CallbackService.canCreateWebSessionFor(
          Uri.parse('https://app.example.test/'),
        ),
        isTrue,
      );
      expect(
        OAuth2CallbackService.canCreateWebSessionFor(
          Uri.parse('http://127.0.0.1:8080/'),
        ),
        isTrue,
      );
      expect(
        OAuth2CallbackService.canCreateWebSessionFor(
          Uri.parse('http://app.example.test/'),
        ),
        isFalse,
      );
    });

    test('accepts the exact Web callback URL and rejects another origin', () {
      final redirectUri = Uri.parse('https://app.example.test/oauth2/callback');
      final payload = OAuth2CallbackParser.parse(
        redirectUri.replace(
          queryParameters: const {
            'code': 'authorization-code',
            'state': 'expected-state',
          },
        ),
        expectedState: 'expected-state',
        expectedRedirectUri: redirectUri,
      );

      expect(payload.code, 'authorization-code');
      expect(payload.state, 'expected-state');
      expect(
        () => OAuth2CallbackParser.parse(
          Uri.parse(
            'https://other.example.test/oauth2/callback?code=code&state=expected-state',
          ),
          expectedState: 'expected-state',
          expectedRedirectUri: redirectUri,
        ),
        throwsArgumentError,
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

    test(
      'retains each desktop callback port until the session closes',
      () async {
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
            await expectLater(
              HttpServer.bind(InternetAddress.loopbackIPv4, redirectUri.port),
              throwsA(isA<SocketException>()),
            );
          } finally {
            await session.close();
          }

          final rebound = await HttpServer.bind(
            InternetAddress.loopbackIPv4,
            Uri.parse(session.redirectUrl).port,
          );
          await rebound.close(force: true);
        }
      },
    );

    for (final platform in <TargetPlatform>[
      TargetPlatform.windows,
      TargetPlatform.linux,
    ]) {
      test(
        'receives, closes, and activates after a $platform callback',
        () async {
          debugDefaultTargetPlatformOverride = platform;
          addTearDown(() => debugDefaultTargetPlatformOverride = null);

          final browserLaunched = Completer<void>();
          final appActivated = Completer<void>();
          late Uri launchedAuthorizationUrl;
          final session = await OAuth2CallbackService.createSession(
            launchExternalUrl: (authorizationUrl) async {
              launchedAuthorizationUrl = authorizationUrl;
              browserLaunched.complete();
              return true;
            },
            activateAppWindow: () async => appActivated.complete(),
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
          await appActivated.future;
          expect(response.statusCode, HttpStatus.ok);
          expect(responseBody, contains('SyncTV'));
          expect(payload.code, 'authorization-code');
          expect(payload.state, expectedState);

          final rebound = await HttpServer.bind(
            InternetAddress.loopbackIPv4,
            callbackUri.port,
          );
          await rebound.close(force: true);
        },
      );
    }

    test(
      'keeps a valid callback result when window activation fails',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);

        final browserLaunched = Completer<void>();
        final session = await OAuth2CallbackService.createSession(
          launchExternalUrl: (_) async {
            browserLaunched.complete();
            return true;
          },
          activateAppWindow: () async => throw StateError('focus failed'),
        );
        addTearDown(session.close);

        final authorization = session.authorize(
          authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
          expectedState: 'expected-state',
        );
        await browserLaunched.future;
        final callbackUri = Uri.parse(session.redirectUrl).replace(
          queryParameters: const {
            'code': 'authorization-code',
            'state': 'expected-state',
          },
        );
        final client = HttpClient();
        addTearDown(() => client.close(force: true));
        final response = await (await client.getUrl(callbackUri)).close();
        await response.drain<void>();

        final payload = await authorization;
        expect(payload.code, 'authorization-code');
      },
    );

    test('continues waiting after unrelated and invalid callbacks', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final browserLaunched = Completer<void>();
      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) async {
          browserLaunched.complete();
          return true;
        },
        activateAppWindow: () async {},
      );
      addTearDown(session.close);

      final authorization = session.authorize(
        authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
        expectedState: 'expected-state',
      );
      await browserLaunched.future;

      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final redirectUri = Uri.parse(session.redirectUrl);

      final unrelatedResponse = await (await client.getUrl(
        redirectUri.replace(path: '/favicon.ico'),
      )).close();
      await unrelatedResponse.drain<void>();
      expect(unrelatedResponse.statusCode, HttpStatus.notFound);

      final invalidResponse = await (await client.getUrl(
        redirectUri.replace(
          queryParameters: const {'code': 'stale-code', 'state': 'stale-state'},
        ),
      )).close();
      await invalidResponse.drain<void>();
      expect(invalidResponse.statusCode, HttpStatus.badRequest);

      final invalidErrorResponse = await (await client.getUrl(
        redirectUri.replace(
          queryParameters: const {
            'error': 'access_denied',
            'state': 'stale-state',
          },
        ),
      )).close();
      await invalidErrorResponse.drain<void>();
      expect(invalidErrorResponse.statusCode, HttpStatus.badRequest);

      final validResponse = await (await client.getUrl(
        redirectUri.replace(
          queryParameters: const {
            'code': 'authorization-code',
            'state': 'expected-state',
          },
        ),
      )).close();
      await validResponse.drain<void>();

      final payload = await authorization;
      expect(validResponse.statusCode, HttpStatus.ok);
      expect(payload.code, 'authorization-code');
      expect(payload.state, 'expected-state');
    });

    test('maps a state-matched access denial to cancellation', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final browserLaunched = Completer<void>();
      final appActivated = Completer<void>();
      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) async {
          browserLaunched.complete();
          return true;
        },
        activateAppWindow: () async => appActivated.complete(),
      );
      final port = Uri.parse(session.redirectUrl).port;
      final authorization = session.authorize(
        authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
        expectedState: 'expected-state',
      );
      await browserLaunched.future;

      final callbackUri = Uri.parse(session.redirectUrl).replace(
        queryParameters: const {
          'error': 'access_denied',
          'state': 'expected-state',
        },
      );
      final client = HttpClient();
      addTearDown(() => client.close(force: true));
      final response = await (await client.getUrl(callbackUri)).close();
      await response.drain<void>();

      expect(response.statusCode, HttpStatus.ok);
      await expectLater(
        authorization,
        throwsA(isA<OAuth2AuthorizationCanceled>()),
      );
      await appActivated.future;
      final rebound = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await rebound.close(force: true);
    });

    test('closes the listener when the system browser cannot launch', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) async => false,
        activateAppWindow: () async {},
      );
      final port = Uri.parse(session.redirectUrl).port;

      await expectLater(
        session.authorize(
          authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
          expectedState: 'expected-state',
        ),
        throwsA(
          isA<PlatformException>().having(
            (error) => error.code,
            'code',
            'LAUNCH_FAILED',
          ),
        ),
      );

      final rebound = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await rebound.close(force: true);
      await session.close();
    });

    test('cancels authorization when the session closes externally', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final browserLaunched = Completer<void>();
      final browserLaunchResult = Completer<bool>();
      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) {
          browserLaunched.complete();
          return browserLaunchResult.future;
        },
        activateAppWindow: () async {},
      );
      final authorization = session.authorize(
        authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
        expectedState: 'expected-state',
      );
      await browserLaunched.future;

      await session.close();

      await expectLater(
        authorization,
        throwsA(isA<OAuth2AuthorizationCanceled>()),
      );
      browserLaunchResult.complete(true);
    });

    test('closes the listener after authorization times out', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) async => true,
        activateAppWindow: () async {},
        authorizationTimeout: const Duration(milliseconds: 20),
      );
      final port = Uri.parse(session.redirectUrl).port;

      await expectLater(
        session.authorize(
          authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
          expectedState: 'expected-state',
        ),
        throwsA(isA<OAuth2AuthorizationTimedOut>()),
      );

      final rebound = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await rebound.close(force: true);
    });

    test('includes browser launch in the authorization timeout', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final browserLaunchStarted = Completer<void>();
      final browserLaunchResult = Completer<bool>();
      final session = await OAuth2CallbackService.createSession(
        launchExternalUrl: (_) {
          browserLaunchStarted.complete();
          return browserLaunchResult.future;
        },
        activateAppWindow: () async {},
        authorizationTimeout: const Duration(milliseconds: 20),
      );
      final port = Uri.parse(session.redirectUrl).port;

      final authorization = session.authorize(
        authorizationUrl: Uri.parse('https://auth.example.com/authorize'),
        expectedState: 'expected-state',
      );
      await browserLaunchStarted.future;
      await expectLater(
        authorization,
        throwsA(isA<OAuth2AuthorizationTimedOut>()),
      );

      final rebound = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await rebound.close(force: true);
      browserLaunchResult.complete(true);
    });

    test('shares concurrent listener close operations', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final session = await OAuth2CallbackService.createSession();
      final port = Uri.parse(session.redirectUrl).port;

      final firstClose = session.close();
      final secondClose = session.close();
      expect(identical(firstClose, secondClose), isTrue);
      await Future.wait([firstClose, secondClose]);

      final rebound = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      await rebound.close(force: true);
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

    test('uses HTTPS host and path options on mobile and Apple platforms', () {
      final redirectUri = Uri.parse('https://app.syncs.tv/oauth2/callback');
      final options = OAuth2CallbackService.optionsFor(redirectUri);

      expect(OAuth2CallbackService.callbackUrlSchemeFor(redirectUri), 'https');
      expect(options.httpsHost, 'app.syncs.tv');
      expect(options.httpsPath, '/oauth2/callback');
    });
  });
}
