import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BilibiliGeetestResult {
  final String validate;

  const BilibiliGeetestResult({required this.validate});
}

class BilibiliGeetestService {
  BilibiliGeetestService._();

  static const _bridgeName = 'SyncTVGeetest';

  static Future<BilibiliGeetestResult> verify(
    BuildContext context, {
    required String gt,
    required String challenge,
    Duration timeout = const Duration(minutes: 3),
  }) async {
    if (_supportsDialogWebView) {
      return _verifyWithDialog(
        context,
        gt: gt,
        challenge: challenge,
        timeout: timeout,
      );
    }
    if (_supportsDesktopWebView) {
      return _verifyWithDesktopWindow(
        context,
        gt: gt,
        challenge: challenge,
        timeout: timeout,
      );
    }
    throw UnsupportedError('当前平台暂不支持内嵌 Bilibili 安全验证');
  }

  static Future<BilibiliGeetestResult> _verifyWithDialog(
    BuildContext context, {
    required String gt,
    required String challenge,
    required Duration timeout,
  }) async {
    final outcome = await showAppDialog<_BilibiliGeetestDialogOutcome>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BilibiliGeetestDialog(
        gt: gt,
        challenge: challenge,
        timeout: timeout,
      ),
    );

    if (outcome == null) {
      throw StateError('Bilibili 安全验证已取消');
    }
    final error = outcome.error;
    if (error != null) {
      throw error;
    }
    return outcome.result!;
  }

  static Future<BilibiliGeetestResult> _verifyWithDesktopWindow(
    BuildContext context, {
    required String gt,
    required String challenge,
    required Duration timeout,
  }) async {
    final client = DependencyScope.read<DesktopWebVerificationClient>(context);
    final message = await client.verify(
      html: buildBilibiliGeetestHtml(gt: gt, challenge: challenge),
      bridgeName: _bridgeName,
      title: 'Bilibili 安全验证',
      windowWidth: 460,
      windowHeight: 620,
      timeout: timeout,
      browserPath: 'provider_verification.html',
      browserFragmentParameters: {'gt': gt, 'challenge': challenge},
    );
    return parseBilibiliGeetestMessage(message);
  }

  static bool get _supportsDialogWebView {
    return !kIsWeb &&
        const {
          TargetPlatform.android,
          TargetPlatform.iOS,
          TargetPlatform.macOS,
        }.contains(defaultTargetPlatform);
  }

  static bool get _supportsDesktopWebView {
    return kIsWeb ||
        const {
          TargetPlatform.windows,
          TargetPlatform.linux,
        }.contains(defaultTargetPlatform);
  }
}

@visibleForTesting
String buildBilibiliGeetestHtml({
  required String gt,
  required String challenge,
}) {
  final gtJson = _scriptSafeJsonString(gt);
  final challengeJson = _scriptSafeJsonString(challenge);
  return '''
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Bilibili 安全验证</title>
  <script src="https://static.geetest.com/static/tools/gt.js"></script>
  <style>
    :root { color-scheme: light dark; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background: #f7f8fb;
      color: #1f2328;
    }
    main {
      width: min(360px, calc(100vw - 32px));
      display: grid;
      gap: 18px;
      justify-items: stretch;
    }
    h1 {
      margin: 0;
      font-size: 22px;
      line-height: 1.25;
      font-weight: 700;
    }
    p {
      margin: 0;
      color: #59636e;
      font-size: 14px;
      line-height: 1.55;
    }
    #captcha {
      min-height: 48px;
      display: grid;
      align-items: center;
    }
    #status {
      min-height: 20px;
      font-size: 13px;
      color: #59636e;
    }
    @media (prefers-color-scheme: dark) {
      body { background: #111318; color: #f0f3f6; }
      p, #status { color: #aeb6c2; }
    }
  </style>
</head>
<body>
  <main>
    <h1>Bilibili 安全验证</h1>
    <p>完成验证后会自动回到 SyncTV 继续发送短信验证码。</p>
    <div id="captcha"></div>
    <div id="status">正在加载验证组件...</div>
  </main>
  <script>
    const gt = $gtJson;
    const challenge = $challengeJson;
    const status = document.getElementById('status');

    function sendMessage(payload) {
      const message = JSON.stringify(payload);
      if (window.${BilibiliGeetestService._bridgeName}) {
        window.${BilibiliGeetestService._bridgeName}.postMessage(message);
      } else if (
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.${BilibiliGeetestService._bridgeName}
      ) {
        window.webkit.messageHandlers.${BilibiliGeetestService._bridgeName}
          .postMessage(message);
      } else if (window.chrome && window.chrome.webview) {
        window.chrome.webview.postMessage(message);
      } else {
        status.textContent = '验证结果无法返回 SyncTV，请升级客户端后重试。';
      }
    }

    function reportError(message) {
      status.textContent = message;
      sendMessage({ error: message });
    }

    function finish(result) {
      const validate = result && result.geetest_validate
        ? String(result.geetest_validate)
        : '';
      if (!validate) {
        reportError('验证结果无效，请刷新后重试。');
        return;
      }
      status.textContent = '验证完成，正在继续发送短信验证码。';
      sendMessage({ validate: validate });
    }

    if (typeof initGeetest !== 'function') {
      reportError('验证组件加载失败，请检查网络后重试。');
    } else {
      initGeetest({
        gt: gt,
        challenge: challenge,
        offline: false,
        new_captcha: true,
        product: 'popup',
        width: '100%'
      }, function(captcha) {
        captcha.appendTo('#captcha');
        captcha.onReady(function() {
          status.textContent = '请完成下方验证。';
        });
        captcha.onSuccess(function() {
          finish(captcha.getValidate());
        });
        captcha.onError(function() {
          reportError('验证组件出错，请刷新后重试。');
        });
      });
    }
  </script>
</body>
</html>
''';
}

@visibleForTesting
BilibiliGeetestResult parseBilibiliGeetestMessage(String message) {
  final decoded = jsonDecode(message);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Geetest 消息格式无效');
  }

  final error = (decoded['error'] ?? '').toString().trim();
  if (error.isNotEmpty) {
    throw StateError(error);
  }

  final validate = (decoded['validate'] ?? '').toString().trim();
  if (validate.isEmpty) {
    throw const FormatException('Geetest validate 为空');
  }

  return BilibiliGeetestResult(validate: validate);
}

String _scriptSafeJsonString(String value) {
  return jsonEncode(value)
      .replaceAll('<', r'\u003c')
      .replaceAll('>', r'\u003e')
      .replaceAll('&', r'\u0026')
      .replaceAll('\u2028', r'\u2028')
      .replaceAll('\u2029', r'\u2029');
}

class _BilibiliGeetestDialog extends StatefulWidget {
  final String gt;
  final String challenge;
  final Duration timeout;

  const _BilibiliGeetestDialog({
    required this.gt,
    required this.challenge,
    required this.timeout,
  });

  @override
  State<_BilibiliGeetestDialog> createState() => _BilibiliGeetestDialogState();
}

class _BilibiliGeetestDialogOutcome {
  final BilibiliGeetestResult? result;
  final Object? error;

  const _BilibiliGeetestDialogOutcome.result(this.result) : error = null;
  const _BilibiliGeetestDialogOutcome.error(this.error) : result = null;
}

class _BilibiliGeetestDialogState extends State<_BilibiliGeetestDialog> {
  late final WebViewController _controller;
  Timer? _timer;
  String? _errorText;
  bool _completed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (!mounted || _completed) return;
            setState(() => _errorText = '验证页面加载失败: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        BilibiliGeetestService._bridgeName,
        onMessageReceived: _handleMessage,
      )
      ..loadHtmlString(
        buildBilibiliGeetestHtml(gt: widget.gt, challenge: widget.challenge),
        baseUrl: 'https://passport.bilibili.com/',
      );

    _timer = Timer(widget.timeout, () {
      if (!mounted || _completed) return;
      _completed = true;
      Navigator.of(context).pop(
        _BilibiliGeetestDialogOutcome.error(
          TimeoutException('Bilibili 验证超时', widget.timeout),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleMessage(JavaScriptMessage message) {
    if (_completed || !mounted) return;

    try {
      final result = parseBilibiliGeetestMessage(message.message);
      _completed = true;
      Navigator.of(context).pop(_BilibiliGeetestDialogOutcome.result(result));
    } catch (error) {
      setState(() => _errorText = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppDialogFrame(
      maxWidth: 460,
      maxHeight: 620,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFB7299).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFFFB7299),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Bilibili 安全验证',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppIconButton(
                    tooltip: '取消',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icons.close_rounded,
                  ),
                ],
              ),
            ),
            const AppDivider(height: 1),
            Flexible(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_loading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: AppLoadingIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: AppActionButton(
                  onPressed: () => _controller.reload(),
                  icon: Icons.refresh_rounded,
                  label: '刷新验证',
                  style: AppActionButtonStyle.outlined,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
