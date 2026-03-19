#!/bin/sh

print_status() {
    status=$(playerctl status -p spotify 2>/dev/null)
    artist=$(playerctl metadata artist -p spotify 2>/dev/null)
    title=$(playerctl metadata title -p spotify 2>/dev/null)

    if [ "$status" = "Playing" ]; then
        printf "   %s - %s \n" "$artist" "$title"
    elif [ "$status" = "Paused" ]; then
        printf "   %s - %s \n" "$artist" "$title"
    fi
}

# Print current state immediately on startup
print_status

# Re-print on every metadata change — no polling
playerctl --player=spotify --follow metadata 2>/dev/null | \
while IFS= read -r _; do
    print_status
done
