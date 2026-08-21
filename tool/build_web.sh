#!/usr/bin/env bash
set -euo pipefail

BUILT_IN_SERVER_URL="${SYNCTV_BUILT_IN_SERVER_URL:-}"
BUILD_OUTPUT="${SYNCTV_BUILD_OUTPUT:-build/web}"
OPTIMIZATION_LEVEL="${SYNCTV_OPTIMIZATION_LEVEL:-4}"
SOURCE_MAPS="${SYNCTV_SOURCE_MAPS:-0}"
WEB_RESOURCES_CDN="${SYNCTV_WEB_RESOURCES_CDN:-1}"
BASE_HREF="${SYNCTV_BASE_HREF:-}"
SKIP_PUB="${SYNCTV_SKIP_PUB:-1}"

ARGS=(
  --release
  --output="$BUILD_OUTPUT"
  --optimization-level="$OPTIMIZATION_LEVEL"
)
if [[ -n "$BUILT_IN_SERVER_URL" ]]; then
  ARGS+=(--dart-define=SYNCTV_BUILT_IN_SERVER_URL="$BUILT_IN_SERVER_URL")
fi
if [[ "$SOURCE_MAPS" != "1" ]]; then
  ARGS+=(--no-source-maps)
fi
if [[ "$WEB_RESOURCES_CDN" == "1" ]]; then
  ARGS+=(--web-resources-cdn)
else
  ARGS+=(--no-web-resources-cdn)
fi
if [[ "$SKIP_PUB" == "1" ]]; then
  ARGS+=(--no-pub)
fi
if [[ -n "$BASE_HREF" ]]; then
  ARGS+=(--base-href="$BASE_HREF")
fi

flutter build web "${ARGS[@]}"

if [[ -f web/pwa-service-worker.js ]]; then
  cp web/pwa-service-worker.js "$BUILD_OUTPUT/flutter_service_worker.js"
fi
