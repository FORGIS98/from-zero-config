#!/usr/bin/env bash

set -euo pipefail

img_path="$(mktemp --tmpdir=/dev/shm swaylock-blur-XXXXXX.png)"
trap 'rm -f -- "$img_path"' EXIT

if grim - | convert - -scale 10% -resize 1000% "$img_path"; then
    swaylock -f -i "$img_path" "$@"
else
    printf 'blur-lock: no se pudo capturar la pantalla; bloqueando con fondo negro.\n' >&2
    swaylock -f -c 000000 "$@"
fi
