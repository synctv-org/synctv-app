#!/usr/bin/env bash
set -euo pipefail

icon_directory="${1:-ios/Runner/Assets.xcassets/AppIcon.appiconset}"
large_icon="$icon_directory/Icon-App-1024x1024@1x.png"

if [[ ! -f "$large_icon" ]]; then
  echo "missing iOS App Store icon: $large_icon" >&2
  exit 1
fi

icon_count=0
invalid_count=0
while IFS= read -r icon; do
  icon_count=$((icon_count + 1))
  if sips -g hasAlpha "$icon" | grep -q 'hasAlpha: yes'; then
    echo "iOS app icon contains an alpha channel: $icon" >&2
    invalid_count=$((invalid_count + 1))
  fi
done < <(find "$icon_directory" -maxdepth 1 -type f -name '*.png' -print | sort)

if [[ $icon_count -eq 0 ]]; then
  echo "no iOS app icons found in $icon_directory" >&2
  exit 1
fi

if [[ $invalid_count -ne 0 ]]; then
  exit 1
fi

echo "Verified $icon_count opaque iOS app icons."
