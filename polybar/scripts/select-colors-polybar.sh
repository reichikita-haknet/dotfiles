#!/bin/bash

help() {
  cat <<- EOF
Corre este script para cambiar la paleta de colores de mis scripts en bash con rofi.

Forma de ejecucion:
  SCRIPT [opciones]
      paleta de colores

opciones para la terminal:
  NordLight
  NordNight
  CatppuccinLatte
  CatppuccinFrappe
  CatppuccinMacchiato
  CatppuccinMocha
EOF
}

#------------------------------ Menú con Rofi ------------------------------------#
# Si usas prinft en lugar de echo esto no funcionara
rofi_menu() {
    # -i para que el filtro no distinga entre mayusculas y minusculas
    echo -e "WalDark\nWalLight\nNordLight\nNordNight\nCatppuccinLatte\nCatppuccinFrappe\nCatppuccinMacchiato\nCatppuccinMocha" | rofi -dmenu -i -p "Selecciona una peleta de colores: " -theme "~/.config/rofi/scripts/config-select-colors-polybar.rasi"
}


####### FUNCIONES PARA CADA PALETA DE COLOR QUE QUIERAS ########

WalDark() {
        # Elimina la regla que se aplicó a las ventanas de terminal kitty.
        bspc rule -r kitty
        # Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
        bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
        # mktemp -d crea un directorio temporal automaticamente
        temp_dir=$(mktemp -d)
        # Se creara un archivo “fondo.txt”  en un directorio temporal (o sea dentro de /tmp) con la ruta del archivo que selecciones en ranger
        terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo.txt")
        fondo_de_pantalla=$(cat "$temp_dir/fondo.txt")
        # Usa -n si quieres que pywal no defina el fondo de pantalla
        wal -e -s -q -n -i "$fondo_de_pantalla"
        # Borro el directorio temporal
#       rm -rf "$temp_dir"
        # Cambiar imagen de neofetch en funcion del fondo de pantalla
        cat ~/.config/neofetch/backup-config.conf > ~/.config/neofetch/config.conf
        sd Fondos_de_pantalla "$fondo_de_pantalla"  ~/.config/neofetch/config.conf
        # Llamo a las variables de colors.sh, necesariamente despues de elegir el fondo de pantalla
        . "${HOME}/.cache/wal/colors.sh"
        bg="$background"
        bgAlt="$color1"
        fg="$color1"
        sel="$color3"
        act="$color6"
        urg="$color5"
        r="$foreground"
        g="$foreground"
        y="$foreground"
        c="$foreground"
        gy="$foreground"
        w="#ffffff"
        y0="#fff075"
        y1="#fff675"
        y2="#fffc37"
        y3="#ffb175"
        y4="#ff9575"
        bspc rule -r kitty
}       
WalLight() {
        # Elimina la regla que se aplicó a las ventanas de terminal kitty.
        bspc rule -r kitty
        # Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
        bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
	# mktemp -d crea un directorio temporal automaticamente
	temp_dir=$(mktemp -d)
	# Se creara un archivo “fondo.txt”  en un directorio temporal (o sea dentro de /tmp) con la ruta del archivo que selecciones en ranger
	terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo.txt")
	fondo_de_pantalla=$(cat "$temp_dir/fondo.txt")
	# Usa -n si quieres que pywal no defina el fondo de pantalla
	wal -l -e -s -q -n -i "$fondo_de_pantalla"
	# Borro el directorio temporal
#	rm -rf "$temp_dir"
	# Cambiar imagen de neofetch en funcion del fondo de pantalla
	cat ~/.config/neofetch/backup-config.conf > ~/.config/neofetch/config.conf
	sd Fondos_de_pantalla "$fondo_de_pantalla"  ~/.config/neofetch/config.conf
	# Llamo a las variables de colors.sh, necesariamente despues de elegir el fondo de pantalla
	. "${HOME}/.cache/wal/colors.sh"
        bg="$background"
        bgAlt="$color1"
        fg="$color1"
        sel="$color3"
        act="$color6"
        urg="$color5"
        r="$foreground"
        g="$foreground"
        y="$foreground"
        c="$foreground"
        gy="$foreground"
        w="#ffffff"
	y0="#fff075"
        y1="#fff675"
        y2="#fffc37"
        y3="#ffb175"
        y4="#ff9575"
	bspc rule -r kitty
}
NordLight() {
	bg="#ECEFF4"
	bgAlt="#E5E9F0"
	fg="#434C5E"
	sel="#5E81AC"
	act="#8FBCBB"
	urg="#BF616A"
	r="#BF616A"
	g="#A3BE8C"
	y="#EBCB8B"
	c="#88C0D0"
	gy="#D8DEE9"
	w="#ECEFF4"
	y0="#EBCB8B"
	y1="#EBCB8B"
	y2="#EBCB8B"
	y3="#D08770"
	y4="#BF616A"
}

NordNight() {
        bg="#434C5E"
        bgAlt="#4C566A"
        fg="#ECEFF4"
	sel="#88C0D0"
        act="#8FBCBB"
        urg="#BF616A"
        r="#BF616A"
        g="#A3BE8C"
        y="#EBCB8B"
        c="#88C0D0"
        gy="#D8DEE9"
        w="#ECEFF4"
        y0="#EBCB8B"
        y1="#EBCB8B"
        y2="#EBCB8B"
        y3="#D08770"
        y4="#BF616A"
}


#----- Paletas de color de catppuccin: https://github.com/catppuccin/catppuccin#-palette -----#

CatppuccinLatte() {
        bg="#eff1f5"
        bgAlt="#e6e9ef"
        fg="#7c7f93"
        sel="#8839ef"
        act="#40a02b"
        urg="#dc8a78"
	r="#d20f39"
        g="#40a02b"
        y="#df8e1d"
        c="#04a5e5"
        gy="#bcc0cc"
        w="#eff1f5"
        y0="#df8e1d"
        y1="#df8e1d"
        y2="#df8e1d"
        y3="#fe640b"
        y4="#d20f39"
}
CatppuccinFrappe() {
        bg="#c6d0f5"
        bgAlt="#b5bfe2"
        fg="#949cbb"
        sel="#ca9ee6"
        act="#81c8be"
        urg="#e78284"
        r="#e78284"
        g="#a6d189"
        y="#e5c890"
        c="#99d1db"
        gy="#b5bfe2"
        w="#c6d0f5"
        y0="#e5c890"       
        y1="#e5c890"       
        y2="#e5c890" 
        y3="#ef9f76"
        y4="#e78284"
}
CatppuccinMacchiato() {
        bg="#cad3f5"
        bgAlt="#b8c0e0"
        fg="#8087a2"
        sel="#ed8796"
        act="#8aadf4"
        urg="#ed8796"
	r="#ed8796"
        g="#a6da95"
        y="#eed49f"
        c="#91d7e3"
        gy="#b8c0e0"
        w="#cad3f5"
        y0="#eed49f"       
        y1="#eed49f"       
        y2="#eed49f"  
        y3="#f5a97f"
        y4="#ed8796"
}
CatppuccinMocha() {
        bg="#cdd6f4"
        bgAlt="#bac2de"
        fg="#585b70"
        sel="#89b4fa"
        act"#fab387"
        urg="#f38ba8"
        r="#f38ba8"
        g="#a6e3a1"
        y="#f9e2af"
        c="#89dceb"
        gy="#bac2de"
        w="#cdd6f4"
        y0="#f9e2af"       
        y1="#f9e2af"       
        y2="#f9e2af"       
        y3="#fab387"
        y4="#f38ba8"
}



#----- Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada -----#

case "$1" in
# 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;

# 2da condicion del bloque case
	"")
		# Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "color"
		color=$(rofi_menu)	
		# Este bloque if verifica si la variable color esta vacia. Si no esta vacia (o sea el usuario selecciono un color) se llama a la función correspondiente y se genera el colors.ini
		if [ -n "$color" ]; then
			# Ahora la variable color debe contener el nombre de la variable seleccionado por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA VARIABLE SIN DARSE CUENTA!!!)
			$color
			echo "
		[colors]
                background = $bg      
                background-alt = $bgAlt 
		transparent = #00000000
                foreground = $fg    
                selected = $sel                    
                active = $act   
                urgent = $urg   
                red = $r     
                green = $g     
                yellow = $y      
                cyan = $c     
                gray = $gy    
                white =  $w     
                sig_yellow_0 = $y0    
                sig_yellow_1 = $y1    
                sig_yellow_2 = $y2    
                sig_yellow_3 = $y3    
                sig_yellow_4 = $y4 
			" >  ~/.config/polybar/colors.ini 
		# Para matar y recargar polybar y mas cositas que tendras que revisar 
		~/.config/polybar/scripts/launch.sh &
		~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $bg" "color: $fg" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "POLYBAR RECARGADO"
		fi

	;;
# 3ra condicion del bloque case. Solo esta por si en lugar de correr el script y ver el rofi (posible solor sin arguemento) prefieres ponerle directamente el argumento
	*)
		$1
		echo "
                [colors]
		background = $bg
	        background-alt = $bgAlt
		transparent = #00000000
		foreground = $fg
		selected = $sel
		active = $act
		urgent = $urg
                red = $r
                green = $g
                yellow = $y
		cyan = $c
                gray = $gy
                white =  $w
                sig_yellow_0 = $y0
                sig_yellow_1 = $y1
                sig_yellow_2 = $y2
                sig_yellow_3 = $y3
                sig_yellow_4 = $y4
		" >  ~/.config/polybar/colors.ini
		# Para matar y recargar polybar y mas cositas que tendras que revisar
                ~/.config/polybar/scripts/launch.sh &
                ~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $bg" "color: $fg" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "POLYBAR RECARGADO"

	;;
esac
