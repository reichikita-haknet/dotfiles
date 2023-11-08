#!/bin/sh

# Usar variables de color actualizadas
. "${HOME}/.config/polybar/scripts/color-htb.sh"

# Obtener la interfaz
IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')

# Comprobar la interfaz y cambiar el color de fondo según el estado
if [ "$IFACE" = "tun0" ]; then
	echo -e "%{B$backgroundAlt}%{F$green}%{F$foreground}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{F-}"
else
	echo -e "%{B$backgroundAlt}%{F$selected}%{F$foreground} Desconectado%{F-}"
fi
