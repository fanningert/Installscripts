#!/bin/bash

# Services
systemctl enable ntpd

wget -q --tries=10 --timeout=20 -O - http://google.com > /dev/null
if [[ $? -eq 0 ]]; then

	# Generate MAC address
	macaddr=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4:\5:\6/')
	echo "options sunxi_gmac mac_str=\"${macaddr^^}\"" > /etc/modprobe.d/sunxi.conf

	pacman -R uboot-cubieboard2
	pacman -Sy uboot-cubietruck

	# Delete me
	rm $0

fi
