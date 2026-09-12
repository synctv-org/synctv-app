import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/presentation/binding/bilibili_geetest_flow.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() {
  testWidgets('setup awaits JavaScript configuration before loading HTML', (
    tester,
  ) async {
    final platform = _Platform()..setupGate = Completer<void>();
    await _open(tester, platform);
    expect(platform.controller.loads, 0);
    platform.setupGate!.complete();
    await tester.pump();
    expect(platform.controller.loads, 1);
    await _cancel(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('setup failure is visible and refresh retries initialization', (
    tester,
  ) async {
    final platform = _Platform()..failSetup = true;
    await _open(tester, platform);
    expect(tester.takeException(), isNull);
    expect(find.textContaining('controlled setup failure'), findsOneWidget);
    expect(find.byType(AppLoadingIndicator), findsNothing);
    platform.failSetup = false;
    await tester.tap(find.text('刷新验证'));
    await tester.pump();
    expect(platform.controller.loads, 1);
    expect(find.textContaining('controlled setup failure'), findsNothing);
    await _cancel(tester);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets(
    'refresh resets error and reports reload failure without a stuck spinner',
    (tester) async {
      final platform = _Platform();
      await _open(tester, platform);
      platform.delegate.onError(
        const WebResourceError(
          errorCode: -1,
          description: 'controlled resource failure',
        ),
      );
      await tester.pump();
      expect(find.byType(AppLoadingIndicator), findsNothing);
      platform.controller.failReload = true;
      await tester.tap(find.text('刷新验证'));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.textContaining('controlled reload failure'), findsOneWidget);
      expect(find.byType(AppLoadingIndicator), findsNothing);
      platform.controller.failReload = false;
      await tester.tap(find.text('刷新验证'));
      await tester.pump();
      expect(find.textContaining('controlled reload failure'), findsNothing);
      expect(find.byType(AppLoadingIndicator), findsOneWidget);
      platform.delegate.onFinished('preview');
      await tester.pump();
      expect(find.byType(AppLoadingIndicator), findsNothing);
      await _cancel(tester);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets('cancel during setup prevents subsequent HTML loading', (
    tester,
  ) async {
    final platform = _Platform()..setupGate = Completer<void>();
    await _open(tester, platform);
    await _cancel(tester);
    platform.setupGate!.complete();
    await tester.pump();
    expect(platform.controller.loads, 0);
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  for (final timeout in [false, true]) {
    testWidgets(
      'covered verification preserves overlay on ${timeout ? 'timeout' : 'success'}',
      (tester) async {
        final previous = WebViewPlatform.instance;
        final platform = _Platform();
        WebViewPlatform.instance = platform;
        addTearDown(() {
          WebViewPlatform.instance = previous ?? _Platform();
        });
        final navigator = GlobalKey<NavigatorState>();
        Object? outcome;
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigator,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    try {
                      outcome = await BilibiliGeetestService.verify(
                        context,
                        gt: 'preview',
                        challenge: 'preview',
                        timeout: const Duration(seconds: 10),
                      );
                    } catch (error) {
                      outcome = error;
                    }
                  },
                  child: const Text('Open verification'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open verification'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        unawaited(
          showDialog<void>(
            context: navigator.currentContext!,
            builder: (context) => AlertDialog(
              title: const Text('Independent overlay'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close overlay'),
                ),
              ],
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        if (timeout) {
          await tester.pump(const Duration(seconds: 10));
        } else {
          platform.controller.channel.onMessageReceived(
            const JavaScriptMessage(message: '{"validate":"accepted"}'),
          );
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Independent overlay'), findsOneWidget);
        if (timeout) {
          expect(outcome, isA<TimeoutException>());
        } else {
          expect((outcome as BilibiliGeetestResult).validate, 'accepted');
        }
        platform.controller.channel.onMessageReceived(
          const JavaScriptMessage(message: '{"validate":"late"}'),
        );
        await tester.pump();
        expect(find.text('Independent overlay'), findsOneWidget);
        await tester.tap(find.text('Close overlay'));
        await tester.pumpAndSettle();
        expect(find.text('Bilibili 安全验证'), findsNothing);
        expect(find.text('Open verification'), findsOneWidget);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.macOS,
      }),
    );
  }
}

Future<void> _open(WidgetTester tester, _Platform platform) async {
  final previous = WebViewPlatform.instance;
  WebViewPlatform.instance = platform;
  addTearDown(() {
    WebViewPlatform.instance = previous ?? _Platform();
  });
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              try {
                await BilibiliGeetestService.verify(
                  context,
                  gt: 'preview',
                  challenge: 'preview',
                );
              } catch (_) {}
            },
            child: const Text('Open verification'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open verification'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _cancel(WidgetTester tester) async {
  await tester.tap(find.byType(AppIconButton));
  await tester.pumpAndSettle();
}

class _Platform extends WebViewPlatform {
  Completer<void>? setupGate;
  bool failSetup = false;
  late _Controller controller;
  late _Delegate delegate;
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) => controller = _Controller(params, this);
  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) => delegate = _Delegate(params);
  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => _View(params);
}

class _Controller extends PlatformWebViewController {
  _Controller(super.params, this.owner) : super.implementation();
  final _Platform owner;
  int loads = 0;
  bool failReload = false;
  late JavaScriptChannelParams channel;
  @override
  Future<void> setJavaScriptMode(JavaScriptMode mode) async {
    if (owner.failSetup) throw StateError('controlled setup failure');
    await owner.setupGate?.future;
  }

  @override
  Future<void> setBackgroundColor(Color color) async {}
  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}
  @override
  Future<void> addJavaScriptChannel(JavaScriptChannelParams params) async {
    channel = params;
  }

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    loads++;
  }

  @override
  Future<void> reload() async {
    if (failReload) throw StateError('controlled reload failure');
  }
}

class _Delegate extends PlatformNavigationDelegate {
  _Delegate(super.params) : super.implementation();
  late PageEventCallback onFinished;
  late WebResourceErrorCallback onError;
  @override
  Future<void> setOnPageFinished(PageEventCallback callback) async {
    onFinished = callback;
  }

  @override
  Future<void> setOnWebResourceError(WebResourceErrorCallback callback) async {
    onError = callback;
  }
}

class _View extends PlatformWebViewWidget {
  _View(super.params) : super.implementation();
  @override
  Widget build(BuildContext context) =>
      const SizedBox.expand(child: Text('Controlled WebView'));
}
