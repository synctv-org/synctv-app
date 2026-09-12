import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { runInNewContext } from 'node:vm';

const bootstrapSource = readFileSync(new URL('../web/flutter_bootstrap.js', import.meta.url), 'utf8')
  .replace('{{flutter_js}}', '')
  .replace('{{flutter_build_config}}', '');

const startupSource = readFileSync(new URL('../web/startup.js', import.meta.url), 'utf8');

function boot({
  visualViewport = new EventTarget(),
  firstFrame = true,
  language = 'en',
  load = () => Promise.resolve(),
  includeBootstrap = true,
  includeStartup = true,
} = {}) {
  const window = new EventTarget();
  const queries = [];
  const frames = [];
  const errors = [];
  let reloads = 0;
  const progress = { hidden: false };
  const message = { hidden: true, textContent: '' };
  const retry = Object.assign(new EventTarget(), { hidden: true, textContent: '' });
  const startup = {
    isConnected: true,
    remove() { this.isConnected = false; },
    querySelector: () => progress,
  };
  const elements = { startup, 'startup-retry': retry, 'startup-error': message };
  class HTMLScriptElement {}
  Object.assign(window, {
    devicePixelRatio: 2,
    visualViewport,
    matchMedia: (media) => {
      const query = new EventTarget();
      queries.push({ media, query });
      return query;
    },
    requestAnimationFrame: (callback) => frames.push(callback),
  });
  const context = {
    window,
    document: { getElementById: (id) => elements[id], baseURI: 'https://example.com/app/' },
    navigator: { language },
    location: { reload: () => reloads++ },
    _flutter: { loader: { load } },
    HTMLScriptElement, URL, Event, CustomEvent,
    console: { error: (...args) => errors.push(args) },
  };
  if (includeStartup) runInNewContext(startupSource, context);
  if (includeBootstrap) runInNewContext(bootstrapSource, context);
  if (firstFrame) window.dispatchEvent(new Event('flutter-first-frame'));
  function resourceError(path) {
    const event = new Event('error');
    Object.defineProperty(event, 'target', {
      value: Object.assign(new HTMLScriptElement(), { src: new URL(path, context.document.baseURI).href }),
    });
    window.dispatchEvent(event);
  }
  return {
    window, queries, frames, errors, progress, message, retry, startup, resourceError,
    get reloads() { return reloads; },
  };
}

for (const script of ['flutter_bootstrap.js', 'main.dart.js']) {
  test(`failed ${script} offers recovery independently of Flutter`, () => {
    const app = boot({ firstFrame: false, includeBootstrap: false });
    app.resourceError(script);
    assert.equal(app.progress.hidden, true);
    assert.equal(app.message.hidden, false);
    assert.equal(app.message.textContent, 'Unable to load SyncTV.');
    assert.equal(app.retry.hidden, false);
    app.retry.dispatchEvent(new Event('click'));
    assert.equal(app.reloads, 1);
  });
}

test('Chinese recovery is localized before Flutter is available', () => {
  const app = boot({ firstFrame: false, language: 'zh-CN', includeBootstrap: false });
  app.resourceError('flutter_bootstrap.js?v=2');
  assert.equal(app.message.textContent, '加载失败，请重试');
  assert.equal(app.retry.textContent, '重试');
});

test('unrelated resource errors do not replace the loading state', () => {
  const app = boot({ firstFrame: false });
  app.resourceError('optional.js');
  assert.equal(app.progress.hidden, false);
  assert.equal(app.retry.hidden, true);
  assert.equal(app.errors.length, 0);
});

test('bootstrap evaluation errors also offer recovery', () => {
  const app = boot({ firstFrame: false, includeBootstrap: false });
  const error = new SyntaxError('broken script');
  app.window.dispatchEvent(Object.assign(new Event('error'), {
    filename: 'https://example.com/app/flutter_bootstrap.js', error,
  }));
  assert.equal(app.retry.hidden, false);
  assert.equal(app.errors[0][1], error);
});

for (const phase of ['load', 'engine', 'runApp']) {
  test(`${phase} rejection offers recovery`, async () => {
    const error = new Error(`${phase} failed`);
    const app = boot({
      firstFrame: false,
      load: async ({ onEntrypointLoaded }) => {
        if (phase === 'load') throw error;
        await onEntrypointLoaded({
          initializeEngine: async () => {
            if (phase === 'engine') throw error;
            return { runApp: async () => { throw error; } };
          },
        });
      },
    });
    await new Promise((resolve) => setImmediate(resolve));
    assert.equal(app.retry.hidden, false);
    assert.equal(app.errors[0][1], error);
  });
}

test('first frame removes the overlay and ignores later startup errors', () => {
  const app = boot();
  assert.equal(app.startup.isConnected, false);
  app.resourceError('main.dart.js');
  app.window.dispatchEvent(new CustomEvent('synctv-startup-error', { detail: new Error('late') }));
  assert.equal(app.errors.length, 0);
  assert.equal(app.retry.hidden, true);
});

test('a missing recovery script does not block successful Flutter startup', () => {
  const app = boot({ includeStartup: false });
  assert.equal(app.startup.isConnected, false);
  assert.equal(app.queries.length, 1);
});

for (const viewport of [true, false]) {
  test(`DPR changes refresh dimensions once after a frame, visual viewport=${viewport}`, () => {
    const { window, queries, frames } = boot({ visualViewport: viewport ? new EventTarget() : null });
    let resizes = 0;
    (window.visualViewport ?? window).addEventListener('resize', () => resizes++);
    assert.equal(queries[0].media, '(resolution: 2dppx)');
    assert.equal(frames.length, 0);
    window.devicePixelRatio = 1;
    queries[0].query.dispatchEvent(new Event('change'));
    queries[0].query.dispatchEvent(new Event('change'));
    assert.equal(queries.length, 2);
    assert.equal(queries[1].media, '(resolution: 1dppx)');
    assert.equal(frames.length, 1);
    assert.equal(resizes, 0);
    frames.shift()();
    assert.equal(resizes, 1);
    window.devicePixelRatio = 2;
    queries[1].query.dispatchEvent(new Event('change'));
    frames.shift()();
    assert.equal(resizes, 2);
    assert.equal(queries[2].media, '(resolution: 2dppx)');
  });
}
