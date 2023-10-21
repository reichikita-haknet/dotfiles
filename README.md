# dotfiles
BspWM

# Instalacion de controladores de NVIDIA
Sol sigue los 6 primeros pasos en la seccion Instalación de esta guia (lo de mas no me fue necesario hasta el momento): https://wiki.archlinux.org/title/NVIDIA


# Controladores de ajustes del sistema
#### Conexion Wifi
1. No necesitas instalar `wpa_supplicant` y `networkmanager` para usar `iwd` en Arch Linux. `iwd` es un demonio de red independiente que puede manejar la funcionalidad proporcionada por estos dos paquetes:
```
sudo pacman -S iwd
```

2. Para utilizar iwd (iNet wireless daemon), un demonio para administrar las conexiones de red inalámbricas, generalmente necesitarás permisos de superusuario. Esto se debe a que la gestión de las conexiones de red es una operación que puede afectar a todo el sistema. Sin embargo para el siguiente script de control de wifi es imperativo que no necesites de `sudo` para ejecutar `iwd` porque vamos a usarlo con `sxhkd`, por lo que debes agregar tu usuario al grupo `wheel` ya que solo los usuarios de ese grupo pueden interactuar con `iwd`:
```
sudo usermod -a -G wheel usuario
```

3. Para que surta efecto el cambio de paleta de color deberas primero crear un archivo `color.rasi` y cambiar su propiedad a tu usuario:
```
sudo touch colors.rasi; sudo chown usuario colors.rasi
```


https://github.com/defname/rofi-iwd-wifi-menu

#### Conexion bluetooth
1. Para utilizar el script antes que nada debes activar el servicio bluetooth:
```
sudo systemctl enable bluetooth.service
```
2. Inicia el servicio Bluetooth:
```
sudo systemctl start bluetooth
```


**Si te pasa como a mi que se dificulta conectar el teclado intenta usar `bluetoothctl` y en esa consola haz lo siguiente:**


1. Activa el agente y establece como predeterminado: 
```
agent on
default-agent
```
2. Escanea dispositivos cercanos: Ahora puedes escanear dispositivos Bluetooth cercanos.
```
scan on
```
3. Empareja tu dispositivo: Una vez que veas tu dispositivo en la lista, puedes emparejarlo usando su dirección MAC. Recuerda reemplazar <MAC_ADDRESS> con la dirección MAC de tu dispositivo.
```
pair <MAC_ADDRESS>
```
4. Confirma el emparejamiento: Si todo va bien, se te pedirá que confirmes el emparejamiento en tu dispositivo.

5. Conéctate a tu dispositivo: Una vez emparejado, puedes conectarte a tu dispositivo usando el comando connect.
```
connect <MAC_ADDRESS>
```
6. Confía en el dispositivo: Para que tu dispositivo se conecte automáticamente en el futuro, puedes usar el comando trust.
```
trust <MAC_ADDRESS>
``` 
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

# Errores comunes
##### Pulseaudio
A veces se para el demonio `pulseaudio`, para solucionarlo solo reinicialo

1. Verifica si alguna instancia de PulseAudio está en ejecución: `pulseaudio --check`. Normalmente no imprime nada, solo el código de salida. 0 significa que está en ejecución¹.
2. Si alguna instancia está en ejecución, mátala: `pulseaudio -k`¹.
3. Finalmente, inicia PulseAudio nuevamente como un demonio: `pulseaudio -D`¹.

Alternativamente, puedes usar systemctl para reiniciar PulseAudio:

1. Reinicia el servicio PulseAudio: `systemctl --user restart pulseaudio.service`¹.
2. También puedes reiniciar el socket PulseAudio: `systemctl --user restart pulseaudio.socket`¹.
