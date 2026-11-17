#!/usr/bin/env bash
# Shared Dart SDK resolution for repo tool scripts.
#
# Resolving `dart` from PATH can pick a different SDK than the one that owns
# `.dart_tool`: a native-assets hook cache compiled by another SDK then fails
# with "Invalid kernel binary format version", and an older SDK cannot load
# the resolved dependencies at all. Prefer the SDK the project is pinned to,
# and heal a stale hook cache once by retrying after removing it — the hooks
# runner cache is not keyed by SDK version.

_synctv_project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)"

resolve_project_dart() {
  local flutter_root="${FLUTTER_ROOT:-}"
  if [ -n "$flutter_root" ] &&
    [ -x "$flutter_root/bin/cache/dart-sdk/bin/dart" ]; then
    printf '%s\n' "$flutter_root/bin/cache/dart-sdk/bin/dart"
    return 0
  fi
  local fvm_dart="$_synctv_project_root/.fvm/flutter_sdk/bin/dart"
  if [ -x "$fvm_dart" ]; then
    printf '%s\n' "$fvm_dart"
    return 0
  fi
  if command -v dart >/dev/null 2>&1; then
    printf '%s\n' dart
    return 0
  fi
  echo "no project Dart SDK found: set FLUTTER_ROOT, pin one with fvm, or put dart on PATH" >&2
  return 1
}

project_dart() {
  local dart_bin
  if ! dart_bin="$(resolve_project_dart)"; then
    return 1
  fi
  local output status
  if output="$("$dart_bin" "$@" 2>&1)"; then
    printf '%s\n' "$output"
    return 0
  fi
  status=$?
  if printf '%s\n' "$output" |
    grep -Eq 'Invalid kernel binary format version|Running build hooks failed'; then
    rm -rf "$_synctv_project_root/.dart_tool/hooks_runner"
    "$dart_bin" "$@"
    return
  fi
  printf '%s\n' "$output" >&2
  return "$status"
}
