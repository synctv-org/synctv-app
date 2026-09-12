import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bilibili_geetest_html.dart';

export 'bilibili_geetest_html.dart' show buildBilibiliGeetestHtml;

class BilibiliGeetestResult {
  final String validate;

  const BilibiliGeetestResult({required this.validate});
}

class BilibiliGeetestService {
  BilibiliGeetestService._();

  static const _bridgeName = bilibiliGeetestBridgeName;

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
  bool _configured = false;
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_load());

    _timer = Timer(widget.timeout, () {
      _finish(
        _BilibiliGeetestDialogOutcome.error(
          TimeoutException('Bilibili 验证超时', widget.timeout),
        ),
      );
    });
  }

  bool get _active => mounted && !_completed;

  Future<void> _load() async {
    if (!_active || _requesting) return;
    setState(() {
      _requesting = true;
      _loading = true;
      _errorText = null;
    });
    try {
      if (!_configured) {
        await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
        if (!_active) return;
        await _controller.setBackgroundColor(Colors.transparent);
        if (!_active) return;
        await _controller.setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              if (_active) setState(() => _loading = false);
            },
            onWebResourceError: (error) {
              _showError('验证页面加载失败: ${error.description}');
            },
          ),
        );
        if (!_active) return;
        await _controller.addJavaScriptChannel(
          BilibiliGeetestService._bridgeName,
          onMessageReceived: _handleMessage,
        );
        if (!_active) return;
        await _controller.loadHtmlString(
          buildBilibiliGeetestHtml(gt: widget.gt, challenge: widget.challenge),
          baseUrl: 'https://passport.bilibili.com/',
        );
        _configured = true;
      } else {
        await _controller.reload();
      }
    } catch (error) {
      _showError('验证页面加载失败: $error');
    } finally {
      if (_active) setState(() => _requesting = false);
    }
  }

  void _showError(String error) {
    if (!_active) return;
    setState(() {
      _loading = false;
      _errorText = error;
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
      _finish(_BilibiliGeetestDialogOutcome.result(result));
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _finish(_BilibiliGeetestDialogOutcome? outcome) {
    if (!mounted || _completed) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isActive) return;
    _completed = true;
    _timer?.cancel();
    final navigator = Navigator.of(context);
    if (route.isCurrent) {
      navigator.pop(outcome);
    } else {
      navigator.removeRoute(route, outcome);
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
                    onPressed: () => _finish(null),
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
                  onPressed: _requesting ? null : _load,
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
