'use strict';

(() => {
  const DB_NAME = 'synctv-p2p-media';
  const DB_VERSION = 2;
  const STORE = 'pieces';
  const METADATA_INDEX = 'namespaceAccessSize';
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
    return await new Promise((resolve) => {
      const worker = navigator.serviceWorker;
      let settled = false;
      const finish = (ready) => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        worker.removeEventListener('controllerchange', onControllerChange);
        resolve(ready);
      };
      const onControllerChange = () => {
        if (worker.controller) finish(true);
      };
      // Registration and activation can both remain pending indefinitely.
      const timeout = setTimeout(() => finish(false), 5000);
      (async () => {
        try {
          await worker.register('/synctv_service_worker.js', {
            scope: '/',
            updateViaCache: 'none',
          });
          if (settled) return;
          await worker.ready;
          if (settled) return;
          worker.addEventListener('controllerchange', onControllerChange);
          onControllerChange();
        } catch (error) {
          if (settled) return;
          console.warn('SyncTV service worker registration failed:', error);
          finish(false);
        }
      })();
    });
  }

  function openDatabase() {
    if (databasePromise) return databasePromise;
    const opening = new Promise((resolve, reject) => {
      let settled = false;
      const request = indexedDB.open(DB_NAME, DB_VERSION);
      const fail = (error) => {
        if (settled) return;
        settled = true;
        reject(error);
      };
      request.onupgradeneeded = () => {
        const database = request.result;
        const store = database.objectStoreNames.contains(STORE)
          ? request.transaction.objectStore(STORE)
          : database.createObjectStore(STORE, { keyPath: 'id' });
        if (!store.indexNames.contains('namespace')) {
          store.createIndex('namespace', 'namespace', { unique: false });
        }
        if (!store.indexNames.contains(METADATA_INDEX)) {
          store.createIndex(METADATA_INDEX, ['namespace', 'lastAccessed', 'size']);
        }
      };
      request.onsuccess = () => {
        const database = request.result;
        // An open request cannot be cancelled after reporting a blocked upgrade.
        if (settled) {
          database.close();
          return;
        }
        settled = true;
        const forget = () => {
          if (databasePromise === opening) databasePromise = null;
        };
        database.onversionchange = () => {
          database.close();
          forget();
        };
        database.onclose = forget;
        resolve(database);
      };
      request.onerror = () => fail(request.error || new Error('P2P cache database could not be opened.'));
      request.onblocked = () => fail(new Error('P2P cache database upgrade is blocked.'));
    });
    databasePromise = opening;
    opening.catch(() => {
      if (databasePromise === opening) databasePromise = null;
    });
    return opening;
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
    const cleanup = () => {
      if (cacheTails.get(namespace) === tail) cacheTails.delete(namespace);
    };
    const tail = current.then(cleanup, cleanup);
    cacheTails.set(namespace, tail);
    return current;
  }

  async function cacheEntries(namespace, transaction) {
    const index = transaction.objectStore(STORE).index(METADATA_INDEX);
    // Index keys expose eviction metadata without cloning the stored media bytes.
    const range = IDBKeyRange.bound([namespace], [namespace, []]);
    return await new Promise((resolve, reject) => {
      const entries = [];
      const request = index.openKeyCursor(range);
      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        const cursor = request.result;
        if (!cursor) {
          resolve(entries);
          return;
        }
        entries.push({
          id: cursor.primaryKey,
          lastAccessed: cursor.key[1],
          size: cursor.key[2],
        });
        cursor.continue();
      };
    });
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
    clearRequestHandler: (handler) => {
      if (requestHandler === handler) requestHandler = null;
    },
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
      const database = await openDatabase();
      const transaction = database.transaction(STORE, 'readwrite');
      const store = transaction.objectStore(STORE);
      const id = `${namespace}|${key}`;
      if (bytes.byteLength > maxBytes) {
        store.delete(id);
      } else {
        store.put({
          id,
          namespace,
          key,
          bytes: bytes.slice().buffer,
          size: bytes.byteLength,
          lastAccessed: Date.now(),
        });
      }
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
