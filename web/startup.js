(() => {
  const startup = document.getElementById('startup');
  const retry = document.getElementById('startup-retry');
  const chinese = navigator.language.toLowerCase().startsWith('zh');
  if (retry) {
    retry.textContent = chinese ? '重试' : 'Retry';
    retry.addEventListener('click', () => location.reload());
  }

  function showStartupError(error) {
    console.error('SyncTV startup failed', error);
    if (!startup?.isConnected) return;
    startup.querySelector('progress').hidden = true;
    const message = document.getElementById('startup-error');
    message.textContent = chinese ? '加载失败，请重试' : 'Unable to load SyncTV.';
    message.hidden = false;
    retry.hidden = false;
  }

  function onStartupError(event) {
    showStartupError(event.detail);
  }

  function onResourceError(event) {
    const source = event.target instanceof HTMLScriptElement
      ? event.target.src
      : event.filename;
    if (source && /\/(flutter_bootstrap|main\.dart)\.js$/.test(
      new URL(source, document.baseURI).pathname,
    )) {
      showStartupError(event.error ?? new Error('Application script could not be loaded.'));
    }
  }

  window.addEventListener('error', onResourceError, { capture: true });
  window.addEventListener('synctv-startup-error', onStartupError);
  window.addEventListener('flutter-first-frame', () => {
    window.removeEventListener('error', onResourceError, { capture: true });
    window.removeEventListener('synctv-startup-error', onStartupError);
  }, { once: true });
})();
