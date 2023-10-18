# dotfiles
BspWM

# Sistema
### Controles
##### Control de brillo
Una alternativa para evitar tener que ejecutar `light` con `sudo` es cambiar los permisos del archivo de dispositivo que `light` utiliza para ajustar el brillo. Esto se puede hacer con una regla `udev`.

Aquí tienes un ejemplo de cómo podrías hacerlo:

1. Crea un archivo llamado `90-backlight.rules` en el directorio `/etc/udev/rules.d/` con el siguiente contenido:

```bash
# /etc/udev/rules.d/90-backlight.rules
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

2. Asegúrate de que tu usuario esté en el grupo `video`. Puedes hacerlo con el siguiente comando:

```bash
sudo usermod -a -G video tu_usuario
```

Reemplaza `tu_usuario` con tu nombre de usuario.

3. Reinicia tu sistema para que los cambios surtan efecto¹².

Esto permitirá a cualquier usuario en el grupo `video` ajustar el brillo sin necesidad de `sudo`. Ahora deberías poder usar `light` en tu configuración de `sxhkd` sin problemas.

Por favor, ten en cuenta que este método requiere privilegios de administrador y debe ser utilizado con cuidado. Si no estás seguro de lo que estás haciendo, te recomiendo que busques más información o que pidas ayuda a alguien con más experiencia en la administración de sistemas Linux.

### Paletas de colores
##### Nord
https://www.nordtheme.com/docs/colors-and-palettes

##### Figlet
https://github.com/xero/figlet-fonts
sudo cp Descargas/figlet-fonts/3d.flf /usr/share/figlet/fonts/
