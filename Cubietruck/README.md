# Scripts for Cubietruck

## Create working sdcard

1. Download all needed files: `./download_data.sh`
2. Create working sdcard: `sudo ./create_sdcard.sh /dev/mmcblk0`

On every boot, a dynamic created mac address is set for the network interface. You can set a fix mac address in the file `/etc/modprobe.d/sunxi.conf`

## Change the network configuration for eth0

You can change the network setting for eth0 over the file `/etc/systemd/network/eth0.network`

## Disable LEDs

```bash
systemctl enable cubietruck_leds_off.service
systemctl start cubietruck_leds_off.service
```

## Changelog

2014-08-07
* Add: Workaround for the current problem with dhcp and systemd-networkd (static network config)
* Fix: Now the initscript is run on the login of the root user

2014-08-06

* ADD: Systemd service to disable leds
