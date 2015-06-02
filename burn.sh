#!/bin/bash
#
# Description : Easy script to burn images to SD/USB from terminal
# Author      : Jose Cerrejon Gonzalez (ulysess@gmail_dot._com)
# Compatible  : OSX, Linux (Debian tested)
# Version     : 0.9.9 (02/Jun/15)
#
# TODO 		  : Linux compatibility incomplete
# 				https://blog.tinned-software.net/create-bootable-usb-stick-from-iso-in-mac-os-x/
#
clear

IMG="$1"
OS="OSX"
[[ $(uname) == 'Linux' ]] && OS="Linux"

usage()
{
	echo -e "Burn images from terminal\n=========================\n\nUsage: burn.sh [image_path]\n\nExample: ./burn.sh Downloads/myimage.img\n"
	echo -e "For trouble, ideas or technical support please visit http://misapuntesde.com\n"
}

edit()
{
	if [ -f /Volumes/boot/boot.ini ]; then
		nano /Volumes/boot/boot.ini
	elif [ -f /Volumes/BOOT/boot.ini ]; then
		nano /Volumes/BOOT/boot.ini
	elif [ -f /Volumes/boot/boot.txt ]; then
		nano /Volumes/boot/boot.txt
	elif [ -f /Volumes/NO\ NAME/config.txt ]; then
		nano /Volumes/NO\ NAME/config.txt
	elif [ -f /media/$USER/BOOT/boot.ini ]; then
		nano /media/$USER/BOOT/boot.ini
	elif [ -f /Volumes/Untitled/uEnv.txt ]; then
		nano /Volumes/Untitled/uEnv.txt
	else
		echo "File boot not found."
	fi
}

dd_osx()
{
	DEVICE_NUMBER=1
	if [ -e /dev/disk2 ]; then
		echo -e "DEVICES LIST\n============\n"
		diskutil list | grep "/dev/\|0:" | awk '{print $1,$3, $4}'
		echo -e "\nChoose disk number (Example: /dev/disk1 = 1, /dev/disk2 = 2,...)\n"
		read -p "Disk Number = " option
		DEVICE_NUMBER="$option"
		if [ "$option" == "0" ]; then
			echo -e "You don't want to write on device 0. Drunken mode ON. Aborting...\n"
			exit
		fi
	fi

	echo -e "Starting the process on /dev/disk$DEVICE_NUMBER. Please be patient...\n\n"
	# unmount diskX
	echo -e "Unmounting...\n"
	diskutil unmountDisk /dev/disk$DEVICE_NUMBER
	#If IMG is a iso image, convert it to .img before burn
	if [ ${IMG: -4} == ".iso" ]; then 
		hdiutil convert -format UDRW -o ./$IMG $IMG
		mv $IMG.dmg $IMG.img
		IMG=$IMG.img
		echo -e "\nImage to burn: $IMG\n"
	fi
	# dd to /dev/rdiskX
	echo -e "\nCopying (please wait)...\n"

	# Android image
	if [ $(echo $IMG1|grep 'selfinstall-odroidc') ]; then 
		echo -e "\nDetected Android image. The process may take a long time, so please wait..\nNOTE: If fail, change your SD-to-MicroSD adapter.\n"
		sudo dd bs=1m of=/dev/disk$DEVICE_NUMBER if=$IMG
	else	
	# Another one
		sudo dd bs=4m of=/dev/rdisk$DEVICE_NUMBER if=$IMG
	fi

	if [ ${IMG: -8} == ".iso.img" ]; then 
		rm $IMG
	fi
}

dd_linux()
{
	if [[ $(grep -c sd[b-z]$ /proc/partitions) -eq 1 ]]; then
		DEVICE_ID="$(grep -Eo sd[b-z]$ /proc/partitions)"
	else
		echo -e "DEVICES LIST\n============\n"
		grep -Eo sd[b-z]$ /proc/partitions
		sudo fdisk -l | grep -E Disk\ /dev/sd[b-z]\+[0-9]* | awk '{print $1,$2,$3,$4}'
		echo -e "Choose device (Example: /dev/sdc1 = sdc, /dev/sdd1 = sdd,...)\n"
		read -p "Device chosen = " option
		DEVICE_ID="$option"
		if [ "$option" == "sda" ]; then
				echo -e "You don't want to write on device 0. Drunken mode ON. Aborting...\n"
				exit 0
		fi
	fi

	echo -e "Starting the process on /dev/$DEVICE_ID. Be patient...\n\n"
	# unmount (I can't find the best method for that)
	echo -e "Unmounting...\n"
	sudo umount /dev/${DEVICE_ID}1 /dev/${DEVICE_ID}2 > /dev/null 2>&1
	
	# Uncompress if the file is compressed with .xz
	if [ "${IMG: -3}" == ".xz" ]; then
		echo -e "Uncompressing the file $IMG...\n"
		unxz "${IMG}"
		IMG="${IMG%.xz}"
		echo -e "\nImage to burn: $IMG\n"
	fi

	# dd to /dev/sdX
	# Android image
	if [ $(echo $IMG|grep 'selfinstall-odroidc') ]; then 
		echo -e "\nDetected Android image. The process may take a long time, so be patience..\nIf fail:\n· Change your SD-to-MicroSD adapter.\n· Make sure you uncompress the image with: unxz my-odroid-image.img.xz\n\nCopying (please wait)..\n"
		sudo dd if=$IMG of=/dev/$DEVICE_ID bs=1M conv=fsync && sync;sync
	else
	# Another one
	echo -e "\nCopying (please wait)...\n"
		sudo dd if=$IMG of=/dev/$DEVICE_ID bs=4M && sync
	fi

	if [ -e /usr/bin/notify-send ]; then
		notify-send 'Image burned successfully' --icon=mail-signed-verified
	fi
}

if [ "$IMG" == "" ]; then
	echo -e "Missing argument.\n"
	usage
	exit
elif [ ! -f $IMG ]; then
	echo -e "Image not found. Make sure the path is correct.\n"
	exit
fi

if [[ $(uname)=='Linux' ]]; then dd_linux ; else dd_osx ; fi


echo -e "\nDone!. Do you want to (E)ject the media, edit the (B)oot file config with nano or e(X)it?."
read -p "Choose (E/B/X)? " option

case "$option" in
    e*) echo -e "\nEjecting...\n" ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    b*) edit ; diskutil eject /dev/disk$DEVICE_NUMBER ;;
    x*) echo -e "\nRemove the SD Card or USB device & have a nice day :)\n" ;exit ;;
esac

echo -e "\nFor trouble, ideas or technical support please visit http://misapuntesde.com\n"
