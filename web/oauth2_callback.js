(() => {
  'use strict';

  const message = {'flutter-web-auth-2': window.location.href};
  const targetOrigin = window.location.origin;

  if (window.opener && !window.opener.closed) {
    window.opener.postMessage(message, targetOrigin);
    window.close();
    return;
  }
  if (window.parent && window.parent !== window) {
    window.parent.postMessage(message, targetOrigin);
    return;
  }

  window.localStorage.setItem('flutter-web-auth-2', window.location.href);
  window.close();
})();
