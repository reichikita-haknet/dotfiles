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

#-------- FUNCIONES PARA CADA GESTOR DE ARCHIVOS CON EL QUE SELECCIONAR UN FONDO DE PANTALLA PARA BETTERLOCKSCREEN -------#

Ranger() {
	# Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
	bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
	# mktemp -d crea un directorio temporal automaticamente
	temp_dir=$(mktemp -d)
	# Se creara un archivo “fondo-betterlockscreen.txt”  en un directorio temporal (o sea dentro de /tmp) con la ruta absoluta del archivo que selecciones en ranger
	terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo-betterlockscreen.txt")
	fondo_de_pantalla=$(cat "$temp_dir/fondo-betterlockscreen.txt")
}

#----- Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada -----#

case "$1" in
# 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;
# 2da condicion del bloque case
	"")
		Ranger
		# Usamos -u para "actualizar" (update) el fondo de betterlockscreen
		betterlockscreen -u "$fondo_de_pantalla"
		# Pywal con betterlockscreen actualizado
		ln -sf ~/.cache/wal/betterlockscreenrc ~/.config/betterlockscreen/betterlockscreenrc
		~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "border: 5px solid $foreground" "font-family: 'Hack Nerd Font'" -m "BETTERLOCKSCREEN RECARGADO"
		# Debido a que eliminar la regla kitty solo surtira efecto si recarga bspwm, es mucho mejor establecer otra regla
		bspc rule -a kitty state=tiled
	;;
# 3ra condicion del bloque case. Solo esta por si prefieres ponerle directamente un argumento para ejcutar el script
	*)
		# Usamos -u para "actualizar" (update) el fondo de betterlockscreen
		betterlockscreen -u "$1"
		# Pywal con betterlockscreen actualizado
		ln -sf ~/.cache/wal/betterlockscreenrc ~/.config/betterlockscreen/betterlockscreenrc
		~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "border: 5px solid $foreground" "font-family: 'Hack Nerd Font'" -m "BETTERLOCKSCREEN RECARGADO"
		# Debido a que eliminar la regla kitty solo surtira efecto si recarga bspwm, es mucho mejor establecer otra regla
		bspc rule -a kitty state=tiled
	;;
esac
