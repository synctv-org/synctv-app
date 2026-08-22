'use strict';

const APP_CACHE = 'synctv-app-runtime-v3';
const P2P_PREFIX = '/__synctv_p2p__/';
const P2P_HEADER_TIMEOUT_MS = 35000;
const STATIC_PREFIXES = ['/assets/', '/canvaskit/', '/icons/', '/playback/'];
const STATIC_PATHS = new Set([
  '/favicon.png',
  '/flutter.js',
  '/flutter_bootstrap.js',
  '/main.dart.js',
  '/manifest.json',
  '/passkeys_bundle.js',
  '/provider_verification.css',
  '/provider_verification.js',
  '/synctv_p2p_bridge.js',
  '/version.json',
]);

self.addEventListener('install', (event) => {
  event.waitUntil(self.skipWaiting());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const names = await caches.keys();
    await Promise.all(names
      .filter((name) => name.startsWith('synctv-app-runtime-') && name !== APP_CACHE)
      .map((name) => caches.delete(name)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;
  if (url.pathname.startsWith(P2P_PREFIX)) {
    event.respondWith(handleP2pFetch(event));
    return;
  }
  if (event.request.method !== 'GET' || isApiPath(url.pathname)) return;
  if (event.request.mode === 'navigate' && isAppNavigationPath(url.pathname)) {
    event.respondWith(networkFirstNavigation(event));
    return;
  }
  if (isStaticAssetPath(url.pathname)) {
    event.respondWith(cacheFirstStaticAsset(event));
  }
});

function isApiPath(path) {
  return path === '/api' || path.startsWith('/api/') ||
    path === '/ws' || path.startsWith('/ws/') ||
    path === '/grpc' || path.startsWith('/grpc/');
}

function isAppNavigationPath(path) {
  return path === '/' || !path.split('/').pop().includes('.');
}

function isStaticAssetPath(path) {
  return STATIC_PATHS.has(path) ||
    STATIC_PREFIXES.some((prefix) => path.startsWith(prefix));
}

function isCacheable(response) {
  if (!response.ok || response.type !== 'basic') return false;
  const cacheControl = response.headers.get('cache-control') || '';
  return !/(?:^|,)\s*(?:no-store|private)(?:\s|,|$)/i.test(cacheControl);
}

async function networkFirstNavigation(event) {
  const cache = await caches.open(APP_CACHE);
  try {
    const response = await fetch(event.request);
    if (isCacheable(response)) {
      event.waitUntil(cache.put(new Request('/'), response.clone()).catch(() => {}));
    }
    return response;
  } catch (error) {
    const index = await cache.match(new Request('/'));
    if (index) return index;
    throw error;
  }
}

async function cacheFirstStaticAsset(event) {
  const cache = await caches.open(APP_CACHE);
  const cached = await cache.match(event.request);
  const update = fetch(event.request).then((response) => {
    if (isCacheable(response)) {
      event.waitUntil(cache.put(event.request, response.clone()).catch(() => {}));
    }
    return response;
  });
  if (cached) {
    event.waitUntil(update.catch(() => {}));
    return cached;
  }
  return update;
}

async function handleP2pFetch(event) {
  const client = event.clientId ? await self.clients.get(event.clientId) : null;
  if (!client) return textResponse(503, 'The P2P media client is unavailable.');

  const channel = new MessageChannel();
  let bodyController;
  let responseSettled = false;
  const body = new ReadableStream({
    start(controller) {
      bodyController = controller;
    },
    pull() {
      channel.port1.postMessage({ type: 'pull' });
    },
    cancel() {
      channel.port1.postMessage({ type: 'cancel' });
      channel.port1.close();
    },
  }, { highWaterMark: 1 });

  const response = new Promise((resolve) => {
    const timeout = setTimeout(() => {
      if (responseSettled) return;
      responseSettled = true;
      bodyController.error(new Error('P2P media response header timed out.'));
      channel.port1.postMessage({ type: 'cancel' });
      channel.port1.close();
      resolve(textResponse(504, 'The P2P media response timed out.'));
    }, P2P_HEADER_TIMEOUT_MS);

    channel.port1.onmessage = (message) => {
      const data = message.data || {};
      if (data.type === 'meta') {
        if (responseSettled) return;
        responseSettled = true;
        clearTimeout(timeout);
        resolve(new Response(event.request.method === 'HEAD' ? null : body, {
          status: data.status,
          headers: data.headers,
        }));
      } else if (data.type === 'chunk') {
        if (event.request.method !== 'HEAD' && data.bytes) {
          bodyController.enqueue(new Uint8Array(data.bytes));
        }
      } else if (data.type === 'end') {
        clearTimeout(timeout);
        bodyController.close();
        channel.port1.close();
      } else if (data.type === 'error') {
        clearTimeout(timeout);
        if (!responseSettled) {
          responseSettled = true;
          resolve(textResponse(data.status || 502, data.message || 'P2P media request failed.'));
        } else {
          bodyController.error(new Error(data.message || 'P2P media request failed.'));
        }
        channel.port1.close();
      }
    };
    channel.port1.start();
  });

  client.postMessage({
    type: 'synctv-p2p-fetch',
    url: event.request.url,
    method: event.request.method,
    headers: Array.from(event.request.headers.entries()),
  }, [channel.port2]);
  return response;
}

function textResponse(status, message) {
  return new Response(message, {
    status,
    headers: { 'content-type': 'text/plain; charset=utf-8', 'cache-control': 'no-store' },
  });
}
