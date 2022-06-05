#!/usr/bin/env bash

# currspace=$(yabai -m query --spaces --space | /opt/homebrew/bin/jq '.index')

padding=$(expr $(cat ~/.local/share/yabai/padding.txt))

if [[ $padding != 3 ]];
then
  yabai -m config top_padding 3
  yabai -m config bottom_padding 3
  yabai -m config left_padding 3
  yabai -m config right_padding 3
  yabai -m config window_gap 0
  echo 3 > ~/.local/share/yabai/padding.txt
  ~/.config/yabai/scripts/refresh.sh
else
  yabai -m config top_padding $padding
  yabai -m config bottom_padding $padding
  yabai -m config left_padding $padding
  yabai -m config right_padding $padding
  yabai -m config window_gap $padding
  echo 8 > ~/.local/share/yabai/padding.txt
  ~/.config/yabai/scripts/refresh.sh
fi
