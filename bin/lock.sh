#!/usr/bin/env bash

#icon="$HOME/Pictures/Lockscreen/hyper_light_drifter_icon_by_andonovmarko-d9xby35.png"
icon="$HOME/Imagens/Lockscreen/1501641626807.png"
tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

#i3lock-fancy -p "$tmpbg"
#i3lock -u -i "$tmpbg"
i3lock -b -t -i "$tmpbg"
