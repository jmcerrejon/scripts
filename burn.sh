#!/bin/bash
#
# Description : Easy script to burn images from terminal for OSX
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Version     : 0.9 (2/Feb/15)
#
# TODO 		  : Linux compatibility incomplete
#
clear

DEVICE_NUMBER=1
IMG=$1
if [[ $(uname) == 'Linux' ]]; then OS="Linux"; else OS="OSX"; fi

function usage(){
	echo -e "Burn images from terminal (OSX)\n===============================\n\nUsage: burn.sh [image_path]\n\nExample: ./burn.sh Downloads/myimage.img\n"
	echo -e "For trouble, ideas or technical support please visit http://misapuntesde.com\n"
}

function edit(){
	if [ -f /Volumes/boot/boot.ini ]; then
		nano /Volumes/boot/boot.ini
	elif [ -f /Volumes/boot/boot.txt ]; then
		nano /Volumes/boot/boot.txt
	else
		echo "File boot not found."
	fi
}

function dd_osx(){
	echo -e "Starting the process on /dev/disk1. Please be patient...\n\n"
	# unmount disk1
	echo -e "Unmounting...\n"
	diskutil unmountDisk /dev/disk$DEVICE_NUMBER
	# dd to /dev/rdisk1
	echo -e "\nCopying (please wait)...\n\n"
	sudo dd bs=1m of=/dev/rdisk$DEVICE_NUMBER if=$IMG
}

if [ -e /dev/disk2 ]; then
	echo -e "DEVICES LIST\n============\n"
	diskutil list | grep "/dev/\|0:" | awk '{print $1,$3, $4}'
	echo -e "Choose disk number (Example: /dev/disk1 = 1, /dev/disk2 = 2,...)\n"
	read -p "Disk Number = " option
	$DEVICE_NUMBER="$option"
elif [ "$IMG" == "" ]; then
	echo -e "Missing argument.\n"
	usage
	exit
elif [ ! -f $IMG ]; then
	echo -e "Image not found. Make sure the path is correct.\n"
	exit
fi

dd_osx

echo -e "\nDone!. Do you want to (E)ject the SD, edit the (B)oot file config with nano or e(X)it?."
read -p "Choose (E/B/X)? " option

case "$option" in
    e*) echo -e "\nEjecting...\n" ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    b*) edit ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    x*) echo -e "\nRemove the SD Card & have a nice day :)\n" ;exit ;;
esac

echo -e "\nFor trouble, ideas or technical support please visit http://misapuntesde.com\n"
