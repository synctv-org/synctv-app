#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$project_root"

for command_name in dart jq grep; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "missing Icon Composer verification dependency: $command_name" >&2
    exit 1
  fi
done

icon_directory="${1:-assets/icon/AppIcon.icon}"
required_files=(
  "$icon_directory/icon.json"
  "$icon_directory/Assets/background.svg"
  "$icon_directory/Assets/foreground.svg"
)
for required_file in "${required_files[@]}"; do
  if [[ ! -s "$required_file" ]]; then
    echo "missing Icon Composer resource: $required_file" >&2
    exit 1
  fi
done

jq empty "$icon_directory/icon.json"

temporary_directory="$(mktemp -d)"
trap 'rm -rf "${temporary_directory:-}"' EXIT
generated_icon="$temporary_directory/AppIcon.icon"
dart run tool/generate_apple_icon_composer.dart \
  assets/icon/logo-notext.svg \
  "$generated_icon"
diff -rq "$icon_directory" "$generated_icon"

for project in \
  ios/Runner.xcodeproj/project.pbxproj \
  macos/Runner.xcodeproj/project.pbxproj; do
  if ! grep -Eq 'folder\.iconcomposer\.icon' "$project"; then
    echo "Icon Composer file type is missing from $project" >&2
    exit 1
  fi
  if ! grep -Eq 'AppIcon\.icon in Resources' "$project"; then
    echo "Icon Composer resource phase is missing from $project" >&2
    exit 1
  fi
done

legacy_icon="$(find ios macos -type d -name 'AppIcon.appiconset' -print -quit)"
if [[ -n "$legacy_icon" ]]; then
  echo "legacy Apple app icon set remains: $legacy_icon" >&2
  exit 1
fi

echo "Verified shared iOS and macOS Icon Composer resources."
