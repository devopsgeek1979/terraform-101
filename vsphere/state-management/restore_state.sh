#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <version_file_path> <target_state_file_path>"
  exit 1
fi

version_file="$1"
target_file="$2"

if [[ ! -f "$version_file" ]]; then
  echo "Version file not found: $version_file"
  exit 1
fi

if [[ -f "${version_file}.sha256" ]]; then
  expected_sum="$(awk '{print $1}' "${version_file}.sha256")"
  actual_sum="$(shasum -a 256 "$version_file" | awk '{print $1}')"
  if [[ "$expected_sum" != "$actual_sum" ]]; then
    echo "Checksum mismatch for $version_file"
    exit 1
  fi
fi

mkdir -p "$(dirname "$target_file")"
cp "$version_file" "$target_file"

echo "State restored to: $target_file"
