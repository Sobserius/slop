#!/usr/bin/env bash
CHOICE=$(echo -e "Scroller\nTile\nGrid\nMonocle\nDeck\nCenter Tile\nRight Tile\nVertical Scroller\nVertical Tile\nVertical Grid\nVertical Deck\nTGMix" | fuzzel --dmenu --lines=5 --width=14 --hide-prompt)
case "$CHOICE" in
  Scroller) mmsg -l S ;;
  Tile) mmsg -l T ;;
  Grid) mmsg -l G ;;
  Monocle) mmsg -l M ;;
  Deck) mmsg -l K ;;
  "Center Tile") mmsg -l CT ;;
  "Right Tile") mmsg -l RT ;;
  "Vertical Scroller") mmsg -l VS ;;
  "Vertical Tile") mmsg -l VT ;;
  "Vertical Grid") mmsg -l VG ;;
  "Vertical Deck") mmsg -l VK ;;
  TGMix) mmsg -l TG ;;
esac
