#!/bin/bash

sketchybar --set "$NAME" \
  icon="$(date '+%a %d. %b')" \
  label="$(date '+%-I:%M %p')" \
  icon.padding_right=20 \
  label.padding_left=4
