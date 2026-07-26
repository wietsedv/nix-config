#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $(basename "$0") <host>" >&2
  exit 1
fi

host="$1"

exec nix run nixpkgs#nixos-rebuild -- build \
  --flake ".#$host" \
  --target-host "$host" \
  --build-host "$host"
