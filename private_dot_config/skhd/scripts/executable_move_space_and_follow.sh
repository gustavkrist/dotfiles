WINDOW=$(yabai -m query --windows --window | jq '.id')
yabai -m window --space $SPACE
sleep 0.05
yabai -m space --focus $SPACE
yabai -m window --focus $WINDOW
