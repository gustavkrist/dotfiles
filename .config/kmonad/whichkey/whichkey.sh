parser="$HOME/.config/kmonad/whichkey/parser.py"
menufile="$1"
zenity --info --no-wrap --text "$(python $parser $menufile)"
