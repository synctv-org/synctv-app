import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:math';

import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:synctv_app/features/providers/infrastructure/browser_verification_protocol.dart';
import 'package:web/web.dart' as web;

final class NativeDesktopWebVerificationClient
    implements DesktopWebVerificationClient {
  const NativeDesktopWebVerificationClient();

  static bool _verificationActive = false;

  @override
  bool get supported => true;

  @override
  Future<String> verify({
    required String html,
    required String bridgeName,
    required String title,
    required double windowWidth,
    required double windowHeight,
    required Duration timeout,
    String? browserPath,
    Map<String, String> browserFragmentParameters = const {},
  }) async {
    if (browserPath == null || browserPath.isEmpty) {
      throw UnsupportedError('当前验证流程未提供浏览器安全验证页面。');
    }
    if (_verificationActive) {
      throw StateError('已有安全验证正在进行');
    }
    _verificationActive = true;

    final token = _randomToken();
    final fragment = Uri(
      queryParameters: {
        ...browserFragmentParameters,
        'bridge': bridgeName,
        'token': token,
      },
    ).query;
    final verificationUri = '${Uri.base.resolve(browserPath)}#$fragment';
    final overlay = web.HTMLDivElement()
      ..setAttribute('role', 'dialog')
      ..setAttribute('aria-modal', 'true')
      ..setAttribute('aria-label', title)
      ..setAttribute('data-synctv-provider-verification', '')
      ..style.cssText =
          'position:fixed;inset:0;z-index:2147483647;display:grid;'
          'place-items:center;padding:20px;background:rgba(0,0,0,.58);';
    final frame = web.HTMLIFrameElement()
      ..title = title
      ..src = verificationUri
      ..sandbox.add('allow-scripts')
      ..style.cssText =
          'display:block;width:min(${windowWidth}px,calc(100vw - 40px));'
          'height:min(${windowHeight}px,calc(100vh - 40px));border:0;'
          'border-radius:8px;background:#f7f8fb;box-shadow:0 18px 54px rgba(0,0,0,.35);';
    final closeButton = web.HTMLButtonElement()
      ..type = 'button'
      ..textContent = 'X'
      ..title = 'Close verification'
      ..setAttribute('aria-label', 'Close verification')
      ..style.cssText =
          'position:absolute;top:12px;right:12px;width:40px;height:40px;'
          'border:0;border-radius:50%;background:#20242a;color:#fff;'
          'font:600 18px/40px sans-serif;cursor:pointer;';
    overlay
      ..appendChild(frame)
      ..appendChild(closeButton);

    final completer = Completer<String>();
    final rootElement = web.document.documentElement as web.HTMLElement?;
    final previousOverflow = rootElement?.style.overflow ?? '';
    late final web.EventListener messageListener;
    late final web.EventListener keyListener;
    late final web.EventListener closeListener;
    late final web.EventListener errorListener;

    void cancel() {
      if (!completer.isCompleted) {
        completer.completeError(StateError('Bilibili 安全验证已取消'));
      }
    }

    messageListener = ((web.Event rawEvent) {
      final event = rawEvent as web.MessageEvent;
      if (event.source != frame.contentWindow) return;
      final data = event.data?.dartify();
      try {
        final payload = parseBrowserVerificationMessage(
          data,
          expectedBridge: bridgeName,
          expectedToken: token,
        );
        if (payload != null && !completer.isCompleted) {
          completer.complete(jsonEncode(payload));
        }
      } catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      }
    }).toJS;
    keyListener = ((web.Event rawEvent) {
      final event = rawEvent as web.KeyboardEvent;
      if (event.key == 'Escape') cancel();
    }).toJS;
    closeListener = ((web.Event _) => cancel()).toJS;
    errorListener = ((web.Event _) {
      if (!completer.isCompleted) {
        completer.completeError(StateError('Bilibili 安全验证页面加载失败'));
      }
    }).toJS;

    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Bilibili 验证超时', timeout));
      }
    });
    web.window.addEventListener('message', messageListener);
    web.window.addEventListener('keydown', keyListener);
    closeButton.addEventListener('click', closeListener);
    frame.addEventListener('error', errorListener);
    rootElement?.style.overflow = 'hidden';
    web.document.body?.appendChild(overlay);
    frame.focus();

    try {
      return await completer.future;
    } finally {
      timer.cancel();
      web.window.removeEventListener('message', messageListener);
      web.window.removeEventListener('keydown', keyListener);
      closeButton.removeEventListener('click', closeListener);
      frame.removeEventListener('error', errorListener);
      overlay.remove();
      rootElement?.style.overflow = previousOverflow;
      _verificationActive = false;
    }
  }
}

String _randomToken() {
  final random = Random.secure();
  final bytes = List<int>.generate(24, (_) => random.nextInt(256));
  return base64UrlEncode(bytes).replaceAll('=', '');
}
