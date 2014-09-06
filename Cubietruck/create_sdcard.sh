#!/bin/sh

################################################################################
#
################################################################################

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

# usage:   sudo ./create_sdcard <drive>
# example: sudo ./create_sdcard /dev/sdb
# loop example: sudo ./create_sdcard /dev/loop0 ~/vSD.img

# create an empty image file for use with loop device like this:
# dd if=/dev/zero of=~/vSD.img bs=1M count=910

if [ "$(id -u)" != "0" ]; then
  clear
  echo -e $COL_RED"#########################################################"
  echo "# please execute with 'sudo' or -DANGEROUS!!!- as root  #"
  echo "# example: sudo ./create_sdcard <drive>                 #"
  echo -e "#########################################################"$COL_RESET
  exit 1
fi

if [ -z "$1" ]; then
  clear
  echo -e $COL_RED"#########################################################"
  echo "# please execute with your drive as option              #"
  echo "# example: sudo ./create_sdcard /dev/sdb                #"
  echo "# or:      sudo ./create_sdcard /dev/mmcblk0            #"
  echo "# or:      sudo ./create_sdcard /dev/loop0 ~/vSD.img    #"
  echo "# to create an image file for /dev/loop0 option:        #"
  echo "#   sudo dd if=/dev/zero of=~/vSD.img bs=1M count=910   #"
  echo -e "#########################################################"$COL_RESET
  exit 1
fi

DISK="$1"
case $DISK in
  "/dev/mmcblk"*)
    PART1="${DISK}p1"
    ;;
  "/dev/loop"*)
    PART1="${DISK}p1"
    IMGFILE="$2"
    losetup $DISK $IMGFILE
    ;;
  *)
    PART1="${DISK}1"
    ;;
esac

clear
echo -e $COL_RED"#########################################################"
echo "#                                                       #"
echo "#             ArchLinux ARM USB Installer               #"
echo "#                   for Cubietruck                      #"
echo "#                                                       #"
echo "#########################################################"
echo "#                                                       #"
echo "#     This will wipe any data off your chosen drive     #"
echo "# Please read the instructions and use very carefully.. #"
echo "#                                                       #"
echo -e "#########################################################"$COL_RESET

# check for some required tools
  # this is needed to partion the drive
  which parted > /dev/null
  if [ "$?" = "1" ]; then
    clear
    echo -e $COL_RED"#########################################################"
    echo "#                                                       #"
    echo "# OpenELEC.tv missing tool - Installation will quit     #"
    echo "#                                                       #"
    echo "#      We can't find the required tool \"parted\"       #"
    echo "#      on your system.                                  #"
    echo "#      Please install it via your package manager.      #"
    echo "#                                                       #"
    echo -e "#########################################################"$COL_RESET
    exit 1
  fi

  # this is needed to format the drive
  which mkfs.ext4 > /dev/null
  if [ "$?" = "1" ]; then
    clear
    echo -e $COL_RED"#########################################################"
    echo "#                                                       #"
    echo "# OpenELEC.tv missing tool - Installation will quit     #"
    echo "#                                                       #"
    echo "#      We can't find the required tool \"mkfs.ext4\"    #"
    echo "#      on your system.                                  #"
    echo "#      Please install it via your package manager.      #"
    echo "#                                                       #"
    echo -e "#########################################################"$COL_RESET
    exit 1
  fi

  # this is needed to tell the kernel for partition changes
  which partprobe > /dev/null
  if [ "$?" = "1" ]; then
    clear
    echo -e $COL_RED"#########################################################"
    echo "#                                                       #"
    echo "# OpenELEC.tv missing tool - Installation will quit     #"
    echo "#                                                       #"
    echo "#      We can't find the required tool \"partprobe\"    #"
    echo "#      on your system.                                  #"
    echo "#      Please install it via your package manager.      #"
    echo "#                                                       #"
    echo -e "#########################################################"$COL_RESET
    exit 1
  fi

  # this is needed to tell the kernel for partition changes
  which md5sum > /dev/null
  if [ "$?" = "1" ]; then
    clear
    echo -e $COL_RED"#########################################################"
    echo "#                                                       #"
    echo "# OpenELEC.tv missing tool - Installation will quit     #"
    echo "#                                                       #"
    echo "#      We can't find the required tool \"md5sum\"       #"
    echo "#      on your system.                                  #"
    echo "#      Please install it via your package manager.      #"
    echo "#                                                       #"
    echo -e "#########################################################"$COL_RESET
    exit 1
  fi

# check MD5/SHA sums

# (TODO) umount everything (if more than one partition)
  umount ${DISK}*

# remove all partitions from the drive
  echo -e $COL_RED"writing new disklabel on $DISK (removing all partitions)..."$COL_RESET
  parted -s "$DISK" mklabel msdos

# create a single partition
  echo -e $COL_RED"creating partitions on $DISK..."$COL_RESET
  parted -s "$DISK" mkpart primary ext2 -- 2048s 2099199s

# tell kernel we have a new partition table
  echo -e $COL_RED"telling kernel we have a new partition table..."$COL_RESET
  partprobe "$DISK"

# create ext4 partition with optimized settings for running on flash/sd
# See http://blogofterje.wordpress.com/2012/01/14/optimizing-fs-on-sd-card/ for reference.
  echo -e $COL_RED"creating filesystem on $PART1..."$COL_RESET
  mkfs.ext4 -O ^has_journal -b 4096 "$PART1"

# remount loopback device
  if [ "$DISK" = "/dev/loop0" ]; then
    sync
    losetup -d $DISK
    losetup $DISK $IMGFILE -o 1048576 --sizelimit 131071488
    PART1=$DISK
  fi

# mount partition
  echo -e $COL_RED"mounting partition $PART1..."$COL_RESET
  rm -rf /tmp/cubietruck_install
  mkdir -p /tmp/cubietruck_install
  mount -t ext4 "$PART1" /tmp/cubietruck_install
  MOUNTPOINT=/tmp/cubietruck_install

# copy files
  echo -e $COL_RED"copying files to $MOUNTPOINT..."$COL_RESET
  tar -xf ArchLinuxARM-sun7i-latest.tar.gz -C "$MOUNTPOINT"

# sync disk
  echo -e $COL_RED"syncing disk..."$COL_RESET
  sync

# copy bootloader
  echo -e $COL_RED"copying bootloade to $DISK..."$COL_RESET
  tar -xf uboot-cubietruck-armv7h.pkg.tar.xz -C "$MOUNTPOINT" --exclude='.PKGINFO' --exclude='.MTREE' --exclude='.INSTALL'
  dd if="$MOUNTPOINT"/boot/u-boot-sunxi-with-spl.bin of="$DISK" bs=1024 seek=8

# copy initial files
  echo -e $COL_RED"copying configuration files to $PART1..."$COL_RESET
  cp -R etc "$MOUNTPOINT"

# unmount partition
  echo -e $COL_RED"unmounting partition $MOUNTPOINT..."$COL_RESET
  umount $MOUNTPOINT
  sync

# cleaning
  echo -e $COL_RED"cleaning tempdir..."$COL_RESET
  rmdir $MOUNTPOINT

# unmount loopback device
  if [ "$DISK" = "/dev/loop0" ]; then
    losetup -d $DISK
  fi

echo -e $COL_RED"...installation finished"$COL_RESET
