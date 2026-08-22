import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';

final class NativeDesktopWebVerificationClient
    implements DesktopWebVerificationClient {
  const NativeDesktopWebVerificationClient();

  @override
  bool get supported => Platform.isWindows || Platform.isLinux;

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
    if (Platform.isWindows && !await WebviewWindow.isWebviewAvailable()) {
      throw UnsupportedError('当前系统未安装 WebView2 Runtime，无法完成 Bilibili 安全验证');
    }

    final appDirectory = await getApplicationSupportDirectory();
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        title: title,
        windowWidth: windowWidth.toInt(),
        windowHeight: windowHeight.toInt(),
        userDataFolderWindows:
            '${appDirectory.path}${Platform.pathSeparator}web_verification',
      ),
    );
    final completer = Completer<String>();
    var closing = false;

    void completeMessage(Object? body) {
      if (completer.isCompleted) return;
      completer.complete(body is String ? body : jsonEncode(body));
    }

    void closeWebView() {
      if (closing) return;
      closing = true;
      webview.close();
    }

    webview.onClose.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(StateError('Bilibili 安全验证已取消'));
      }
    });
    if (Platform.isLinux) {
      webview.registerJavaScriptMessageHandler(
        bridgeName,
        (_, body) => completeMessage(body),
      );
    }
    if (Platform.isWindows) {
      webview.addOnWebMessageReceivedCallback(completeMessage);
    }

    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Bilibili 验证超时', timeout));
      }
    });
    webview.launch(
      Uri.dataFromString(
        html,
        mimeType: 'text/html',
        encoding: utf8,
      ).toString(),
    );

    try {
      return await completer.future;
    } finally {
      timer.cancel();
      closeWebView();
    }
  }
}
