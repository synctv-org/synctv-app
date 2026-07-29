#!/usr/bin/env bash
set -euo pipefail

app_path="${1:?app path is required}"
rp_ids="${2:-}"
oauth2_origin="${3:-}"

codesign --verify --deep --strict --verbose=2 "$app_path"
entitlements_plist="$(mktemp)"
entitlements_json="$(mktemp)"
trap 'rm -f "$entitlements_plist" "$entitlements_json"' EXIT
codesign -d --entitlements :- "$app_path" > "$entitlements_plist" 2>/dev/null
plutil -convert json -o "$entitlements_json" "$entitlements_plist"

if [[ -n "$rp_ids" ]]; then
  IFS=';' read -r -a configured_rp_ids <<< "$rp_ids"
  for raw_rp_id in "${configured_rp_ids[@]}"; do
    rp_id="$(printf '%s' "$raw_rp_id" | tr '[:upper:]' '[:lower:]' | xargs)"
    jq -e --arg domain "webcredentials:$rp_id" \
      '.["com.apple.developer.associated-domains"] | index($domain) != null' \
      "$entitlements_json" >/dev/null
  done
fi

if [[ -n "$oauth2_origin" ]]; then
  oauth2_host="$(printf '%s\n' "$oauth2_origin" | sed -nE 's#^https://([^/:?#]+)(/[^?#]*)?$#\1#p')"
  if [[ -z "$oauth2_host" ]]; then
    echo "OAuth2 App Link origin must be an HTTPS origin without a port, query, or fragment" >&2
    exit 1
  fi
  jq -e --arg domain "applinks:$oauth2_host" \
    '.["com.apple.developer.associated-domains"] | index($domain) != null' \
    "$entitlements_json" >/dev/null
fi
