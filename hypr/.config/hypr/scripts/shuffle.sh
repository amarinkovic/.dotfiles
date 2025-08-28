#!/bin/bash

WALLZ_DIR="$HOME/wallz/"

DEFAULT_WALLPAPER="/usr/share/hypr/wall0.png"

if [ ! -d "$WALLZ_DIR" ]; then
    echo "Wallz directory not found: $WALLZ_DIR"
    WALLPAPER = $DEFAULT_WALLPAPER
else
  RANDOM_WALLPAPER=$(find "$WALLZ_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

  if [ -n "$RANDOM_WALLPAPER" ]; then
      WALLPAPER="$RANDOM_WALLPAPER"
  else
      WALLPAPER="$DEFAULT_WALLPAPER"
  fi
fi

echo "random: " $RANDOM_WALLPAPER
echo "selected: " $WALLPAPER
hyprctl hyprpaper preload "$WALLPAPER"

MONITORS=$(hyprctl monitors | grep Monitor | awk '{print $2}')

for monitor in $MONITORS; do
    hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
done

