#!/usr/bin/env bash

function getProgressString {
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

# Arbitrary but unique message id
msgId="991049"

# Change the volume

if [[ $1 == "toggle" ]]; then
    pactl set-sink-mute 0 toggle > /dev/null
else
    pactl set-sink-volume 0 "$1" > /dev/null
fi

# Query amixer for the current volume and whether or not the speaker is muted
volume="$( pactl list sinks | grep '^[[:space:]]Volume:' | head -n 1 | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')"
mute="$(pactl list sinks | grep '^[[:space:]]Mute:' | sed 's/^[[:space:]]Mute: //')"
if [[ $volume == 0 || $mute == "yes" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i "/usr/share/icons/ePapirus/48x48/status/notification-audio-volume-muted.svg" -r "$msgId" "Volume muted" 
else
    if [[ $volume > 50 ]]; then
        volume_icon="/usr/share/icons/ePapirus/48x48/status/notification-audio-volume-high.svg"
    elif [[ $volume > 25 ]]; then
        volume_icon="/usr/share/icons/ePapirus/48x48/status/notification-audio-volume-medium.svg"
    else
        volume_icon="/usr/share/icons/ePapirus/48x48/status/notification-audio-volume-low.svg"
    fi
    # Show the volume notification
    dunstify -a "changeVolume" -u low -i "$volume_icon" -r "$msgId" \
    "Volume: ${volume}%" "$(getProgressString 10 "<b> </b>" " " $volume)"
fi

# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"
