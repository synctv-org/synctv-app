#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <artifact-directory> <output-file>" >&2
  exit 2
fi

required_environment=(
  ARTIFACT_VERSION
  GITHUB_REPOSITORY
  GITHUB_SERVER_URL
  GITHUB_SHA
  RELEASE_TAG
)
for variable in "${required_environment[@]}"; do
  if [[ -z "${!variable:-}" ]]; then
    echo "$variable is required" >&2
    exit 1
  fi
done

artifact_directory="$(cd "$1" && pwd)"
output_file="$2"
asset_base="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/releases/download/$RELEASE_TAG"

cat > "$output_file" <<'EOF'
<!-- synctv-app-downloads:start -->
## Quick downloads

> [!TIP]
> Choose the Universal build on Android and macOS. Windows users should choose the EXE installer; Linux users should choose the DEB package on Debian and Ubuntu.

| Platform | Device | Recommended download | Alternative | Best for |
|:---|:---|:---:|:---|:---|
EOF

find_asset() {
  local pattern="$1"
  local matches=()
  while IFS= read -r match; do
    if [[ "$match" == *-symbols.* ]]; then
      continue
    fi
    matches+=("$match")
  done < <(compgen -G "$artifact_directory/$pattern" || true)
  if [[ ${#matches[@]} -eq 0 ]]; then
    return 1
  fi
  basename "${matches[0]}"
}

append_download() {
  local platform="$1"
  local device="$2"
  local primary_pattern="$3"
  local package_type="$4"
  local badge_color="$5"
  local badge_logo="$6"
  local details="$7"
  local alternative_pattern="${8:-}"
  local alternative_label="${9:-}"
  local primary_asset
  if ! primary_asset="$(find_asset "$primary_pattern")"; then
    return
  fi
  local alternative="-"
  if [[ -n "$alternative_pattern" ]]; then
    local alternative_asset
    if alternative_asset="$(find_asset "$alternative_pattern")"; then
      alternative="[$alternative_label]($asset_base/$alternative_asset)"
    fi
  fi
  local badge="https://img.shields.io/badge/Download-$package_type-$badge_color?style=for-the-badge&logo=$badge_logo&logoColor=white"
  printf "| **%s** | %s | [![Download %s](%s)](%s/%s)<br><sub>\`%s\`</sub> | %s | %s |\n" \
    "$platform" \
    "$device" \
    "$package_type" \
    "$badge" \
    "$asset_base" \
    "$primary_asset" \
    "$primary_asset" \
    "$alternative" \
    "$details" >> "$output_file"
}

append_download "Android" "Universal" \
  "SyncTV-$ARTIFACT_VERSION-android-universal-*.apk" \
  "APK" "3DDC84" "android" \
  "Most phones and tablets" \
  "SyncTV-$ARTIFACT_VERSION-android-universal-*.aab" \
  "AAB publishing bundle"
append_download "Android" "arm64" \
  "SyncTV-$ARTIFACT_VERSION-android-arm64-*.apk" \
  "APK" "3DDC84" "android" \
  "Current 64-bit Android devices"
append_download "Android" "armv7" \
  "SyncTV-$ARTIFACT_VERSION-android-armv7-*.apk" \
  "APK" "3DDC84" "android" \
  "32-bit Android devices"
append_download "Android" "x64" \
  "SyncTV-$ARTIFACT_VERSION-android-x64-*.apk" \
  "APK" "3DDC84" "android" \
  "x86_64 devices and emulators"
append_download "iOS" "arm64" \
  "SyncTV-$ARTIFACT_VERSION-ios-signed.ipa" \
  "IPA" "000000" "apple" \
  "App Store distribution archive"
append_download "iOS" "arm64" \
  "SyncTV-$ARTIFACT_VERSION-ios-unsigned.zip" \
  "ZIP" "000000" "apple" \
  "Re-signable archive for fork builds"
append_download "macOS" "Universal" \
  "SyncTV-$ARTIFACT_VERSION-macos-universal-*.dmg" \
  "DMG" "000000" "apple" \
  "Apple silicon and Intel Macs" \
  "SyncTV-$ARTIFACT_VERSION-macos-universal-*.zip" \
  "Portable ZIP"
append_download "macOS" "Apple silicon" \
  "SyncTV-$ARTIFACT_VERSION-macos-arm64-*.dmg" \
  "DMG" "000000" "apple" \
  "Apple silicon Macs" \
  "SyncTV-$ARTIFACT_VERSION-macos-arm64-*.zip" \
  "Portable ZIP"
append_download "macOS" "Intel" \
  "SyncTV-$ARTIFACT_VERSION-macos-x64-*.dmg" \
  "DMG" "000000" "apple" \
  "Intel Macs" \
  "SyncTV-$ARTIFACT_VERSION-macos-x64-*.zip" \
  "Portable ZIP"
append_download "Windows" "x64" \
  "SyncTV-$ARTIFACT_VERSION-windows-x64-setup.exe" \
  "EXE" "0078D4" "windows11" \
  "64-bit Windows 10 and 11" \
  "SyncTV-$ARTIFACT_VERSION-windows-x64.zip" \
  "Portable ZIP"
append_download "Linux" "x64" \
  "SyncTV-$ARTIFACT_VERSION-linux-x64.deb" \
  "DEB" "FCC624" "linux" \
  "Debian and Ubuntu on Intel or AMD" \
  "SyncTV-$ARTIFACT_VERSION-linux-x64.tar.gz" \
  "Portable TAR.GZ"
append_download "Linux" "arm64" \
  "SyncTV-$ARTIFACT_VERSION-linux-arm64.deb" \
  "DEB" "FCC624" "linux" \
  "Debian and Ubuntu on ARM64" \
  "SyncTV-$ARTIFACT_VERSION-linux-arm64.tar.gz" \
  "Portable TAR.GZ"

printf "| **Checksums** | All files | [![Verify SHA-256](https://img.shields.io/badge/Verify-SHA--256-24292F?style=for-the-badge&logo=github&logoColor=white)](%s/SHA256SUMS.txt) | - | Integrity verification |\n" \
  "$asset_base" >> "$output_file"

cat >> "$output_file" <<'EOF'

## Installation notes

- Android filenames identify stable `signed` and ephemeral `development` signing modes.
- Signed Android releases include a public `android-passkey-server-config.yaml` file for self-hosted servers.
- Windows publishes an x64 EXE installer and portable ZIP. Official builds use Authenticode when signing secrets are configured.
- Linux publishes DEB installers and portable TAR.GZ archives for x64 and ARM64.
- macOS publishes DMG installers and portable ZIPs for Universal, Apple silicon, and Intel builds. Signed releases carry stapled Apple notarization tickets.
- iOS publishes a signed IPA when signing secrets are configured and an unsigned re-signable archive for fork builds.
- `SHA256SUMS.txt` authenticates every attached SyncTV artifact.
<!-- synctv-app-downloads:end -->
EOF

generated_notes="$(gh api \
  --method POST \
  "repos/$GITHUB_REPOSITORY/releases/generate-notes" \
  -f tag_name="$RELEASE_TAG" \
  -f target_commitish="$GITHUB_SHA" \
  --jq .body)"
if [[ -n "$generated_notes" ]]; then
  printf '\n%s\n' "$generated_notes" >> "$output_file"
fi
