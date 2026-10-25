#!/usr/bin/env bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_dir="$script_dir/../../img"

mapfile -d '' wallpapers < <(find -L "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpeg' -o -iname '*.jpg' \) -print0)

if ((${#wallpapers[@]} == 0)); then
	printf 'No wallpaper files found in %s\n' "$wallpaper_dir" >&2
	exit 1
fi

feh --bg-fill "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
