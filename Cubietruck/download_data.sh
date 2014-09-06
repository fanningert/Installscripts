#!/bin/sh

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

echo -e $COL_RED"Download Image"$COL_RESET
rm ArchLinuxARM-sun7i-latest.tar.gz
wget http://archlinuxarm.org/os/ArchLinuxARM-sun7i-latest.tar.gz -O ArchLinuxARM-sun7i-latest.tar.gz

echo -e $COL_RED"Download Bootloader"$COL_RESET
rm uboot-cubietruck-armv7h.pkg.tar.xz
wget http://os.archlinuxarm.org/armv7h/alarm/uboot-cubietruck-2014.04-9-armv7h.pkg.tar.xz -O uboot-cubietruck-armv7h.pkg.tar.xz
