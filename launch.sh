#!/bin/bash

#------- Configuracion de monitor o monitores -------#
pri=$(xrandr --query | grep " primary" | cut -d" " -f1)
sec=$(xrandr --query | grep -v " primary" | grep " connected" | cut -d" " -f1)

if [ "$(xrandr -q | awk '/ connected / {print $1}' | wc -l)" -eq 1 ]; then
	# Para usar betterlockscreen con un monitor en caso de que esten los parametros para doble monitor
	sed -i 's/--display 1 --span/#parametros_para_segundo_monitor/' ~/.config/sxhkd/sxhkdrc 
	xrandr -s 1920x1080
	# Guarda el valor de $sec en un archivo
	echo $sec >> ~/.config/bspwm/scripts/sec.txt
	# Luego lee el valor de $sec desde el archivo, ahora $sec tiene un valor aunque desconecte el monitor secundario para que asi no sea nulo si lo desconecto y pueda hacer las configuraciones necesarias
	sec=$(grep -v '^$' ~/.config/bspwm/scripts/sec.txt | head -n 1)
	sed -i "s/bspc monitor $pri -d I II III IV V; bspc monitor $sec -d VI VII VIII IX X/bspc monitor -d I II III IV V VI VII VII IX X/g" ~/.config/bspwm/bspwmrc
	bspc monitor $sec -r
	dunstify -t 4000 -i ~/.config/dunst/icons/apps/cat-0.png "UN MONITOR"
elif [ "$(xrandr -q | awk '/ connected / {print $1}' | wc -l)" -eq 2 ]; then
	# Para usar betterlockscreen con un monitor en caso de que NO esten los parametros para doble monitor
        sed -i 's/#parametros_para_segundo_monitor/--display 1 --span/' ~/.config/sxhkd/sxhkdrc
	#------------------- Pantalla dividida -------------------------#
	#xrandr --output $pri --primary --mode 1920x1080 --pos 0x0 --rotate normal --output $sec --mode 1920x1080 --pos 1920x0 --rotate normal
	#sed -i "s/bspc monitor -d I II III IV V VI VII VII IX X/bspc monitor $pri -d I II III IV V; bspc monitor $sec -d VI VII VIII IX X/g" ~/.config/bspwm/bspwmrc
	#------------------- Quedarme solo con el monitor secundario --------------------#
	xrandr --output $pri --off --output $sec --mode 1920x1080 --pos 1920x0 --rotate normal
	sed -i "s/bspc monitor $pri -d I II III IV V; bspc monitor $sec -d VI VII VIII IX X/bspc monitor $sec -d I II III IV V VI VII VII IX X/g" ~/.config/bspwm/bspwmrc
	bspc monitor $pri -r
	dunstify -t 4000 -i ~/.config/dunst/icons/apps/cat-0.png "DOBLE MONITOR"
	# Guarda el valor de $sec en un archivo, en este caso para que cuando desconectes el monitor secundario $sec tenga un valor no nulo
	# Como va a /tmp no te preocupes de que vaya a escribirse 1000 veces el nombre del monitor secundario
	echo $sec >> ~/.config/bspwm/scripts/sec.txt
fi


# Si 'polybar' está en ejecución, lo mata
if [ -n "$(pgrep -x polybar)" ]; then
    pkill -KILL polybar
fi

# Espera un segundo para que 'polybar' termine completamente
sleep 1

# Si 'polybar' no está en ejecución, inicia dos instancias de 'polybar'
if [ -z "$(pgrep -x polybar)" ]; then
	polybar barup &
	polybar bardown &
fi

# Definir con feh como fondo de pantalla el ultimo fondo de pantalla usado por pywal
# Lo pongo despues de usar xrandr porque asi defino el fondo de pantalla en mas de un monitor si los hay
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
