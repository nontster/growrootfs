#!/bin/bash

function osrelease () {
    OS=`cat /etc/os-release | grep '^NAME=' |  tr -d \" | sed 's/\n//g' | sed 's/NAME=//g'`
    
    if [ "$OS" == "Ubuntu" ]; then
        echo "Ubuntu"
    elif [ "$OS" == "Amazon Linux AMI" ]; then
        echo "AMZN"
    elif [ "$OS" == "CentOS Linux" ]; then
        echo "CentOS"
    elif [ "$OS" == "Red Hat Enterprise Linux Server" ]; then
        echo "RHEL"
    else
        echo "Operating System Not Found"
    fi
}

function vgname () {
    echo `vgs --noheadings -o vg_name`
}

vg=$(vgname)
release=$(osrelease)

if [ "$release" == "RHEL" ]; then
	echo -e "n\np\n\n\n\nt\n\n8e\nw" | fdisk /dev/sda
    partprobe
	pvcreate /dev/sda3
	vgextend $vg /dev/sda3
	lvextend -l +100%FREE /dev/$vg/root
	xfs_growfs /dev/$vg/root
elif [ "$release" == "CentOS" ]; then
	echo -e "n\np\n\n\n\nt\n\n8e\nw" | fdisk /dev/sda
    partprobe
	pvcreate /dev/sda3
	vgextend $vg /dev/sda3
	lvextend -l +100%FREE /dev/$vg/root
	xfs_growfs /dev/$vg/root
elif [ "$release" == "Ubuntu" ]; then
	echo -e "n\np\n\n\nt\n\n8e\nw" | fdisk /dev/sda
    partprobe
	pvcreate /dev/sda4
	vgextend $vg /dev/sda4
	lvextend -l +100%FREE /dev/$vg/root
	resize2fs /dev/$vg/root
fi
