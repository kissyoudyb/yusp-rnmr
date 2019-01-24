#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install yusp"
    exit 1
fi

cur_dir=$(pwd)
Stack=$1
if [ "${Stack}" = "" ]; then
    Stack="yusp"
else
	Stack=$1
fi

YUSP_Ver='1.0'
. yusp.conf
. include/main.sh
. include/init.sh
. include/nginx.sh
. include/end.sh
. include/only.sh
    
Get_Dist_Name

if [ "${DISTRO}" = "unknow" ]; then
    Echo_Red "Unable to get Linux distribution name, or do NOT support the current distribution."
    exit 1
fi

if [[ "${Stack}" = "yusp" || "${Stack}" = "yuspa" || "${Stack}" = "yump" ]]; then
    if [ -f /bin/yusp ]; then
        Echo_Red "You have installed YUSP!"
        echo -e "If you want to reinstall YUSP, please BACKUP your data.\nand run uninstall script: ./uninstall.sh before you install."
        exit 1
    fi
fi

Check_YUSPConf

clear
echo "+------------------------------------------------------------------------+"
echo "|          YUSP V${YUSP_Ver} for ${DISTRO} Linux Server, Written by Danyb|"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install YUSP/YUSPA/YUMP on Linux       |"
echo "+------------------------------------------------------------------------+"
echo "|           For more information please visit https://yusp.org           |"
echo "+------------------------------------------------------------------------+"

Init_Install()
{
    Press_Install
    Print_APP_Ver
    Get_Dist_Version
    Print_Sys_Info
    Check_Hosts
    Check_Mirror
    if [ "${DISTRO}" = "RHEL" ]; then
        RHEL_Modify_Source
    fi
    if [ "${DISTRO}" = "Ubuntu" ]; then
        Ubuntu_Modify_Source
    fi
    Add_Swap
    Set_Timezone
    if [ "$PM" = "yum" ]; then
        CentOS_InstallNTP
        CentOS_RemoveAMP
        CentOS_Dependent
    elif [ "$PM" = "apt" ]; then
        Deb_InstallNTP
        Xen_Hwcap_Setting
        Deb_RemoveAMP
        Deb_Dependent
    fi
    Disable_Selinux
    Check_Download
    Install_Libiconv
    Install_Libmcrypt
    Install_Mhash
    Install_Mcrypt
    Install_Freetype
    Install_Pcre
    Install_Icu4c
    if [ "${SelectMalloc}" = "2" ]; then
        Install_Jemalloc
    elif [ "${SelectMalloc}" = "3" ]; then
        Install_TCMalloc
    fi
    if [ "$PM" = "yum" ]; then
        CentOS_Lib_Opt
    elif [ "$PM" = "apt" ]; then
        Deb_Lib_Opt
        Deb_Check_MySQL
    fi
    if [ "${DBSelect}" = "1" ]; then
        Install_MySQL_56
    elif [ "${DBSelect}" = "2" ]; then
        Install_MySQL_57
    elif [ "${DBSelect}" = "3" ]; then
        Install_MySQL_80
    fi
    TempMycnf_Clean
}

YUSP_Stack()
{
    Init_Install
    Install_Nginx
    Add_Iptables_Rules
    Add_YUSP_Startup
    Check_YUSP_Install
}

#TODO YUSPA
YUSPA_Stack()
{
    Init_Install
    if [ "${ApacheSelect}" = "1" ]; then
        Install_Apache_22
    else
        Install_Apache_24
    fi
    Install_Nginx
    Add_Iptables_Rules
    Add_YUSPA_Startup
    Check_YUSPA_Install
}

case "${Stack}" in
    yusp)
        Dispaly_Selection
        YUSP_Stack 2>&1 | tee /root/yusp-install.log
        ;;
    yuspa)
        Dispaly_Selection
        YUSPA_Stack 2>&1 | tee /root/yusp-install.log
        ;;
    nginx)
        Install_Only_Nginx 2>&1 | tee /root/nginx-install.log
        ;;
    db)
        Install_Only_Database
        ;;
    *)
        Echo_Red "Usage: $0 {yusp|yuspa}"
        Echo_Red "Usage: $0 {nginx|db}"
        ;;
esac

exit