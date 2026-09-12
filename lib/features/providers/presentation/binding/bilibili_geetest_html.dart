import 'dart:convert';

const bilibiliGeetestBridgeName = 'SyncTVGeetest';

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
    <div id="status" role="status" aria-live="polite">正在加载验证组件...</div>
  </main>
  <script>
    const gt = $gtJson;
    const challenge = $challengeJson;
    const status = document.getElementById('status');
    let completed = false;

    function sendMessage(payload) {
      const message = JSON.stringify(payload);
      if (window.$bilibiliGeetestBridgeName) {
        window.$bilibiliGeetestBridgeName.postMessage(message);
      } else if (
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.$bilibiliGeetestBridgeName
      ) {
        window.webkit.messageHandlers.$bilibiliGeetestBridgeName
          .postMessage(message);
      } else if (window.chrome && window.chrome.webview) {
        window.chrome.webview.postMessage(message);
      } else {
        status.textContent = '验证结果无法返回 SyncTV，请升级客户端后重试。';
      }
    }

    function reportError(message) {
      if (completed) return;
      completed = true;
      status.textContent = message;
      sendMessage({ error: message });
    }

    function finish(result) {
      if (completed) return;
      const validate = result && result.geetest_validate
        ? String(result.geetest_validate)
        : '';
      if (!validate) {
        reportError('验证结果无效，请刷新后重试。');
        return;
      }
      completed = true;
      status.textContent = '验证完成，正在继续发送短信验证码。';
      sendMessage({ validate: validate });
    }

    if (typeof initGeetest !== 'function') {
      reportError('验证组件加载失败，请检查网络后重试。');
    } else {
      try {
        initGeetest({
          gt: gt,
          challenge: challenge,
          offline: false,
          new_captcha: true,
          product: 'popup',
          width: '100%'
        }, function(captcha) {
          if (completed) return;
          try {
            captcha.appendTo('#captcha');
            captcha.onReady(function() {
              if (!completed) status.textContent = '请完成下方验证。';
            });
            captcha.onSuccess(function() {
              if (completed) return;
              try {
                finish(captcha.getValidate());
              } catch (_) {
                reportError('读取验证结果失败，请返回后重试。');
              }
            });
            captcha.onError(function() {
              reportError('验证组件出错，请刷新后重试。');
            });
          } catch (_) {
            reportError('验证组件初始化失败，请返回后重试。');
          }
        });
      } catch (_) {
        reportError('验证组件初始化失败，请返回后重试。');
      }
    }
  </script>
</body>
</html>
''';
}

String _scriptSafeJsonString(String value) {
  return jsonEncode(value)
      .replaceAll('<', r'\u003c')
      .replaceAll('>', r'\u003e')
      .replaceAll('&', r'\u0026')
      .replaceAll('\u2028', r'\u2028')
      .replaceAll('\u2029', r'\u2029');
}
