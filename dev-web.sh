#!/usr/bin/env bash
set -euo pipefail

PROXY_PORT="${SYNCTV_PROXY_PORT:-8081}"
APP_PORT="${SYNCTV_APP_PORT:-8083}"
API_UPSTREAM="${SYNCTV_API_UPSTREAM:-http://localhost:8080}"
RUN_MODE="${SYNCTV_RUN_MODE:-debug}"

cleanup() {
  if [[ -n "${PROXY_PID:-}" ]]; then
    kill "$PROXY_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

dart tool/web_reverse_proxy.dart \
  --listen-port="$PROXY_PORT" \
  --app-upstream="http://127.0.0.1:${APP_PORT}" \
  --api-upstream="$API_UPSTREAM" &
PROXY_PID=$!

FLUTTER_ARGS=(
  run
  -d web-server
  --web-hostname=0.0.0.0
  --web-port="$APP_PORT"
  --no-pub
)
if [[ -n "${SYNCTV_BUILT_IN_SERVER_URL:-}" ]]; then
  FLUTTER_ARGS+=(--dart-define=SYNCTV_BUILT_IN_SERVER_URL="$SYNCTV_BUILT_IN_SERVER_URL")
fi

case "$RUN_MODE" in
  debug)
    FLUTTER_ARGS+=(--debug)
    ;;
  profile)
    FLUTTER_ARGS+=(--profile)
    ;;
  release)
    FLUTTER_ARGS+=(--release)
    ;;
  *)
    echo "Unsupported RUN_MODE: ${RUN_MODE}" >&2
    exit 1
    ;;
esac

flutter "${FLUTTER_ARGS[@]}"
