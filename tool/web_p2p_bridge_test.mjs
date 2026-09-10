import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { runInNewContext } from 'node:vm';

const source = readFileSync(new URL('../web/synctv_p2p_bridge.js', import.meta.url), 'utf8');
const tick = () => new Promise(setImmediate);

function workerBridge({ register = () => Promise.resolve(), ready = Promise.resolve(), controller = null } = {}) {
  const listeners = new Map();
  const timers = new Map();
  const warnings = [];
  const serviceWorker = {
    register, ready, controller,
    addEventListener(name, listener, options) {
      const wrapped = (...args) => {
        if (options?.once) listeners.delete(name);
        listener(...args);
      };
      wrapped.original = listener;
      listeners.set(name, wrapped);
    },
    removeEventListener(name, listener) {
      if (listeners.get(name)?.original === listener) listeners.delete(name);
    },
  };
  const window = { isSecureContext: true };
  let timerId = 0;
  runInNewContext(source, {
    window, navigator: {serviceWorker},
    console: {warn: (...args) => warnings.push(args)},
    setTimeout(callback, delay) { const id = ++timerId; timers.set(id, {callback, delay}); return id; },
    clearTimeout(id) { timers.delete(id); },
  });
  return {
    api: window.SyncTvP2pBridge, serviceWorker, listeners, timers, warnings,
    expire() {
      assert.equal(timers.size, 1, 'Every startup phase must have a deadline');
      const [id, timer] = timers.entries().next().value;
      assert.equal(timer.delay, 5000);
      timers.delete(id);
      timer.callback();
    },
  };
}

for (const phase of ['register', 'ready', 'controller']) {
  test(`worker startup deadline covers ${phase} and ignores late completion`, async () => {
    let release;
    const pending = new Promise((resolve) => { release = resolve; });
    const context = workerBridge({
      register: () => phase === 'register' ? pending : Promise.resolve(),
      ready: phase === 'ready' ? pending : Promise.resolve(),
    });
    await tick();
    context.expire();
    assert.equal(await context.api.ready(), false);
    assert.equal(context.listeners.has('controllerchange'), false);
    context.serviceWorker.controller = {};
    release();
    await tick();
    assert.equal(await context.api.ready(), false);
    assert.equal(context.listeners.has('controllerchange'), false);
    assert.equal(context.timers.size, 0);
  });
}

for (const controlled of [false, true]) {
  test(`worker startup succeeds and releases deadline, initially controlled=${controlled}`, async () => {
    const context = workerBridge({controller: controlled ? {} : null});
    await tick();
    if (!controlled) {
      context.serviceWorker.controller = {};
      context.listeners.get('controllerchange')();
    }
    assert.equal(await context.api.ready(), true);
    assert.equal(context.listeners.has('controllerchange'), false);
    assert.equal(context.timers.size, 0);
  });
}

test('worker registration rejection releases its startup deadline', async () => {
  const context = workerBridge({register: () => Promise.reject(new Error('Registration failed'))});
  assert.equal(await context.api.ready(), false);
  assert.equal(context.timers.size, 0);
  assert.equal(context.listeners.has('controllerchange'), false);
  assert.equal(context.warnings.length, 1);
});

function bridge() {
  const requests = [];
  const window = { isSecureContext: false };
  runInNewContext(source, {
    window,
    navigator: {},
    indexedDB: { open(name, version) { const request = {name, version}; requests.push(request); return request; } },
    IDBKeyRange: { bound: (lower, upper) => ({lower, upper}) },
    console,
  });
  return { api: window.SyncTvP2pBridge, requests };
}

function database(label) {
  return {
    closed: 0,
    transactions: 0,
    close() { this.closed++; },
    transaction() {
      this.transactions++;
      throw new Error(label);
    },
  };
}

test('stale handler cleanup preserves the current engine and owner cleanup removes it', () => {
  const context = workerBridge();
  const calls = [];
  const first = () => calls.push('first');
  const current = () => calls.push('current');
  const port = {postMessage: (message) => calls.push(message.status), close() {}};
  const dispatch = () => context.listeners.get('message')({
    data: {type: 'synctv-p2p-fetch'}, ports: [port],
  });
  context.api.setRequestHandler(first);
  context.api.setRequestHandler(current);
  context.api.clearRequestHandler(first);
  dispatch();
  assert.deepEqual(calls, ['current']);
  context.api.clearRequestHandler(current);
  dispatch();
  assert.deepEqual(calls, ['current', 503]);
  context.expire();
});

for (const failure of ['error', 'blocked']) {
  test(`retries database open after ${failure} without unhandled queue rejection`, async () => {
    const { api, requests } = bridge();
    const first = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    requests[0].error = new Error('open failed');
    requests[0][failure === 'error' ? 'onerror' : 'onblocked']();
    assert.match(String(await first), /open failed|blocked/);
    await tick();
    const second = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    assert.equal(requests.length, 2);
    const connection = database('new connection');
    requests[1].result = connection;
    requests[1].onsuccess();
    assert.match(String(await second), /new connection/);
    await tick();
  });
}

test('late success from blocked open closes only the superseded connection', async () => {
  const { api, requests } = bridge();
  const first = api.cacheBytes('room', 1000).catch((error) => error);
  await tick();
  requests[0].onblocked();
  await first;
  const retry = api.cacheBytes('room', 1000).catch((error) => error);
  await tick();
  assert.equal(requests.length, 2);
  const current = database('current');
  requests[1].result = current;
  requests[1].onsuccess();
  await retry;
  const stale = database('stale');
  requests[0].result = stale;
  requests[0].onsuccess();
  assert.equal(stale.closed, 1);
  assert.equal(current.closed, 0);
  assert.match(String(await api.cacheBytes('room', 1000).catch((error) => error)), /current/);
  assert.equal(requests.length, 2);
  await tick();
});

for (const reason of ['versionchange', 'close']) {
  test(`connection ${reason} allows a fresh open`, async () => {
    const { api, requests } = bridge();
    const first = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    const connection = database('first connection');
    requests[0].result = connection;
    requests[0].onsuccess();
    await first;
    connection['on' + reason]();
    assert.equal(connection.closed, reason === 'versionchange' ? 1 : 0);
    const next = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    assert.equal(requests.length, 2);
    requests[1].result = database('second connection');
    requests[1].onsuccess();
    assert.match(String(await next), /second connection/);
    await tick();
  });
}

test('concurrent namespaces share an opening and recover after its rejection', async () => {
  const { api, requests } = bridge();
  const first = api.cacheBytes('a', 1000).catch((error) => error);
  const second = api.cacheBytes('b', 1000).catch((error) => error);
  await tick();
  assert.equal(requests.length, 1);
  requests[0].error = new Error('shared failure');
  requests[0].onerror();
  assert.match(String(await first), /shared failure/);
  assert.match(String(await second), /shared failure/);
  const retry = api.cacheBytes('a', 1000).catch((error) => error);
  await tick();
  assert.equal(requests.length, 2);
  requests[1].result = database('recovered');
  requests[1].onsuccess();
  assert.match(String(await retry), /recovered/);
  await tick();
});

for (const existing of [false, true]) {
  test(`schema upgrade preserves existing store=${existing} and adds metadata index`, async () => {
    const { api, requests } = bridge();
    const operation = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    const indexes = [];
    const store = {
      indexNames: { contains: (name) => existing && name === 'namespace' },
      createIndex: (name, key) => indexes.push({name, key}),
    };
    let created = 0;
    const connection = Object.assign(database('upgraded'), {
      objectStoreNames: { contains: () => existing },
      createObjectStore() { created++; return store; },
    });
    requests[0].result = connection;
    requests[0].transaction = {objectStore: () => store};
    assert.equal(requests[0].version, 2);
    requests[0].onupgradeneeded();
    assert.equal(created, existing ? 0 : 1);
    assert.deepEqual(indexes.map((index) => index.name),
      existing ? ['namespaceAccessSize'] : ['namespace', 'namespaceAccessSize']);
    assert.deepEqual(Array.from(indexes.at(-1).key), ['namespace', 'lastAccessed', 'size']);
    requests[0].onsuccess();
    await operation;
    await tick();
  });
}

for (const fail of [false, true]) {
  test(`byte statistics use metadata key cursor, failure=${fail}`, async () => {
    const { api, requests } = bridge();
    const operation = api.cacheBytes('room', 1000).catch((error) => error);
    await tick();
    const transaction = {};
    const index = {
      getAll() { throw new Error('Media payloads must not be read'); },
      openKeyCursor(range) {
        assert.deepEqual(Array.from(range.lower), ['room']);
        assert.equal(range.upper[0], 'room');
        const request = {};
        const entries = [
          {primaryKey: 'room|old', key: ['room', Date.now() - 5000, 99]},
          {primaryKey: 'room|new', key: ['room', Date.now(), 7]},
        ];
        const next = () => {
          if (fail) {
            request.error = new Error('Cursor failed');
            request.onerror();
            return;
          }
          request.result = entries.length ? {...entries.shift(), continue: () => setImmediate(next)} : null;
          request.onsuccess();
          if (!request.result) setImmediate(() => transaction.oncomplete());
        };
        setImmediate(next);
        return request;
      },
    };
    transaction.objectStore = () => ({index(name) {
      assert.equal(name, 'namespaceAccessSize');
      return index;
    }});
    requests[0].result = {transaction: () => transaction, close() {}};
    requests[0].onsuccess();
    const result = await operation;
    if (fail) assert.match(String(result), /Cursor failed/);
    else assert.equal(result, 7);
    await tick();
  });
}

