LABEL=$(osascript -e 'output volume of (get volume settings)')%
MUTED=$(osascript -e 'output muted of (get volume settings)')

sketchybar -m --set $NAME label=$LABEL

case $MUTED in
  false)
    sketchybar -m --set "$NAME""_logo" background.color=0xff81A1C1
    echo "false"
    ;;
  true)
    sketchybar -m --set "$NAME""_logo" background.color=0xff3B4252
    echo "true"
    ;;
esac
