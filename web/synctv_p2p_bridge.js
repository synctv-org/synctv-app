'use strict';

(() => {
  const DB_NAME = 'synctv-p2p-media';
  const DB_VERSION = 1;
  const STORE = 'pieces';
  let requestHandler = null;
  let databasePromise = null;
  const cacheTails = new Map();
  const serviceWorkerSupported =
    'serviceWorker' in navigator && window.isSecureContext;

  const workerReady = registerWorker();
  if (serviceWorkerSupported) {
    navigator.serviceWorker.addEventListener('message', (event) => {
      if (!event.data || event.data.type !== 'synctv-p2p-fetch' || !event.ports[0]) return;
      const port = event.ports[0];
      if (!requestHandler) {
        port.postMessage({
          type: 'error',
          status: 503,
          message: 'The SyncTV P2P engine is not active.',
        });
        port.close();
        return;
      }
      try {
        requestHandler(event.data, port);
      } catch (error) {
        port.postMessage({
          type: 'error',
          status: 502,
          message: String(error),
        });
        port.close();
      }
    });
  }

  async function registerWorker() {
    if (!serviceWorkerSupported) return false;
    try {
      await navigator.serviceWorker.register('/synctv_service_worker.js', {
        scope: '/',
        updateViaCache: 'none',
      });
      await navigator.serviceWorker.ready;
      if (navigator.serviceWorker.controller) return true;
      return await new Promise((resolve) => {
        const timeout = setTimeout(() => resolve(false), 5000);
        navigator.serviceWorker.addEventListener('controllerchange', () => {
          clearTimeout(timeout);
          resolve(Boolean(navigator.serviceWorker.controller));
        }, { once: true });
      });
    } catch (error) {
      console.warn('SyncTV service worker registration failed:', error);
      return false;
    }
  }

  function openDatabase() {
    if (databasePromise) return databasePromise;
    databasePromise = new Promise((resolve, reject) => {
      const request = indexedDB.open(DB_NAME, DB_VERSION);
      request.onupgradeneeded = () => {
        const database = request.result;
        const store = database.createObjectStore(STORE, { keyPath: 'id' });
        store.createIndex('namespace', 'namespace', { unique: false });
      };
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
      request.onblocked = () => reject(new Error('P2P cache database upgrade is blocked.'));
    });
    return databasePromise;
  }

  function requestResult(request) {
    return new Promise((resolve, reject) => {
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
  }

  function transactionDone(transaction) {
    return new Promise((resolve, reject) => {
      transaction.oncomplete = () => resolve();
      transaction.onerror = () => reject(transaction.error);
      transaction.onabort = () => reject(transaction.error || new Error('P2P cache transaction aborted.'));
    });
  }

  function enqueueCache(namespace, operation) {
    const previous = cacheTails.get(namespace) || Promise.resolve();
    const current = previous.catch(() => {}).then(operation);
    const tail = current.finally(() => {
      if (cacheTails.get(namespace) === tail) cacheTails.delete(namespace);
    });
    cacheTails.set(namespace, tail);
    return current;
  }

  async function cacheEntries(namespace, transaction) {
    const index = transaction.objectStore(STORE).index('namespace');
    return await requestResult(index.getAll(IDBKeyRange.only(namespace)));
  }

  async function evict(namespace, maxBytes, ttlMs) {
    const database = await openDatabase();
    const transaction = database.transaction(STORE, 'readwrite');
    const store = transaction.objectStore(STORE);
    const entries = await cacheEntries(namespace, transaction);
    const cutoff = Date.now() - ttlMs;
    let total = 0;
    const retained = [];
    for (const entry of entries) {
      if (entry.lastAccessed <= cutoff || entry.size > maxBytes) {
        store.delete(entry.id);
      } else {
        total += entry.size;
        retained.push(entry);
      }
    }
    retained.sort((left, right) => left.lastAccessed - right.lastAccessed);
    for (const entry of retained) {
      if (total <= maxBytes) break;
      store.delete(entry.id);
      total -= entry.size;
    }
    await transactionDone(transaction);
    return total;
  }

  window.SyncTvP2pBridge = Object.freeze({
    ready: () => workerReady,
    setRequestHandler: (handler) => { requestHandler = handler || null; },
    cacheGet: (namespace, key, ttlMs) => enqueueCache(namespace, async () => {
      const database = await openDatabase();
      const transaction = database.transaction(STORE, 'readwrite');
      const store = transaction.objectStore(STORE);
      const id = `${namespace}|${key}`;
      const entry = await requestResult(store.get(id));
      if (!entry || Date.now() - entry.lastAccessed >= ttlMs) {
        if (entry) store.delete(id);
        await transactionDone(transaction);
        return null;
      }
      entry.lastAccessed = Date.now();
      store.put(entry);
      await transactionDone(transaction);
      return new Uint8Array(entry.bytes);
    }),
    cachePut: (namespace, key, bytes, maxBytes, ttlMs) => enqueueCache(namespace, async () => {
      if (bytes.byteLength > maxBytes) return await evict(namespace, maxBytes, ttlMs);
      const database = await openDatabase();
      const transaction = database.transaction(STORE, 'readwrite');
      transaction.objectStore(STORE).put({
        id: `${namespace}|${key}`,
        namespace,
        key,
        bytes: bytes.slice().buffer,
        size: bytes.byteLength,
        lastAccessed: Date.now(),
      });
      await transactionDone(transaction);
      return await evict(namespace, maxBytes, ttlMs);
    }),
    cacheResize: (namespace, maxBytes, ttlMs) =>
      enqueueCache(namespace, () => evict(namespace, maxBytes, ttlMs)),
    cacheBytes: (namespace, ttlMs) => enqueueCache(namespace, async () => {
      const database = await openDatabase();
      const transaction = database.transaction(STORE, 'readonly');
      const entries = await cacheEntries(namespace, transaction);
      await transactionDone(transaction);
      const cutoff = Date.now() - ttlMs;
      return entries
        .filter((entry) => entry.lastAccessed > cutoff)
        .reduce((total, entry) => total + entry.size, 0);
    }),
  });
})();
