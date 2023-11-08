#!/bin/bash

cap_scr_save(){
	flameshot gui
}


cap_scr_temp(){
    flameshot gui -r > /tmp/latest.png && sxiv -b /tmp/latest.png
}

cap_col(){
    prev_file="/tmp/preview.png"
    window_size="64x64"
    clipped="xclip -o -selection clipboard"
    xcolor | xclip -selection clipboard
    convert -size "$window_size" xc:$(${clipped}) -flatten $prev_file
    dunstify -a "Selector de color" -t 2500 "Valor Hex copiado" "$(${clipped})"
}

cap_lens(){
	~/.local/bin/flameshot-lens
}

scr_active(){
    activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
    activeWinId="${activeWinLine:40}"
    import -window $activeWinId ~/Capturas_de_pantalla/`date +%F_%H%M%S_%N`.jpg
    dunstify -t 2500 -i ~/.config/dunst/icons/apps/kobeni00.png "Captura de pantalla guardada"
}

scr_total(){
	import -window root ~/Capturas_de_pantalla/`date +%F_%H%M%S_%N`.jpg
	dunstify -t 2500 -i ~/.config/dunst/icons/apps/asa00.png "Captura de pantalla guardada"
}

cap_scrot(){
	scrot -d 5 -F ~/Capturas_de_pantalla/'%Y-%m-%d_$wx$h.png'
	dunstify -t 2500 -i ~/.config/dunst/icons/apps/yuko00.png "Captura de pantalla guardada"
}

# simple menu
if [ "$1" = "-c" ]; then
	cap_scr_save
elif [ "$1" = "-k" ]; then
	cap_scr_temp
elif [ "$1" = "-w" ]; then
	cap_col
elif [ "$1" = "-l" ]; then
	cap_lens
elif [ "$1" = "-a" ]; then
	scr_active
elif [ "$1" = "-t" ]; then
	scr_total
elif [ "$1" = "-s" ]; then
	cap_scrot
else
	echo "Usa un parametro pibe"
fi
