#!/bin/sh

print_status() {
    status=$(playerctl status -p spotify 2>/dev/null)
    artist=$(playerctl metadata artist -p spotify 2>/dev/null)
    title=$(playerctl metadata title -p spotify 2>/dev/null)

    if [ "$status" = "Playing" ]; then
        printf "   %s - %s \n" "$artist" "$title"
    elif [ "$status" = "Paused" ]; then
        printf "   %s - %s \n" "$artist" "$title"
    fi
}

# Reap the backgrounded follow pipelines when Waybar stops/restarts this module,
# otherwise each restart leaks two orphaned playerctl --follow processes.
cleanup() { kill "$status_pid" "$meta_pid" 2>/dev/null; }
trap cleanup EXIT INT TERM

# Print current state immediately on startup
print_status

# Re-print on status changes (play/pause) and metadata changes (track switch)
playerctl --player=spotify --follow status 2>/dev/null | while IFS= read -r _; do print_status; done &
status_pid=$!
playerctl --player=spotify --follow metadata 2>/dev/null | while IFS= read -r _; do print_status; done &
meta_pid=$!

wait
