#!/usr/bin/env bash
# Swaps the visible workspaces between the two connected monitors in i3.
set -euo pipefail

workspaces_json=$(i3-msg -t get_workspaces)

mapfile -t visible < <(echo "$workspaces_json" | jq -r '.[] | select(.visible==true) | "\(.output)\t\(.name)"' | sort)

if [ "${#visible[@]}" -ne 2 ]; then
    echo "swap-workspaces: se requieren exactamente 2 monitores con workspaces visibles (encontrados: ${#visible[@]})." >&2
    exit 1
fi

output1=$(cut -f1 <<<"${visible[0]}")
ws1=$(cut -f2 <<<"${visible[0]}")
output2=$(cut -f1 <<<"${visible[1]}")
ws2=$(cut -f2 <<<"${visible[1]}")

i3-msg "workspace \"$ws1\"; move workspace to output \"$output2\"; workspace \"$ws2\"; move workspace to output \"$output1\""
