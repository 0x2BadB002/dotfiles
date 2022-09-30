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
    local music_dir temp_song cover_file current_music_file
    music_dir="$HOME/Music"
    temp_song="/tmp/current-song"
    cover_file="/tmp/cover.png"
    current_music_file="$(mpc --format %file% current)"

    if [[ -r "${music_dir}/${current_music_file}" ]]; then
        cp "${music_dir}/${current_music_file}" "${temp_song}"

        ffmpeg \
            -hide_banner \
            -loglevel 0 \
            -y \
            -i "${temp_song}" \
            -vf scale=400:-1 \
            "${cover_file}" >/dev/null 2>&1

        convert "${cover_file}" -resize 512x512 /tmp/resized.png
        rm "${temp_song}"
    fi
}

function send_notification() {
    if [[ -e "/tmp/resized.png" ]]; then
        dunstify -a "mpd" -I "/tmp/resized.png" "$(mpc --format "%title%\n\n%artist%" current)"
    else
        dunstify -a "mpd" "$(mpc --format "%title%\n\n%artist%" current)"
    fi
}

if [[ $1 == "extract" ]]; then
    extract_cover
    send_notification
else
    launch_player
fi
