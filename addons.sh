#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

cur_dir=$(pwd)
action=$1
action2=$2

. ./yusp.conf
. include/main.sh
. include/init.sh
. include/version.sh
. include/redis.sh
. include/jdk.sh

Display_Addons_Menu()
{
    echo "##### cache / jdk / accelerator #####"
	echo "1: Jdk"
    echo "5: Redis"
    echo "##### Image Processing #####"
    echo "7: imageMagick"
    echo "##### encryption/decryption utility for PHP #####"
    echo "8: ionCube Loader"
    echo "exit: Exit current script"
    echo "#####################################################"
    read -p "Enter your choice (1, 5, 7, 8 or exit): " action2
}

clear
echo "+-----------------------------------------------------------------------+"
echo "|            Addons script for YUSP V1.0, Written by Danyub             |"
echo "+-----------------------------------------------------------------------+"
echo "|    A tool to Install redis,elasticsearch,filebeat...addons for YUSP   |"
echo "+-----------------------------------------------------------------------+"
echo "|           For more information please visit https://yusp.org          |"
echo "+-----------------------------------------------------------------------+"

if [[ "${action}" == "" || "${action2}" == "" ]]; then
    action='install'
    Display_Addons_Menu
fi
Get_Dist_Name

    case "${action}" in
    install)
        case "${action2}" in
			1|[jJ][dD][kK])
                Install_JDK
                ;;
            5|[rR]edis)
                Install_Redis
                ;;
            7|image[mM]agick)
                Install_ImageMagic
                ;;
            8|ion[cC]ube)
                Install_ionCube
                ;;
            [eE][xX][iI][tT])
                exit 1
                ;;
            *)
                echo "Usage: ./addons.sh {install|uninstall} {jdk|redis|imagemagick|ioncube}"
                ;;
        esac
        ;;
    uninstall)
        case "${action2}" in
            [rR]edis)
                Uninstall_Redis
                ;;
            apcu)
                Uninstall_Apcu
                ;;
            image[mM]agick)
                Uninstall_ImageMagick
                ;;
            ion[cC]ube)
                Uninstall_ionCube
                ;;
            *)
                echo "Usage: ./addons.sh {install|uninstall} {redis|apcu|imagemagick|ioncube}"
                ;;
        esac
        ;;
    [eE][xX][iI][tT])
        exit 1
        ;;
    *)
        echo "Usage: ./addons.sh {install|uninstall} {redis|apcu|imagemagick|ioncube}"
        exit 1
        ;;
    esac