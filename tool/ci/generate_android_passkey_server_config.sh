#!/usr/bin/env bash
set -euo pipefail

package_name="${1:?package name is required}"
primary_fingerprint="${2:?primary certificate fingerprint is required}"
additional_fingerprints="${3:-}"
output="${4:?output path is required}"

if [[ ! "$package_name" =~ ^[A-Za-z][A-Za-z0-9_]*(\.[A-Za-z][A-Za-z0-9_]*)+$ ]]; then
  echo "invalid Android package name: $package_name" >&2
  exit 1
fi

canonical_fingerprint() {
  local compact
  local canonical=""
  local index
  compact="$(printf '%s' "$1" | tr -d ':[:space:]' | tr '[:lower:]' '[:upper:]')"
  if [[ ! "$compact" =~ ^[0-9A-F]{64}$ ]]; then
    echo "invalid Android certificate SHA-256 fingerprint" >&2
    exit 1
  fi
  for ((index = 0; index < 64; index += 2)); do
    if [[ -n "$canonical" ]]; then
      canonical+=":"
    fi
    canonical+="${compact:index:2}"
  done
  printf '%s' "$canonical"
}

fingerprints=("$(canonical_fingerprint "$primary_fingerprint")")
IFS=';' read -r -a additional_values <<< "$additional_fingerprints"
for value in "${additional_values[@]}"; do
  if [[ -z "${value//[[:space:]]/}" ]]; then
    continue
  fi
  fingerprint="$(canonical_fingerprint "$value")"
  duplicate=false
  for configured in "${fingerprints[@]}"; do
    if [[ "$configured" == "$fingerprint" ]]; then
      duplicate=true
      break
    fi
  done
  if [[ "$duplicate" == "false" ]]; then
    fingerprints+=("$fingerprint")
  fi
done

mkdir -p "$(dirname "$output")"
{
  echo "# Public identity of this signed SyncTV Android release."
  echo "# Merge android_apps into the webauthn section of your server configuration."
  echo "webauthn:"
  echo "  android_apps:"
  echo "    - package_name: \"$package_name\""
  echo "      sha256_cert_fingerprints:"
  for fingerprint in "${fingerprints[@]}"; do
    echo "        - \"$fingerprint\""
  done
} > "$output"
