#!/usr/bin/env bash
set -euo pipefail

ARGS=$(getopt --options "vhn" --longoptions "version,help,nitrogen" --name "lock.sh" -- "$@")

if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$ARGS"

image_file=$(rg "file=" "$HOME/.config/nitrogen/bg-saved.cfg" | awk -F "=" '{print $2}')

while true; do
    case "$1" in
        -v|--version)
            shift
            # TODO version message
            ;;
        -h|--help)
            shift
            # TODO help message
            echo "Help msg"
            exit
            ;;
        -n|--nitrogen)
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done

image_name=$(printf "$image_file" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')

[ -d "/tmp/lock.sh" ] || mkdir /tmp/lock.sh

[ -f "/tmp/lock.sh/${image_name}.png" ] || convert -gaussian-blur 5x4 "$image_file" "/tmp/lock.sh/${image_name}.png"

#color_fg=$(printf "$(rg "foreground[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/foreground[\w]* = [\w]*\#//")ff")
#color_bg=$(printf "$(rg ";background[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/;background[\w]* = [\w]*\#//")ff")
#color_blue=$(printf "$(rg "blue[\s]*=[\s]*#" $HOME/.config/polybar/config | sed "s/blue[\w]* = [\w]*\#//")ff")
#i3lock -ek --indpos="340:h-150" --image="$image" --timecolor "$color_fg" \
#    --datecolor "$color_fg" --time-font="Ubuntu Bold" --date-font="Ubuntu Bold" \
#    --radius 30 --veriftext="" --timepos="200:h-150" --ringcolor="$color_bg"
