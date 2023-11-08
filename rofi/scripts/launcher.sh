#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Elegi el type-6/style-1

dir="$HOME/.config/rofi/scripts"
theme='config-launcher'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
