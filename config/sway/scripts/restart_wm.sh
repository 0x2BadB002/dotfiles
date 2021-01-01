#!/usr/bin/env bash

if pgrep waybar > /dev/null; then
    killall waybar
    while pgrep waybar > /dev/null; do
        sleep 1
    done
fi

swaymsg reload

waybar --config ~/.config/sway/waybar.conf --style ~/.config/sway/waybar_style.css &>> /tmp/waybar_log &

