# dotfiles
BspWM

# Ajustes del sistema
#### Conexion Wifi
No necesitas instalar `wpa_supplicant` y `networkmanager` para usar `iwd` en Arch Linux. `iwd` es un demonio de red independiente que puede manejar la funcionalidad proporcionada por estos dos paquetes.

Para utilizar iwd (iNet wireless daemon), un demonio para administrar las conexiones de red inalámbricas, generalmente necesitarás permisos de superusuario. Esto se debe a que la gestión de las conexiones de red es una operación que puede afectar a todo el sistema.

https://github.com/defname/rofi-iwd-wifi-menu

#### Control de brillo
##### Ajustes previos para que funcione el script `~/.config/bspwm/scripts/bl`
Para evitar tener que ejecutar `light` con `sudo` es cambiar los permisos del archivo de dispositivo que `light` utiliza para ajustar el brillo. Esto se puede hacer con una regla `udev`.

1. Crea un archivo llamado `90-backlight.rules` en el directorio `/etc/udev/rules.d/` con el siguiente contenido (no olvides que el grupo por defecto para `/sys/class/backlight/%k/brightness` es `video`):

```
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

2. Agrega tu usuario al grupo `video`
```
sudo usermod -a -G video usuario
```

3. Asegúrate de que tu usuario esté en el grupo que configuraste antes. Puedes hacerlo con el siguiente comando:

```
groups usuario
```

3. Reinicia tu sistema para que los cambios surtan efecto.

Esto permitirá a cualquier usuario en el grupo `video` ajustar el brillo sin necesidad de `sudo`. Ahora deberías poder usar `light` en tu configuración de `sxhkd` sin problemas.

### Paletas de colores
##### Nord
https://www.nordtheme.com/docs/colors-and-palettes

##### Figlet
https://github.com/xero/figlet-fonts
```
sudo cp Descargas/figlet-fonts/3d.flf /usr/share/figlet/fonts/
```
