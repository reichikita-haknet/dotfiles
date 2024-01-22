#!/bin/sh

# Usar variables de color actualizadas
. "${HOME}/.cache/wal/colors.sh"

# Obtener la interfaz
IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')

# Comprobar la interfaz y cambiar el color de fondo según el estado
if [ "$IFACE" = "tun0" ]; then
	echo -e " $(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{F-} "
else
	echo -e "Desconectado"
fi
