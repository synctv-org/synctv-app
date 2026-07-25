#!/usr/bin/env bash
set -euo pipefail

source_app="${1:-build/macos/Build/Products/Release/SyncTV.app}"
output_root="${2:-build/macos/Build/Products/Release}"
source_symbols="${3:-build/symbols/macos-universal}"

if [[ ! -d "$source_app" ]]; then
  echo "macOS universal app was not found: $source_app" >&2
  exit 1
fi
if [[ ! -d "$source_symbols" ]]; then
  echo "macOS universal symbols were not found: $source_symbols" >&2
  exit 1
fi

create_app() {
  local architecture="$1"
  local macho_architecture="$2"
  local symbol_name="$3"
  local destination_directory="$output_root/$architecture"
  local destination_app="$destination_directory/SyncTV.app"
  local destination_symbols="build/symbols/macos-$architecture"
  local checked=0

  rm -rf "$destination_directory" "$destination_symbols"
  mkdir -p "$destination_directory" "$destination_symbols"
  ditto "$source_app" "$destination_app"

  while IFS= read -r -d '' file_path; do
    local architectures
    architectures="$(lipo -archs "$file_path" 2>/dev/null || true)"
    if [[ -z "$architectures" ]]; then
      continue
    fi
    if [[ " $architectures " != *" $macho_architecture "* ]]; then
      echo "macOS binary lacks $macho_architecture: $file_path ($architectures)" >&2
      exit 1
    fi

    local temporary_file="$file_path.thin"
    local permissions
    permissions="$(stat -f '%Lp' "$file_path")"
    lipo "$file_path" -thin "$macho_architecture" -output "$temporary_file"
    chmod "$permissions" "$temporary_file"
    mv "$temporary_file" "$file_path"
    checked=$((checked + 1))
  done < <(find "$destination_app" -type f -print0)

  if [[ "$checked" -eq 0 ]]; then
    echo "No Mach-O binaries were found in $destination_app" >&2
    exit 1
  fi

  local source_symbol="$source_symbols/$symbol_name"
  if [[ ! -f "$source_symbol" ]]; then
    echo "macOS $architecture symbols were not found: $source_symbol" >&2
    exit 1
  fi
  cp "$source_symbol" "$destination_symbols/$symbol_name"

  local signing_identity="${SYNCTV_MACOS_SIGNING_IDENTITY:--}"
  local timestamp_argument="--timestamp=none"
  local runtime_arguments=()
  if [[ "$signing_identity" != "-" ]]; then
    timestamp_argument="--timestamp"
    runtime_arguments=(--options runtime)
  fi
  codesign --force --deep --sign "$signing_identity" "$timestamp_argument" \
    "${runtime_arguments[@]}" \
    --preserve-metadata=entitlements,requirements,flags \
    "$destination_app"
  codesign --verify --deep --strict "$destination_app"
  echo "Created $architecture macOS app with $checked Mach-O binaries"
}

create_app arm64 arm64 app.darwin-arm64.symbols
create_app x64 x86_64 app.darwin-x86_64.symbols
