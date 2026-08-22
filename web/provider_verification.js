(() => {
  'use strict';

  const parameters = new URLSearchParams(window.location.hash.slice(1));
  const gt = parameters.get('gt') || '';
  const challenge = parameters.get('challenge') || '';
  const bridge = parameters.get('bridge') || '';
  const token = parameters.get('token') || '';
  const status = document.getElementById('status');

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
    status.textContent = message;
    send({error: message});
  }

  if (!gt || !challenge || !bridge || !token) {
    fail('验证参数无效，请返回 SyncTV 后重试。');
    return;
  }
  if (typeof window.initGeetest !== 'function') {
    fail('验证组件加载失败，请检查网络后重试。');
    return;
  }

  window.initGeetest({
    gt,
    challenge,
    offline: false,
    new_captcha: true,
    product: 'popup',
    width: '100%',
  }, (captcha) => {
    captcha.appendTo('#captcha');
    captcha.onReady(() => {
      status.textContent = '请完成下方验证。';
    });
    captcha.onSuccess(() => {
      const result = captcha.getValidate();
      const validate = result && result.geetest_validate
        ? String(result.geetest_validate)
        : '';
      if (!validate) {
        fail('验证结果无效，请返回后重试。');
        return;
      }
      status.textContent = '验证完成，正在继续发送短信验证码。';
      send({validate});
    });
    captcha.onError(() => {
      fail('验证组件出错，请返回后重试。');
    });
  });
})();
