#! /usr/bin/env bash

function launch_player() {
    kitty @ new-window --new-tab --tab-title music --title cover sh
    kitty @ goto-layout --match title:music Horizontal
    kitty @ send-text 'export PS1="" \r'
    change_cover
    kitty @ new-window --title ncmpcpp ncmpcpp
    kitty @ resize-window --increment 93
    kitty @ close-tab --match id:1
}

function change_cover() {
    kitty @ send-text \
        --match title:cover \
        'clear && kitty icat --transfer-mode=stream /tmp/cover.png \r'
}

function extract_cover() {
    music_dir="$HOME/Music"
    temp_song="/tmp/current-song"

    cp "$music_dir/$(mpc --format %file% current)" "$temp_song"

    ffmpeg \
        -hide_banner \
        -loglevel 0 \
        -y \
        -i "$temp_song" \
        -vf scale=400:-1 \
        "/tmp/cover.png" > /dev/null 2>&1

    convert /tmp/cover.png -resize 512x512 /tmp/resized.png
    rm "$temp_song"
}

function send_notification() {
    dunstify -I "/tmp/resized.png" "$(mpc --format "%title%\n\n%artist%" current)"
}

if [[ $1 == "extract" ]]; then
    extract_cover
    change_cover
    send_notification
else
    launch_player
fi
