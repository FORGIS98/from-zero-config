#!/usr/bin/env bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_dir="$script_dir/../../img"

mapfile -d '' wallpapers < <(find -L "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpeg' -o -iname '*.jpg' \) -print0)

if ((${#wallpapers[@]} == 0)); then
    printf 'No wallpaper files found in %s\n' "$wallpaper_dir" >&2
    exit 1
fi

if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    for _ in {1..20}; do
        awww query >/dev/null 2>&1 && break
        sleep 0.25
    done
fi

awww img --resize crop --transition-type center "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
