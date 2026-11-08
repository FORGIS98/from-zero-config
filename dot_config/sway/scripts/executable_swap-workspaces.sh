#!/usr/bin/env bash
# Swaps the visible workspaces between the two connected monitors in Sway.
set -euo pipefail

workspaces_json=$(swaymsg -t get_workspaces)

visible_lines=$(jq -r '.[] | select(.visible==true) | "\(.output | @json)\t\(.name | @json)"' <<<"$workspaces_json" | sort)
visible=()
if [[ -n "$visible_lines" ]]; then
    mapfile -t visible <<<"$visible_lines"
fi

if [ "${#visible[@]}" -ne 2 ]; then
    echo "swap-workspaces: se requieren exactamente 2 monitores con workspaces visibles (encontrados: ${#visible[@]})." >&2
    exit 1
fi

output1=$(cut -f1 <<<"${visible[0]}")
ws1=$(cut -f2 <<<"${visible[0]}")
output2=$(cut -f1 <<<"${visible[1]}")
ws2=$(cut -f2 <<<"${visible[1]}")

swaymsg "workspace $ws1; move workspace to output $output2; workspace $ws2; move workspace to output $output1"
