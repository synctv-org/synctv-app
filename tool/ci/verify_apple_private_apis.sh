#!/usr/bin/env bash
set -euo pipefail

artifact_path="${1:?Apple app bundle or IPA path is required}"
scan_root="$artifact_path"
temporary_directory=""

cleanup() {
  if [[ -n "$temporary_directory" ]]; then
    rm -rf "$temporary_directory"
  fi
}
trap cleanup EXIT

if [[ "$artifact_path" == *.ipa ]]; then
  temporary_directory="$(mktemp -d)"
  unzip -q "$artifact_path" -d "$temporary_directory"
  scan_root="$temporary_directory/Payload"
fi

if [[ ! -e "$scan_root" ]]; then
  echo "Apple artifact path does not exist: $scan_root" >&2
  exit 1
fi

forbidden_selectors=(
  'buttonPressed:'
  'controlsStyle'
  'NSXPCConnection'
)
found=0

while IFS= read -r -d '' candidate; do
  if [[ "$(file -b "$candidate")" != *Mach-O* ]]; then
    continue
  fi
  for selector in "${forbidden_selectors[@]}"; do
    if strings -a "$candidate" | grep -F -- "$selector" >/dev/null; then
      echo "Forbidden Apple API selector '$selector' found in $candidate" >&2
      found=1
    fi
  done
done < <(find "$scan_root" -type f -print0)

if ((found != 0)); then
  exit 1
fi

echo "Apple private API scan passed: $artifact_path"
