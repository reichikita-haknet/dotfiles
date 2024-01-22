#!/bin/bash

# Define una regla para que las nuevas ventanas de kitty aparezcan en un estado flotante, centradas y con un tamaño específico.
bspc rule -a kitty state=floating center=true rectangle=600x400+0+0
# mktemp -d crea un directorio temporal
temp_dir=$(mktemp -d)
terminal=$(kitty -e ranger --choosefile="$temp_dir/fondo_feh.txt")
fondo_de_pantalla_feh=$(cat "$temp_dir/fondo_feh.txt")
feh --bg-fill $fondo_de_pantalla_feh
bspc rule -a kitty state=tiled
