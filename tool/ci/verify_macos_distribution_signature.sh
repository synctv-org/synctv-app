#!/usr/bin/env bash
set -euo pipefail

app="${1:?macOS app path is required}"

codesign --verify --deep --strict --verbose=2 "$app"

signature_details="$(codesign --display --verbose=4 "$app" 2>&1)"
if ! grep -Eq '^CodeDirectory .*flags=.*\(runtime\)' <<< "$signature_details"; then
  echo "macOS distribution signature is missing hardened runtime" >&2
  exit 1
fi
if ! grep -q '^Timestamp=' <<< "$signature_details"; then
  echo "macOS distribution signature is missing a secure timestamp" >&2
  exit 1
fi

entitlements="$(codesign --display --entitlements :- "$app" 2>/dev/null)"
get_task_allow="$({
  printf '%s' "$entitlements" \
    | plutil -extract com.apple.security.get-task-allow raw -o - - 2>/dev/null
} || true)"
if [[ "$get_task_allow" == "true" ]]; then
  echo "macOS distribution signature contains get-task-allow=true" >&2
  exit 1
fi
