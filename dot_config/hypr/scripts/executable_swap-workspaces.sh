#!/usr/bin/env bash
# Intercambia los workspaces visibles entre los dos monitores conectados en Hyprland.
set -euo pipefail

mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name' | sort)

if [ "${#monitors[@]}" -ne 2 ]; then
    echo "swap-workspaces: se requieren exactamente 2 monitores (encontrados: ${#monitors[@]})." >&2
    exit 1
fi

hyprctl dispatch "hl.dsp.workspace.swap_monitors({ monitor1 = \"${monitors[0]}\", monitor2 = \"${monitors[1]}\" })"
