import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';

enum OAuth2CallbackTransport {
  flutterWebAuth2,
  loopbackHttpServer,
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

  static bool get canCreateSession => kIsWeb
      ? canCreateWebSessionFor(Uri.base)
      : canCreateSessionFor(
          defaultTargetPlatform,
          hasMobileOrigin: OAuth2CallbackConfig.hasMobileOrigin,
        );

  static Future<OAuth2CallbackSession> createSession({
    Future<bool> Function(Uri authorizationUrl)? launchExternalUrl,
    Future<void> Function()? activateAppWindow,
    Duration authorizationTimeout = oauth2AuthorizationTimeout,
  }) async {
    if (kIsWeb) {
      if (!canCreateWebSessionFor(Uri.base)) {
        throw UnsupportedError(
          'OAuth2 requires HTTPS or a loopback origin in a browser.',
        );
      }
      final redirectUri = webRedirectUri(Uri.base);
      return _FlutterWebAuth2CallbackSession(
        redirectUri: redirectUri,
        callbackUrlScheme: redirectUri.scheme,
        options: optionsFor(redirectUri),
      );
    }

    final platform = defaultTargetPlatform;
    final transport = callbackTransportFor(platform);
    if (transport == OAuth2CallbackTransport.unsupported) {
      throw UnsupportedError(
        'OAuth2 authorization is unavailable on $platform',
      );
    }

    late final Uri redirectUri;
    HttpServer? loopbackServer;
    if (transport == OAuth2CallbackTransport.loopbackHttpServer) {
      try {
        loopbackServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        redirectUri = loopbackRedirectUriForPort(loopbackServer.port);
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
          callbackUrlScheme: callbackUrlSchemeFor(redirectUri),
          options: optionsFor(redirectUri),
        ),
      OAuth2CallbackTransport.loopbackHttpServer =>
        _LoopbackHttpCallbackSession(
          server: loopbackServer!,
          redirectUri: redirectUri,
          launchExternalUrl: launchExternalUrl ?? _launchExternalUrl,
          activateAppWindow: activateAppWindow ?? _activateAppWindow,
          authorizationTimeout: authorizationTimeout,
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
      TargetPlatform.android => OAuth2CallbackTransport.flutterWebAuth2,
      TargetPlatform.windows ||
      TargetPlatform.linux => OAuth2CallbackTransport.loopbackHttpServer,
      TargetPlatform.iOS || TargetPlatform.macOS =>
        OAuth2CallbackTransport.darwinAuthenticationSession,
      TargetPlatform.fuchsia => OAuth2CallbackTransport.unsupported,
    };
  }

  @visibleForTesting
  static bool canCreateWebSessionFor(Uri pageUri) {
    if (pageUri.host.isEmpty) return false;
    if (pageUri.scheme == 'https') return true;
    return pageUri.scheme == 'http' && _isLoopbackHost(pageUri.host);
  }

  @visibleForTesting
  static Uri webRedirectUri(Uri pageUri) {
    return Uri.parse(pageUri.origin).replace(path: '/oauth2/callback');
  }

  static bool _isLoopbackHost(String host) {
    final normalized = host.toLowerCase();
    return normalized == 'localhost' ||
        normalized == '127.0.0.1' ||
        normalized == '::1' ||
        normalized == '[::1]';
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
  static Uri loopbackRedirectUriForPort(int port) {
    return Uri(
      scheme: 'http',
      host: InternetAddress.loopbackIPv4.address,
      port: port,
      path: '/oauth2/callback',
    );
  }

  @visibleForTesting
  static String callbackUrlSchemeFor(Uri redirectUri) => redirectUri.scheme;

  @visibleForTesting
  static FlutterWebAuth2Options optionsFor(Uri redirectUri) {
    return FlutterWebAuth2Options(
      httpsHost: redirectUri.host,
      httpsPath: redirectUri.path,
    );
  }

  static Future<bool> _launchExternalUrl(Uri authorizationUrl) {
    return launchUrl(authorizationUrl, mode: LaunchMode.externalApplication);
  }

  static Future<void> _activateAppWindow() => WindowToFront.activate();
}

final class _LoopbackHttpCallbackSession implements OAuth2CallbackSession {
  _LoopbackHttpCallbackSession({
    required this._server,
    required this.redirectUri,
    required this.launchExternalUrl,
    required this.activateAppWindow,
    required this.authorizationTimeout,
  });

  final HttpServer _server;
  final Uri redirectUri;
  final Future<bool> Function(Uri authorizationUrl) launchExternalUrl;
  final Future<void> Function() activateAppWindow;
  final Duration authorizationTimeout;
  Future<void>? _closeFuture;
  bool _callbackAccepted = false;

  @override
  String get redirectUrl => redirectUri.toString();

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    final callback = Completer<_LoopbackCallbackResult>();
    final requests = _server.listen(
      (request) => unawaited(
        _handleRequest(
          request,
          expectedState: expectedState,
          callback: callback,
        ).catchError((Object error, StackTrace stackTrace) {
          if (!callback.isCompleted) {
            callback.completeError(error, stackTrace);
            return;
          }
          debugPrint('Failed to handle an OAuth2 callback request: $error');
        }),
      ),
      onError: (Object error, StackTrace stackTrace) {
        if (!callback.isCompleted) callback.completeError(error, stackTrace);
      },
      onDone: () {
        if (!callback.isCompleted) {
          callback.completeError(const OAuth2AuthorizationCanceled());
        }
      },
    );
    try {
      final launch = () async {
        final launched = await launchExternalUrl(authorizationUrl);
        if (!launched) {
          throw PlatformException(
            code: 'LAUNCH_FAILED',
            message: 'The system browser could not be opened',
          );
        }
      }();
      final results =
          await Future.wait<Object?>([
            launch,
            callback.future,
          ], eagerError: true).timeout(
            authorizationTimeout,
            onTimeout: () => throw const OAuth2AuthorizationTimedOut(),
          );
      final result = results[1]! as _LoopbackCallbackResult;
      await close();
      try {
        await activateAppWindow();
      } catch (error) {
        debugPrint('Failed to activate the app after OAuth2 callback: $error');
      }
      return switch (result) {
        _LoopbackCallbackSuccess(:final payload) => payload,
        _LoopbackCallbackFailure(:final error, :final stackTrace) =>
          Error.throwWithStackTrace(error, stackTrace),
      };
    } finally {
      await requests.cancel();
      await close();
    }
  }

  Future<void> _handleRequest(
    HttpRequest request, {
    required String expectedState,
    required Completer<_LoopbackCallbackResult> callback,
  }) async {
    if (request.uri.path != redirectUri.path) {
      await _respond(request, HttpStatus.notFound, 'Not found.');
      return;
    }

    final parameters = request.uri.queryParameters;
    final authorizationError = parameters['error']?.trim() ?? '';
    if (authorizationError.isNotEmpty) {
      final state = parameters['state']?.trim() ?? '';
      if (state.isEmpty ||
          (expectedState.isNotEmpty && state != expectedState)) {
        await _respond(
          request,
          HttpStatus.badRequest,
          'Invalid OAuth2 callback.',
        );
        return;
      }
      if (_callbackAccepted) {
        await _respond(
          request,
          HttpStatus.conflict,
          'Callback already received.',
        );
        return;
      }
      _callbackAccepted = true;
      await _respond(
        request,
        HttpStatus.ok,
        'OAuth2 authorization was canceled.',
      );
      if (!callback.isCompleted) {
        if (authorizationError == 'access_denied') {
          callback.complete(
            _LoopbackCallbackFailure(
              const OAuth2AuthorizationCanceled(),
              StackTrace.current,
            ),
          );
        } else {
          final description = parameters['error_description']?.trim();
          callback.complete(
            _LoopbackCallbackFailure(
              PlatformException(
                code: 'AUTHORIZATION_FAILED',
                message: description == null || description.isEmpty
                    ? authorizationError
                    : description,
                details: authorizationError,
              ),
              StackTrace.current,
            ),
          );
        }
      }
      return;
    }

    late final OAuth2CallbackPayload payload;
    try {
      payload = OAuth2CallbackParser.parse(
        request.requestedUri,
        expectedState: expectedState,
      );
    } on ArgumentError {
      await _respond(
        request,
        HttpStatus.badRequest,
        'Invalid OAuth2 callback.',
      );
      return;
    }

    if (_callbackAccepted) {
      await _respond(
        request,
        HttpStatus.conflict,
        'Callback already received.',
      );
      return;
    }
    _callbackAccepted = true;

    try {
      request.response.headers.contentType = ContentType.html;
      request.response.write(OAuth2CallbackService._loopbackLandingPage);
      await request.response.close();
    } on IOException catch (error) {
      debugPrint('Failed to send the OAuth2 landing page: $error');
    }
    if (!callback.isCompleted) {
      callback.complete(_LoopbackCallbackSuccess(payload));
    }
  }

  Future<void> _respond(HttpRequest request, int status, String body) async {
    try {
      request.response.statusCode = status;
      request.response.write(body);
      await request.response.close();
    } on IOException {
      // The client can disconnect after delivering a request. A later valid
      // OAuth callback must remain eligible to complete the session.
    }
  }

  @override
  Future<void> close() => _closeFuture ??= _closeServer();

  Future<void> _closeServer() async => _server.close(force: true);
}

sealed class _LoopbackCallbackResult {
  const _LoopbackCallbackResult();
}

final class _LoopbackCallbackSuccess extends _LoopbackCallbackResult {
  const _LoopbackCallbackSuccess(this.payload);

  final OAuth2CallbackPayload payload;
}

final class _LoopbackCallbackFailure extends _LoopbackCallbackResult {
  const _LoopbackCallbackFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

final class _FlutterWebAuth2CallbackSession implements OAuth2CallbackSession {
  const _FlutterWebAuth2CallbackSession({
    required this.redirectUri,
    required this.callbackUrlScheme,
    required this.options,
  });

  final Uri redirectUri;
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
        expectedRedirectUri: redirectUri,
      );
    } on PlatformException catch (error) {
      if (error.code == 'CANCELED') {
        throw const OAuth2AuthorizationCanceled();
      }
      rethrow;
    }
  }

  @override
  Future<void> close() async {}
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

  @override
  Future<void> close() async {}
}

/// Starts Apple's first-party Authentication Services flow. The native
/// controller returns the authorization code directly, so no browser callback
/// URL is involved.
final class PlatformNativeAppleSignInClient implements NativeAppleSignInClient {
  const PlatformNativeAppleSignInClient();

  static const _buildEnabled = bool.fromEnvironment(
    'SYNCTV_NATIVE_APPLE_SIGN_IN',
    defaultValue: true,
  );

  static const MethodChannel _channel = MethodChannel(
    'org.synctv.app/apple_sign_in',
  );

  @override
  bool get isSupported =>
      _buildEnabled &&
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
