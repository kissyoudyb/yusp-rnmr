#!/bin/bash

Install_JDK()
{
    echo "====== Installing JDK ======"
    echo "Install ${JDK_Ver} Version..."
    Press_Start

    cd ${cur_dir}/src
	java -version
    if [ $? = 0 ]; then
        echo "JDK already install. JAVA_HOME is: ${JAVA_HOME}"
    else
        Download_Files ${YUSP_Download_Mirror}/${JDK_Ver}.tar.gz ${JDK_Ver}.tar.gz
        Tar_Cd ${JDK_Ver}.tar.gz ${JDK_Ver}
		pwd
		mv ./jdk1* /usr/local/
		cd /usr/local/jdk*
		JAVA_HOME=`pwd`
		cat >>/etc/profile<<EOF
		#JAVA_HOME
		export JAVA_HOME=${JAVA_HOME}
		export PATH=$PATH:$JAVA_HOME/bin
EOF
		source /etc/profile
		java -version
		if [ $? = 0 ]; then
			Echo_Green "====== Jdk install completed ======"
			Echo_Green "Jdk installed successfully, enjoy it!"
		else
        Echo_Red "Jdk install failed!"
		fi
        # if [ "${Is_64bit}" = "y" ] ; then
            # make PREFIX=/usr/local/redis install
        # else
            # make CFLAGS="-march=i686" PREFIX=/usr/local/redis install
        # fi
        # mkdir -p /usr/local/redis/etc/
        # \cp redis.conf  /usr/local/redis/etc/
        # sed -i 's/daemonize no/daemonize yes/g' /usr/local/redis/etc/redis.conf
        # if ! grep -Eqi '^bind[[:space:]]*127.0.0.1' /usr/local/redis/etc/redis.conf; then
            # sed -i 's/^# bind 127.0.0.1/bind 127.0.0.1/g' /usr/local/redis/etc/redis.conf
        # fi
        # sed -i 's#^pidfile /var/run/redis_6379.pid#pidfile /var/run/redis.pid#g' /usr/local/redis/etc/redis.conf
        # cd ../
        # rm -rf ${cur_dir}/src/${Redis_Stable_Ver}

        # if [ -s /sbin/iptables ]; then
            # if /sbin/iptables -C INPUT -i lo -j ACCEPT; then
                # /sbin/iptables -A INPUT -p tcp --dport 6379 -j DROP
                # if [ "$PM" = "yum" ]; then
                    # service iptables save
                # elif [ "$PM" = "apt" ]; then
                    # iptables-save > /etc/iptables.rules
                # fi
            # fi
        # fi
    fi

    # if [ -s ${PHPRedis_Ver} ]; then
        # rm -rf ${PHPRedis_Ver}
    # fi

    # if echo "${Cur_PHP_Version}" | grep -Eqi '^5.2.';then
        # Download_Files http://pecl.php.net/get/redis-2.2.7.tgz redis-2.2.7.tgz
        # Tar_Cd redis-2.2.7.tgz redis-2.2.7
    # else
        # Download_Files http://pecl.php.net/get/${PHPRedis_Ver}.tgz ${PHPRedis_Ver}.tgz
        # Tar_Cd ${PHPRedis_Ver}.tgz ${PHPRedis_Ver}
    # fi
    # ${PHP_Path}/bin/phpize
    # ./configure --with-php-config=${PHP_Path}/bin/php-config
    # Make_Install
    # cd ../

    # cat >${PHP_Path}/conf.d/007-redis.ini<<EOF
# extension = "redis.so"
# EOF

    # \cp ${cur_dir}/init.d/init.d.redis /etc/init.d/redis
    # chmod +x /etc/init.d/redis
    # echo "Add to auto startup..."
    # StartUp redis
    #Restart_PHP
    # /etc/init.d/redis start

    # if [ -s /usr/local/redis/bin/redis-server ]; then
        # Echo_Green "====== Redis install completed ======"
        # Echo_Green "Redis installed successfully, enjoy it!"
    # else
        # rm -f ${PHP_Path}/conf.d/007-redis.ini
        # Echo_Red "Redis install failed!"
    # fi
}

Uninstall_Redis()
{
    echo "You will uninstall Redis..."
    Press_Start
    rm -f ${PHP_Path}/conf.d/007-redis.ini
    #Restart_PHP
    Remove_StartUp redis
    echo "Delete Redis files..."
    rm -rf /usr/local/redis
    rm -rf /etc/init.d/redis
    if [ -s /sbin/iptables ]; then
        /sbin/iptables -D INPUT -p tcp --dport 6379 -j DROP
        if [ "$PM" = "yum" ]; then
            service iptables save
        elif [ "$PM" = "apt" ]; then
            iptables-save > /etc/iptables.rules
        fi
    fi
    Echo_Green "Uninstall Redis completed."
}