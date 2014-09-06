#!/bin/bash

# System name
echo server > /etc/hostname

# Localisation
echo KEYMAP=de-latin1 > /etc/vconsole.conf
echo LANG=de_AT.UTF8 > /etc/locale.conf
nano /etc/locale.gen
locale-gen

# Date and Time
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime
