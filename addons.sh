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
. include/maven.sh
. include/apollo.sh
. include/nexus.sh
. include/rabbitmq.sh

Display_Addons_Menu()
{
    echo "##### cache / jdk / Maven #####"
	echo "1: Jdk"
	echo "2: Maven"
	echo "##### Ctrip Apollo #####"
	echo "3: Apollo"
	echo "##### Nexus #####"
	echo "4: Nexus"
    echo "5: Redis"
	echo "6: RabbitMQ"
    echo "exit: Exit current script"
    echo "#####################################################"
    read -p "Enter your choice (1, 2, 3, 4, 5, 6 or exit): " action2
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
			2|[mM]aven)
                Install_Maven
                ;;
			3|[aA]pollo)
                Install_Apollo
                ;;
			4|[nN]exus)
                Install_Nexus
                ;;	
            5|[rR]edis)
                Install_Redis
                ;;
			6|[rR]abbit[mM][qQ])
                Install_RabbitMQ
                ;;	
            [eE][xX][iI][tT])
                exit 1
                ;;
            *)
                echo "Usage: ./addons.sh {install|uninstall} {jdk|maven|redis|apollo|nexus|rabbitmq}"
                ;;
        esac
        ;;
    uninstall)
        case "${action2}" in
			[jJ][dD][kK])
                Uninstall_JDK
                ;;
			[mM][aA][vV][eE][nN])
                Uninstall_Maven
                ;;
            [rR]edis)
                Uninstall_Redis
                ;;
            [aA]pollo)
                Uninstall_Apollo
                ;;
			[nN]exus)
                Uninstall_Nexus
                ;;
			[rR]abbit[mM][qQ])
                Uninstall_RabbitMQ
                ;;
            *)
                echo "Usage: ./addons.sh {install|uninstall} {jdk|maven|redis|apollo|nexus|rabbitmq}"
                ;;
        esac
        ;;
    [eE][xX][iI][tT])
        exit 1
        ;;
    *)
        echo "Usage: ./addons.sh {install|uninstall} {jdk|maven|redis|apollo|nexus|rabbitmq}"
        exit 1
        ;;
    esac