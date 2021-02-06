#!/usr/bin/env bash
set -euo pipefail

bspc subscribe desktop_focus | while read -r _ _ desktop type; do
    bspc query -N -d "$desktop" | while read node; do
        gaps=$(bspc config window_gap)
        echo "$gaps" "$node"
        [[ $gaps -eq 0 ]] \
            && xprop -id "$node" -f _PICOM_ROUND 32c -set _PICOM_ROUND 1 \
            || xprop -id "$node" -remove _PICOM_ROUND
    done
done
