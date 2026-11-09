#!/usr/bin/env bash

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_dir="$HOME/.config/img"
queue_file="$wallpaper_dir/queue.txt"

touch "$queue_file"

# Refill the queue (shuffled) when it has no content
if ! grep -q . "$queue_file"; then
    find -L "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpeg' -o -iname '*.jpg' \) | shuf > "$queue_file"
fi

wallpaper="$(grep . "$queue_file" | tail -n 1)"

if [[ -z "$wallpaper" ]]; then
    printf 'No wallpaper files found in %s\n' "$wallpaper_dir" >&2
    exit 1
fi

# Remove the last non-empty line so it is not picked again
grep . "$queue_file" | head -n -1 > "$queue_file.tmp" && mv "$queue_file.tmp" "$queue_file"

if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    for _ in {1..20}; do
        awww query >/dev/null 2>&1 && break
        sleep 0.25
    done
fi

awww img --resize crop --transition-type center "$wallpaper"
