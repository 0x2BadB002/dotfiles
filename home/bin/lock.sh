#!/usr/bin/env bash
set -euo pipefail

[ -f "/tmp/lock.sh/image.png" ] || {
    image=$(rg "file=" "$HOME/.config/nitrogen/bg-saved.cfg" | sed "s/file=//")
    mkdir /tmp/lock.sh
    convert -gaussian-blur 5x4 "$image" "/tmp/lock.sh/image.png"
}

image="/tmp/lock.sh/image.png"
color_fg=$(printf "$(rg "foreground[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/foreground[\w]* = [\w]*\#//")ff")
color_bg=$(printf "$(rg ";background[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/;background[\w]* = [\w]*\#//")ff")
color_blue=$(printf "$(rg "blue[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/blue[\w]* = [\w]*\#//")ff")
i3lock -ek --indpos="340:h-150" --image="$image" --timecolor "$color_fg" \
    --datecolor "$color_fg" --time-font="Ubuntu Bold" --date-font="Ubuntu Bold" \
    --radius 30 --veriftext="" --timepos="200:h-150" --ringcolor="$color_bg"
