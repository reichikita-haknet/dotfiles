## Capturas de pantalla
<details>
  <summary>Arch Linux con XServer, bspwm y polybar</summary>
  <img src="" alt="GRUB">
  <img src="" alt="Monitor principal">
  <img src="" alt="Monitor secundario">
</details>

# Instalacion de controladores de NVIDIA y soporte para Asus en Arch Linux

```
sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

sudo pacman-key --finger 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

wget "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x8b15a6b0e9a3fa35" -O g14.sec

sudo pacman-key -a g14.sec

sudo vim /etc/pacman.conf

sudo pacman -Suy

sudo pacman -S asusctl

systemctl enable --now power-profiles-daemon.service

sudo pacman -S supergfxctl rog-control-center

systemctl enable --now supergfxd

sudo pacman -Sy linux-g14 linux-g14-headers

sudo pacman -S nvidia-dkms
```
Fuente: https://asus-linux.org/wiki/arch-guide/

Ahora simplemente sigue el paso 5 y 6 primeros de la seccion "Instalación" de la siguiente guia (los demas pasos no me fueron necesarios hasta el momento): https://wiki.archlinux.org/title/NVIDIA

Finalmente ejecuta **como usuario root** el lanzador de aplicaciones (super + shit + space) el programa rog-control-center para realizar tus ajustes. Puedes revisar tus ajustes en `/etc/asusd/asusd.ron`.

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

#### Configuracion de mas de un monitor
Para que no tengas que perder el tiempo ajustando con `xrandr` y `bscp monitor` cada que conectes mas de un monitor hice un script en bash en `~/.config/polybar/scripts/launch.sh` que basicamente hace dos cosas:
   1. Guarda en la variable `pri` el nombre del monitor principal y en la variable `sec` el nombre del monitor secundario
   2. Hago uso de un `bloque if` para que si se detecta como conectado solamente al monitor principal, `bspwm` asigne todos los espacios de trabajo a este. Y por otro lado si se detecta como conectado al monitor principal y al monitor secundario, `bspwm` asigne 5 espacios de trabajo para cada uno.

| :warning: Nota |
|-----------------------|
| 1. Deberas recargar dos veces `bspwm` cada que conectes y desconectes un monitor secundario.<br/> 2. Si durante la sesion actual de `bspwm` se ha conectado mas de un monitor pero luego lo desconectas para usar solo el monitor principal, se usara `bspc monitor $sec -r` para remover el monitor secundario antes configurado y asi no habra inconvenientes a la hora de asignar todos los espacios de trabajo al monitor principal.|

# Paletas de colores
##### Nord
https://www.nordtheme.com/docs/colors-and-palettes

##### Figlet
https://github.com/xero/figlet-fonts

```
sudo cp Descargas/figlet-fonts/3d.flf /usr/share/figlet/fonts/
```

# Compositor
```
sudo pacman -S picom
```

```
cp picom.conf ~/.config/
```

# GRUB
Antes que nada realiza una vista previa del tema para GRUB, incluso si es otro tema el que te gustaria usar te recomiendo usar la siguiiente utilidad para no tener que reinciar a cada rato tu PC para mas de revisar tu tema de GRUB, sobre todo si como a mi te gusta hacer modificaciones personales: https://github.com/hartwork/grub2-theme-preview

Aqui como instalar la utilidad antes mencionada:

```diff
pipx install grub2-theme-preview

+sudo pacman -S qemu qemu-full ovmf mtools xorriso
```
Nota: El paquete `qemu-full` en Arch Linux incluye soporte para GUI.

# Consideraciones generales
Si como a mi te pasa que no puedes usar pip para instalar dependencias, la razon es que Python está siendo administrado externamente, probablemente por el administrador de paquetes de Arch Linux, pacman.Entonces simplemente:

1. Para instalar paquetes de Python a nivel del sistema, puedes usar `sudo pacman -S python-xyz`, donde `xyz` es el paquete que intentas instalar.

2. Para instalar un paquete de Python que no está empaquetado por Arch, puedes crear un entorno virtual usando `python -m venv path/to/venv`. Luego puedes usar `path/to/venv/bin/python` y `path/to/venv/bin/pip` para instalar paquetes en ese entorno virtual.

3. Si deseas instalar una aplicación de Python que no está empaquetada por Arch, puedes usar `pipx install xyz`, que administrará un entorno virtual para ti. Asegúrate de tener el paquete `python-pipx` instalado a través de pacman.

# Utilidades
##### Applio
Debido a que la versión mas reciente de Python no es compatible con las versiones de `torch` y `torchcrepe`, te veras en la obligacion de instalar una version de python que si lo sea, en este caso `Python3.10`
```
yay -S python310
```

Ahora `pip` seguramente no está asociado con la versión correcta de Python, puedes usar el módulo ensurepip para instalarlo:
```
python3.10 -m ensurepip
```
Ahora instalamos los modulos de Python necesarios para ejecutar `Applio`:
```
python310 -m pip install -r Applio-RVC-Fork/assets/requirements/requirements.txt
```

| :warning: Nota |
|-----------------------|
| Edita el archivo `install.sh` y go-applio.sh` cambiando todas las coincidencias de `python` por `python3.10` (en la opcion que vayas a usar basta, en mi caso la opcion para usar Nvidia) |

```
./install.sh
```

Para ejcutarlo en Linux simplemente usa:
```
./go-applio.sh
```

# Aplicaciones 
##### Discord 
```
sudo pacman -S discord
```

Mostrar los emojis en los canales de discord:
```
sudo pacman -S noto-fonts-emoji
```
Después de instalar la fuente, es posible que necesites reiniciar las aplicaciones para que puedan detectar y usar la nueva fuente

# Errores comunes
##### Pulseaudio
A veces se para el demonio `pulseaudio`, para solucionarlo solo reinicialo

1. Verifica si alguna instancia de PulseAudio está en ejecución: `pulseaudio --check`. Normalmente no imprime nada, solo el código de salida. 0 significa que está en ejecución.
2. Si alguna instancia está en ejecución, mátala: `pulseaudio -k`.
3. Finalmente, inicia PulseAudio nuevamente como un demonio: `pulseaudio -D`.

Alternativamente, puedes usar systemctl para reiniciar PulseAudio:

1. Reinicia el servicio PulseAudio: `systemctl --user restart pulseaudio.service`.
2. También puedes reiniciar el socket PulseAudio: `systemctl --user restart pulseaudio.socket`.
