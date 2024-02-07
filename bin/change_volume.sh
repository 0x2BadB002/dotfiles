#!/usr/bin/env bash

operation="$1"

# Arbitrary but unique message id
msg_id="991049"

get_alsa_volume() {
    local str
    # Query amixer for the current volume and whether or not the speaker is muted
    str="$(amixer get Master | tail -n 1)"
    volume=$(printf '%s' "$str" | awk '/Right:/ {print substr($NF, 2, length($NF)-2)}')
    [[ "$volume" == "on" ]] && volume=$(printf '%s' "$str" | awk -F 'Right:|[][]' 'BEGIN {RS=""}{ print $3 }')
}

get_pulse_volume() {
    local str
    str=$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F ": " '{printf $2}')
    if [[ "$str" == "no" ]]; then
        local volume_left volume_right
        str=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 \
                    | sed -e 's/[[:space:]]//g' -e 's/\%//g')
        volume_left=$(echo "$str" | awk -F "/" '{printf $2}')
        volume_right=$(echo "$str" | awk -F "/" '{printf $4}')
        volume=$(( (volume_left + volume_right) / 2 ))
    else
        volume="off"
    fi
}

get_wireplumber_volume() {
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
        awk -F ": " '{n = split($2, arr, " "); if (n > 1) print "off"; else print substr($2,3)}')
}

alsa_change_volume() {
    amixer sset Master "$operation" > /dev/null
}

pulse_change_volume() {
    if [[ "$operation" == "toggle" ]]; then
        pactl set-sink-mute @DEFAULT_SINK@ toggle
    else
        operation="${operation:2}${operation:0:2}"
        pactl set-sink-volume @DEFAULT_SINK@ "$operation"
    fi
}

wireplumber_change_volume() {
    if [[ "$operation" == "toggle" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    else
        wpctl set-volume @DEFAULT_AUDIO_SINK@ -l 1 "$operation"
    fi
}

if command -v "wpctl" &>/dev/null; then
    wireplumber_change_volume    
    get_wireplumber_volume
elif command -v "pactl" &>/dev/null; then
    pulse_change_volume
    get_pulse_volume
else
    alsa_change_volume
    get_alsa_volume
fi

if [[ "$volume" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i "notification-audio-volume-muted" -r "$msg_id" "Volume muted"
else
    if (( volume >= 50 )); then
        volume_icon="notification-audio-volume-high"
    elif (( volume >= 25 )); then
        volume_icon="notification-audio-volume-medium"
    else
        volume_icon="notification-audio-volume-low"
    fi
    # Show the volume notification
    dunstify -a "changeVolume" -u low -i "$volume_icon" -r "$msg_id" \
      -h "int:value:${volume}" "Volume: "

    # Play the volume changed sound
    canberra-gtk-play -i audio-volume-change -d "changeVolume"
fi
