WINDOW=$(yabai -m query --windows --window | jq '.id')
yabai -m window --space $SPACE
sleep 0.3
yabai -m window --focus $WINDOW
