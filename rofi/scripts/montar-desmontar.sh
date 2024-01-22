#!/bin/bash

help() {
	cat <<- EOF
Corre este script para montar o desmontar un dispositivo extraible como por ejemplo una USB.

opciones:
	-h Mostrar este menu de ayuda
	-c Revisar el numero de dispositivos extraibles montados actualmente
	-m Montar dispositivo extraible
	-u Desmontar dispositivo extraible
EOF
}


confirmacion() {
        echo -e " Si\n No" | rofi -dmenu -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px; height: 170px;} mainbox {children: [ "message", "listview" ];} listview {columns: 1; lines: 1;} element-text {horizontal-align: 0.5;} textbox {horizontal-align: 0.5;}' -mesg 'Abrir punto de montaje con ranger?' -theme ~/.config/rofi/scripts/config-powermenu.rasi
}

abrirRanger() {
        eleccion=$(confirmacion)
        if [[ "$eleccion" == " Si" ]]; then
		bspc rule -a kitty state=floating center=true rectangle=700x600+0+0
                kitty -e ranger "$puntoM"
		bspc rule -a kitty state=tiled
        elif [[ "$eleccion" == " No" ]]; then
                exit 0
        else
                dunstify -a Sistema -i ~/.config/dunst/icons/apps/quanxi00.png "Opcion invalida!"
        fi
}

# Revisamos con `lsblk` los dispositivos de bloque montados, exceptuando discos y particiones de discos, esto lo logramos con `grep`
# Como los USB suelen montarse como `sda`, no lo exclui con `grep -v`
# No uso en $montados y $no_montados directamente `wc -w` para que las variables antes mencionadas puedan mostrar su ruta y su tamano

montados=$(lsblk -p -r -o "name,type,size,mountpoint" | grep -v -E '(nvme0n1)' | awk '$2=="part"&&$4!=""{printf "%s (%s)\t  ",$1,$3}')

no_montados=$(lsblk -p -r -o "name,type,size,mountpoint" | grep -v -E '(nvme0n1)' | awk '$2=="part"&&$4==""{printf "%s (%s)\t  ",$1,$3}')

# La unica diferencia en los 2 comandos anteriores es:
# El 1ro usa awk para seleccionar las lineas donde el 2do campo (type) es ‘part’ y el 4to campo (mountpoint) ESTA VACIO
# En cambio, el 2do usa `awk` para seleccionar las lineas donde el 2do campo (type) es ‘part’ y el 4to campo (mountpoint) NO ESTA VACIO 

NumeroDeDispositivosMontados() {
	# Si $montados imprime mas de una palabra (contadas por `wc`) entonces muestra una notificacion de cuantos dispositivos estan montados actualmente
	if [ $(echo "$montados" | wc -w) -gt 0 ]; then
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/power02.png "Dispositivos montados: $(echo "$montados" | awk '{print $1}' | wc -w)"
	else 
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/power02.png "Dispositivos montados: $(echo "$montados" | wc -w)"
	fi
}

MontarDispositivo() {
	if [ $(echo "$no_montados" | wc -w) -gt 0 ]; then
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
		# Obvio muestro los no montados, para montarlos
		# awk '{print $1}': imprimir el primer campo de CADA linea
		aMontar=$(echo "$no_montados" | rofi -dmenu -theme "~/.config/rofi/scripts/config-montar-desmontar.rasi" | awk '{print $1}')
		if [[ -n "$aMontar" ]]; then
			# Usamos para montar `udisksctl`
			# La salida de `udisksctl` es el punto de montaje del dispositivo, por eso lo asigno a $punto
			# `udisksctl` selecciona automaticamente un punto de montaje
			# En `sed` el argumento `s/.*at //` le dice que reemplace todo lo que coincide con .*at  (cualquier cosa seguida de at ) con una cadena vacía
			# sed 's/ /\\ /g': simplemente le dice que reemplace los espacios por una barra invertida. Una barra invertida en `sed` se escribe como `\\`, por que?, porque con `\` es un caracter especial para escapar otros caracteres especiales (como `\` mismo), entonces le decimos a `sed` que estamos escapando lo que le siga, es decir, que lo interprete de forma literal
			puntoM=$(udisksctl mount --no-user-interaction -b "$aMontar" 2>/dev/null | sed 's/.*at //')
			puntoDunst=$(echo -n $puntoM | sed 's/ /\\ /g')
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/asa01.png "$aMontar montado en $puntoDunst"
			# Copiamos con xclip (SOLO PARA X11) el punto de montaje que devuelve `udisksctl`
			# El argumento -n evita que se añada un salto de línea al final del valor. El argumento -selection clipboard especifica que se use el portapapeles principal, al que se puede acceder con CTRL+V. Si quieres usar el portapapeles secundario, al que se puede acceder con Shift+Insert, puedes omitir ese argumento o usar -selection primary
			# sed 's/ /\\ /g': simplemente le dice que reemplace los espacios por una barra invertida. Una barra invertida en `sed` se escribe como `\\`, por que?, porque con `\` es un caracter especial para escapar otros caracteres especiales (como `\` mismo), entonces le decimos a `sed` que estamos escapando lo que le siga, es decir, que lo interprete de forma literal
			echo -n $puntoDunst | xclip -selection clipboard
			dunstify -a Sistema -t 7000 -i ~/.config/dunst/icons/apps/angel02.png "Punto de montaje copiado al portapapeles!"
			abrirRanger
		else 
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/asa00.png "Dispositivo no seleccionado!"

		fi
	else 
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/quanxi00.png "Dispositivo no detectado como desmontado!"
	fi
}

DesmontarDispositivo() {
	if [ $(echo "$montados" | wc -w) -gt 0 ]; then
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
		# Obvio muestro los montados, para desmontarlos
		# awk '{print $1}': imprimir el primer campo de CADA linea
		aDesmontar=$(echo $montados | rofi -dmenu -theme "~/.config/rofi/scripts/config-montar-desmontar.rasi" | awk '{print $1}')
		if [[ -n "$aDesmontar" ]]; then
			# Usamos para desmontar `udisksctl`
			puntoD=$(udisksctl unmount --no-user-interaction -b "$aDesmontar" 2>/dev/null | awk '{print $4}') && dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel03.png "Dispositivo $puntoD desmontado!"
		else
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/asa00.png "Dispositivo no seleccionado!"
		fi
	else 
		dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/quanxi00.png "Dispositivo no detectado como montado!"
	fi
}


#--------------------------------- Menú con Rofi ------------------------------------#
# Si usas `prinft` en lugar de `echo` esto no funcionara
rofi_menu(){
	echo -e "NumeroDeDispositivosMontados\nMontarDispositivo\nDesmontarDispositivo" | rofi -dmenu -theme "~/.config/rofi/scripts/config-montar-desmontar.rasi"
}

### Bloque case que verifica el primer argumento para este script, si no se proporciona un argumento (o sea un $1) no hace nada
case "$1" in
	 # 1ra condicion del bloque case. Solo sirve para verificar si el argumento que pase el usuario es -h, si es asi se usa la funcion help
	"-h")
		help
		;;
	# 2da condicion del bloque case
	"")
		# Llama a la funcion rofi_menu y guarda el nombre de la funcion elegida por el usuario en la variable "eleccion"
		eleccion=$(rofi_menu)
		# Este bloque if verifica si la variable eleccion esta vacia. Si no esta vacia (o sea el usuario selecciono una opcion) se llama a la función correspondiente
		if [ -n "$eleccion" ]; then
			# Ahora la variable eleccion debe contener el nombre de la funcion seleccionada por el usuario en rofi_menu para ejecutarla (ME AHORRO EL ESCRIBIR DIFERENTES OPCIONES Y EN CADA OPCION ESCRIBIR UNA VARIABLE DIFERENTE, SIMPLEMENTE EL USUARIO MISMO EJECUTA LA FUNCION SIN DARSE CUENTA!!!)
			$eleccion
		else
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/caida01.png "Opcion no valida!"
		fi

		;;
	# Las siguientes condiciones solo estan por si el usuario prefiere no usar rofi
	"-c")
		NumeroDeDispositivosMontados
		;;
	"-m")
		# Obvio que he de montar los no montados xd
		if [ $(echo "$no_montados" | wc -w) -gt 0 ]; then
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
			MontarDispositivo
		else
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel00.png "Dispositivo no detectado!"	
		fi
		;;
	"-u")
		if [ $(echo $montados| wc -w) -gt 0 ]; then
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel01.png "Dispositivo detectado"
			DesmontarDispositivo
		else
			dunstify -a Sistema -t 4000 -i ~/.config/dunst/icons/apps/angel04.png "Dispositivo no detectado!"
		fi
		;;
esac
