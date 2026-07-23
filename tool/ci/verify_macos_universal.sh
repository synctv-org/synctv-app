#!/usr/bin/env bash
set -euo pipefail

app_path="${1:-build/macos/Build/Products/Release/SyncTV.app}"
if [[ ! -d "$app_path" ]]; then
  echo "macOS release app was not found: $app_path" >&2
  exit 1
fi

checked=0
while IFS= read -r -d '' file_path; do
  architectures="$(lipo -archs "$file_path" 2>/dev/null || true)"
  if [[ -z "$architectures" ]]; then
    continue
  fi
  checked=$((checked + 1))
  if [[ "$architectures" != *arm64* || "$architectures" != *x86_64* ]]; then
    echo "macOS binary is not universal: $file_path ($architectures)" >&2
    exit 1
  fi
done < <(find "$app_path" -type f -print0)

if [[ "$checked" -eq 0 ]]; then
  echo "No Mach-O binaries were found in $app_path" >&2
  exit 1
fi

echo "Verified $checked universal macOS binaries"
