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

case "$platform" in
  android)
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
        "$output_directory/SyncTV-$version-android-${architectures[$file_name]}.apk"
    done
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
      "$output_directory/SyncTV-$version-macos-$architecture.zip"
    ;;
  ios)
    app_path="build/ios/iphoneos/Runner.app"
    if [[ ! -d "$app_path" ]]; then
      echo "iOS release app was not found: $app_path" >&2
      exit 1
    fi
    ditto -c -k --sequesterRsrc --keepParent "$app_path" \
      "$output_directory/SyncTV-$version-ios-unsigned.zip"
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
