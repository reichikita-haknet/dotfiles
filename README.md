## Capturas de pantalla
<details>
  <summary>Arch Linux con XServer, bspwm y polybar</summary>
  <img src="" alt="GRUB">
  <img src="" alt="Monitor principal">
  <img src="" alt="Monitor secundario">
</details>


# Fondos de pantalla
Puedes ver y descargar mi carpeta `Fondos_de_pantalla` que uso por ejemplo en mi configuracion con rofi y feh desde mi nube de OneDrive: [Ir a la carpeta](https://keug-my.sharepoint.com/:f:/g/personal/tony_haknet_keug_onmicrosoft_com/El1aVaEI0yFGsr6SPTxl1jwB1aAVhspu0i24MGC3ilEU6Q?e=RSsme4)

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

Nota: Los paquetes `supergfxctl` y `nvidia-utils` contienen un archivo que incluye en la lista negra el módulo `nouveau`:
![2023-11-09_145855_625763821](https://github.com/reichikita-haknet/dotfiles/assets/147787974/d8955438-d198-4ef9-aee8-615e948b391f)



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

3. Para utilizar `bluetoothctl` debes instalar:
```
sudo pacman -S bluez
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
| 1. Deberas recargar dos veces `bspwm` cada que conectes y desconectes un monitor secundario.<br/> 2. Si durante la sesion actual de `bspwm` se ha conectado mas de un monitor pero luego lo desconectas para usar solo el monitor principal, se usara `bspc monitor $sec -r` para remover el monitor secundario antes configurado y asi no habra inconvenientes a la hora de asignar y ordenar todos los espacios de trabajo al monitor principal.|

# Pywal

## Feh
Bueno basicamente en mis configuraciones hago que el fondo no sea defino por wal (bandera -n) entonces lo hago con Feh!, para que cada que inicies sesion cargues tu ultimo fondo de pantalla usado con feh agrega a `.xinitrc` lo siguiente:
```
~/.fehbg &
```
Nota: Necesariamente antes de `exec`

## Pywal para Discord
Antes que nada deberas instalar [BetterDiscord](https://github.com/BetterDiscord/BetterDiscord), puedes hacerlo con su instalador automatico de su pagina web oficial. BetterDiscord basicamente se instala sobre tu instalacion de Discord para incluir nuevas funciones en la seccion "Ajustes de usuario" 

Puedes usar scripts commo `pywal-discord` o `wal-discord` para crear un tema en Discord usando los colores de Pywal.

También hay un tema `discord-wal` para un archivo de plantilla compatible con Vencord (especialmente notable para usuarios de Windows).

https://github.com/FilipLitwora/pywal-discord: `yay -S pywal-discord-git`

https://github.com/guglicap/wal-discord

https://github.com/Gremious/discord-wal-theme-template


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

## Vim
Para instalar Plugins primero debes instalar [Vundle](https://github.com/VundleVim/Vundle.vim), en el repositorio de github existen instrucciones.

[Plugin para vistas previas de colores en CSS](https://github.com/ap/vim-css-color)
## Dunst
### Configuracion
https://dunst-project.org/documentation/#Keyboard-shortcuts-X11-only

### dunstify
https://linuxcommandlibrary.com/man/dunstify

### dunstctl
https://man.archlinux.org/man/dunstctl.1.en

## Applio
Debido a que la versión mas reciente de Python no es compatible con las versiones de `torch` y `torchcrepe` y otras cosas no especificadas, te veras en la obligacion de instalar `Python3.9.8` pero como si lo hago puede romperse muchas dependencias del sistema es mucho mejor crear un entorno virtual con la version requerida de Python:

Para instalar específicamente Python 3.9.8 en un entorno virtual en Arch Linux, puedes seguir estos pasos:

1. Primero, debes asegurarte de tener instalado `pyenv:
```
sudo pacman -S pyenv
```

2. `pyenv` descarga un archivo porque es una herramienta de gestión de versiones de Python1. Cuando instalas una versión específica de Python con pyenv, lo que hace es descargar el archivo correspondiente a esa versión desde los repositorios oficiales de Python.
Una vez descargado, pyenv compila e instala esa versión de Python en un directorio específico dentro del directorio .pyenv en tu directorio personal1. De esta manera, puedes tener múltiples versiones de Python instaladas en tu sistema sin que interfieran entre sí. Puedes instalar Python 3.9.8:
```
pyenv install 3.9.8
```
Simplementa espera unos miutos a que haga todo en segundo plano, y se guardara automaticamente en `~/.pyenv/versions`

3. Después de instalar Python 3.9.8, puedes crear un nuevo entorno virtual con esa versión de Python usando `venv`, que es la herramienta estándar para crear entornos virtuales:
```bash
sudo pacman -S python-virtualenv
```

4. Ahora puedes crear un entorno virtual que use Python 3.9.8 con el siguiente comando:
```bash
virtualenv -p ~/.pyenv/versions/3.9.8/bin/python3.9 nombre_del_entorno
```
Reemplaza `nombre_del_entorno` con el nombre que desees para tu entorno virtual.

5. Para activar el entorno virtual, utiliza el siguiente comando:
```bash
source nombre_del_entorno/bin/activate
```
De nuevo, reemplaza `nombre_del_entorno` con el nombre de tu entorno virtual.

6. Ahora deberías estar en tu entorno virtual y cualquier paquete que instales con `pip` se instalará en este entorno, no en tu sistema global.

**Si deseas desinstalar** una version especifica de un modulo simplemente incluye `==` seguido de la versión del paquete que deseas desinstalar. Por ejemplo, si deseas desinstalar específicamente la versión 2.1.0 de `torch`, puedes usar el siguiente comando:
```
pip uninstall torch==2.1.0
```

| :warning: Nota |
|-----------------------|
| 1. No es necesario ejecutar `./install.sh` y no lo hagas o se instalara otra vez cada modulo... <br> 2. Recuerda que siempre debes activar el entorno virtual antes de usarlo y desactivarlo cuando hayas terminado. Puedes desactivar el entorno virtual con simplemente escribir `deactivate` en la terminal. <br/> 3. Si vas instalar con `pip install` en el entorno virtual modulo por modulo ten presente hacerlo con la version especificada en:`assets/requirements/requirements.txt` |

Intala especificamente estas versiones de los modulos (como lo pone en `install.sh`):
```
pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu117
```

Instala todos los demas modulos:
```
pip install -r assets/requirements/requirements.txt
```

Para ejcutarlo en Linux simplemente usa:
```
./go-applio.sh
```
O directamente si usas Nvidia como yo:
```

```

El archivo Makefile deberia contener en la parte de instalacion lo siguiente:
```
	sudo pacman -S --needed base-devel python ffmpeg
	pip install --upgrade setuptools wheel
	pip install --upgrade pip
	pip install faiss-gpu fairseq gradio ffmpeg ffmpeg-python praat-parselmouth pyworld numpy==1.23.5 numba==0.56.4 librosa==0.9.1
	pip install -r assets/requirements/requirements.txt
	pip install --upgrade lxml
	sudo pacman -Syu
	sudo pacman -S --needed aria2
```

##### Separar voz e instrumental de una cancion
Solo me dejo un intento: https://vocalremover.org/es/

# Aplicaciones 

### Drivers para impresora EPSON
En mi caso tengo una L4260, simplemente:
```
yay -S epson-inkjet-printer-escpr
```
https://wiki.archlinux.org/title/CUPS/Printer-specific_problems
### Activando el tema
1. Copia el archivo `custom.css` a `~/.config/Caprine`

2. En Caprine ve a `File`/`Caprine Settings`/`Advanced`/`Custom Styles`
   
## Discord 
```
sudo pacman -S discord
```

Mostrar los emojis en los canales de discord:
```
sudo pacman -S noto-fonts-emoji
```
Después de instalar la fuente, es posible que necesites reiniciar las aplicaciones para que puedan detectar y usar la nueva fuente

# Errores comunes
## rog-control-center
A veces al parecer `systemd` no carga correctamente el demonio `asusd` por lo que simplemente reinica el servicio:
```
systemctl restart asusd
```

## Pulseaudio
A veces se para el demonio `pulseaudio`, para solucionarlo solo reinicialo

1. Verifica si alguna instancia de PulseAudio está en ejecución: `pulseaudio --check`. Normalmente no imprime nada, solo el código de salida. 0 significa que está en ejecución.
2. Si alguna instancia está en ejecución, mátala: `pulseaudio -k`.
3. Finalmente, inicia PulseAudio nuevamente como un demonio: `pulseaudio -D`.

Alternativamente, puedes usar systemctl para reiniciar PulseAudio:

1. Reinicia el servicio PulseAudio: `systemctl --user restart pulseaudio.service`.
2. También puedes reiniciar el socket PulseAudio: `systemctl --user restart pulseaudio.socket`.

# Ranger
Si se jode la vista previa de imagenes apesar de haberla configurado en el `rc.conf`, probablemente quieras simplemente usar: 
```
sudo pacman -S python-pillow

python -c "from PIL import Image"`
```
# Datitos utiles
## Eliminar kernel en desuso
1. Identifica el nombre del kernel que quieres eliminar. Puedes usar el comando `uname -r` para ver el kernel que estás usando actualmente y asi asegurarte de cual NO eliminar.
2. Actualiza el gestor de arranque para que no muestre el kernel eliminado. Si usas GRUB, puedes usar el comando `grub-mkconfig -o /boot/grub/grub.cfg` para generar un nuevo archivo de configuración. 
