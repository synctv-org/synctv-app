(() => {
  'use strict';

  const parameters = new URLSearchParams(window.location.hash.slice(1));
  const gt = parameters.get('gt') || '';
  const challenge = parameters.get('challenge') || '';
  const bridge = parameters.get('bridge') || '';
  const token = parameters.get('token') || '';
  const status = document.getElementById('status');
  let completed = false;

  try {
    window.history.replaceState(null, '', window.location.pathname);
  } catch (_) {
    // Sandboxed documents can reject history updates. The fragment stays local.
  }

  function send(payload) {
    window.parent.postMessage({
      type: 'synctv-provider-verification',
      bridge,
      token,
      payload,
    }, '*');
  }

  function fail(message) {
    finish({error: message}, message);
  }

  function finish(payload, message) {
    if (completed) return;
    completed = true;
    status.textContent = message;
    send(payload);
  }

  if (!gt || !challenge || !bridge || !token) {
    fail('验证参数无效，请返回 SyncTV 后重试。');
    return;
  }
  if (typeof window.initGeetest !== 'function') {
    fail('验证组件加载失败，请检查网络后重试。');
    return;
  }

  try {
    window.initGeetest({
      gt,
      challenge,
      offline: false,
      new_captcha: true,
      product: 'popup',
      width: '100%',
    }, (captcha) => {
      if (completed) return;
      try {
        captcha.appendTo('#captcha');
        captcha.onReady(() => {
          if (!completed) status.textContent = '请完成下方验证。';
        });
        captcha.onSuccess(() => {
          if (completed) return;
          try {
            const result = captcha.getValidate();
            const validate = result && result.geetest_validate
              ? String(result.geetest_validate)
              : '';
            if (!validate) {
              fail('验证结果无效，请返回后重试。');
              return;
            }
            finish({validate}, '验证完成，正在继续发送短信验证码。');
          } catch (_) {
            fail('读取验证结果失败，请返回后重试。');
          }
        });
        captcha.onError(() => {
          fail('验证组件出错，请返回后重试。');
        });
      } catch (_) {
        fail('验证组件初始化失败，请返回后重试。');
      }
    });
  } catch (_) {
    fail('验证组件初始化失败，请返回后重试。');
  }
})();
