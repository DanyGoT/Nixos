#!/usr/bin/env bash

swaymsg -t subscribe -m '["window", "workspace"]' | while read -r event; do
    focused_ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true)')
    output=$(echo "$focused_ws" | jq -r '.output')
    window_count=$(echo "$focused_ws" | jq -r '.representation | split(" ") | length')

    if [[ "$output" == "HDMI-A-1" && "$window_count" -eq 1 ]]; then
        swaymsg gaps horizontal current set 650
        # swaymsg gaps left all set 450
        # swaymsg gaps right all set 450
    else
        swaymsg gaps horizontal current set 0
        # swaymsg gaps left all set 0
        # swaymsg gaps right all set 0
    fi
done

