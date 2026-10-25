#!/usr/bin/env bash

set -euo pipefail

img_path="$(mktemp --tmpdir=/dev/shm i3lock-blur-XXXXXX.png)"
trap 'rm -f -- "$img_path"' EXIT

maim -u -f bmp | convert - -scale 10% -resize 1000% "$img_path"

i3lock -n -e -i "$img_path" "$@"
