#!/usr/bin/env bash

CHOICE=$(printf '%s\n' \
    'Scroller' \
    'Tile' \
    'Grid' \
    'Monocle' \
    'Deck' \
    'Center Tile' \
    'Right Tile' \
    'Vertical Scroller' \
    'Vertical Tile' \
    'Vertical Grid' \
    'Vertical Deck' \
    'Dwindle' \
    'Fair' \
    'Vertical Fair' | fuzzel --dmenu --hide-prompt --lines=5 --width=18)

case "$CHOICE" in
    'Scroller') mmsg dispatch setlayout,scroller ;;
    'Tile') mmsg dispatch setlayout,tile ;;
    'Grid') mmsg dispatch setlayout,grid ;;
    'Monocle') mmsg dispatch setlayout,monocle ;;
    'Deck') mmsg dispatch setlayout,deck ;;
    'Center Tile') mmsg dispatch setlayout,center_tile ;;
    'Right Tile') mmsg dispatch setlayout,right_tile ;;
    'Vertical Scroller') mmsg dispatch setlayout,vertical_scroller ;;
    'Vertical Tile') mmsg dispatch setlayout,vertical_tile ;;
    'Vertical Grid') mmsg dispatch setlayout,vertical_grid ;;
    'Vertical Deck') mmsg dispatch setlayout,vertical_deck ;;
    'Dwindle') mmsg dispatch setlayout,dwindle ;;
    'Fair') mmsg dispatch setlayout,fair ;;
    'Vertical Fair') mmsg dispatch setlayout,vertical_fair ;;
esac
