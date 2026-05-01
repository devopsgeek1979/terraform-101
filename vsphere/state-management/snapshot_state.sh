#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <state_file_path>"
  exit 1
fi

state_file="$1"
if [[ ! -f "$state_file" ]]; then
  echo "State file not found: $state_file"
  exit 1
fi

state_dir="$(dirname "$state_file")"
base_name="$(basename "$state_file")"
version_dir="${state_dir%/}/.versions"
mkdir -p "$version_dir"

ts="$(date -u +%Y%m%dT%H%M%SZ)"
version_file="$version_dir/${base_name}.${ts}"

cp "$state_file" "$version_file"

sha256_file="${version_file}.sha256"
shasum -a 256 "$version_file" > "$sha256_file"

echo "Snapshot created: $version_file"
echo "Checksum file: $sha256_file"
