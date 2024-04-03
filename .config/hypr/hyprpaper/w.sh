#!/bin/bash
monitors=$(hyprctl monitors | grep Monitor | awk '{print $2}') # get monitors
hyprdir=$HOME/.config/hypr                                     # hypr directory
wallpaper=$1                                                   # wallpaper

####################################1######

sleep 0.25s # wait for wallpaper to load

##########################################

for monitor in $monitors; do                          # loop through monitors
    hyprctl hyprpaper wallpaper "$monitor,$wallpaper" # set wallpaper
done

##########################################

sleep 0.5s
$hyprdir/wal/pywal "$wallpaper" # set wallpaper theme # wait for wallpaper to load

# $hyprdir/scripts/dynamic-border.sh # set border theme

##########################################
