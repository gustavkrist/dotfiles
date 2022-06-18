SPACE=$(yabai -m query --spaces --space | jq -re ".index")
NEXT_SPACE=$(($SPACE + 1))
if [[ $NEXT_SPACE > 6 ]]; then
  NEXT_SPACE=1
fi
bash -c "SPACE=$NEXT_SPACE ~/.config/skhd/scripts/move_space_and_follow.sh"
