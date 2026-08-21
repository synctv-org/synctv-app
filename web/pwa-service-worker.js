'use strict';

const CACHE_PREFIX = 'synctv-pwa-';
const FALLBACK_CACHE = 'synctv-pwa-fallback';
const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './favicon.ico',
  './favicon.png',
  './icons/Icon-180.png',
  './icons/Icon-192.png',
  './icons/Icon-512.png',
  './icons/Icon-maskable-192.png',
  './icons/Icon-maskable-512.png',
  './flutter.js',
  './flutter_bootstrap.js',
  './main.dart.js',
  './main.dart.wasm',
  './passkeys_bundle.js',
];

let activeCacheName;

async function currentCacheName() {
  try {
    const response = await fetch('./version.json', { cache: 'no-store' });
    const version = await response.json();
    return `${CACHE_PREFIX}${version.version}-${version.build_number}`;
  } catch (_) {
    return FALLBACK_CACHE;
  }
}

async function cacheName() {
  if (!activeCacheName) {
    activeCacheName = await currentCacheName();
  }
  return activeCacheName;
}

async function precacheAppShell(cache) {
  await Promise.all(
    APP_SHELL.map(async (path) => {
      try {
        const response = await fetch(path, { cache: 'reload' });
        if (response.ok) {
          await cache.put(path, response);
        }
      } catch (_) {
        // A missing optional asset should not block service worker activation.
      }
    }),
  );
}

function shouldSkip(request) {
  const url = new URL(request.url);
  if (request.method !== 'GET') {
    return true;
  }
  if (
    url.origin !== self.location.origin &&
    url.hostname !== 'www.gstatic.com'
  ) {
    return true;
  }
  if (url.pathname === '/version.json' || url.pathname.endsWith('/version.json')) {
    return true;
  }
  if (url.pathname.endsWith('/flutter_service_worker.js')) {
    return true;
  }
  if (
    url.pathname === '/api' ||
    url.pathname.startsWith('/api/') ||
    url.pathname.startsWith('/ws/')
  ) {
    return true;
  }
  return false;
}

async function networkFirst(request) {
  const cache = await caches.open(await cacheName());
  try {
    const response = await fetch(request);
    if (response.ok) {
      await cache.put(request, response.clone());
    }
    return response;
  } catch (_) {
    const cached = await cache.match(request);
    if (cached) {
      return cached;
    }
    return (await cache.match('./index.html')) || cache.match('./');
  }
}

async function staleWhileRevalidate(request) {
  const cache = await caches.open(await cacheName());
  const cached = await cache.match(request);
  const update = fetch(request)
    .then((response) => {
      if (response.ok) {
        return cache.put(request, response.clone()).then(() => response);
      }
      return response;
    })
    .catch(() => cached);
  return cached || update;
}

self.addEventListener('install', (event) => {
  event.waitUntil(
    (async () => {
      const cache = await caches.open(await cacheName());
      await precacheAppShell(cache);
      await self.skipWaiting();
    })(),
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    (async () => {
      const activeCache = await cacheName();
      const keys = await caches.keys();
      await Promise.all(
        keys
          .filter(
            (key) => key.startsWith(CACHE_PREFIX) && key !== activeCache,
          )
          .map((key) => caches.delete(key)),
      );
      await self.clients.claim();
    })(),
  );
});

self.addEventListener('fetch', (event) => {
  if (shouldSkip(event.request)) {
    return;
  }
  if (event.request.mode === 'navigate') {
    event.respondWith(networkFirst(event.request));
    return;
  }
  event.respondWith(staleWhileRevalidate(event.request));
});
