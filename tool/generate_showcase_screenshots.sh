#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

flutter_command=(flutter)
if command -v fvm >/dev/null 2>&1; then
  flutter_command=(fvm flutter)
fi

install -d build/showcase
"${flutter_command[@]}" test tool/home_showcase_screenshots_test.dart

install -d fastlane/screenshots
install -m 0644 build/showcase/01-home-iphone-6.9.png fastlane/screenshots/
install -m 0644 build/showcase/01-home-ipad-13.png fastlane/screenshots/
install -m 0644 build/showcase/01-home-macos.png fastlane/screenshots/
