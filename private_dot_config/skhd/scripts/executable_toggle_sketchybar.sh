#!/bin/bash
HIDDEN=$(sketchybar --query bar | jq -r '.hidden')

if [ "$HIDDEN" = "off" ]; then
  sketchybar --bar hidden=on
else
  sketchybar --bar hidden=off
fi
