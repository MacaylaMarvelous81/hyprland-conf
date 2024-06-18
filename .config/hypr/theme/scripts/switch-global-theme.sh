#!/bin/bash

hyprDir=$HOME/.config/hypr

$hyprDir/theme/scripts/system-theme.sh switch

$hyprDir/theme/scripts/wal-theme.sh &

$hyprDir/theme/scripts/rofi-theme.sh &

$hyprDir/theme/scripts/xava-theme.sh &

$hyprDir/theme/scripts/eww-theme.sh && sleep 1 && notify-send "Current theme" "$($hyprDir/theme/scripts/system-theme.sh get)"
