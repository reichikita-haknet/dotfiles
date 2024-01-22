#!/bin/sh

help() {
  cat <<- EOF
Corre este script para cambiar la paleta de colores de mis scripts en bash con rofi.

Forma de ejecucion:
  SCRIPT [options]
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

#-------------- FUNCIONES PARA CADA PALETA DE COLOR QUE QUIERAS --------------#

WalDark() {
        bspc rule -r kitty
        # mktemp -d crea un directorio temporal
        temp_dir=$(mktemp -d)
        # Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
        bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
        terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo.txt" &) PIDkitty=$!
        fondo_de_pantalla=$(cat "$temp_dir/fondo.txt")
        wal -e -s -q -n -i "$fondo_de_pantalla"
        # Borro el directorio temporal
        rm -rf "$temp_dir"
        # Cambiar imagen de neofetch en funcion del fondo de pantalla
        cat ~/.config/neofetch/backup-config.conf > ~/.config/neofetch/config.conf
        sd Fondos_de_pantalla "$fondo_de_pantalla"  ~/.config/neofetch/config.conf
        # Llamo a las variables de colors.sh, necesariamente despues de elegir el fondo de pantalla
        . "${HOME}/.cache/wal/colors.sh"
        bg="$color1"
        bgAlt="$color2"
        fg="$foreground"
        sel="$color3"
        act="$color4"
        urg="$color5"
        bspc rule -r kitty

#--------- Kitty ------------#
	sed -i 's/export BAT_THEME="gruvbox-light"/export BAT_THEME="gruvbox-dark"/g' ~/.zshrc
#--------- Discord + Pywal ! ----------#
        # Borrar anterior tema
        rm ~/.config/BetterDiscord/themes/pywal.theme.css
        # Este script imprimirá solo el nombre del archivo y no la ruta absoluta
        archivo=$(basename "$wallpaper")
        echo $archivo
        # Sube la imagen a transfer.sh
        upload=$(curl --upload-file $wallpaper https://transfer.sh/$archivo)
        # Ojo que aqui uso llaves porque estoy usando una operación de sustitución de cadenas en bash.
        # Reemplaza la primera aparición de `transfer.sh` en la variable `upload` con `transfer.sh/get`.
        # Por lo tanto, si upload era https://transfer.sh/hcRDb5Gzfo/fondoPywal.png, después de esta línea, upload se convierte en https://transfer.sh/get/hcRDb5Gzfo/fondoPywal.png.
        # Esto por que solo con `/get` es el link directo a la imagen, sin el es solo un visualizador
        upload=${upload/transfer.sh/transfer.sh/get}

        # Eliminar el tema anterior porque tiene el mismo nombre, BetterDiscord lo agregara despues al JSON automaticamente
        sed -i '/"Wal": false/d' ~/.config/BetterDiscord/data/stable/themes.json
        # Reemplaza la regla background-image en pywal.theme.css
        sed -i "s|background-image: url(.*)|background-image: url($upload)|g" ~/.cache/wal/pywal.theme.css
        # Copiar tema modificado
        cp ~/.cache/wal/pywal.theme.css ~/.config/BetterDiscord/themes/
        ~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "color: $foreground" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "DISCORD RECARGADO"
}

WalLight() {
	bspc rule -r kitty
	# mktemp -d crea un directorio temporal
        temp_dir=$(mktemp -d)
        # Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
        bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
        terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo.txt" &) PIDkitty=$!
	fondo_de_pantalla=$(cat "$temp_dir/fondo.txt")
        wal -l -e -s -q -n -i "$fondo_de_pantalla"
	# Borro el directorio temporal
        rm -rf "$temp_dir"
	# Cambiar imagen de neofetch en funcion del fondo de pantalla
        cat ~/.config/neofetch/backup-config.conf > ~/.config/neofetch/config.conf
	sd Fondos_de_pantalla "$fondo_de_pantalla"  ~/.config/neofetch/config.conf
	# Llamo a las variables de colors.sh, necesariamente despues de elegir el fondo de pantalla
        . "${HOME}/.cache/wal/colors.sh"
        bg="$color1"
        bgAlt="$color2"
        fg="$foreground"
        sel="$color3"
        act="$color4"
        urg="$color5"
	bspc rule -r kitty
#--------- Kitty ------------#
	sed -i 's/export BAT_THEME="gruvbox-dark"/export BAT_THEME="gruvbox-light"/g' ~/.zshrc
#--------- Discord + Pywal ! ----------#
	# Borrar anterior tema
	rm ~/.config/BetterDiscord/themes/pywal.theme.css
	# Este script imprimirá solo el nombre del archivo y no la ruta absoluta
	archivo=$(basename "$wallpaper")
	echo $archivo
	# Sube la imagen a transfer.sh
	upload=$(curl --upload-file $wallpaper https://transfer.sh/$archivo)
	# Ojo que aqui uso llaves porque estoy usando una operación de sustitución de cadenas en bash.
	# Reemplaza la primera aparición de `transfer.sh` en la variable `upload` con `transfer.sh/get`.
	# Por lo tanto, si upload era https://transfer.sh/hcRDb5Gzfo/fondoPywal.png, después de esta línea, upload se convierte en https://transfer.sh/get/hcRDb5Gzfo/fondoPywal.png.
	# Esto por que solo con `/get` es el link directo a la imagen, sin el es solo un visualizador
	upload=${upload/transfer.sh/transfer.sh/get}

	# Eliminar el tema anterior porque tiene el mismo nombre, BetterDiscord lo agregara despues al JSON automaticamente
	sed -i '/"Wal": false/d' ~/.config/BetterDiscord/data/stable/themes.json
	# Reemplaza la regla background-image en pywal.theme.css
	sed -i "s|background-image: url(.*)|background-image: url($upload)|g" ~/.cache/wal/pywal.theme.css
	# Copiar tema modificado
	cp ~/.cache/wal/pywal.theme.css ~/.config/BetterDiscord/themes/
	~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "color: $foreground" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "DISCORD RECARGADO"
}

NordLight() {
    bg="#ECEFF4"
    bgAlt="#E5E9F0"
    fg="#4C566A"
    sel="#88C0D0"
    act="#8FBCBB"
    urg="#D08770"
}

NordNight() { 
        bg="#434C5E"
        bgAlt="#4C566A" 
        fg="#ECEFF4"
        sel="#8FBCBB"
        act="#5E81AC"
        urg="#EBCB8B"
}

#----- Paletas de color de catppuccin: https://github.com/catppuccin/catppuccin#-palette -----#

CatppuccinLatte() {
	bg="#eff1f5"
	bgAlt="#e6e9ef"
	fg="#7c7f93"
	sel="#8839ef"
	act="#40a02b"
	urg="#dc8a78"
}
CatppuccinFrappe() {
	bg="#c6d0f5"
	bgAlt="#b5bfe2"
	fg="#949cbb"
	sel="#ca9ee6"
	act="#81c8be"
	urg="#e78284"
}
CatppuccinMacchiato() { 
        bg="#cad3f5"
        bgAlt="#b8c0e0" 
        fg="#8087a2"
        sel="#ed8796"
        act="#8aadf4"
        urg="#ed8796"
}
CatppuccinMocha() { 
	bg="#cdd6f4"
        bgAlt="#bac2de" 
        fg="#585b70"
	sel="#89b4fa"
        act="#fab387"
        urg="#f38ba8"
}



#--------------------------------- Menú con Rofi ------------------------------------#
# Si usas `prinft` en lugar de `echo` esto no funcionara
rofi_menu() {
    echo -e "WalDark\nWalLight\nNordLight\nNordNight\nCatppuccinLatte\nCatppuccinFrappe\nCatppuccinMacchiato\nCatppuccinMocha" | rofi -dmenu -i -theme "~/.config/rofi/scripts/config-select-colors-rofi.rasi"
}

### Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada
case "$1" in
    # 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
    "-h")
            help
            ;;

    # 2da condicion del bloque case, "" significa patron vacio, por lo que se ejecutara si simplemente se ejecuta el script sinun argumento!
    "")
        # Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "color"
        color=$(rofi_menu)
	# Este bloque if verifica si la variable color esta vacia. Si no esta vacia (o sea el usuario selecciono un color) se llama a la función correspondiente y se genera el colors.rasi
        if [ -n "$color" ]; then
            # Ahora la variable color debe contener el nombre de la funcion seleccionada por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA FUNCION SIN DARSE CUENTA!!!)
            $color
            echo "
            * {
            background:     $bg;
            background-alt: $bgAlt;
            foreground:     $fg;
            selected:       $sel;
            active:         $act;
            urgent:         $urg;   
            }
            " | tee ~/.config/rofi/scripts/colors.rasi /usr/share/iwdrofimenu/res/colors.rasi > /dev/null
	    ~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "color: $foreground" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "ROFI RECARGADO"
	fi


        ;;
    # 3ra condicion del bloque case. Solo esta por si en lugar de correr el script y ver el rofi prefieres ponerle directamente un argumento
    *)
        $1
        echo "
        * {
        background:     $bg;
        background-alt: $bgAlt;
        foreground:     $fg;
        selected:       $sel;
        active:         $act;
        urgent:         $urg;
        }
        " | tee ~/.config/rofi/scripts/colors.rasi /usr/share/iwdrofimenu/res/colors.rasi > /dev/null
	~/.config/bspwm/scripts/pop_report -d 1000 -o "background-color: $background" "color: $foreground" "border: 5px solid $color1" "font-family: 'Hack Nerd Font'" -m "ROFI RECARGADO"
	;;
esac
