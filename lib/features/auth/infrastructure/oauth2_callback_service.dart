import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';

enum OAuth2CallbackTransport {
  flutterWebAuth2,
  darwinAuthenticationSession,
  unsupported,
}

class OAuth2CallbackService {
  static const String _loopbackLandingPage = '''
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>SyncTV 授权完成</title>
</head>
<body style="font-family:system-ui,sans-serif;margin:48px;line-height:1.5">
  <h1>SyncTV 授权完成</h1>
  <p>授权已完成，可以关闭此页面并返回 SyncTV。</p>
</body>
</html>
''';

  static String get mobileCallbackUrl => OAuth2CallbackConfig.mobileCallbackUrl;

  static bool get canCreateSession => canCreateSessionFor(
    defaultTargetPlatform,
    hasMobileOrigin: OAuth2CallbackConfig.hasMobileOrigin,
  );

  static Future<OAuth2CallbackSession> createSession() async {
    final platform = defaultTargetPlatform;
    final transport = callbackTransportFor(platform);
    if (transport == OAuth2CallbackTransport.unsupported) {
      throw UnsupportedError(
        'OAuth2 authorization is unavailable on $platform',
      );
    }

    late final Uri redirectUri;
    if (usesLoopbackCallback(platform)) {
      try {
        final port = await _findAvailableLoopbackPort();
        redirectUri = Uri(
          scheme: 'http',
          host: InternetAddress.loopbackIPv4.address,
          port: port,
          path: '/oauth2/callback',
        );
      } on SocketException catch (error) {
        throw OAuth2CallbackBindFailed(error);
      }
    } else {
      redirectUri = Uri.parse(mobileCallbackUrl);
    }

    return switch (transport) {
      OAuth2CallbackTransport.flutterWebAuth2 =>
        _FlutterWebAuth2CallbackSession(
          redirectUri: redirectUri,
          usesLoopbackCallback: usesLoopbackCallback(platform),
          callbackUrlScheme: callbackUrlSchemeFor(platform, redirectUri),
          options: optionsFor(platform, redirectUri),
        ),
      OAuth2CallbackTransport.darwinAuthenticationSession =>
        _DarwinOAuth2CallbackSession(redirectUri),
      OAuth2CallbackTransport.unsupported => throw StateError(
        'Unsupported OAuth2 callback transport',
      ),
    };
  }

  @visibleForTesting
  static OAuth2CallbackTransport callbackTransportFor(TargetPlatform platform) {
    return switch (platform) {
      TargetPlatform.android ||
      TargetPlatform.linux ||
      TargetPlatform.windows => OAuth2CallbackTransport.flutterWebAuth2,
      TargetPlatform.iOS || TargetPlatform.macOS =>
        OAuth2CallbackTransport.darwinAuthenticationSession,
      TargetPlatform.fuchsia => OAuth2CallbackTransport.unsupported,
    };
  }

  @visibleForTesting
  static bool canCreateSessionFor(
    TargetPlatform platform, {
    required bool hasMobileOrigin,
  }) {
    if (callbackTransportFor(platform) == OAuth2CallbackTransport.unsupported) {
      return false;
    }
    return usesLoopbackCallback(platform) || hasMobileOrigin;
  }

  @visibleForTesting
  static bool usesLoopbackCallback(TargetPlatform platform) {
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux;
  }

  @visibleForTesting
  static String callbackUrlSchemeFor(TargetPlatform platform, Uri redirectUri) {
    return usesLoopbackCallback(platform)
        ? redirectUri.toString()
        : redirectUri.scheme;
  }

  @visibleForTesting
  static FlutterWebAuth2Options optionsFor(
    TargetPlatform platform,
    Uri redirectUri,
  ) {
    if (usesLoopbackCallback(platform)) {
      return const FlutterWebAuth2Options(
        useWebview: false,
        timeout: 5 * 60,
        landingPageHtml: _loopbackLandingPage,
      );
    }
    return FlutterWebAuth2Options(
      httpsHost: redirectUri.host,
      httpsPath: redirectUri.path,
    );
  }

  static Future<int> _findAvailableLoopbackPort() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    try {
      return server.port;
    } finally {
      await server.close(force: true);
    }
  }
}

final class _FlutterWebAuth2CallbackSession implements OAuth2CallbackSession {
  const _FlutterWebAuth2CallbackSession({
    required this.redirectUri,
    required this.usesLoopbackCallback,
    required this.callbackUrlScheme,
    required this.options,
  });

  final Uri redirectUri;
  final bool usesLoopbackCallback;
  final String callbackUrlScheme;
  final FlutterWebAuth2Options options;

  @override
  String get redirectUrl => redirectUri.toString();

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    try {
      final callback =
          await FlutterWebAuth2.authenticate(
            url: authorizationUrl.toString(),
            callbackUrlScheme: callbackUrlScheme,
            options: options,
          ).timeout(
            oauth2AuthorizationTimeout,
            onTimeout: () => throw const OAuth2AuthorizationTimedOut(),
          );
      return OAuth2CallbackParser.parse(
        Uri.parse(callback),
        expectedState: expectedState,
      );
    } on SocketException catch (error) {
      if (usesLoopbackCallback) {
        throw OAuth2CallbackBindFailed(error);
      }
      rethrow;
    } on PlatformException catch (error) {
      if (error.code == 'CANCELED') {
        throw const OAuth2AuthorizationCanceled();
      }
      rethrow;
    }
  }
}

final class _DarwinOAuth2CallbackSession implements OAuth2CallbackSession {
  const _DarwinOAuth2CallbackSession(this.redirectUri);

  static const MethodChannel _channel = MethodChannel(
    'org.synctv.app/darwin_oauth2',
  );

  final Uri redirectUri;

  @override
  String get redirectUrl => redirectUri.toString();

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    try {
      final callback = await _channel.invokeMethod<String>('authorize', {
        'url': authorizationUrl.toString(),
        'callbackHost': redirectUri.host,
        'callbackPath': redirectUri.path,
        'timeoutSeconds': oauth2AuthorizationTimeout.inSeconds,
      });
      if (callback == null || callback.isEmpty) {
        throw PlatformException(
          code: 'EMPTY_CALLBACK',
          message: 'The OAuth2 callback URL was empty',
        );
      }
      return OAuth2CallbackParser.parse(
        Uri.parse(callback),
        expectedState: expectedState,
      );
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'CANCELED':
          throw const OAuth2AuthorizationCanceled();
        case 'TIMED_OUT':
          throw const OAuth2AuthorizationTimedOut();
        default:
          rethrow;
      }
    }
  }
}

/// Starts Apple's first-party Authentication Services flow. The native
/// controller returns the authorization code directly, so no browser callback
/// URL is involved.
final class PlatformNativeAppleSignInClient
    implements NativeAppleSignInClient {
  const PlatformNativeAppleSignInClient();

  static const MethodChannel _channel = MethodChannel(
    'org.synctv.app/apple_sign_in',
  );

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Future<OAuth2CallbackPayload> authorize({
    required String expectedState,
    required String nonce,
  }) async {
    try {
      final response = await _channel.invokeMethod<Map<Object?, Object?>>(
        'authorize',
        {'state': expectedState, 'nonce': nonce},
      );
      final code = response?['code']?.toString().trim() ?? '';
      final state = response?['state']?.toString().trim() ?? '';
      if (code.isEmpty || state.isEmpty || state != expectedState) {
        throw ArgumentError('Apple authorization state is invalid');
      }
      return OAuth2CallbackPayload(code: code, state: state);
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'CANCELED':
          throw const OAuth2AuthorizationCanceled();
        case 'TIMED_OUT':
          throw const OAuth2AuthorizationTimedOut();
        default:
          rethrow;
      }
    }
  }
}

final class FlutterWebAuth2CallbackClient implements OAuth2CallbackClient {
  const FlutterWebAuth2CallbackClient();

  @override
  bool get canCreateSession => OAuth2CallbackService.canCreateSession;

  @override
  Future<OAuth2CallbackSession> createSession() {
    return OAuth2CallbackService.createSession();
  }
}
