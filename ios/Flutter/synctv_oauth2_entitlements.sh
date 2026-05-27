#!/bin/sh
set -eu

OUTPUT="${SRCROOT}/Flutter/GeneratedOAuth2.entitlements"
DOMAIN="${SYNC_TV_OAUTH2_APP_LINK_DOMAIN:-}"

decode_define() {
  printf '%s' "$1" | base64 --decode 2>/dev/null ||
    printf '%s' "$1" | base64 -D 2>/dev/null
}

if [ -n "${DART_DEFINES:-}" ]; then
  OLD_IFS="$IFS"
  IFS=','
  for encoded in $DART_DEFINES; do
    decoded="$(decode_define "$encoded" || true)"
    case "$decoded" in
      SYNC_TV_OAUTH2_APP_LINK_ORIGIN=*)
        origin="${decoded#SYNC_TV_OAUTH2_APP_LINK_ORIGIN=}"
        host="$(printf '%s\n' "$origin" | sed -nE 's#^https://([^/:?#]+)(/[^?#]*)?$#\1#p')"
        if [ -n "$host" ]; then
          DOMAIN="applinks:$host"
        else
          echo "SYNC_TV_OAUTH2_APP_LINK_ORIGIN must be an https origin without port, query, or fragment" >&2
          exit 1
        fi
        ;;
    esac
  done
  IFS="$OLD_IFS"
fi

if [ -z "$DOMAIN" ]; then
  DOMAIN="applinks:oauth.invalid"
fi

cat > "$OUTPUT" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>$DOMAIN</string>
	</array>
</dict>
</plist>
EOF
