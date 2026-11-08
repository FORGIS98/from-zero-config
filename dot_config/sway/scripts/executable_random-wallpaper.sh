#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_dir="$script_dir/../../img"
queue_file="$wallpaper_dir/queue.txt"

touch "$queue_file"

# Refill the queue (shuffled) when it has no content
if ! grep -q . "$queue_file"; then
	find -L "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' \) | shuf > "$queue_file"
fi

wallpaper="$(awk '/./ { line = $0 } END { print line }' "$queue_file")"

if [[ -z "$wallpaper" ]]; then
	printf 'No wallpaper files found in %s\n' "$wallpaper_dir" >&2
	exit 1
fi

# Quote the path for Sway's command parser, not just for the shell.
escaped_wallpaper="${wallpaper//\\/\\\\}"
escaped_wallpaper="${escaped_wallpaper//\"/\\\"}"
swaymsg "output * bg \"$escaped_wallpaper\" fill"

# Remove the last non-empty line only after Sway accepts the wallpaper.
awk '/./ { if (seen) print line; line = $0; seen = 1 }' "$queue_file" >"$queue_file.tmp"
mv "$queue_file.tmp" "$queue_file"
