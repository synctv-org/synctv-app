#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

for command_name in dart rsvg-convert ffmpeg grep; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "missing icon generation dependency: $command_name" >&2
    exit 1
  fi
done

icon_svg="assets/icon/logo-notext.svg"
for source_file in "$icon_svg" "assets/icon/logo-notext.png"; do
  if [[ ! -f "$source_file" ]]; then
    echo "missing no-text logo source: $source_file" >&2
    exit 1
  fi
done

if grep -Eq '<switch([[:space:]>])' "$icon_svg"; then
  echo "unsupported <switch> element in Flutter SVG asset: $icon_svg" >&2
  exit 1
fi

icon_work_directory="$(mktemp -d)"
trap 'rm -rf "${icon_work_directory:-}"' EXIT

dart run tool/generate_apple_icon_composer.dart
dart run flutter_launcher_icons

windows_icon_directory="$icon_work_directory/windows"
mkdir -p "$windows_icon_directory"
windows_sizes=(16 24 32 48 64 128 256)
ffmpeg_inputs=()
ffmpeg_maps=()
stream_index=0
for icon_size in "${windows_sizes[@]}"; do
  icon_path="$windows_icon_directory/app_icon_$icon_size.png"
  rsvg-convert -w "$icon_size" -h "$icon_size" "$icon_svg" -o "$icon_path"
  ffmpeg_inputs+=(-i "$icon_path")
  ffmpeg_maps+=(-map "$stream_index:v:0")
  stream_index=$((stream_index + 1))
done

ffmpeg -hide_banner -loglevel error \
  "${ffmpeg_inputs[@]}" \
  "${ffmpeg_maps[@]}" \
  -pix_fmt rgba \
  -c:v png \
  -y windows/runner/resources/app_icon.ico

linux_sizes=(16 24 32 48 64 128 256 512)
for icon_size in "${linux_sizes[@]}"; do
  linux_icon_directory="linux/packaging/icons/hicolor/${icon_size}x${icon_size}/apps"
  mkdir -p "$linux_icon_directory"
  rsvg-convert -w "$icon_size" -h "$icon_size" "$icon_svg" \
    -o "$linux_icon_directory/org.synctv.app.png"
done

scalable_icon_directory="linux/packaging/icons/hicolor/scalable/apps"
mkdir -p "$scalable_icon_directory"
cp "$icon_svg" "$scalable_icon_directory/org.synctv.app.svg"

echo "Generated platform icons from the designer-provided no-text SyncTV logo."
