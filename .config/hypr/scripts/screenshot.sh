#!/bin/bash

file="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')"

#check if file argument is passed as second argument
if [[ "$2" ]]; then
    file=$2
    echo "File : $file"
fi

screenshotAll(){
    ScreenshotsDir="$HOME/Pictures/WorkspaceShots"
    screenshots=()
    
    # active workspaces
    workspace_ids=()
    while IFS= read -r line; do
        id=$(echo "$line" | awk '{print $3}')
        if [[ $id =~ ^[0-9]+$ ]]; then
            workspace_ids+=("$id")
        fi
    done < <(hyprctl workspaces | grep '^workspace ID' | sort -n)
    
    hyprctl dispatch workspace 11
    
    # create directory if not exists
    mkdir -p "$ScreenshotsDir"
    
    # take screenshots
    for id in "${workspace_ids[@]}"; do
        hyprctl dispatch workspace "$id"
        sleep 2
        file="$ScreenshotsDir/$(date +'%s_grim.png')"
        $HOME/.config/hypr/scripts/screenshot.sh --now "$file" && screenshots+=("$file")
    done
    
    # Reorder the screenshots array to append the first screenshot (0) as the last one (10)
    screenshots=("${screenshots[@]:1}" "${screenshots[0]}")
    
    # merge screenshots
    convert -append ${screenshots[@]} $ScreenshotsDir/$(date +'%s_grim_result.jpg')
    
    # notify
    notify-send 'Clipboard' 'Screenshots taken and merged.' --hint=string:actions:"[[\"Preview\",\"feh $ScreenshotsDir/$(date +'%s_grim_result.jpg') \"],[\"Edit\",\"gimp $ScreenshotsDir/$(date +'%s_grim_result.jpg') \"],[\"Delete\",\"rm $ScreenshotsDir/$(date +'%s_grim_result.jpg') \"]]"
    
}

# notify and view screenshot

if [[ "$1" == "--now" ]]; then
    
    grim - | wl-copy && wl-paste >$file
    
    notify-send -i $file 'Clipboard' 'Screenshot taken and copied to clipboard.' --hint=string:actions:"[[\"Preview\",\"feh $file \"],[\"Edit\",\"gimp $file \"],[\"Delete\",\"rm $file \"]]"
    
    elif [[ "$1" == "--area" ]]; then
    
    grim -g "$(slurp)" - | wl-copy && wl-paste >$file
    
    notify-send -i $file 'Clipboard' 'Screenshot taken and copied to clipboard.' --hint=string:actions:"[[\"Preview\",\"feh $file \"],[\"Edit\",\"gimp $file \"],[\"Delete\",\"rm $file \"]]"
    
    elif [[ "$1" == "--all" ]]; then
    
    screenshotAll
else
    
    echo -e "Available Options : --now --area"
fi
