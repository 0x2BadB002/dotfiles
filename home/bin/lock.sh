#!/usr/bin/env bash
set -euo pipefail

main() {
    local image_file image_name
    
    image_file=$(rg "file=" "$HOME/.config/nitrogen/bg-saved.cfg" | awk -F "=" '{print $2}')
    image_name=$(printf "$image_file" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')

    local resolution

    resolution=$(xrandr | rg "current" | awk -F "," '{print $2}' | awk '{printf $2} {printf "x"} {printf $4}')
    
    [ -d "/tmp/lock.sh" ] || mkdir /tmp/lock.sh
    [ -f "/tmp/lock.sh/${image_name}.png" ] \
        || convert -scale ${resolution}\! -gaussian-blur 0x4 "$image_file" "/tmp/lock.sh/${image_name}.png"

    local color_bg color_fg color_blue

    color_bg=$(awk '/^background/ {printf $2} END {printf "FF"}' $HOME/.config/lock.d/colors)
    color_fg=$(awk '/^foreground/ {printf $2} END {printf "FF"}' $HOME/.config/lock.d/colors)
    color_blue=$(awk '/^blue/ {printf $2} END {printf "FF"}' $HOME/.config/lock.d/colors)

    local font xpos ypos

    font="Ubuntu Medium"
    xpos="200"
    ypos=$(( $(echo $resolution | awk -F "x" '{printf $2}') - 200 ))

    i3lock -ek --indpos="$(( $xpos + 540 )):$ypos" --image="/tmp/lock.sh/${image_name}.png" --timecolor "$color_fg" \
        --datecolor "$color_fg" --time-font="$font" --date-font="$font" \
        --radius 30 --veriftext="" --timepos="$xpos:$ypos" --ringcolor="$color_bg" \
        --ringvercolor="$color_blue" --composite --timestr="%H:%M" --timesize=128 \
        --time-align 1 --date-align 1 --datesize=48 --datepos="$xpos:$(( $ypos + 55 ))"
}

error() {
    local NORMAL RED YELLOW GREEN

    NORMAL=$(tput sgr0)
    RED=$(tput setaf 1)
    YELLOW=$(tput setaf 3)
    GREEN=$(tput setaf 2)

    case "$1" in
        -i ) echo "[ ${GREEN}INFO${NORMAL} ] $2" ;;
        -w ) echo "[ ${YELLOW}WARNING${NORMAL} ] $2" ;;
        -c ) echo "[ ${RED}CRITICAL${NORMAL} ] $2" ;;
        *  ) exit 1 ;;
    esac
}

declare -A __o
eval set -- "$(getopt --name "lock.sh" \
    --options "vh" \
    --longoptions "version,help" \
    -- "$@"
)"

while true; do
    case "$1" in
        -v | --version ) __o[version]=1 ;;
        -h | --help    ) __o[help]=1 ;;
        -- ) shift ; break ;;
        *  ) break ;;
    esac
    shift
done

if [[ ${__o[help]:-} = 1 ]]; then
  ___printhelp
  exit
elif [[ ${__o[version]:-} = 1 ]]; then
  ___printversion
  exit
fi

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 

main "${@:-}"
