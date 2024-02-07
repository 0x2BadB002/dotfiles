#!/usr/bin/env bash

operation="$1"

# Arbitrary but unique message id
msg_id="987145"
device="intel_backlight"

brightness=$(brightnessctl get --device="${device}")
brightnessMax=$(brightnessctl max --device="${device}")

(( brightness = brightness / brightnessMax ))

echo "$brightness"

if [[ "${brightness}" == "1" ]]; then
    dunstify -a "changeBrightness" -u low -i "notification-audio-volume-muted" -r "$msg_id" "Volume muted"
else
    if (( brightness >= 80000 )); then
        volume_icon="notification-audio-volume-high"
    elif (( brightness >= 9600)); then
        volume_icon="notification-audio-volume-medium"
    else
        volume_icon="notification-audio-volume-low"
    fi
    # Show the volume notification
    dunstify -a "changeBrightness" -u low -i "$volume_icon" -r "$msg_id" \
      -h "int:value:${brightness}" "Volume: "

    # Play the volume changed sound
    canberra-gtk-play -i audio-volume-change -d "changeVolume"
fi
intel_backlight