#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <app-path> <universal|arm64|x64>" >&2
  exit 2
fi

app_path="$1"
architecture="$2"
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
  case "$architecture" in
    universal)
      if [[ " $architectures " != *" arm64 "* || " $architectures " != *" x86_64 "* ]]; then
        echo "macOS binary is not universal: $file_path ($architectures)" >&2
        exit 1
      fi
      ;;
    arm64)
      if [[ "$architectures" != "arm64" ]]; then
        echo "macOS binary is not arm64-only: $file_path ($architectures)" >&2
        exit 1
      fi
      ;;
    x64)
      if [[ "$architectures" != "x86_64" ]]; then
        echo "macOS binary is not x64-only: $file_path ($architectures)" >&2
        exit 1
      fi
      ;;
    *)
      echo "unsupported macOS architecture: $architecture" >&2
      exit 2
      ;;
  esac
done < <(find "$app_path" -type f -print0)

if [[ "$checked" -eq 0 ]]; then
  echo "No Mach-O binaries were found in $app_path" >&2
  exit 1
fi

codesign --verify --deep --strict "$app_path"
echo "Verified $checked $architecture macOS binaries"
