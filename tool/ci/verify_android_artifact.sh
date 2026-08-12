#!/usr/bin/env bash
set -euo pipefail

artifact_path="${1:?Android APK path is required}"

if [[ ! -f "$artifact_path" ]]; then
  echo "Android artifact does not exist: $artifact_path" >&2
  exit 1
fi

apkanalyzer_binary="$(command -v apkanalyzer || true)"
if [[ -z "$apkanalyzer_binary" && -n "${ANDROID_HOME:-}" ]]; then
  candidate="$ANDROID_HOME/cmdline-tools/latest/bin/apkanalyzer"
  if [[ -x "$candidate" ]]; then
    apkanalyzer_binary="$candidate"
  fi
fi
if [[ -z "$apkanalyzer_binary" ]]; then
  echo "apkanalyzer is required to inspect the final Android manifest" >&2
  exit 1
fi

permissions="$($apkanalyzer_binary manifest permissions "$artifact_path")"
for forbidden_permission in \
  android.permission.SYSTEM_ALERT_WINDOW \
  android.permission.REORDER_TASKS; do
  if grep -F -- "$forbidden_permission" <<<"$permissions" >/dev/null; then
    echo "Forbidden Android permission '$forbidden_permission' found in $artifact_path" >&2
    exit 1
  fi
done

aapt2_binary="$(command -v aapt2 || true)"
if [[ -z "$aapt2_binary" && -n "${ANDROID_HOME:-}" ]]; then
  while IFS= read -r candidate; do
    aapt2_binary="$candidate"
  done < <(find "$ANDROID_HOME/build-tools" -maxdepth 2 -type f -name aapt2 | sort)
fi
if [[ -z "$aapt2_binary" ]]; then
  echo "aapt2 is required to inspect final Android resources" >&2
  exit 1
fi

manifest="$($aapt2_binary dump xmltree "$artifact_path" --file AndroidManifest.xml)"
for launcher_attribute in android:icon android:roundIcon; do
  if ! grep -E -- "$launcher_attribute.*=@0x[0-9a-f]+" <<<"$manifest" >/dev/null; then
    echo "Missing launcher manifest attribute '$launcher_attribute' in $artifact_path" >&2
    exit 1
  fi
done

resources="$($aapt2_binary dump resources "$artifact_path")"
if ! grep -F -- 'mipmap/ic_launcher' <<<"$resources" >/dev/null; then
  echo "Missing launcher resource 'mipmap/ic_launcher' in $artifact_path" >&2
  exit 1
fi
for legacy_adaptive_resource in \
  'drawable/ic_launcher_foreground' \
  'drawable/ic_launcher_monochrome'; do
  if grep -F -- "$legacy_adaptive_resource" <<<"$resources" >/dev/null; then
    echo "Unexpected adaptive launcher resource '$legacy_adaptive_resource' in $artifact_path" >&2
    exit 1
  fi
done
launcher_block="$(grep -A 10 -F 'mipmap/ic_launcher' <<<"$resources")"
if grep -F '(anydpi-v26)' <<<"$launcher_block" >/dev/null; then
  echo "Unexpected adaptive v26 launcher configuration in $artifact_path" >&2
  exit 1
fi

echo "Android manifest and launcher icon scan passed: $artifact_path"
