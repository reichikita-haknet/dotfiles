# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.
# Author: Joseph Tannhuber <sepp.tannhuber@yahoo.de>, 2013
# Solarized like colorscheme, similar to solarized-dircolors
# from https://github.com/seebi/dircolors-solarized.
# This is a modification of Roman Zimbelmann's default colorscheme.

from __future__ import (absolute_import, division, print_function)

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    cyan, magenta, red, white, default,
    normal, bold, reverse,
    default_colors,
)

import json

# Lee el archivo colors.json
with open('~/.cache/wal/colors.json') as f:
    data = json.load(f)

# Cuando conviertes color1 a un número entero (int), estás obteniendo un número que puede ser mayor que 255, lo que causa un error.
# orque seguramente el número de color excede el número máximo de colores soportados por la terminal. En la mayoría de los terminales, el número máximo de colores es 256 (enumerados del 0 al 255).
# Para solucionar este problema, uso una función que convierta color1 (formato hexadecimal) a un número entero entre 0 y 255:

def hex_to_256(color):
    return int(color[1:], 16) %256

# Ahora puedes acceder a los colores
background = hex_to_256(data['special']['background'])
foreground = hex_to_256(data['special']['foreground'])
color1 = hex_to_256(data['colors']['color1'])
color2 = hex_to_256(data['colors']['color2'])
color3 = hex_to_256(data['colors']['color3'])
color4 = hex_to_256(data['colors']['color4'])
color5 = hex_to_256(data['colors']['color5'])
color6 = hex_to_256(data['colors']['color6'])
color7 = hex_to_256(data['colors']['color7'])
color8 = hex_to_256(data['colors']['color8'])
color9 = hex_to_256(data['colors']['color9'])
# etc.

class pywal(ColorScheme):
    progress_bar_color = color1

    def use(self, context):  # pylint: disable=too-many-branches,too-many-statements
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg = magenta
            if context.selected:
                attr = reverse
            else:
                attr = normal
            # Color "empty", texto que se mostrara al seleccionar un directorio vacio
            if context.empty or context.error:
                fg = red
                bg = background
            if context.border:
                fg = cyan
            if context.media:
                if context.image:
                    # Color de fondo (raro) de un archivo de imagen (.jpg, png, etc.)
                    fg = background
                else:
                    # Color de fondo de un archivo media (.mp4)
                    fg = color4 
            if context.container:
                fg = 61
            if context.directory:
                # Color de fondo (raro, deberia ser de primer plano) al seleccionar un directorio
                fg = color8
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                # Color de fondo de archivos ejecutables (como .sh)
                fg = foreground
                attr |= bold
            if context.socket:
                fg = 136
                bg = 230
                attr |= bold
            if context.fifo:
                fg = 136
                bg = 230
                attr |= bold
            if context.device:
                fg = 244
                bg = 230
                attr |= bold
            if context.link:
                fg = 37 if context.good else 160
                attr |= bold
                if context.bad:
                    bg = 235
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                fg = cyan
                attr|= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = 237
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = white

            if context.inactive_pane:
                fg = 241
        #------------------- Barra de titulo ---------------------#
        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = color3 if context.bad else 255
                if context.bad:
                    bg = red
            # Color de primer plano de un directorio cualquiera en la barra de titulo
            elif context.directory:
                fg = color4
            elif context.tab:
                fg = 47 if context.good else 33
                bg = 239
            elif context.link:
                fg = color3
        #------------- Barra de estado (barra inferiro) -------------#
        elif context.in_statusbar:
            # Color de los permisos de cada directorio o archivo
            if context.permissions:
                if context.good:
                    fg = color3
                elif context.bad:
                    fg = 160
                    bg = 235
            if context.marked:
                attr |= bold | reverse
                fg = 237
                bg = 47
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 160
                    bg = 235
            if context.loaded:
                bg = self.progress_bar_color

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = cyan

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        return fg, bg, attr
