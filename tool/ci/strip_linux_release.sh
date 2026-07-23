#!/usr/bin/env bash
set -euo pipefail

bundle_directory="$(find build/linux -type d -path '*/release/bundle' -print -quit)"
if [[ -z "$bundle_directory" ]]; then
  echo "Linux release bundle was not found" >&2
  exit 1
fi

while IFS= read -r -d '' file; do
  if file --brief "$file" | grep --quiet 'ELF .*not stripped'; then
    strip --strip-unneeded "$file"
  fi
done < <(find "$bundle_directory" -type f -print0)
