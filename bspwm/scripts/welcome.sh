#!/bin/bash
#------- Como hago el efecto de animacion de ampliar la ventana hacia los lados? -------#
# Usamos los 4 bucles for en este script al ajustar el tamaño de las ventanas de terminal. 
# En cada iteración del bucle, se cambia el tamaño de la ventana un poco y luego se hace una pausa antes de la siguiente iteración. 
# Este proceso crea la ilusión de que la ventana está cambiando de tamaño gradualmente, como si estuviera animada.
#----------------------------------------------------------------------------------------#

# USO: kitty -e bash welcome.sh

# Espera medio segundo para dar tiempo a que se abra la ventana del terminal.
sleep 0.5

# Se repetira lo de reducir el tamano 5 veces!, ajustalo si es necesario, lo mismo con los demas buicles for
for i in {1..15}
do
  # Aumenta el tamaño de la ventana en 4 píxeles hacia abajo.
  bspc node -z bottom 0 4
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

for i in {1..15}
do
  # Aumenta el tamaño de la ventana en 5 píxeles hacia arriba.
  bspc node -z top 0 -5
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

for i in {1..40}
do
  # Aumenta el tamaño de la ventana en 10 píxeles hacia la izquierda.
  bspc node -z left -10 0
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

for i in {1..40}
do
  # Aumenta el tamaño de la ventana en 10 píxeles hacia la derecha.
  bspc node -z right 10 0
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done


#------------- Ejecuta el primer comando deseado --------------#
sleep 0.5
echo -e "\nUn gusto verte\n$(whoami)!" | figlet -f 3d -c -t -k | lolcat -a -d 2
sleep 1
clear

#--------------------------------------------------------------#


#------------- Ejecuta el segundo comando deseado -------------#
for i in {1..15}
do
  # Aumenta el tamaño de la ventana en 4 píxeles hacia abajo.
  bspc node -z bottom 0 2
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

for i in {1..40}
do
  # Reduce el tamaño de la ventana en 3 píxeles hacia la izquierda.
  bspc node -z left 3 0
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

for i in {1..40}
do
  # Reduce el tamaño de la ventana en 3 píxeles hacia la derecha.
  bspc node -z right -3 0
  # Pausa durante 0.01 segundos antes de la siguiente iteración.
  sleep 0.01
done

sleep 0.5
~/.config/bspwm/scripts/banners/denis.sh
# Como no surtia efecto el eliminar la regla para kitty antes puesta mejor use otra :)
bspc rule -a kitty state=tiled
sleep 2
exit
