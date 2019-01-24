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

YUSP_Ver='1.0'

. yusp.conf
. include/main.sh

shopt -s extglob

Check_DB
Get_Dist_Name

clear
echo "+------------------------------------------------------------------------+"
echo "|          YUSP V${YUSP_Ver} for ${DISTRO} Linux Server, Written by Danyb|"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install Nginx+MySQL+Redis on Linux     |"
echo "+------------------------------------------------------------------------+"
echo "|           For more information please visit https://yusp.org           |"
echo "+------------------------------------------------------------------------+"

Sleep_Sec()
{
    seconds=$1
    while [ "${seconds}" -ge "0" ];do
      echo -ne "\r     \r"
      echo -n ${seconds}
      seconds=$(($seconds - 1))
      sleep 1
    done
    echo -ne "\r"
}

Uninstall_YUSP()
{
    echo "Stoping YUSP..."
    yusp kill
    yusp stop

    Remove_StartUp nginx
    if [ ${DB_Name} != "None" ]; then
        Remove_StartUp ${DB_Name}
        echo "Backup ${DB_Name} databases directory to /root/databases_backup_$(date +"%Y%m%d%H%M%S")"
        if [ ${DB_Name} == "mysql" ]; then
            mv ${MySQL_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        elif [ ${DB_Name} == "mariadb" ]; then
            mv ${MariaDB_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        fi
    fi
    chattr -i ${Default_Website_Dir}/.user.ini
    echo "Deleting YUSP files..."
    rm -rf /usr/local/nginx

    if [ ${DB_Name} != "None" ]; then
        rm -rf /usr/local/${DB_Name}
        rm -f /etc/my.cnf
        rm -f /etc/init.d/${DB_Name}
    fi

    rm -f /etc/init.d/nginx
    rm -f /bin/yusp
    echo "YUSP Uninstall completed."
}

Uninstall_LNMPA()
{
    echo "Stoping LNMPA..."
    lnmp kill
    lnmp stop
    
    Remove_StartUp nginx
    Remove_StartUp httpd
    if [ ${DB_Name} != "None" ]; then
        Remove_StartUp ${DB_Name}
        echo "Backup ${DB_Name} databases directory to /root/databases_backup_$(date +"%Y%m%d%H%M%S")"
        if [ ${DB_Name} == "mysql" ]; then
            mv ${MySQL_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        elif [ ${DB_Name} == "mariadb" ]; then
            mv ${MariaDB_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        fi
    fi
    echo "Deleting LNMPA files..."
    rm -rf /usr/local/nginx
    rm -rf /usr/local/php
    rm -rf /usr/local/apache
    rm -rf /usr/local/zend

    if [ ${DB_Name} != "None" ]; then
        rm -rf /usr/local/${DB_Name}
        rm -f /etc/my.cnf
        rm -f /etc/init.d/${DB_Name}
    fi

    if [ -s /usr/local/acme.sh/acme.sh ]; then
        /usr/local/acme.sh/acme.sh --uninstall
        rm -rf /usr/local/acme.sh
    fi

    rm -f /etc/init.d/nginx
    rm -f /etc/init.d/httpd
    rm -f /bin/lnmp
    echo "LNMPA Uninstall completed."
}

Uninstall_LAMP()
{
    echo "Stoping LAMP..."
    lnmp kill
    lnmp stop

    Remove_StartUp httpd
    if [ ${DB_Name} != "None" ]; then
        Remove_StartUp ${DB_Name}
        echo "Backup ${DB_Name} databases directory to /root/databases_backup_$(date +"%Y%m%d%H%M%S")"
        if [ ${DB_Name} == "mysql" ]; then
            mv ${MySQL_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        elif [ ${DB_Name} == "mariadb" ]; then
            mv ${MariaDB_Data_Dir} /root/databases_backup_$(date +"%Y%m%d%H%M%S")
        fi
    fi
    echo "Deleting LAMP files..."
    rm -rf /usr/local/apache
    rm -rf /usr/local/php
    rm -rf /usr/local/zend

    if [ ${DB_Name} != "None" ]; then
        rm -rf /usr/local/${DB_Name}
        rm -f /etc/my.cnf
        rm -f /etc/init.d/${DB_Name}
    fi

    if [ -s /usr/local/acme.sh/acme.sh ]; then
        /usr/local/acme.sh/acme.sh --uninstall
        rm -rf /usr/local/acme.sh
    fi

    rm -f /etc/my.cnf
    rm -f /etc/init.d/httpd
    rm -f /bin/lnmp
    echo "LAMP Uninstall completed."
}

    Check_Stack
    echo "Current Stack: ${Get_Stack}"

    action=""
    echo "Enter 1 to uninstall YUSP"
    echo "Enter 2 to uninstall YUSPA"
    read -p "(Please input 1, 2): " action

    case "$action" in
    1|[yY][uU][sS][pP])
        echo "You will uninstall YUSP"
        Echo_Red "Please backup your configure files and mysql data!!!!!!"
        Echo_Red "The following directory or files will be remove!"
        cat << EOF
/usr/local/nginx
${MySQL_Dir}
/usr/local/php
/etc/init.d/nginx
/etc/init.d/${DB_Name}
/etc/my.cnf
/bin/yusp
EOF
        Sleep_Sec 3
        Press_Start
        Uninstall_YUSP
    ;;
    2|[yY][uU][sS][pP][aA])
        echo "You will uninstall YUSPA"
        Echo_Red "Please backup your configure files and mysql data!!!!!!"
        Echo_Red "The following directory or files will be remove!"
        cat << EOF
/usr/local/nginx
${MySQL_Dir}
/etc/init.d/nginx
/etc/init.d/${DB_Name}
/etc/my.cnf
/bin/yusp
EOF
        Sleep_Sec 3
        Press_Start
        Uninstall_YUSPA
    ;;
    esac