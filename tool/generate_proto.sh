#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROTO_ROOT="$ROOT_DIR"
OUT_DIR="$ROOT_DIR/lib/src/generated"

if [ -x "$ROOT_DIR/.fvm/flutter_sdk/bin/dart" ]; then
  export PATH="$ROOT_DIR/.fvm/flutter_sdk/bin:$PATH"
fi
export PATH="$PATH:$HOME/.pub-cache/bin"

if ! command -v protoc >/dev/null 2>&1; then
  echo "protoc is required to generate Dart protobuf files" >&2
  exit 1
fi

if ! command -v protoc-gen-dart >/dev/null 2>&1; then
  echo "protoc-gen-dart is required. Install it with: dart pub global activate protoc_plugin" >&2
  exit 1
fi

PROTO_FILES=()
while IFS= read -r file; do
  PROTO_FILES+=("$file")
done < <(
  find "$ROOT_DIR/proto" -type f -name '*.proto' \
    ! -path "$ROOT_DIR/proto/buf/validate/*" \
    | sort
)

if [ "${#PROTO_FILES[@]}" -eq 0 ]; then
  echo "no proto files found under $ROOT_DIR/proto" >&2
  exit 1
fi

rm -rf "$OUT_DIR/proto"
mkdir -p "$OUT_DIR"

protoc \
  --dart_out="$OUT_DIR" \
  -I"$PROTO_ROOT" \
  -I"$PROTO_ROOT/proto" \
  "${PROTO_FILES[@]}"

find "$OUT_DIR/proto" -type f \( -name '*.pbgrpc.dart' -o -name '*.pbserver.dart' \) -delete
