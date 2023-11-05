#!/bin/bash

# Inicializa la variable de estado de pantalla completa
pantalla_completa=0

while true; do
	# Obtiene el ID de la ventana activa
	active_window_id=$(xdotool getactivewindow)

	# Obtiene el estado de la ventana activa
	window_state=$(xprop -id $active_window_id | grep _NET_WM_STATE)

	# Verifica si la ventana está en pantalla completa
	if [[ $window_state == *"_NET_WM_STATE_FULLSCREEN"* ]]; then
		# Si la ventana acaba de entrar en pantalla completa, es decir, la variable es igual a 0, muestra la notificación, y despues de hacerlo asigno el valor de 1 a la varible para evitar que se ejecute este condicional que contiene la notificacion con dunst mientras siguas en modo de pantalla completa
		if [[ $pantalla_completa -eq 0 ]]; then
			dunstify -t 3000 "La ventana está en pantalla completa" -i ~/.config/dunst/icons/apps/yoru00.png
			pantalla_completa=1
		fi
	else
		# Si la ventana acaba de salir de pantalla completa (por eso esta en else), restablece la variable de estado, asi incluso si es la misma ventan este proceso se reinicia
		if [[ $pantalla_completa -eq 1 ]]; then
			pantalla_completa=0
        	fi
	fi

	# Espera antes de la próxima verificación
	sleep 1
done
