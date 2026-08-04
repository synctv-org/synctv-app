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
repository_url="${SYNCTV_REPOSITORY_URL:-}"
if [[ -z "$repository_url" && -n "${GITHUB_REPOSITORY:-}" ]]; then
  repository_url="${GITHUB_SERVER_URL:-https://github.com}/$GITHUB_REPOSITORY"
fi
if [[ -z "$repository_url" ]]; then
  remote_url="$(git remote get-url origin 2>/dev/null || true)"
  case "$remote_url" in
    http://*|https://*) repository_url="${remote_url%.git}" ;;
    git@*:* )
      remote_host_and_path="${remote_url#git@}"
      remote_host="${remote_host_and_path%%:*}"
      remote_path="${remote_host_and_path#*:}"
      repository_url="https://$remote_host/${remote_path%.git}"
      ;;
    *)
      echo "Unable to determine the repository URL; set SYNCTV_REPOSITORY_URL" >&2
      exit 1
      ;;
  esac
fi
package_maintainer="${SYNCTV_PACKAGE_MAINTAINER:-SyncTV contributors <noreply@example.invalid>}"
for control_field in "$repository_url" "$package_maintainer"; do
  if [[ "$control_field" == *$'\n'* || "$control_field" == *$'\r'* ]]; then
    echo "Debian control metadata must use single-line values" >&2
    exit 1
  fi
done
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

    case "$architecture" in
      x64) debian_architecture="amd64" ;;
      arm64) debian_architecture="arm64" ;;
      *)
        echo "unsupported Debian architecture: $architecture" >&2
        exit 2
        ;;
    esac
    debian_root="$(mktemp -d)"
    trap 'rm -rf "${debian_root:-}"' EXIT
    install -d \
      "$debian_root/DEBIAN" \
      "$debian_root/opt/synctv" \
      "$debian_root/usr/bin" \
      "$debian_root/usr/share/applications" \
      "$debian_root/usr/share/doc/synctv" \
      "$debian_root/usr/share/icons"
    cp -a "$bundle_directory/." "$debian_root/opt/synctv/"
    ln -s /opt/synctv/synctv "$debian_root/usr/bin/synctv"
    install -m 0644 linux/packaging/org.synctv.app.desktop \
      "$debian_root/usr/share/applications/org.synctv.app.desktop"
    cp -a linux/packaging/icons/hicolor \
      "$debian_root/usr/share/icons/"
    install -m 0644 LICENSE "$debian_root/usr/share/doc/synctv/copyright"
    installed_size="$(du -sk "$debian_root" | cut -f1)"
    cat > "$debian_root/DEBIAN/control" <<EOF
Package: synctv
Version: $version
Architecture: $debian_architecture
Maintainer: $package_maintainer
Installed-Size: $installed_size
Depends: libasound2, libgtk-3-0, libmpv2, libwebkit2gtk-4.1-0
Section: video
Priority: optional
Homepage: $repository_url
Description: Synchronized room media player
 SyncTV plays media in sync for everyone in a room and includes chat,
 voice chat, media P2P, playlists, and provider integrations.
EOF
    dpkg-deb --root-owner-group --build "$debian_root" \
      "$output_directory/SyncTV-$version-linux-$architecture.deb"
    rm -rf "$debian_root"
    trap - EXIT
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
    create_dmg="tool/ci/macos-dmg/node_modules/.bin/create-dmg"
    if [[ ! -x "$create_dmg" ]]; then
      echo "macOS packaging dependencies are missing; run npm ci --prefix tool/ci/macos-dmg" >&2
      exit 1
    fi
    dmg_path="$output_directory/SyncTV-$version-macos-$architecture-$signing_label.dmg"
    dmg_staging="$(mktemp -d)"
    trap 'rm -rf "${dmg_staging:-}"' EXIT
    "$create_dmg" \
      "$app_path" \
      "$dmg_staging" \
      --overwrite \
      --no-version-in-filename \
      --no-code-sign \
      --dmg-title=SyncTV
    generated_dmg="$dmg_staging/SyncTV.dmg"
    if [[ ! -f "$generated_dmg" ]]; then
      echo "macOS disk image was not generated: $generated_dmg" >&2
      exit 1
    fi
    mv "$generated_dmg" "$dmg_path"
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
