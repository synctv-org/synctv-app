import { createServer } from 'node:http';
import { readFileSync } from 'node:fs';

const worker = readFileSync(new URL('../web/synctv_service_worker.js', import.meta.url), 'utf8');
const bridge = readFileSync(new URL('../web/synctv_p2p_bridge.js', import.meta.url), 'utf8');
const cacheChecks = readFileSync(new URL('./web_p2p_cache_checks.js', import.meta.url), 'utf8');
const icon = readFileSync(new URL('../web/icons/Icon-192.png', import.meta.url));
const fault = [
  "self.caches.open = async () => { throw new Error('Injected cache failure'); };",
  "self.caches.keys = async () => { throw new Error('Injected cache failure'); };",
  "self.addEventListener('message', async (event) => {",
  "  if (event.data !== 'probe-cache') return;",
  "  try { await caches.open('probe'); event.ports[0].postMessage('available'); }",
  "  catch { event.ports[0].postMessage('unavailable'); }",
  "});",
].join('\n');
const html = [
  '<!doctype html><html lang="en"><meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<title>SyncTV cache recovery</title>',
  '<style>body{font:16px system-ui;margin:24px;color:#111827;background:#f6f7fa}',
  'main{max-width:640px}h1{font-size:24px}button,a{font:inherit;display:inline-block;padding:10px;margin:0 8px 12px 0}',
  'td,th{text-align:left;padding:8px;border-bottom:1px solid #bbb}img{width:96px;height:96px}</style>',
  '<main><h1>SyncTV cache recovery</h1><p id="state" role="status">Connecting</p>',
  '<button id="run" disabled>Run checks</button><a href="/next">Next page</a>',
  '<table><tbody id="results"></tbody></table><img id="icon" alt="SyncTV" hidden></main>',
  '<script>',
  '(async () => {',
  'const state = document.getElementById("state");',
  'const run = document.getElementById("run");',
  'const results = document.getElementById("results");',
  'try {',
  'await navigator.serviceWorker.register("/synctv_service_worker.js");',
  'await navigator.serviceWorker.ready;',
  'if (!navigator.serviceWorker.controller) await new Promise((resolve, reject) => {',
  ' const timeout = setTimeout(() => reject(new Error("Worker control timeout")), 5000);',
  ' navigator.serviceWorker.addEventListener("controllerchange", () => { clearTimeout(timeout); resolve(); }, {once:true});',
  '});',
  'const channel = new MessageChannel();',
  'const availability = new Promise((resolve, reject) => {',
  ' const timeout = setTimeout(() => reject(new Error("Cache probe timeout")), 5000);',
  ' channel.port1.onmessage = (event) => {clearTimeout(timeout); resolve(event.data); channel.port1.close();};',
  '});',
  'navigator.serviceWorker.controller.postMessage("probe-cache", [channel.port2]);',
  'state.textContent = "Cache storage: " + await availability;',
  'run.disabled = false;',
  'run.onclick = async () => {',
  ' run.disabled = true; results.replaceChildren();',
  ' for (const path of ["/assets/probe.txt", "/playback/probe.txt"]) {',
  '  const row = results.insertRow(); row.insertCell().textContent = path;',
  '  try { const response = await fetch(path); row.insertCell().textContent = response.status + " " + await response.text(); }',
  '  catch { row.insertCell().textContent = "Failed"; }',
  ' }',
  ' const icon = document.getElementById("icon"); icon.hidden = false; icon.src = "/icons/Icon-192.png";',
  ' run.disabled = false;',
  '};',
  '} catch(error) {state.textContent = String(error);}',
  '})();',
  '</script></html>',
].join('\n');

const p2pHtml = [
  '<!doctype html><html lang="en"><meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<title>SyncTV P2P cache recovery</title>',
  '<style>body{font:16px system-ui;margin:24px;color:#111827;background:#f6f7fa}',
  'main{max-width:640px}h1{font-size:24px}button{font:inherit;padding:10px;margin:0 8px 12px 0}',
  'p{overflow-wrap:anywhere}img{width:96px;height:96px}</style>',
  '<main><img src="/icons/Icon-192.png" alt="SyncTV"><h1>P2P cache recovery</h1>',
  '<p id="state" role="status">Opening cache</p><p id="errors">Unhandled rejections: 0</p>',
  '<button id="retry" disabled>Retry cache</button><button id="reset" disabled>Recreate cache</button></main>',
  '<script>',
  'let failures = 0;',
  'window.addEventListener("unhandledrejection", () => {',
  ' document.getElementById("errors").textContent = "Unhandled rejections: " + ++failures;',
  '});',
  'const nativeOpen = indexedDB.open.bind(indexedDB); let injected = false;',
  'indexedDB.open = (...args) => {',
  ' if (!injected) {injected = true; throw new DOMException("Injected open failure", "UnknownError");}',
  ' return nativeOpen(...args);',
  '};',
  '</script><script src="/synctv_p2p_bridge.js"></script><script>',
  '(async () => {',
  'const state = document.getElementById("state");',
  'const retry = document.getElementById("retry");',
  'const reset = document.getElementById("reset");',
  'const api = window.SyncTvP2pBridge;',
  'async function roundTrip(label) {',
  ' retry.disabled = reset.disabled = true;',
  ' try {',
  '  const expected = new Uint8Array([3, 1, 4, 1, 5]);',
  '  await api.cachePut("fixture", "piece", expected, 1024, 60000);',
  '  const result = await api.cacheGet("fixture", "piece", 60000);',
  '  if (!result || result.length !== expected.length || !result.every((value, index) => value === expected[index])) throw new Error("Byte mismatch");',
  '  state.textContent = label + ": " + result.length + " bytes verified";',
  ' } catch(error) {state.textContent = String(error);}',
  ' finally {retry.disabled = reset.disabled = false;}',
  '}',
  'retry.onclick = () => roundTrip("Retry succeeded");',
  'reset.onclick = async () => {',
  ' retry.disabled = reset.disabled = true;',
  ' try {',
  '  await new Promise((resolve, reject) => {',
  '   const request = indexedDB.deleteDatabase("synctv-p2p-media");',
  '   request.onsuccess = resolve; request.onerror = () => reject(request.error);',
  '   request.onblocked = () => reject(new Error("Database deletion blocked"));',
  '  });',
  '  await roundTrip("Recreated");',
  ' } catch(error) {state.textContent = String(error); retry.disabled = reset.disabled = false;}',
  '};',
  'try {await api.cacheBytes("fixture", 60000); state.textContent = "Unexpected initial success";}',
  'catch {state.textContent = "Initial open failed";}',
  'retry.disabled = false;',
  '})();',
  '</script></html>',
].join('\n');

const policyHtml = [
  '<!doctype html><html lang="en"><meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<title>SyncTV P2P cache policy</title>',
  '<style>body{font:16px system-ui;margin:24px;color:#111827;background:#f6f7fa}',
  'main{max-width:640px}h1{font-size:24px}button{font:inherit;padding:10px}',
  'li,p{overflow-wrap:anywhere}li{margin:12px 0}img{width:96px;height:96px}</style>',
  '<main><img src="/icons/Icon-192.png" alt="SyncTV"><h1>P2P cache policy</h1>',
  '<button id="run">Run checks</button><p id="state" role="status">Ready</p><ul id="results"></ul></main>',
  '<script src="/synctv_p2p_bridge.js"></script><script src="/cache-checks.js"></script>',
  '<script>document.getElementById("run").onclick = async () => {',
  'const button = document.getElementById("run"); const state = document.getElementById("state");',
  'const list = document.getElementById("results"); list.replaceChildren(); button.disabled = true;',
  'try {await runP2pCacheChecks((text) => {const item = document.createElement("li"); item.textContent = text; list.append(item);}); state.textContent = "All 6 checks passed";}',
  'catch(error) {state.textContent = String(error);}',
  'finally {button.disabled = false;}',
  '};</script></html>',
].join('\n');

const startupHtml = [
  '<!doctype html><html lang="en"><meta charset="utf-8">',
  '<meta name="viewport" content="width=device-width,initial-scale=1">',
  '<title>SyncTV worker startup</title>',
  '<style>body{font:16px system-ui;margin:24px;color:#111827;background:#f6f7fa}',
  'main{max-width:640px}h1{font-size:24px}a{display:inline-block;padding:10px;margin:0 8px 12px 0}',
  'p{overflow-wrap:anywhere}img{width:96px;height:96px}</style>',
  '<main><img src="/icons/Icon-192.png" alt="SyncTV"><h1>Worker startup</h1>',
  '<nav><a href="/startup?mode=register">Pending registration</a><a href="/startup?mode=ready">Pending activation</a><a href="/startup">Normal startup</a></nav>',
  '<p id="state" role="status">Waiting</p><p id="listeners"></p><p id="errors">Unhandled rejections: 0</p></main>',
  '<script>',
  'const mode = new URLSearchParams(location.search).get("mode");',
  'const sw = navigator.serviceWorker; const originalRegister = sw.register;',
  'const originalReady = Object.getOwnPropertyDescriptor(sw, "ready");',
  'const originalAdd = sw.addEventListener; const originalRemove = sw.removeEventListener;',
  'const listeners = new Set(); let failures = 0;',
  'sw.addEventListener = function(name, listener, options) {if (name === "controllerchange") listeners.add(listener); return originalAdd.call(this, name, listener, options);};',
  'sw.removeEventListener = function(name, listener, options) {if (name === "controllerchange") listeners.delete(listener); return originalRemove.call(this, name, listener, options);};',
  'window.addEventListener("unhandledrejection", () => {document.getElementById("errors").textContent = "Unhandled rejections: " + ++failures;});',
  'if (mode === "register") sw.register = () => new Promise(() => {});',
  'if (mode === "ready") Object.defineProperty(sw, "ready", {configurable:true, value:new Promise(() => {})});',
  'const started = performance.now();',
  '</script><script src="/synctv_p2p_bridge.js"></script><script>',
  'SyncTvP2pBridge.ready().then((ready) => {',
  'document.getElementById("state").textContent = (ready ? "Worker ready" : "Startup unavailable") + " after " + ((performance.now() - started) / 1000).toFixed(1) + " seconds";',
  'document.getElementById("listeners").textContent = "Controller listeners remaining: " + listeners.size;',
  '}).finally(() => {',
  'sw.register = originalRegister; sw.addEventListener = originalAdd; sw.removeEventListener = originalRemove;',
  'if (originalReady) Object.defineProperty(sw, "ready", originalReady); else delete sw.ready;',
  '});',
  '</script></html>',
].join('\n');

createServer((request, response) => {
  const path = new URL(request.url, 'http://localhost').pathname;
  if (path === '/synctv_service_worker.js') {
    response.writeHead(200, {'content-type': 'application/javascript', 'cache-control': 'no-store'});
    response.end(fault + '\n' + worker);
  } else if (path === '/synctv_p2p_bridge.js') {
    response.writeHead(200, {'content-type': 'application/javascript', 'cache-control': 'no-store'});
    response.end(bridge);
  } else if (path === '/cache-checks.js') {
    response.writeHead(200, {'content-type': 'application/javascript'});
    response.end(cacheChecks);
  } else if (path === '/startup') {
    response.writeHead(200, {'content-type': 'text/html', 'cache-control': 'no-store'});
    response.end(startupHtml);
  } else if (path === '/p2p-policy') {
    response.writeHead(200, {'content-type': 'text/html', 'cache-control': 'no-store'});
    response.end(policyHtml);
  } else if (path === '/p2p') {
    response.writeHead(200, {'content-type': 'text/html', 'cache-control': 'no-store'});
    response.end(p2pHtml);
  } else if (path === '/icons/Icon-192.png') {
    response.writeHead(200, {'content-type': 'image/png'});
    response.end(icon);
  } else if (path === '/assets/probe.txt' || path === '/playback/probe.txt') {
    response.writeHead(200, {'content-type': 'text/plain'});
    response.end('Network OK');
  } else if (path === '/' || path === '/next') {
    response.writeHead(200, {'content-type': 'text/html', 'cache-control': 'no-store'});
    response.end(html);
  } else {
    response.writeHead(404);
    response.end();
  }
}).listen(Number(process.argv[2] || 8775), '127.0.0.1', () => {
  console.log('Cache failure fixture ready');
});

