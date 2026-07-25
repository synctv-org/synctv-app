#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: $0 <android|linux|macos|ios> <architecture> <version> <output-directory>" >&2
  exit 2
fi

platform="$1"
architecture="$2"
version="$3"
output_directory="$4"
mkdir -p "$output_directory"
output_directory="$(cd "$output_directory" && pwd)"

case "$platform" in
  android)
    signing_label="${SYNCTV_ANDROID_SIGNING_LABEL:-development}"
    declare -A architectures=(
      [app-armeabi-v7a-release.apk]=armv7
      [app-arm64-v8a-release.apk]=arm64
      [app-x86_64-release.apk]=x64
      [app-release.apk]=universal
    )
    for file_name in "${!architectures[@]}"; do
      source_file="build/app/outputs/flutter-apk/$file_name"
      if [[ ! -f "$source_file" ]]; then
        echo "missing Android artifact: $source_file" >&2
        exit 1
      fi
      cp "$source_file" \
        "$output_directory/SyncTV-$version-android-${architectures[$file_name]}-$signing_label.apk"
    done
    app_bundle="build/app/outputs/bundle/release/app-release.aab"
    if [[ ! -f "$app_bundle" ]]; then
      echo "missing Android App Bundle: $app_bundle" >&2
      exit 1
    fi
    cp "$app_bundle" \
      "$output_directory/SyncTV-$version-android-universal-$signing_label.aab"
    ;;
  linux)
    bundle_directory="$(find build/linux -type d -path '*/release/bundle' -print -quit)"
    if [[ -z "$bundle_directory" ]]; then
      echo "Linux release bundle was not found" >&2
      exit 1
    fi
    tar -C "$bundle_directory" -czf \
      "$output_directory/SyncTV-$version-linux-$architecture.tar.gz" .
    ;;
  macos)
    signing_label="${SYNCTV_MACOS_SIGNING_LABEL:-ad-hoc}"
    if [[ "$architecture" == "universal" ]]; then
      app_path="build/macos/Build/Products/Release/SyncTV.app"
    else
      app_path="build/macos/Build/Products/Release/$architecture/SyncTV.app"
    fi
    if [[ ! -d "$app_path" ]]; then
      echo "macOS release app was not found: $app_path" >&2
      exit 1
    fi
    ditto -c -k --sequesterRsrc --keepParent "$app_path" \
      "$output_directory/SyncTV-$version-macos-$architecture-$signing_label.zip"
    dmg_staging="$(mktemp -d)"
    trap 'rm -rf "${dmg_staging:-}"' EXIT
    ditto "$app_path" "$dmg_staging/SyncTV.app"
    ln -s /Applications "$dmg_staging/Applications"
    hdiutil create \
      -volname "SyncTV" \
      -srcfolder "$dmg_staging" \
      -ov \
      -format UDZO \
      -imagekey zlib-level=9 \
      "$output_directory/SyncTV-$version-macos-$architecture-$signing_label.dmg"
    rm -rf "$dmg_staging"
    trap - EXIT
    ;;
  ios)
    if [[ "${SYNCTV_IOS_SIGNED:-0}" == "1" ]]; then
      exported_ipa="$(find build/ios/ipa -maxdepth 1 -type f -name '*.ipa' -print -quit)"
      if [[ -z "$exported_ipa" ]]; then
        echo "signed App Store IPA was not found" >&2
        exit 1
      fi
      cp "$exported_ipa" "$output_directory/SyncTV-$version-ios-signed.ipa"
    else
      app_path="build/ios/iphoneos/Runner.app"
      if [[ ! -d "$app_path" ]]; then
        echo "iOS release app was not found: $app_path" >&2
        exit 1
      fi
      ditto -c -k --sequesterRsrc --keepParent "$app_path" \
        "$output_directory/SyncTV-$version-ios-unsigned.zip"
    fi
    ;;
  *)
    echo "unsupported release platform: $platform" >&2
    exit 2
    ;;
esac

symbols_directory="build/symbols/$platform-$architecture"
if [[ ! -d "$symbols_directory" ]]; then
  echo "missing $platform $architecture symbols: $symbols_directory" >&2
  exit 1
fi

if [[ "$platform" == "macos" || "$platform" == "ios" ]]; then
  ditto -c -k --sequesterRsrc --keepParent "$symbols_directory" \
    "$output_directory/SyncTV-$version-$platform-$architecture-symbols.zip"
else
  tar -C "$symbols_directory" -czf \
    "$output_directory/SyncTV-$version-$platform-$architecture-symbols.tar.gz" .
fi
