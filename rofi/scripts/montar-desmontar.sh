#!/bin/bash

# Revisamos con `lsblk` los dispositivos de bloque montados, exceptuando discos y particiones de discos, esto lo logramos con `grep`
# Como los USB suelen montatse como sda, no lo exclui con grep -v
# No uso en $montados y $no_montados directamente `wc -w` para que las variables antes mencionadas puedan mostrar su ruta y su tamano
montados=$(lsblk -p -r -o "name,type,size,mountpoint" | grep -v -E '(nvme0n1)' | awk '$2=="part"&&$4!=""{printf "%s (%s)\t  ",$1,$3}')

no_montados=$(lsblk -p -r -o "name,type,size,mountpoint" | grep -v -E '(nvme0n1)' | awk '$2=="part"&&$4==""{printf "%s (%s)\t  ",$1,$3}')

# La unica diferencia en los 2 comandos anteriores es:
# El 1ro usa awk para seleccionar las lineas donde el 2do campo (type) es ‘part’ y el 4to campo (mountpoint) ESTA VACIO
# En cambio. el 2do usa awk para seleccionar las lineas donde el 2do campo (type) es ‘part’ y el 4to campo (mountpoint) NO ESTA VACIO 

revisar_numero_de_dispositivos_montados() {
	# Si $montados imprime mas de una palabra (contadas por wc) entonces muestra una notificacion de cuantos dispositivos estan montados actualmente
	if [ $(echo "$montados" | wc -w) -gt 0 ]; then
		dunstify -t 4000 -i ~/.config/dunst/icons/apps/power02.png "Dispositivos montados: $(echo "$montados" | wc -w)"
	else 
		dunstify -t 4000 -i ~/.config/dunst/icons/apps/power02.png "Dispositivos montados: $(echo "$montados" | wc -w)"
	fi
}

montar() {
	# Obvio muestro los no montados, para montarlos
	# awk '{print $1}': imprimir el primer campo de CADA linea
	aMontar=$(echo "$no_montados" | rofi -dmenu -i -theme "~/.config/rofi/scripts/config-montar-desmontar.rasi" | awk '{print $1}')
	# usamos para montar udisksctl
	# la salida de udisksctl es el punto de montaje del dispositivo, por eso lo asigno a $punto
	# udisksctl selecciona automaticamente un punto de montaje
	punto=$(udisksctl mount --no-user-interaction -b "$aMontar" 2>/dev/null) && dunstify -t 4000 -i ~/.config/dunst/icons/apps/asa01.png "$aMontar montado en $punto" && exit 0
}

#desmonatr() {
#
#}


case "$1" in
	-c)
		revisar_numero_de_dispositivos_montados
		;;
	-m)
		# Obvio que he de montar los no montados xd
		if [ $(echo "$no_montados" | wc -w) -gt 0 ]; then
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
			montar
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel02.png "Dispositivo montado!"
		else
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel00.png "Dispositivo no detectado!"	
		fi
		;;
	-u)
		if [ $(echo $montados| wc -w) -gt 0 ]; then
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
			desmontar
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel03.png "Dispositivo desmontado!"
		else
			dunstify -t 4000 -i ~/.config/dunst/icons/apps/angel04.png "Dispositivo no detectado!"
		fi
		;;
esac
