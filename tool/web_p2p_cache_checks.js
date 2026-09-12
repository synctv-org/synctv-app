'use strict';

window.runP2pCacheChecks = async (report) => {
  const api = window.SyncTvP2pBridge;
  const originalNow = Date.now;
  const originalGetAll = IDBIndex.prototype.getAll;
  let now = originalNow();
  const ttl = 60000;
  const bytes = new Uint8Array([1, 2, 3, 4, 5]);
  const requestResult = (request) => new Promise((resolve, reject) => {
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
    request.onblocked = () => reject(new Error('Database blocked by another tab'));
  });
  const check = (condition, message) => { if (!condition) throw new Error(message); };
  const equal = (actual, expected) => actual?.length === expected.length &&
    actual.every((value, index) => value === expected[index]);
  try {
    await requestResult(indexedDB.deleteDatabase('synctv-p2p-media'));
    const opening = indexedDB.open('synctv-p2p-media', 1);
    opening.onupgradeneeded = () => {
      const store = opening.result.createObjectStore('pieces', {keyPath: 'id'});
      store.createIndex('namespace', 'namespace');
    };
    const legacy = await requestResult(opening);
    const seed = legacy.transaction('pieces', 'readwrite');
    seed.objectStore('pieces').put({
      id: 'legacy|piece', namespace: 'legacy', key: 'piece',
      bytes: bytes.buffer, size: bytes.length, lastAccessed: now,
    });
    await new Promise((resolve, reject) => {
      seed.oncomplete = resolve;
      seed.onabort = () => reject(seed.error);
    });
    legacy.close();

    Date.now = () => now;
    check(equal(await api.cacheGet('legacy', 'piece', ttl), bytes), 'Legacy bytes changed');
    const migrated = await requestResult(indexedDB.open('synctv-p2p-media'));
    check(migrated.version === 2, 'Missing schema migration');
    const indexes = migrated.transaction('pieces').objectStore('pieces').indexNames;
    check(indexes.contains('namespaceAccessSize'), 'Missing metadata index');
    migrated.close();
    report('Legacy migration: 5 bytes preserved');

    IDBIndex.prototype.getAll = () => { throw new Error('Payload scan attempted'); };
    check(await api.cacheBytes('legacy', ttl) === 5, 'Wrong migrated byte count');
    await api.cachePut('metadata', 'piece', bytes, 100, ttl);
    check(await api.cacheResize('metadata', 100, ttl) === 5, 'Wrong resized count');
    report('Metadata scans: no payload getAll');

    await api.cachePut('other', 'piece', bytes, 100, ttl);
    await api.cachePut('metadata', 'piece', new Uint8Array(101), 100, ttl);
    check(await api.cacheGet('metadata', 'piece', ttl) === null, 'Oversized replacement kept stale bytes');
    check(equal(await api.cacheGet('other', 'piece', ttl), bytes), 'Other namespace was changed');
    report('Oversized replacement: stale entry removed');
    report('Namespace isolation: preserved');

    now += 10;
    await api.cachePut('lru', 'a', new Uint8Array([1, 1]), 4, ttl);
    now += 10;
    await api.cachePut('lru', 'b', new Uint8Array([2, 2]), 4, ttl);
    now += 10;
    await api.cacheGet('lru', 'a', ttl);
    now += 10;
    check(await api.cachePut('lru', 'c', new Uint8Array([3, 3]), 4, ttl) === 4, 'Capacity limit failed');
    check(await api.cacheGet('lru', 'b', ttl) === null, 'Least recently used entry survived');
    check(equal(await api.cacheGet('lru', 'a', ttl), new Uint8Array([1, 1])), 'Recently used entry evicted');
    report('LRU eviction: 4-byte capacity respected');

    await api.cachePut('expiry', 'piece', bytes, 100, ttl);
    now += ttl;
    check(await api.cacheGet('expiry', 'piece', ttl) === null, 'Expiry boundary retained stale bytes');
    check(await api.cacheBytes('expiry', ttl) === 0, 'Expired bytes still counted');
    report('TTL boundary: expired entry removed');
  } finally {
    Date.now = originalNow;
    IDBIndex.prototype.getAll = originalGetAll;
  }
};

