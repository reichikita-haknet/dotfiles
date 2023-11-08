#!/bin/bash

# Si 'polybar' está en ejecución, lo mata
if [ -n "$(pgrep -x polybar)" ]; then
    pkill -KILL polybar
fi

# Espera un segundo para que 'polybar' termine completamente
sleep 1

# Si 'polybar' no está en ejecución, inicia dos instancias de 'polybar'
if [ -z "$(pgrep -x polybar)" ]; then
	polybar barup &
	polybar bardown &
fi
