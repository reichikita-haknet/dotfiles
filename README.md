# dotfiles
BspWM

# Sistema
### Controles
##### Control de brillo
Una alternativa para evitar tener que ejecutar `light` con `sudo` es cambiar los permisos del archivo de dispositivo que `light` utiliza para ajustar el brillo. Esto se puede hacer con una regla `udev`.

1. Crea un archivo llamado `90-backlight.rules` en el directorio `/etc/udev/rules.d/` con el siguiente contenido (no olvides editar el grupo al que quieres que pertenezca el permiso):

```
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp GRUPO /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

2. Asegúrate de que tu usuario esté en el grupo que configuraste antes. Puedes hacerlo con el siguiente comando:

```
sudo usermod -a -G GRUPO usuario
```

Reemplaza `tu_usuario` con tu nombre de usuario.

3. Reinicia tu sistema para que los cambios surtan efecto.

Esto permitirá a cualquier usuario en el grupo `video` ajustar el brillo sin necesidad de `sudo`. Ahora deberías poder usar `light` en tu configuración de `sxhkd` sin problemas.

### Paletas de colores
##### Nord
https://www.nordtheme.com/docs/colors-and-palettes

##### Figlet
https://github.com/xero/figlet-fonts
sudo cp Descargas/figlet-fonts/3d.flf /usr/share/figlet/fonts/
