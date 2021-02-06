#!/usr/bin/env bash

# Arbitrary but unique message id
msg_id="991049"
operation="$1"
theme="ePapirus"

icon_muted="/usr/share/icons/${theme}/48x48/status/notification-audio-volume-muted.svg"
icon_low="/usr/share/icons/${theme}/48x48/status/notification-audio-volume-low.svg"
icon_medium="/usr/share/icons/${theme}/48x48/status/notification-audio-volume-medium.svg"
icon_high="/usr/share/icons/${theme}/48x48/status/notification-audio-volume-high.svg"

function get_progress_string {
    ITEMS="$1" # The total number of items(the width of the bar)
    FILLED_ITEM="$2" # The look of a filled item 
    NOT_FILLED_ITEM="$3" # The look of a not filled item
    STATUS="$4" # The current progress status in percent

    # calculate how many items need to be filled and not filled
    FILLED_ITEMS=$(echo "((${ITEMS} * ${STATUS})/100 + 0.5) / 1" | bc)
    NOT_FILLED_ITEMS=$(echo "$ITEMS - $FILLED_ITEMS" | bc)

    # Assemble the bar string
    msg=$(printf "%${FILLED_ITEMS}s" | sed "s| |${FILLED_ITEM}|g")
    msg=${msg}$(printf "%${NOT_FILLED_ITEMS}s" | sed "s| |${NOT_FILLED_ITEM}|g")
    
    echo "$msg"
}

function get_alsa_volume {
    local str volume
    # Query amixer for the current volume and whether or not the speaker is muted
    str="$(amixer get Master | tail -n 1)"
    volume=$(printf '%s' "$str" | awk '/Right:/ {print substr($NF, 2, length($NF)-2)}')
    [[ "$volume" == "on" ]] && volume=$(printf '%s' "$str" | awk -F 'Right:|[][]' 'BEGIN {RS=""}{ print $3 }')
    echo "${volume%\%}"
}

# Change the volume
if [[ "$operation" == "toggle" ]]; then
    amixer sset Master toggle > /dev/null
else
    amixer sset Master "$operation" > /dev/null
fi

# Get volume
volume=$(get_alsa_volume)

if [[ "$volume" == "off" ]]; then
    # Show the sound muted notification
    [ "$XDG_SESSION_TYPE" == "wayland" ] || dunstify -a "changeVolume" -u low -i "$icon_muted" -r "$msg_id" "Volume muted" 
else
    if (( volume >= 50 )); then
        volume_icon="$icon_high"
    elif (( volume >= 25 )); then
        volume_icon="$icon_medium"
    else
        volume_icon="$icon_low"
    fi
    # Show the volume notification
    [ "$XDG_SESSION_TYPE" == "wayland" ] || \
	dunstify -a "changeVolume" -u low -i "$volume_icon" -r "$msg_id" \
    	"Volume: ${volume}%" "$(get_progress_string 10 "<b> </b>" " " "${volume%\%}")"

    # Play the volume changed sound
    canberra-gtk-play -i audio-volume-change -d "changeVolume"
fi
