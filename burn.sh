#!/bin/bash
#
# Description : Easy script to burn images to SD/USB from terminal (OSX only)
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Version     : 0.9.5 (21/Apr/15)
#
# TODO 		  : Linux compatibility incomplete
# 				https://blog.tinned-software.net/create-bootable-usb-stick-from-iso-in-mac-os-x/
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
	elif [ -f /Volumes/BOOT/boot.ini ]; then
		nano /Volumes/BOOT/boot.ini
	elif [ -f /Volumes/boot/boot.txt ]; then
		nano /Volumes/boot/boot.txt
	elif [ -f /Volumes/NO\ NAME/config.txt ]; then
		nano /Volumes/NO\ NAME/config.txt
	elif [ -f /Volumes/Untitled/uEnv.txt ]; then
		nano /Volumes/Untitled/uEnv.txt
	else
		echo "File boot not found."
	fi
}

function dd_osx(){
	echo -e "Starting the process on /dev/disk$DEVICE_NUMBER. Please be patient...\n\n"
	# unmount diskX
	echo -e "Unmounting...\n"
	diskutil unmountDisk /dev/disk$DEVICE_NUMBER
	#If IMG is a iso image, convert it to .img before burn
	if [ ${IMG: -4} == ".iso" ]; then 
		hdiutil convert -format UDRW -o ./$IMG $IMG
		mv $IMG.dmg $IMG.img
		IMG=$IMG.img
		echo -e "\nImage to burn: $IMG"
	fi
	# dd to /dev/rdiskX
	echo -e "\nCopying (please wait)...\n"
	sudo dd bs=1m of=/dev/rdisk$DEVICE_NUMBER if=$IMG
	if [ ${IMG: -8} == ".iso.img" ]; then 
		rm $IMG
	fi
}

if [ -e /dev/disk2 ]; then
	echo -e "DEVICES LIST\n============\n"
	diskutil list | grep "/dev/\|0:" | awk '{print $1,$3, $4}'
	echo -e "Choose disk number (Example: /dev/disk1 = 1, /dev/disk2 = 2,...)\n"
	read -p "Disk Number = " option
	DEVICE_NUMBER="$option"
	if [ "$option" == "0" ]; then
		echo -e "You don't want to write on device 0. Drunken mode ON. Aborting...\n"
		exit
	fi
elif [ "$IMG" == "" ]; then
	echo -e "Missing argument.\n"
	usage
	exit
elif [ ! -f $IMG ]; then
	echo -e "Image not found. Make sure the path is correct.\n"
	exit
fi

dd_osx

echo -e "\nDone!. Do you want to (E)ject the media, edit the (B)oot file config with nano or e(X)it?."
read -p "Choose (E/B/X)? " option

case "$option" in
    e*) echo -e "\nEjecting...\n" ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    b*) edit ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    x*) echo -e "\nRemove the SD Card or USB device & have a nice day :)\n" ;exit ;;
esac

echo -e "\nFor trouble, ideas or technical support please visit http://misapuntesde.com\n"
