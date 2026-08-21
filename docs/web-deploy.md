# Flutter Web deployment

This fork builds SyncTV's Flutter Web bundle and serves it behind nginx as a
Docker image. The web app proxies API and WebSocket traffic to a SyncTV server
through nginx, so the browser only ever talks to the web origin.

## Local development

`make dev` runs the release single-bundle web app behind the fork's pure-Dart reverse proxy
(`tool/web_reverse_proxy.dart`): the proxy listens on `PROXY_PORT` (default
`8081`) and forwards `/api`, `/api/*`, and `/ws/rooms/*` to `API_UPSTREAM`
(default `http://localhost:8080`) and everything else to the Flutter web server
on `APP_PORT` (default `8083`). No built-in server URL is embedded by default;
set `SYNCTV_BUILT_IN_SERVER_URL` to point the app at the proxy (or another
server) at build time:

```sh
make dev                 # release single-bundle, proxy on :8081
make dev RUN_MODE=debug  # optional debug mode, still single-bundle
```

The proxy preserves the full request path to the API upstream and relays
WebSocket upgrades, so the local experience matches the nginx deployment.

## Runtime server injection

On web, the app injects the **current page origin** as the server at launch,
without rebuilding or manual setup. Because nginx forwards `/api` and `/ws` to
the SyncTV backend, the origin the page was loaded from is already a usable
server endpoint:

```text
https://web.example.com/   ->  server: https://web.example.com
```

The origin wins on every visit: opening a different deployment origin uses
that origin as the server, and accounts, sessions, and cached data stay
isolated per server address (each endpoint is stored as an independent
server). If the origin is unreachable the injection is skipped and startup
proceeds normally; users can still add or switch servers manually.

## Build the web bundle

```sh
make build            # or ./tool/build_web.sh
```

The script runs `flutter build web --release` with sensible defaults and copies
`web/pwa-service-worker.js` into the bundle so the service worker precaches the
app shell. Key variables:

- `SYNCTV_BUILT_IN_SERVER_URL` — optional embedded default server URL
  (`--dart-define`). Empty by default: the web bundle ships server-neutral and
  asks the user to add a server on first launch. The dev script (`dev-web.sh`)
  also leaves it empty unless the variable is set explicitly. Note that debug
  builds fall back to `http://127.0.0.1:8080` when nothing is configured.
- `SYNCTV_OPTIMIZATION_LEVEL` — default `4` (max).
- `SYNCTV_SOURCE_MAPS` — default `0` (off).
- `SYNCTV_WEB_RESOURCES_CDN` — default `1` (use the CDN for web SDK assets).
- `SYNCTV_SKIP_PUB` — default `1` (skip `pub get` when dependencies are current).
- `SYNCTV_BASE_HREF` — optional `<base href>` for sub-path hosting.

## Publish the Docker image

The GitHub Release workflow's `web-docker` job builds the bundle inside Docker
and pushes a multi-arch image (default `linux/amd64,linux/arm64`) with `latest`,
the current commit SHA, and the release version.

Registry configuration is handled by repository variables and secrets:

- `SYNCTV_WEB_DOCKER_IMAGE` — image repository.
- `SYNCTV_WEB_DOCKER_REGISTRY` — registry to authenticate against.
- `SYNCTV_WEB_DOCKER_PLATFORMS` — Docker OS/architecture targets; default
  `linux/amd64,linux/arm64`.
- `SYNCTV_WEB_DOCKER_USERNAME` / `SYNCTV_WEB_DOCKER_TOKEN` — registry
  credentials; fall back to Docker Hub credentials when unset.

## Build the Docker image locally

The Dockerfile installs the official Flutter SDK in a build stage, runs
`flutter pub get --enforce-lockfile` and `flutter build web`, then copies the
generated bundle into nginx. A clean checkout can be built directly without a
local Flutter installation:

```sh
docker build -t synctv-web .
```

Or use the Makefile wrapper:

```sh
make docker-build DOCKER_IMAGE=synctv-web
```

The Flutter SDK build stage follows the builder's native platform and can run
on either amd64 or arm64. The generated web bundle is architecture-neutral,
so it is copied into both amd64 and arm64 nginx runtime images during
the multi-platform CI build.

## Deploy with docker-compose

`docker-compose.yml` runs the SyncTV server (postgres + redis + synctv) and the
Flutter Web image side by side:

```sh
SYNCTV_WEB_IMAGE_TAG=<sha-or-tag> docker compose up -d
```

The `web` service forwards `SYNCTV_BACKEND_URL` (default
`http://synctv:8080`) and `NGINX_CLIENT_MAX_BODY_SIZE` (default `200m`) into
the container. nginx resolves the backend hostname **per request** via Docker's
embedded DNS (`resolver 127.0.0.11`) instead of at config load, so nginx starts
and keeps serving even while the synctv container restarts or is briefly absent
from DNS.

## nginx template

`deploy/nginx.conf.template` is rendered by the official nginx image's
envsubst entrypoint. Only environment variables defined in the container
(`SYNCTV_BACKEND_URL`, `NGINX_PORT`, `NGINX_CLIENT_MAX_BODY_SIZE`) are
substituted; nginx runtime variables (`$request_uri`, `$http_host`, ...)
pass through untouched.

- `/` — static bundle, SPA fallback to `index.html`.
- `/api/` — proxied to the backend (`proxy_read_timeout 300s`).
- `/ws/rooms/` — WebSocket upgrade proxy for realtime rooms (`3600s` timeouts).
