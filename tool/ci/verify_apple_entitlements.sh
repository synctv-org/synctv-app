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

if [[ -f "$app_path/Contents/Info.plist" ]]; then
  info_plist="$app_path/Contents/Info.plist"
else
  info_plist="$app_path/Info.plist"
fi

if [[ ! -f "$info_plist" ]]; then
  echo "Apple app Info.plist does not exist: $info_plist" >&2
  exit 1
fi

for purpose_key in \
  NSCameraUsageDescription \
  NSMicrophoneUsageDescription \
  NSLocalNetworkUsageDescription; do
  purpose_value="$(
    plutil -extract "$purpose_key" raw -o - "$info_plist" 2>/dev/null || true
  )"
  if [[ -z "${purpose_value//[[:space:]]/}" ]]; then
    echo "Apple app contains an empty or missing $purpose_key" >&2
    exit 1
  fi
done

if jq -e '.["com.apple.security.network.server"] == true' \
  "$entitlements_json" >/dev/null; then
  echo "Apple app contains the unnecessary network server entitlement" >&2
  exit 1
fi

if jq -e '.["com.apple.security.app-sandbox"] == true' \
  "$entitlements_json" >/dev/null; then
  jq -e '.["com.apple.security.network.client"] == true' \
    "$entitlements_json" >/dev/null
fi

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
  jq -e --arg domain "webcredentials:$oauth2_host" \
    '.["com.apple.developer.associated-domains"] | index($domain) != null' \
    "$entitlements_json" >/dev/null
fi
