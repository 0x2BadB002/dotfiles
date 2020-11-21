#!/usr/bin/env bash
set -euo pipefail

daemonize() {
    program=$1
    name=$(echo "$program" | awk '{printf $1}')
    pgrep -u "$UID" -x "$name" > /dev/null || eval "$program"
}

daemonize "sxhkd"
daemonize "xfsettingsd"
daemonize "xfce4-power-manager -no-daemon"
daemonize "xfce4-screensaver --no-daemon"
daemonize "picom --experimental-backends"
daemonize "dunst"
daemonize "nm-applet"
daemonize "redshift-gtk"
daemonize "gxkb"
daemonize "volumeicon"

