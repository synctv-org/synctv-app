#!/usr/bin/env bash
set -euo pipefail

platform="${1:?platform is required}"
output="${2:?signing xcconfig output is required}"

case "$platform" in
  ios|macos) ;;
  *)
    echo "unsupported Apple signing platform: $platform" >&2
    exit 2
    ;;
esac

required_names=(
  SYNCTV_APPLE_CERTIFICATE_BASE64
  SYNCTV_APPLE_CERTIFICATE_PASSWORD
  SYNCTV_APPLE_DEVELOPMENT_TEAM
  SYNCTV_APPLE_SIGNING_IDENTITY
  SYNCTV_APPLE_PROVISIONING_PROFILE_BASE64
)
configured=0
for name in "${required_names[@]}"; do
  if [[ -n "${!name:-}" ]]; then
    configured=$((configured + 1))
  fi
done

if [[ "$configured" -eq 0 ]]; then
  if [[ "$platform" == "macos" ]]; then
    echo "SYNCTV_MACOS_SIGNING_LABEL=ad-hoc" >> "${GITHUB_ENV:?GITHUB_ENV is required}"
  fi
  echo "mode=unsigned" >> "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"
  exit 0
fi
if [[ "$configured" -ne "${#required_names[@]}" ]]; then
  echo "Apple release signing configuration is incomplete for $platform" >&2
  exit 1
fi

for value in \
  "$SYNCTV_APPLE_DEVELOPMENT_TEAM" \
  "$SYNCTV_APPLE_SIGNING_IDENTITY"; do
  if [[ "$value" == *$'\n'* || "$value" == *$'\r'* ]]; then
    echo "Apple signing values must be single-line strings" >&2
    exit 1
  fi
done

decode_base64() {
  if printf '%s' "$1" | base64 --decode > "$2" 2>/dev/null; then
    return
  fi
  printf '%s' "$1" | base64 -D > "$2"
}

keychain_path="$RUNNER_TEMP/synctv-signing.keychain-db"
keychain_password="$(openssl rand -hex 32)"
certificate_path="$RUNNER_TEMP/synctv-signing.p12"
profile_path="$RUNNER_TEMP/synctv-$platform.provisionprofile"
profile_plist="$RUNNER_TEMP/synctv-$platform-profile.plist"

decode_base64 "$SYNCTV_APPLE_CERTIFICATE_BASE64" "$certificate_path"
decode_base64 "$SYNCTV_APPLE_PROVISIONING_PROFILE_BASE64" "$profile_path"

security create-keychain -p "$keychain_password" "$keychain_path"
security set-keychain-settings -lut 21600 "$keychain_path"
security unlock-keychain -p "$keychain_password" "$keychain_path"
security import "$certificate_path" \
  -P "$SYNCTV_APPLE_CERTIFICATE_PASSWORD" \
  -A \
  -t cert \
  -f pkcs12 \
  -k "$keychain_path"

additional_certificate_base64="${SYNCTV_APPLE_ADDITIONAL_CERTIFICATE_BASE64:-}"
additional_certificate_password="${SYNCTV_APPLE_ADDITIONAL_CERTIFICATE_PASSWORD:-}"
if [[ -n "$additional_certificate_base64" || -n "$additional_certificate_password" ]]; then
  if [[ -z "$additional_certificate_base64" || -z "$additional_certificate_password" ]]; then
    echo "Additional Apple certificate configuration is incomplete" >&2
    exit 1
  fi
  additional_certificate_path="$RUNNER_TEMP/synctv-additional-signing.p12"
  decode_base64 "$additional_certificate_base64" "$additional_certificate_path"
  security import "$additional_certificate_path" \
    -P "$additional_certificate_password" \
    -A \
    -t cert \
    -f pkcs12 \
    -k "$keychain_path"
fi
security set-key-partition-list \
  -S apple-tool:,apple: \
  -s \
  -k "$keychain_password" \
  "$keychain_path" >/dev/null
security list-keychains -d user -s "$keychain_path"
security default-keychain -d user -s "$keychain_path"
security find-identity -v -p codesigning "$keychain_path"

security cms -D -i "$profile_path" > "$profile_plist"
profile_uuid="$(plutil -extract UUID raw -o - "$profile_plist")"
profile_team="$(plutil -extract TeamIdentifier.0 raw -o - "$profile_plist")"
if [[ "$profile_team" != "$SYNCTV_APPLE_DEVELOPMENT_TEAM" ]]; then
  echo "Provisioning profile team does not match SYNCTV_APPLE_DEVELOPMENT_TEAM" >&2
  exit 1
fi
case "$platform" in
  ios) profile_extension="mobileprovision" ;;
  macos) profile_extension="provisionprofile" ;;
esac

profile_directories=(
  "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"
  "$HOME/Library/MobileDevice/Provisioning Profiles"
)
for profile_directory in "${profile_directories[@]}"; do
  mkdir -p "$profile_directory"
  cp "$profile_path" \
    "$profile_directory/$profile_uuid.$profile_extension"
done

mkdir -p "$(dirname "$output")"
{
  printf 'SYNCTV_CODE_SIGN_IDENTITY = %s\n' "$SYNCTV_APPLE_SIGNING_IDENTITY"
  printf 'SYNCTV_CODE_SIGN_STYLE = Manual\n'
  printf 'SYNCTV_DEVELOPMENT_TEAM = %s\n' "$SYNCTV_APPLE_DEVELOPMENT_TEAM"
  printf 'SYNCTV_PROVISIONING_PROFILE_SPECIFIER = %s\n' "$profile_uuid"
  if [[ "$platform" == "macos" ]]; then
    printf 'SYNCTV_ENABLE_HARDENED_RUNTIME = YES\n'
    printf 'SYNCTV_CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO\n'
    printf 'SYNCTV_OTHER_CODE_SIGN_FLAGS = --timestamp\n'
  fi
} > "$output"

{
  echo "SYNCTV_APPLE_KEYCHAIN_PATH=$keychain_path"
  if [[ "$platform" == "macos" ]]; then
    echo "SYNCTV_MACOS_SIGNING_IDENTITY=$SYNCTV_APPLE_SIGNING_IDENTITY"
    echo "SYNCTV_MACOS_SIGNING_LABEL=signed"
  fi
} >> "${GITHUB_ENV:?GITHUB_ENV is required}"

if [[ "$platform" == "ios" ]]; then
  export_options="$RUNNER_TEMP/synctv-ios-export-options.plist"
  plutil -create xml1 "$export_options"
  plutil -insert method -string app-store-connect "$export_options"
  plutil -insert destination -string export "$export_options"
  plutil -insert signingStyle -string manual "$export_options"
  plutil -insert signingCertificate -string "$SYNCTV_APPLE_SIGNING_IDENTITY" "$export_options"
  plutil -insert teamID -string "$SYNCTV_APPLE_DEVELOPMENT_TEAM" "$export_options"
  plutil -insert manageAppVersionAndBuildNumber -bool false "$export_options"
  plutil -insert stripSwiftSymbols -bool true "$export_options"
  plutil -insert provisioningProfiles -dictionary "$export_options"
  plutil -insert 'provisioningProfiles.org\.synctv\.app' -string "$profile_uuid" "$export_options"
  echo "SYNCTV_IOS_EXPORT_OPTIONS_PLIST=$export_options" >> "${GITHUB_ENV:?GITHUB_ENV is required}"
fi

echo "mode=signed" >> "$GITHUB_OUTPUT"
