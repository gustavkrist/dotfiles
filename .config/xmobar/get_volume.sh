#!/bin/bash
status=$(amixer get Master | tail -n 1 | awk -F ' ' '{print $6}' | tr -d '[]')
case $status in
  "on")
    icon="<fn=2></fn>" ;;
  "off")
    icon="<fn=2></fn>" ;;
esac
level=$(amixer get Master | tail -n 1 | awk -F ' ' '{print $5}' | tr -d '[]')
echo "$icon $level"
# echo $(amixer get Master | tail -n 1 | awk -F ' ' '{printf "%s %s\n", $6, $5}' | tr -d '[]' | sed -e 's/on/<fn=2>\\xfa7d<\/fn>/' -e 's/off//')
