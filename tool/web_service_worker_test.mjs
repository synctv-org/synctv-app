import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { runInNewContext } from 'node:vm';

const source = readFileSync(new URL('../web/synctv_service_worker.js', import.meta.url), 'utf8');
const origin = 'https://example.test';

function worker({ failure, offline = false, cached = false } = {}) {
  const listeners = {};
  const writes = [];
  let requests = 0;
  let claims = 0;
  const response = () => new Response('network');
  const cache = {
    match: async () => {
      if (failure === 'read') throw new Error('cache read failed');
      return cached ? new Response('cached') : undefined;
    },
    put: async (key) => {
      if (failure === 'write') throw new Error('cache write failed');
      writes.push(key.url);
    },
  };
  class WorkerRequest extends Request {
    constructor(url, options) { super(new URL(url, origin), options); }
  }
  runInNewContext(source, {
    self: {
      location: new URL(origin),
      addEventListener: (type, fn) => listeners[type] = fn,
      clients: { claim: async () => claims++ },
    },
    caches: {
      keys: async () => {
        if (failure === 'keys') throw new Error('cache enumeration failed');
        return ['synctv-app-runtime-v2'];
      },
      delete: async () => {
        if (failure === 'delete') throw new Error('cache deletion failed');
        return true;
      },
      open: async () => {
        if (failure === 'open') throw new Error('cache unavailable');
        return cache;
      },
    },
    fetch: async () => {
      requests++;
      if (offline) throw new Error('network unavailable');
      const value = response();
      Object.defineProperty(value, 'type', { value: 'basic' });
      return value;
    },
    URL, Request: WorkerRequest, Response, console,
  });
  return {
    writes,
    get requests() { return requests; },
    get claims() { return claims; },
    async activate() {
      let task;
      listeners.activate({ waitUntil(value) { task = value; } });
      await task;
    },
    async fetch(path, mode = 'cors') {
      const tasks = [];
      let result;
      listeners.fetch({
        request: { url: origin + path, mode, method: 'GET' },
        respondWith(value) { result = value; },
        waitUntil(value) { tasks.push(value); },
      });
      const resolved = await result;
      await Promise.all(tasks);
      return resolved;
    },
  };
}

for (const [path, mode] of [['/room', 'navigate'], ['/assets/probe.txt', 'cors'], ['/playback/probe.txt', 'cors'], ['/startup.js', 'cors']]) {
  for (const failure of ['open', 'read', 'write']) {
    test(`${path} stays online after cache ${failure} failure`, async () => {
      const app = worker({ failure });
      assert.equal(await (await app.fetch(path, mode)).text(), 'network');
      assert.equal(app.requests, 1);
    });
  }
  test(`${path} falls back to cached content offline`, async () => {
    const app = worker({ cached: true, offline: true });
    assert.equal(await (await app.fetch(path, mode)).text(), 'cached');
  });
  test(`${path} preserves network error when both storage and network fail`, async () => {
    const app = worker({ failure: 'open', offline: true });
    await assert.rejects(app.fetch(path, mode), /network unavailable/);
  });
  test(`${path} still populates available cache`, async () => {
    const app = worker();
    assert.equal(await (await app.fetch(path, mode)).text(), 'network');
    assert.deepEqual(app.writes, [origin + (mode === 'navigate' ? '/' : path)]);
  });
}

test('API requests bypass application cache', async () => {
  const app = worker({ failure: 'open' });
  assert.equal(await app.fetch('/api/rooms'), undefined);
  assert.equal(app.requests, 0);
});

for (const failure of ['keys', 'delete', undefined]) {
  test(`activation claims clients after cache cleanup failure=${failure}`, async () => {
    const app = worker({ failure });
    await app.activate();
    assert.equal(app.claims, 1);
  });
}

