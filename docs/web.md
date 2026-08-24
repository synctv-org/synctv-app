# Web Client

The Web client is deployed by the SyncTV HTTP server. It always uses the page
origin as its server identity. Browser builds do not expose native multi-server
management, custom TLS handling, or an independently configured API endpoint.

## Build and embed

Build a standalone distribution for local inspection:

```bash
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run
```

For a production server binary, use the backend repository target. It builds
this app first and embeds `build/web` in the server:

```bash
make web-release-build SYNCTV_APP_DIR=/path/to/synctv-app
```

The frontend and backend protobuf snapshots must define the same
`PlaybackClientProfile` fields. Deploy the companion backend version whenever
that profile changes.

## Playback negotiation

The browser probes its media capabilities at runtime and sends a versioned
profile with playback observations and HTTP playback requests. The profile
describes the browser environment, stream preferences, supported protocols,
container and codec combinations, MSE, custom-header handling, insecure HTTP
media, proxy support, and the P2P media loader.

Providers own route selection. They intersect each media variant with the
client profile and the selected proxy policy before creating playback output.
Media that requires browser-forbidden headers uses a provider proxy route.
`DirectOnly` fails with a structured compatibility error when no direct route
can work. HTTPS pages also reject direct HTTP media while retaining eligible
same-origin proxy routes.

The player uses native HTML media for compatible progressive sources and
vendored HLS.js, dash.js, and mpegts.js engines for HLS, DASH, HTTP-FLV, and
MPEG-TS when an engine is required. Playback libraries are served from the
same origin and require no runtime CDN access.

## Browser features

- Authentication supports OPAQUE, WebAuthn passkeys, OAuth2 through
  `/oauth2/callback`, email flows, TOTP, and recovery flows supported by the
  server. The callback uses the normal SPA entry point and is rendered as a
  regular Flutter route.
- Realtime room traffic uses the same protobuf protocol over browser
  WebSocket.
- Picture-in-picture, fullscreen, volume, uploads, subtitles, danmaku, and
  provider verification use browser APIs when available.
- Media P2P uses the existing room swarm protocol with a WebRTC-compatible
  peer transport. A Service Worker supplies range responses to the media
  element, and IndexedDB retains eligible pieces across reloads.
- Native-only platform controls remain unavailable when the browser does not
  expose an equivalent API. The UI reports the unavailable action instead of
  advertising it as supported.

## Service Worker and security

`synctv_service_worker.js` caches navigation and explicit application assets.
It excludes API, WebSocket, media, and P2P gateway URLs, and it refuses to cache
responses marked `private` or `no-store`. SPA navigations are revalidated, and
the provider-verification page is served with `no-store`.

The embedded server applies the production CSP, frame, referrer, and
permissions policies. Keep authentication bridges and playback engines
vendored under `web/`; adding a remote script also requires an explicit CSP
and supply-chain review.

## Verification

Run static and unit coverage first:

```bash
flutter analyze
flutter test
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run
```

The Chrome integration tests require a matching ChromeDriver on port 4444 and
a media fixture server on port 18181:

```bash
dart run tool/web_media_fixture_server.dart /path/to/media-fixtures 18181
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/web_playback_runtime_test.dart -d chrome \
  --dart-define=SYNCTV_WEB_MEDIA_TEST_BASE=http://127.0.0.1:18181
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/web_p2p_gateway_test.dart -d chrome \
  --dart-define=SYNCTV_WEB_P2P_E2E=true
```

Use the same finite media fixture to verify playback and seeking in a native
application runner:

```bash
flutter test integration_test/native_playback_runtime_test.dart -d macos \
  --dart-define=SYNCTV_NATIVE_MEDIA_TEST_URL=http://127.0.0.1:18181/sample.ts \
  --dart-define=SYNCTV_NATIVE_MEDIA_TEST_FORMAT=mpeg-ts
```
