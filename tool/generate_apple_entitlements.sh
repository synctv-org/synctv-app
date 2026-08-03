#!/usr/bin/env bash
set -euo pipefail

PLATFORM="${1:?platform is required}"
OUTPUT="${2:?output path is required}"
CONFIGURATION="${3:-Debug}"
SIGNING_TEAM="${4:-}"
OAUTH2_ORIGIN=""
PASSKEY_RP_IDS=""

decode_define() {
  printf '%s' "$1" | base64 --decode 2>/dev/null ||
    printf '%s' "$1" | base64 -D 2>/dev/null
}

if [[ -n "${DART_DEFINES:-}" ]]; then
  IFS=',' read -r -a encoded_defines <<< "$DART_DEFINES"
  for encoded in "${encoded_defines[@]}"; do
    decoded="$(decode_define "$encoded" || true)"
    case "$decoded" in
      SYNCTV_OAUTH2_APP_LINK_ORIGIN=*)
        OAUTH2_ORIGIN="${decoded#SYNCTV_OAUTH2_APP_LINK_ORIGIN=}"
        ;;
      SYNCTV_PASSKEY_RP_IDS=*)
        PASSKEY_RP_IDS="${decoded#SYNCTV_PASSKEY_RP_IDS=}"
        ;;
    esac
  done
fi

oauth2_host=""
if [[ -n "$OAUTH2_ORIGIN" && -n "$SIGNING_TEAM" ]]; then
  oauth2_host="$(printf '%s\n' "$OAUTH2_ORIGIN" | sed -nE 's#^https://([^/:?#]+)(/[^?#]*)?$#\1#p')"
  if [[ -z "$oauth2_host" ]]; then
    echo "SYNCTV_OAUTH2_APP_LINK_ORIGIN must be an HTTPS origin without a port, query, or fragment" >&2
    exit 1
  fi
fi

passkey_domains=()
if [[ -n "$PASSKEY_RP_IDS" && -n "$SIGNING_TEAM" ]]; then
  IFS=';' read -r -a configured_rp_ids <<< "$PASSKEY_RP_IDS"
  for raw_rp_id in "${configured_rp_ids[@]}"; do
    rp_id="$(printf '%s' "$raw_rp_id" | tr '[:upper:]' '[:lower:]' | xargs)"
    if ! [[ "$rp_id" =~ ^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$ ]] ||
       [[ "$rp_id" == *..* ]]; then
      echo "SYNCTV_PASSKEY_RP_IDS contains an invalid RP ID: $raw_rp_id" >&2
      exit 1
    fi
    passkey_domains+=("$rp_id")
  done
fi

mkdir -p "$(dirname "$OUTPUT")"
{
  cat <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
EOF

  if [[ "$PLATFORM" == "macos" ]]; then
    cat <<'EOF'
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<!-- Required by the loopback OAuth callback and P2P media gateway servers. -->
	<key>com.apple.security.network.server</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.device.audio-input</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-only</key>
	<true/>
EOF
    if [[ "$CONFIGURATION" != "Release" ]]; then
      cat <<'EOF'
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
EOF
    fi
  elif [[ "$PLATFORM" != "ios" ]]; then
    echo "unsupported Apple platform: $PLATFORM" >&2
    exit 1
  fi

  if [[ -n "$oauth2_host" || ${#passkey_domains[@]} -gt 0 ]]; then
    printf '\t<key>com.apple.developer.associated-domains</key>\n\t<array>\n'
    if [[ -n "$oauth2_host" ]]; then
      printf '\t\t<string>applinks:%s</string>\n' "$oauth2_host"
    fi
    for rp_id in "${passkey_domains[@]}"; do
      printf '\t\t<string>webcredentials:%s</string>\n' "$rp_id"
    done
    printf '\t</array>\n'
  fi

  cat <<'EOF'
</dict>
</plist>
EOF
} > "$OUTPUT"
