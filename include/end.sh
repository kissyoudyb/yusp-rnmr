#!/bin/bash

Add_Iptables_Rules()
{
    #add iptables firewall rules
    if [ -s /sbin/iptables ]; then
        /sbin/iptables -I INPUT 1 -i lo -j ACCEPT
        /sbin/iptables -I INPUT 2 -m state --state ESTABLISHED,RELATED -j ACCEPT
        /sbin/iptables -I INPUT 3 -p tcp --dport 22 -j ACCEPT
        /sbin/iptables -I INPUT 4 -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT 5 -p tcp --dport 443 -j ACCEPT
        /sbin/iptables -I INPUT 6 -p tcp --dport 3306 -j DROP
        /sbin/iptables -I INPUT 7 -p icmp -m icmp --icmp-type 8 -j ACCEPT
        if [ "$PM" = "yum" ]; then
            service iptables save
            if [ -s /usr/sbin/firewalld ]; then
                systemctl stop firewalld
                systemctl disable firewalld
            fi
        elif [ "$PM" = "apt" ]; then
            iptables-save > /etc/iptables.rules
            cat >/etc/network/if-post-down.d/iptables<<EOF
#!/bin/bash
iptables-save > /etc/iptables.rules
EOF
            chmod +x /etc/network/if-post-down.d/iptables
            cat >/etc/network/if-pre-up.d/iptables<<EOF
#!/bin/bash
iptables-restore < /etc/iptables.rules
EOF
            chmod +x /etc/network/if-pre-up.d/iptables
        fi
    fi
}

Add_YUSP_Startup()
{
    echo "Add Startup and Starting YUSP..."
    \cp ${cur_dir}/conf/yusp /bin/yusp
    chmod +x /bin/yusp
    StartUp nginx
    /etc/init.d/nginx start
    if [[ "${DBSelect}" =~ ^[6789]|10$ ]]; then
        StartUp mariadb
        /etc/init.d/mariadb start
        sed -i 's#/etc/init.d/mysql#/etc/init.d/mariadb#' /bin/yusp
    elif [[ "${DBSelect}" =~ ^[12345]$ ]]; then
        StartUp mysql
        /etc/init.d/mysql start
    elif [ "${DBSelect}" = "0" ]; then
        sed -i 's#/etc/init.d/mysql.*##' /bin/yusp
    fi
}

Check_Nginx_Files()
{
    isNginx=""
    echo "============================== Check install =============================="
    echo "Checking ..."
    if [[ -s /usr/local/nginx/conf/nginx.conf && -s /usr/local/nginx/sbin/nginx ]]; then
        Echo_Green "Nginx: OK"
        isNginx="ok"
    else
        Echo_Red "Error: Nginx install failed."
    fi
}

Check_DB_Files()
{
    isDB=""
    if [[ "${DBSelect}" =~ ^[6789]|10$ ]]; then
        if [[ -s /usr/local/mariadb/bin/mysql && -s /usr/local/mariadb/bin/mysqld_safe && -s /etc/my.cnf ]]; then
            Echo_Green "MariaDB: OK"
            isDB="ok"
        else
            Echo_Red "Error: MariaDB install failed."
        fi
    elif [[ "${DBSelect}" =~ ^[12345]$ ]]; then
        if [[ -s /usr/local/mysql/bin/mysql && -s /usr/local/mysql/bin/mysqld_safe && -s /etc/my.cnf ]]; then
            Echo_Green "MySQL: OK"
            isDB="ok"
        else
            Echo_Red "Error: MySQL install failed."
        fi
    elif [ "${DBSelect}" = "0" ]; then
        Echo_Green "Do not install MySQL."
        isDB="ok"
    fi
}

Clean_Src_Dir()
{
    echo "Clean src directory..."
    if [[ "${DBSelect}" =~ ^[12345]$ ]]; then
        rm -rf ${cur_dir}/src/${Mysql_Ver}
    elif [[ "${DBSelect}" =~ ^[6789]|10$ ]]; then
        rm -rf ${cur_dir}/src/${Mariadb_Ver}
    fi
    if [[ "${DBSelect}" = "2" ]]; then
        rm -rf ${cur_dir}/src/${Boost_Ver}
    elif [[ "${DBSelect}" = "3" ]]; then
        rm -rf ${cur_dir}/src/${Boost_New_Ver}
    fi
    if [ "${Stack}" = "yusp" ]; then
        rm -rf ${cur_dir}/src/${Nginx_Ver}
    elif [ "${Stack}" = "lnmpa" ]; then
        rm -rf ${cur_dir}/src/${Nginx_Ver}
        rm -rf ${cur_dir}/src/${Apache_Ver}
    fi
}

Print_Sucess_Info()
{
    Clean_Src_Dir
    echo "+------------------------------------------------------------------------+"
    echo "|      YUSP V${YUSP_Ver} for ${DISTRO} Linux Server, written by Danyb    |"
    echo "+------------------------------------------------------------------------+"
    echo "|           For more information please visit https://yusp.org           |"
    echo "+------------------------------------------------------------------------+"
    echo "|    yusp status manage: yusp {start|stop|reload|restart|kill|status}    |"
    echo "+------------------------------------------------------------------------+"
    echo "|  phpMyAdmin: http://IP/phpmyadmin/                                     |"
    echo "|  phpinfo: http://IP/phpinfo.php                                        |"
    echo "|  Prober:  http://IP/p.php                                              |"
    echo "+------------------------------------------------------------------------+"
    echo "|  Add VirtualHost: yusp vhost add                                       |"
    echo "+------------------------------------------------------------------------+"
    echo "|  Default directory: ${Default_Website_Dir}                             |"
    if [ "${DBSelect}" != "0" ]; then
        echo "+------------------------------------------------------------------------+"
        echo "|  MySQL root password: ${DB_Root_Password}                          |"
    fi
    echo "+------------------------------------------------------------------------+"
    yusp status
    if [ -s /bin/ss ]; then
        ss -ntl
    else
        netstat -ntl
    fi
    stop_time=$(date +%s)
    echo "Install yusp takes $(((stop_time-start_time)/60)) minutes."
    Echo_Green "Install yusp V${YUSP_Ver} completed! enjoy it."
}

Print_Failed_Info()
{
    if [ -s /bin/yusp ]; then
        rm -f /bin/yusp
    fi
    Echo_Red "Sorry, Failed to install YUSP!"
    Echo_Red "Please visit https://yusys.html feedback errors and logs."
    Echo_Red "You can download /root/yusp-install.log from your server,and upload yusp-install.log to YUSP Forum."
}

Check_YUSP_Install()
{
    Check_Nginx_Files
    Check_DB_Files
    if [[ "${isNginx}" = "ok" && "${isDB}" = "ok" ]]; then
        Print_Sucess_Info
    else
        Print_Failed_Info
    fi
}