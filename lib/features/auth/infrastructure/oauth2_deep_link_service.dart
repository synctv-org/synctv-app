import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:url_launcher/url_launcher.dart';

enum OAuth2CallbackTransport { appleAuthenticationSession, loopback, appLink }

class OAuth2DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static final StreamController<Uri> _callbacks =
      StreamController<Uri>.broadcast();

  static StreamSubscription<Uri>? _subscription;
  static bool _initialized = false;
  static String? _lastCallback;

  static Stream<Uri> get callbacks => _callbacks.stream;
  static String get mobileCallbackUrl => OAuth2CallbackConfig.mobileCallbackUrl;
  static bool get canCreateSession =>
      _callbackTransport == OAuth2CallbackTransport.loopback ||
      OAuth2CallbackConfig.hasMobileOrigin;

  static Future<OAuth2CallbackSession> createSession() async {
    if (_callbackTransport ==
        OAuth2CallbackTransport.appleAuthenticationSession) {
      return _AppleOAuth2CallbackSession(
        redirectUri: Uri.parse(mobileCallbackUrl),
      );
    }

    if (_callbackTransport == OAuth2CallbackTransport.loopback) {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      return _NativeOAuth2CallbackSession(
        redirectUrl: 'http://127.0.0.1:${server.port}/oauth2/callback',
        waitForCallback: (expectedState, timeout) {
          return _waitForLoopbackCallback(
            server: server,
            expectedState: expectedState,
            timeout: timeout,
          );
        },
        close: () async {
          await server.close(force: true);
        },
      );
    }

    await initialize();
    return _NativeOAuth2CallbackSession(
      redirectUrl: mobileCallbackUrl,
      waitForCallback: (expectedState, timeout) {
        return waitForCallback(expectedState: expectedState, timeout: timeout);
      },
      close: () async {},
    );
  }

  static Future<void> initialize() async {
    if (_initialized) return;
    if (_callbackTransport != OAuth2CallbackTransport.appLink ||
        !OAuth2CallbackConfig.hasMobileOrigin) {
      return;
    }
    _initialized = true;

    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (error) {
        debugPrint('OAuth2 app link stream error: $error');
      },
    );

    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _handleUri(initial);
    } catch (e) {
      debugPrint('OAuth2 initial app link read error: $e');
    }
  }

  static Future<OAuth2CallbackPayload> waitForCallback({
    required String expectedState,
    Duration timeout = const Duration(minutes: 5),
  }) async {
    await initialize();
    final completer = Completer<OAuth2CallbackPayload>();
    late StreamSubscription<Uri> subscription;
    Timer? timer;

    Future<void> finishWithError(Object error) async {
      if (completer.isCompleted) return;
      timer?.cancel();
      await subscription.cancel();
      completer.completeError(error);
    }

    Future<void> finish(OAuth2CallbackPayload payload) async {
      if (completer.isCompleted) return;
      timer?.cancel();
      await subscription.cancel();
      completer.complete(payload);
    }

    subscription = callbacks.listen((uri) async {
      try {
        final payload = OAuth2CallbackParser.parse(uri);
        if (payload.state != expectedState) return;
        await finish(payload);
      } catch (error) {
        await finishWithError(error);
      }
    });

    timer = Timer(timeout, () {
      finishWithError(TimeoutException('OAuth2 授权超时，请重新发起登录'));
    });

    return completer.future;
  }

  static bool isOAuth2Callback(Uri uri) {
    return OAuth2CallbackConfig.isMobileCallbackUri(uri);
  }

  static OAuth2CallbackTransport get _callbackTransport =>
      callbackTransportFor(defaultTargetPlatform);

  @visibleForTesting
  static OAuth2CallbackTransport callbackTransportFor(
    TargetPlatform platform,
  ) => switch (platform) {
    TargetPlatform.iOS ||
    TargetPlatform.macOS => OAuth2CallbackTransport.appleAuthenticationSession,
    TargetPlatform.windows ||
    TargetPlatform.linux => OAuth2CallbackTransport.loopback,
    TargetPlatform.android ||
    TargetPlatform.fuchsia => OAuth2CallbackTransport.appLink,
  };

  static Future<OAuth2CallbackPayload> _waitForLoopbackCallback({
    required HttpServer server,
    required String expectedState,
    required Duration timeout,
  }) async {
    final completer = Completer<OAuth2CallbackPayload>();
    Timer? timer;
    StreamSubscription<HttpRequest>? subscription;

    Future<void> finishWithError(Object error) async {
      if (completer.isCompleted) return;
      timer?.cancel();
      await subscription?.cancel();
      await server.close(force: true);
      completer.completeError(error);
    }

    Future<void> finish(
      HttpRequest request,
      OAuth2CallbackPayload payload,
    ) async {
      if (completer.isCompleted) return;
      timer?.cancel();
      await _writeLoopbackResponse(request, success: true);
      await subscription?.cancel();
      await server.close(force: true);
      completer.complete(payload);
    }

    subscription = server.listen((request) async {
      try {
        if (request.method != 'GET' || request.uri.path != '/oauth2/callback') {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
          return;
        }
        final callbackUri = Uri.parse(
          'http://${request.headers.host ?? '127.0.0.1'}${request.uri}',
        );
        final payload = OAuth2CallbackParser.parse(
          callbackUri,
          expectedState: expectedState,
        );
        await finish(request, payload);
      } catch (error) {
        await _writeLoopbackResponse(request, success: false);
        await finishWithError(error);
      }
    }, onError: finishWithError);

    timer = Timer(timeout, () {
      finishWithError(TimeoutException('OAuth2 授权超时，请重新发起登录'));
    });

    return completer.future;
  }

  static Future<void> _writeLoopbackResponse(
    HttpRequest request, {
    required bool success,
  }) async {
    final title = success ? 'SyncTV 授权完成' : 'SyncTV 授权失败';
    final message = success ? '授权已完成，可以返回 SyncTV。' : '授权失败，请返回 SyncTV 重试。';
    request.response
      ..statusCode = success ? HttpStatus.ok : HttpStatus.badRequest
      ..headers.contentType = ContentType.html
      ..write(
        '<!doctype html><html><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        '<title>${htmlEscape.convert(title)}</title></head>'
        '<body style="font-family:system-ui,sans-serif;margin:48px;line-height:1.5">'
        '<h1>${htmlEscape.convert(title)}</h1>'
        '<p>${htmlEscape.convert(message)}</p></body></html>',
      );
    await request.response.close();
  }

  static void _handleUri(Uri uri) {
    if (!isOAuth2Callback(uri)) return;
    final value = uri.toString();
    if (_lastCallback == value) return;
    _lastCallback = value;
    _callbacks.add(uri);
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}

final class _NativeOAuth2CallbackSession implements OAuth2CallbackSession {
  const _NativeOAuth2CallbackSession({
    required this.redirectUrl,
    required this._waitForCallback,
    required this._close,
  });

  @override
  final String redirectUrl;
  final Future<OAuth2CallbackPayload> Function(String, Duration)
  _waitForCallback;
  final Future<void> Function() _close;

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    final opened = await launchUrl(
      authorizationUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      throw StateError('Failed to open the authorization page');
    }
    return _waitForCallback(expectedState, const Duration(minutes: 5));
  }

  @override
  Future<void> close() => _close();
}

final class _AppleOAuth2CallbackSession implements OAuth2CallbackSession {
  const _AppleOAuth2CallbackSession({required this.redirectUri});

  final Uri redirectUri;

  @override
  String get redirectUrl => redirectUri.toString();

  @override
  Future<OAuth2CallbackPayload> authorize({
    required Uri authorizationUrl,
    required String expectedState,
  }) async {
    try {
      final callback = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: 'https',
        options: FlutterWebAuth2Options(
          httpsHost: redirectUri.host,
          httpsPath: redirectUri.path,
        ),
      );
      return OAuth2CallbackParser.parse(
        Uri.parse(callback),
        expectedState: expectedState,
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

final class NativeOAuth2CallbackClient implements OAuth2CallbackClient {
  const NativeOAuth2CallbackClient();

  @override
  bool get canCreateSession => OAuth2DeepLinkService.canCreateSession;

  @override
  Future<OAuth2CallbackSession> createSession() =>
      OAuth2DeepLinkService.createSession();

  @override
  Future<void> initialize() => OAuth2DeepLinkService.initialize();
}
