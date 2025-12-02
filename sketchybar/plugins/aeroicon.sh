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

