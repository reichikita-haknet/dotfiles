#!/bin/bash

# Usar variables de color actualizadas
. "${HOME}/.cache/wal/colors.sh"

help() {
  cat <<- EOF
Corre este script para cambiar el tema de tu polybar en bash con rofi.

Forma de ejecucion:
  SCRIPT [opciones]
	tema para polybar

opciones para la terminal:
  Blocks
  Rounded
EOF
}

#------------------------------ Menú con Rofi ------------------------------------#
# Si usas prinft en lugar de echo esto no funcionara
rofi_menu() {
    # -i para que el filtro no distinga entre mayusculas y minusculas
    echo -e "Blocks\nRounded" | rofi -dmenu -i -p "Selecciona un tema:" -theme "~/.config/rofi/scripts/config-select-themes-polybar.rasi"
}
############# FUNCIONES PARA CADA TEMA ##############

Blocks() {
	cp ~/.config/polybar/blocks/*.ini ~/.config/polybar/
	cp ~/.config/polybar/blocks/config ~/.config/cava/
	~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: #d3c6aa" "color: #b8bb26" "border: 5px solid #e69875" "font-family: 'Hack Nerd Font'" -m "POLYBAR RECARGADO"
}
Rounded() {
	cp ~/.config/polybar/rounded/*.ini ~/.config/polybar/
	~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "color: $foreground" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "POLYBAR RECARGADO"
}

#----- Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada -----#

case "$1" in
	# 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;
	# 2da condicion del bloque case
	"")
		# Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "tema"
		tema=$(rofi_menu)
		# Este bloque if verifica si la variable tema esta vacia. Si no esta vacia (o sea el usuario selecciono un tema) se llama a la función correspondiente
		if [ -n "$tema" ]; then
			# Ahora la variable color debe contener el nombre de la variable seleccionado por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA VARIABLE SIN DARSE CUENTA!!!)
			$tema
			# Para matar y recargar polybar y mas cositas que tendras que revisar 
                ~/.config/polybar/scripts/launch.sh &
		fi
	;;
# 3ra condicion del bloque case. Solo esta por si en lugar de correr el script y ver el rofi (posible solor sin arguemento) prefieres ponerle directamente el argumento
	*)
		$1
		# Para matar y recargar polybar y mas cositas que tendras que revisar
                ~/.config/polybar/scripts/launch.sh &
	;;
esac
