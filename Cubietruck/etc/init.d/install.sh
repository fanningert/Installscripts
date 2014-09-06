#!/bin/bash

# System name
#echo server > /etc/hostname

# Localisation
# echo KEYMAP=de-latin1 > /etc/vconsole.conf
# echo LANG=de_AT.UTF8 > /etc/locale.conf
# nano /etc/locale.gen
# locale-gen

# Date and Time
#rm /etc/localtime
#ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime

# Services
systemctl enable ntpd

# Generate MAC address
macaddr=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4:\5:\6/')
echo "options sunxi_gmac mac_str=\"${macaddr^^}\"" > /etc/modprobe.d/sunxi.conf

#timedatectl set-timezone Europe/Vienna
#hwclock --systohc

# Delete me
rm $0
