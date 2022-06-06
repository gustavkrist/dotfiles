parser="$HOME/.config/kmonad/whichkey/parser.py"
menufile="$1"
yad --info --no-wrap --no-buttons --center --text "$(python $parser $menufile)"
