#!/bin/bash

help () {
	cat <<- EOF
Corre este script para cambiar la configuracion de tus monitores.

run,
	SCRIPT [options]
		modo para pantalla del monitor/es

options:
	Solo pantalla principal (si tienes una laptop se usara la pantalla de esta)
	Solo pantalla secundaria
	Pantalla dividida (dos monitores)
EOF
}

#--------------- FUNCION PARA POLYBAR -------------#
recargar_polybar() {
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
}

fondo_con_feh() {
	# Definir con feh como fondo de pantalla el ultimo fondo de pantalla usado por pywal
	# Lo pongo despues de usar xrandr porque asi defino el fondo de pantalla en mas de un monitor si los hay
	feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
	
}


#--------------- FUNCIONES PARA CADA MODO DE PANTALLA DEL MONITOR/ES ---------------#

pri=$(xrandr --query | grep " primary" | cut -d" " -f1)
sec=$(xrandr --query | grep -v " primary" | grep " connected" | cut -d" " -f1)

SoloPrincipal() {
	# Para usar betterlockscreen con un monitor en caso de que esten los parametros para doble monitor
        sed -i 's/--span/#parametros/' ~/.config/sxhkd/sxhkdrc
        xrandr --output $sec --off --output $pri --mode 1920x1080 --pos 1920x0 --rotate normal 
        # Guarda el valor de $sec en un archivo
        echo $sec >> ~/.config/bspwm/scripts/sec.txt
        # Luego lee el valor de $sec desde el archivo, ahora $sec tiene un valor que aunque desconecte el monitor secundario no sera nulo y asi pueda hacer las configuraciones necesarias
        sec=$(grep -v '^$' ~/.config/bspwm/scripts/sec.txt | tail -n 1)
	#----------- SIN ESTO LOS NODOS (VENTANAS) YA NO SERIAN CONSIDERADAS ASI POR BSPWM, POR LO QUE PARECERIAN CONGELADAS Y TENDRIAS QUE CERRARLAS CON PKILL -----------#
	# bspc query -N -d: Enumera todos los ID de las ventanas en el escritorio actual
        # xargs -I id -n1 bspc node id -m ^2: Para cada ID de ventana, mueve esa ventana al monitor 1 (despues de usar xrandr solo habria 1)
        bspc query -N -d | xargs -I id -n1 bspc node id -m ^1
	#-------------------------------------------------------------------------------------------------------------------------------------------------------------------#
	# Reemplazo si existen los otros dos
        sed -i "s/bspc monitor $pri -d 1 2 3 4 5;bspc monitor $sec -d 6 7 8 9 10/bspc monitor -d 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	sed -i "s/bspc monitor $sec -d 1 2 3 4 5 6 7 8 9 10/bspc monitor -d 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
        # Reemplazo si existen los otros dos
	sed -i "s/bspc monitor $pri -o 1 2 3 4 5;bspc monitor $sec -o 6 7 8 9 10/bspc monitor -o 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	sed -i "s/bspc monitor $sec -o 1 2 3 4 5 6 7 8 9 10/bspc monitor -o 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	bspc monitor $sec -r
        dunstify -t 4000 -i ~/.config/dunst/icons/apps/power00.png "SOLO MONITOR PRINCIPAL"
}

SoloSecundaria() {
	# Para usar betterlockscreen con un monitor en caso de que esten los parametros para doble monitor
        sed -i 's/--span/#parametros/' ~/.config/sxhkd/sxhkdrc
	xrandr --output $pri --off --output $sec --mode 1920x1080 --pos 1920x0 --rotate normal
	#----------- SIN ESTO LOS NODOS (VENTANAS) YA NO SERIAN CONSIDERADAS ASI POR BSPWM, POR LO QUE PARECERIAN CONGELADAS Y TENDRIAS QUE CERRARLAS CON PKILL -----------#
	# bspc query -N -d: Enumera todos los ID de las ventanas en el escritorio actual
        # xargs -I id -n1 bspc node id -m ^2: Para cada ID de ventana, mueve esa ventana al monitor 1 (despues de usar xrandr solo habria 1)
        bspc query -N -d | xargs -I id -n1 bspc node id -m ^1
	#-------------------------------------------------------------------------------------------------------------------------------------------------------------------#
	# Reemplazo si existen los otros dos
        sed -i "s/bspc monitor $pri -d 1 2 3 4 5;bspc monitor $sec -d 6 7 8 9 10/bspc monitor $sec -d 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	sed -i "s/bspc monitor -d 1 2 3 4 5 6 7 8 9 10/bspc monitor $sec -d 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	# Reemplazo si existen los otros dos
        sed -i "s/bspc monitor $pri -o 1 2 3 4 5;bspc monitor $sec -o 6 7 8 9 10/bspc monitor $sec -o 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
        sed -i "s/bspc monitor -o 1 2 3 4 5 6 7 8 9 10/bspc monitor $sec -o 1 2 3 4 5 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
        bspc monitor $pri -r
        dunstify -t 4000 -i ~/.config/dunst/icons/apps/kiga00.png "SOLO MONITOR SECUNDARIO"
        # Guarda el valor de $sec en un archivo, en este caso para que cuando desconectes el monitor secundario $sec tenga un valor no nulo
        # Como va a /tmp no te preocupes de que vaya a escribirse 1000 veces el nombre del monitor secundario
        echo $sec >> ~/.config/bspwm/scripts/sec.txt	
}

Dividida() {
	# Para usar betterlockscreen con un monitor en caso de que NO esten los parametros para doble monitor
        sed -i 's/#parametros/--span/' ~/.config/sxhkd/sxhkdrc
	xrandr --output $pri --primary --mode 1920x1080 --pos 0x0 --rotate normal --left-of $sec --mode 1920x1080 --pos 1920x0 --rotate normal
	# Reemplazo si existen los otros dos
        sed -i "s/bspc monitor -d 1 2 3 4 5 6 7 8 9 10/bspc monitor $pri -d 1 2 3 4 5;bspc monitor $sec -d 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	sed -i "s/bspc monitor $sec -d 1 2 3 4 5 6 7 8 9 10/bspc monitor $pri -d 1 2 3 4 5;bspc monitor $sec -d 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	# Reemplazo si existen los otros dos
        sed -i "s/bspc monitor -o 1 2 3 4 5 6 7 8 9 10/bspc monitor $pri -o 1 2 3 4 5;bspc monitor $sec -o 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
        sed -i "s/bspc monitor $sec -o 1 2 3 4 5 6 7 8 9 10/bspc monitor $pri -o 1 2 3 4 5;bspc monitor $sec -o 6 7 8 9 10/g" ~/.config/bspwm/bspwmrc
	dunstify -t 4000 -i ~/.config/dunst/icons/apps/power01.png "PANTALLA DIVIDIDA"
        # Guarda el valor de $sec en un archivo, en este caso para que cuando desconectes el monitor secundario $sec tenga un valor no nulo
        # Como va a /tmp no te preocupes de que vaya a escribirse 1000 veces el nombre del monitor secundario
        echo $sec >> ~/.config/bspwm/scripts/sec.txt
}

#------------------------------ MENU CON ROFI -----------------------#
# Si usas prinft en lugar de echo esto no funcionara
rofi_menu () {
	echo -e "SoloPrincipal\nSoloSecundaria\nDividida" | rofi -dmenu -i -theme "~/.config/rofi/scripts/config-monitores.rasi"
}

### Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada

case "$1" in
	# 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;
	# 2da condicion del bloque case
	"")
		# Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "pantalla"
		pantalla=$(rofi_menu)
		# Este bloque if verifica si la variable pantalla esta vacia. Si no esta vacia (o sea el usuario selecciono un modo de pantalla) se llama a la función correspondiente
		if [ -n "$pantalla"  ]; then
			# Ahora la variable pantalla debe contener el nombre de la funcion seleccionada por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA FUNCION SIN DARSE CUENTA!!!)
			$pantalla
		fi
		;;
	# 3ra condicion del bloque case. Solo esta por si en lugar de correr el script y ver el rofi prefieres ponerle directamente un argumento
	*)
		$1
		;;
esac

recargar_polybar
# fondo_con_feh
