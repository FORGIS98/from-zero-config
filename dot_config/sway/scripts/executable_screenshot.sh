#!/usr/bin/env bash

set -euo pipefail

selection="$(slurp)"
image="$(mktemp --suffix=.png)"
trap 'rm -f -- "$image"' EXIT

grim -g "$selection" "$image"
wl-copy < "$image"
