import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { runInNewContext } from 'node:vm';

const source = readFileSync(new URL('../web/provider_verification.js', import.meta.url), 'utf8');

function fixture({ failure, missing = false, fragment = 'gt=demo&challenge=demo&bridge=bridge&token=token' } = {}) {
  const status = { textContent: 'Loading' };
  const messages = [];
  const callbacks = {};
  let initialize;
  const captcha = {
    appendTo() { if (failure === 'mount') throw new Error('SDK mount failed'); },
    onReady(callback) { callbacks.ready = callback; },
    onSuccess(callback) { callbacks.success = callback; },
    onError(callback) { callbacks.error = callback; },
    getValidate() {
      if (failure === 'validate') throw new Error('SDK result failed');
      return { geetest_validate: failure === 'empty' ? '' : 'valid-result' };
    },
  };
  const window = {
    location: { hash: `#${fragment}`, pathname: '/provider_verification.html' },
    history: { replaceState() {} },
    parent: { postMessage(message) { messages.push(message); } },
  };
  if (!missing) {
    window.initGeetest = (_, callback) => {
      if (failure === 'init') throw new Error('SDK init failed');
      initialize = () => callback(captcha);
    };
  }
  const run = () => runInNewContext(source, {
    window, document: { getElementById: () => status }, URLSearchParams,
  });
  return { run, status, messages, callbacks, initialize: () => initialize() };
}

for (const failure of ['init', 'mount', 'validate']) {
  test(`SDK ${failure} exception reports one failure to parent`, () => {
    const f = fixture({ failure });
    assert.doesNotThrow(f.run);
    if (failure !== 'init') assert.doesNotThrow(f.initialize);
    if (failure === 'validate') assert.doesNotThrow(f.callbacks.success);
    assert.equal(f.messages.length, 1);
    assert.equal(typeof f.messages[0].payload.error, 'string');
    assert.equal(f.status.textContent, f.messages[0].payload.error);
    assert.notEqual(f.status.textContent, 'Loading');
  });
}

for (const first of ['success', 'error']) {
  test(`${first} completion survives later callbacks`, () => {
    const f = fixture();
    f.run(); f.initialize(); f.callbacks.ready();
    f.callbacks[first]();
    const status = f.status.textContent;
    f.callbacks.success(); f.callbacks.error(); f.callbacks.ready();
    assert.equal(f.messages.length, 1);
    assert.equal(f.status.textContent, status);
    assert.equal(f.messages[0].bridge, 'bridge');
    assert.equal(f.messages[0].token, 'token');
    assert.equal(f.messages[0].type, 'synctv-provider-verification');
    if (first === 'success') assert.equal(f.messages[0].payload.validate, 'valid-result');
  });
}

for (const options of [{ missing: true }, { fragment: '' }, { failure: 'empty' }]) {
  test(`invalid setup or result: ${JSON.stringify(options)}`, () => {
    const f = fixture(options);
    f.run();
    if (options.failure) { f.initialize(); f.callbacks.success(); }
    assert.equal(f.messages.length, 1);
    assert.equal(typeof f.messages[0].payload.error, 'string');
  });
}
