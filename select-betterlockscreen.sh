#!/bin/bash

# Llamo a las variables de colors.sh, necesariamente para usar sus colores con pop_report
. "${HOME}/.cache/wal/colors.sh"

help() {
	cat <<- EOF
Corre este script para cambiar el fondo de pantalla de betterlockscreen.

Forma de ejecucion:
	SCRIPT [Ruta absoluta a fondo de pantalla]
EOF
}

#------------------------ MENU CON ROFI ---------------------#
# Si usas prinft en lugar de echo esto no funcionara
rofi_menu() {
	# -i para que el filtro no distinga entre mayusculas y minusculas
	echo -e "Ranger\nThunar" | rofi -dmenu -i -p "Selecciona un fondo de pantalla: " -theme "~/.config/rofi/scripts/config-select-betterlockscreen.rasi"
}

#-------- FUNCIONES PARA CADA GESTOR DE ARCHIVOS CON EL QUE SELECCIONAR UN FONDO DE PANTALLA PARA BETTERLOCKSCREEN -------#

Ranger() {
	# Elimina la regla que se aplicó a las ventanas de terminal kitty.	
	bspc rule -r kitty
	# Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
	bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
	# mktemp -d crea un directorio temporal automaticamente
	temp_dir=$(mktemp -d)
	# Se creara un archivo “fondo-betterlockscreen.txt”  en un directorio temporal (o sea dentro de /tmp) con la ruta absoluta del archivo que selecciones en ranger
	terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo-betterlockscreen.txt")
	fondo_de_pantalla=$(cat "$temp_dir/fondo-betterlockscreen.txt")
	# Usamos -u para "actualizar" (update) el fondo de betterlockscreen
	betterlockscreen -u "$fondo_de_pantalla"
	# Pywal con betterlockscreen actualizado
	ln -sf ~/.cache/wal/betterlockscreenrc ~/.config/betterlockscreenrc
}

#Thunar() {
#
#}

#----- Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada -----#

case "$1" in
# 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;
# 2da condicion del bloque case
	"")
		# Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "fondo_de_betterlockscreen"
		fondo_de_betterlockscreen=$(rofi_menu)
		# Este bloque if verifica si la variable fondo_de_betterlockscreen esta vacia. Si no esta vacia (o sea el usuario selecciono un fondo) se llama a la función correspondiente.
		if [ -n "$fondo_de_betterlockscreen" ]; then
			# Ahora la variable fondo_de_betterlockscreen debe contener el nombre de la variable seleccionado por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA VARIABLE SIN DARSE CUENTA!!!)
			$fondo_de_betterlockscreen
			~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "border: 5px solid $foreground" "font-family: 'Hack Nerd Font'" -m "BETTERLOCKSCREEN RECARGADO"
		fi
		bspc rule -r kitty
	;;
# 3ra condicion del bloque case. Solo esta por si en lugar de correr el script y ver el rofi (posible solor sin arguemento) prefieres ponerle directamente el argumento
	*)
		$1
		~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "border: 5px solid $foreground" "font-family: 'Hack Nerd Font'" -m "BETTERLOCKSCREEN RECARGADO"
		bspc rule -r kitty
	;;
esac
