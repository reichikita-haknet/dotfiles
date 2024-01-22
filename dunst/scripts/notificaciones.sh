#!/bin/bash

caps(){
	# Ojo, lo que hace que pueda cambiar la salida del comando que verifica if es el `sleep 0.2 &&`
	sleep 0.2 && if [ "$(xset q | grep "Caps Lock:" | awk '{print $4}')" = "on" ]; then
		# El `-a` solo me sirve para mostrar un titulo en mi notificacion
		# El `-h` es muy util ya que es una "pista (hint)", es decir, le doy la "pista de donde buscar su regla"
		# En dunstrc estableci un icono diferente para cada estado, la forma en que lo sabe es cuando el "summary =" en dunstrc coinde con el "summary" de dunstify
		# Al final sirve para que no aparezca el contador de notificaciones sin necesidad de desactivar en dunstrc (porque eso desactiva todas, y apps como messenger es importante un contador)
		dunstify -a Sistema -t 1200 -h string:x-dunst-stack-tag:capslock "Mayúsculas activadas"
	else 
		dunstify -a Sistema -t 1200 -h string:x-dunst-stack-tag:capslock "Mayúsculas desactivadas"
	fi
}


obs(){
    sleep 1 && if [ "$(grep obs | wc -l)" = "2" ]; then dunstify -a 'OBS Studio' -t 1200 -h string:x-dunst-stack-tag:obs "Recording Started"; elif [ "$(pgrep obs | wc -l)" = "1" ]; then dunstify -a 'OBS Studio' -t 1200 -h string:x-dunst-stack-tag:obs "Recording Stopped"; fi
}

rec(){
    if [ $(pgrep ffmpeg) ]; then dunstify -a 'Recording' -t 1200 -h string:x-dunst-stack-tag:recording "Started"; else dunstify -a 'Recording' -t 1200 -h string:x-dunst-stack-tag:recording "Stopped"; fi
}

tp_locked(){
    dunstify -a System -t 1200 -h string:x-dunst-stack-tag:touchpad "Touchpad" "Locked"
}

tp_unlocked(){
    dunstify -a System -t 1200 -h string:x-dunst-stack-tag:touchpad "Touchpad" "Unlocked"
}


while getopts ":corlu" option; do
	case $option in
		c) caps;;
		o) obs;;
		r) rec;;
		l) tp_locked;;
		u) tp_unlocked;;
		\?) exit 1;;
	esac
done
