#!/usr/bin/env bash
set -euo pipefail

app_path="${1:?app path is required}"
rp_ids="${2:-}"

codesign --verify --deep --strict --verbose=2 "$app_path"
entitlements_plist="$(mktemp)"
entitlements_json="$(mktemp)"
trap 'rm -f "$entitlements_plist" "$entitlements_json"' EXIT
codesign -d --entitlements :- "$app_path" > "$entitlements_plist" 2>/dev/null
plutil -convert json -o "$entitlements_json" "$entitlements_plist"

if [[ -z "$rp_ids" ]]; then
  exit 0
fi

IFS=';' read -r -a configured_rp_ids <<< "$rp_ids"
for raw_rp_id in "${configured_rp_ids[@]}"; do
  rp_id="$(printf '%s' "$raw_rp_id" | tr '[:upper:]' '[:lower:]' | xargs)"
  jq -e --arg domain "webcredentials:$rp_id" \
    '.["com.apple.developer.associated-domains"] | index($domain) != null' \
    "$entitlements_json" >/dev/null
done
