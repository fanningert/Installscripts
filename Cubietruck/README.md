# Scripts for Cubietruck

## Create working sdcard

1. Download all needed files: `./download_data.sh`
2. Create working sdcard: `sudo ./create_sdcard.sh /dev/mmcblk0`

After the first start, a dynamic created mac adress is set for the network interface. You can change it in the file `/etc/modprobe.d/sunxi.conf`

## Bluetooth

```bash
systemctl enable brcm40183.service
systemctl start brcm40183.service
```

## Disable LEDs

```bash
systemctl enable cubietruck_leds_off.service
systemctl start cubietruck_leds_off.service
```

## Changelog

2014-08-06

* ADD: Bluetooth support - Thanks to PLyttle@archlinuxarm [Post](http://archlinuxarm.org/forum/viewtopic.php?f=33&t=7253#p39885)
* ADD: Systemd service to disable leds
