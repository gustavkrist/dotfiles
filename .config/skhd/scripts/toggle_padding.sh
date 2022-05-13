#!/usr/bin/env bash

if [[ $(yabai -m config window_gap) = 8 ]];
then
  yabai -m config top_padding 3
  yabai -m config bottom_padding 3
  yabai -m config left_padding 3
  yabai -m config right_padding 3
  yabai -m config window_gap 0
  export PADDING_ENABLED=false
else
  yabai -m config top_padding 8
  yabai -m config bottom_padding 8
  yabai -m config left_padding 8
  yabai -m config right_padding 8
  yabai -m config window_gap 8
  export PADDING_ENABLED=true
fi
