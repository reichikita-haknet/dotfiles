#!/bin/bash

# Importa los colores de pywal
source "/home/reichikita/.cache/wal/colors.sh"

bl_up(){
    light -A 5 && dunstify -a System -t 1000 -h string:x-dunst-stack-tag:backlight -h int:value:$(light -G) "Backlight: $(light -G)%"
}

bl_down(){
    light -U 5 && dunstify -a System -t 1000 -h string:x-dunst-stack-tag:backlight -h int:value:$(light -G) "Backlight: $(light -G)%"
}

# :: Main

while getopts ":udt" option; do
    case $option in
        u) bl_up;;
        d) bl_down;;
        \?) exit 1
    esac
done
