#!/usr/bin/env bash

source "/Users/abhi/.config/sketchybar/plugins/icon_map.sh"
source "/Users/abhi/.config/sketchybar/colors.sh"

NAME=space.$(aerospace list-workspaces --focused)

apps=$(aerospace list-windows --workspace focused 2>/dev/null | awk -F' \\| ' '{print $2}' | sort -u)

icon_string=""
if [ -n "$apps" ]; then
  for app in $apps; do
    __icon_map "$app"
    if [ "$icon_result" != ":default:" ]; then
      icon_string+="$icon_result"
    fi
  done
fi

if [ -n "$icon_string" ]; then
  sketchybar --set $NAME label="$icon_string" label.drawing=on
else
  sketchybar --set $NAME label.drawing=off
fi

for sid in $(aerospace list-workspaces --monitor focused --empty no); do
  # Determine icon based on workspace ID
  space_icon=""
  case "$sid" in
  1) space_icon="󰗀" ;;
  2) space_icon="󰖟" ;;
  3) space_icon="󰋋" ;;
  4) space_icon="󰎲" ;;
  5) space_icon="󰼓" ;;
  6) space_icon="󰎴" ;;
  7) space_icon="󰼕" ;;
  8) space_icon="󰎺" ;;
  9) space_icon="󰼗" ;;
  0) space_icon="󰗘" ;;
  *) space_icon="" ;;
  esac

  sketchybar --set space.$sid \
    icon="$space_icon" 
done

for sid in $(aerospace list-workspaces --monitor focused --empty); do
  # Determine icon based on workspace ID
  space_icon=""

  sketchybar --set space.$sid \
    icon="$space_icon" 
done
