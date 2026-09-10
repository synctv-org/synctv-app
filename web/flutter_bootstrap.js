{{flutter_js}}
{{flutter_build_config}}

window.addEventListener('flutter-first-frame', () => {
  // Successful startup must also work if the recovery script was unavailable.
  document.getElementById('startup')?.remove();
  watchDisplayPixelRatio();
}, { once: true });

function watchDisplayPixelRatio() {
  // Flutter's full-page view can retain physical dimensions from the old DPR.
  const query = window.matchMedia(`(resolution: ${window.devicePixelRatio}dppx)`);
  query.addEventListener('change', () => {
    watchDisplayPixelRatio();
    window.requestAnimationFrame(() => {
      (window.visualViewport ?? window).dispatchEvent(new Event('resize'));
    });
  }, { once: true });
}

function showStartupError(error) {
  window.dispatchEvent(new CustomEvent('synctv-startup-error', { detail: error }));
}

_flutter.loader.load({
  config: { canvasKitBaseUrl: new URL('canvaskit/', document.baseURI).href },
  onEntrypointLoaded: async (engineInitializer) => {
    try {
      const runner = await engineInitializer.initializeEngine();
      await runner.runApp();
    } catch (error) {
      showStartupError(error);
    }
  },
}).catch(showStartupError);
