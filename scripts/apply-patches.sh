#!/usr/bin/env bash
# Applies every patch in $1 to the Hermes tree in $2, in file name order.
set -euo pipefail

patches=$1
tree=$2

# The image needs neither tests, the docs site, nor the contributor map (each of our PRs adds the same file).
skip=(--exclude='tests/*' --exclude='website/*' --exclude='contributors/*')

cd "$tree"
for p in "$patches"/*.patch; do
  name=$(basename "$p")
  if git apply --check "${skip[@]}" "$p" 2>/dev/null; then
    git apply "${skip[@]}" "$p"
    echo "applied $name"
  elif git apply --check --reverse "${skip[@]}" "$p" 2>/dev/null; then
    echo "$name is already in this Hermes release: delete it (see README)" >&2
    exit 1
  else
    echo "$name no longer applies: refresh it from its PR, or delete it if the PR was merged (see README)" >&2
    git apply --check "${skip[@]}" "$p"
    exit 1
  fi
done
