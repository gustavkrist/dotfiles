isFocused=$(yabai -m query --windows --window | jq -re ".id")
echo $isFocused
if [[ -z "$isFocused" ]]; then
    $(yabai -m window --focus $(yabai -m query --windows | jq -re '.[] | select((."is-visible" == true) and ."has-focus" == false).id' | head -n 1))
    echo hi
fi
