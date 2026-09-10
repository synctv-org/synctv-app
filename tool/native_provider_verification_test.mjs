import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { runInNewContext } from 'node:vm';

const html = readFileSync(process.env.GEETEST_NATIVE_HTML, 'utf8');
const source = html.match(/<script>\s*([\s\S]*?)<\/script>/)[1];

function fixture(failure, bridge = 'direct') {
  const status = { textContent: 'Loading' };
  const messages = [];
  const callbacks = {};
  let initialize;
  const channel = { postMessage: (message) => messages.push(JSON.parse(message)) };
  const window = bridge === 'direct' ? { SyncTVGeetest: channel }
    : bridge === 'webkit' ? { webkit: { messageHandlers: { SyncTVGeetest: channel } } }
      : { chrome: { webview: channel } };
  const captcha = {
    appendTo() { if (failure === 'mount') throw new Error('Mount failed'); },
    onReady(fn) { callbacks.ready = fn; },
    onSuccess(fn) { callbacks.success = fn; },
    onError(fn) { callbacks.error = fn; },
    getValidate() {
      if (failure === 'validate') throw new Error('Read failed');
      return { geetest_validate: 'preview-result' };
    },
  };
  const run = () => runInNewContext(source, {
    window, document: { getElementById: () => status },
    initGeetest(_, callback) {
      if (failure === 'init') throw new Error('Init failed');
      initialize = () => callback(captcha);
    },
  });
  return { run, initialize: () => initialize(), callbacks, status, messages };
}

for (const failure of ['init', 'mount', 'validate']) {
  test(`generated native HTML reports ${failure} failure`, () => {
    const f = fixture(failure);
    assert.doesNotThrow(f.run);
    if (failure !== 'init') assert.doesNotThrow(f.initialize);
    if (failure === 'validate') assert.doesNotThrow(f.callbacks.success);
    assert.equal(f.messages.length, 1);
    assert.equal(typeof f.messages[0].error, 'string');
    assert.equal(f.status.textContent, f.messages[0].error);
  });
}

for (const bridge of ['direct', 'webkit', 'webview']) {
  test(`generated native HTML sends success once through ${bridge}`, () => {
    const f = fixture(undefined, bridge);
    f.run(); f.initialize(); f.callbacks.success();
    const status = f.status.textContent;
    f.callbacks.success(); f.callbacks.error(); f.callbacks.ready();
    assert.equal(f.messages.length, 1);
    assert.equal(f.messages[0].validate, 'preview-result');
    assert.equal(f.status.textContent, status);
  });
}

test('generated native HTML preserves first error', () => {
  const f = fixture();
  f.run(); f.initialize(); f.callbacks.error();
  const status = f.status.textContent;
  f.callbacks.success(); f.callbacks.ready();
  assert.equal(f.messages.length, 1);
  assert.equal(f.status.textContent, status);
  assert.equal(typeof f.messages[0].error, 'string');
});
