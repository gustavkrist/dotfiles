#!/usr/bin/env bash

case "$(yabai -m query --windows --window | jq '."is-floating"')" in
    false)
    sketchybar -m --set yabai_float icon=""
    echo "false"
    ;;
    true)
    sketchybar -m --set yabai_float icon=""
    echo "true"
    ;;
esac
