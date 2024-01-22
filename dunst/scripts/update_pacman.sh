#!/bin/bash

username=$(whoami)
updates=$(sleep 10;checkupdates | wc -l)
minutes=$(uptime | awk '{print $3}')
timeunit=$(uptime | awk '{print $4}' | cut -c '1-3')

if [ "$updates" -eq 0 ]; then
	dunstify -a "Sistema" "Pacman" "Todos los paquetes actualizados" -i ~/.config/dunst/icons/apps/makima00.png
else
	dunstify -a "Sistema" "Pacman" "Actualizaciones disponibles: $updates" -i ~/.config/dunst/icons/apps/makima01.png
fi

#------- NIVEL DE BATERIA -------#

# Este parte del script comprueba el nivel de batería cada 10 minutos y muestra una notificación si está por debajo del 20%

while true; do
	# Obtenemos el nivel de batería actual
	nivel=$(acpi -b | grep -P -o '[0-9]+(?=%)')
	# Si el nivel es menor o igual que 20, mostramos una notificación con dunst
	if [ $nivel -le 20 ]; then
		notify-send -a "Sistema" -u critical -t 0 "Batería baja" "Conecta el cargador cuanto antes"
	fi
	# Esperamos 10 minutos antes de volver a comprobar
	sleep 10m
done
