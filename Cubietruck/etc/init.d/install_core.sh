#!/bin/bash

# Services
systemctl enable ntpd

# Generate MAC address
macaddr=$(dd if=/dev/urandom bs=1024 count=1 2>/dev/null|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(..\).*$/\1:\2:\3:\4:\5:\6/')
echo "options sunxi_gmac mac_str=\"${macaddr^^}\"" > /etc/modprobe.d/sunxi.conf

# Delete me
rm $0
