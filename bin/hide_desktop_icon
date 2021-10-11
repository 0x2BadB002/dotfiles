#!/usr/bin/env bash

path=$1
name=$(echo "$path" | awk -F "/" '{printf $NF}')

cp "$path" /home/pavel/.local/share/applications/"$name"

echo "NoDisplay=true" >> /home/pavel/.local/share/applications/"$name"
