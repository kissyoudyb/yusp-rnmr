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
		echo "mv jdkdir to /usr/local ..."
		rm -rf /usr/local/jdkl*
		mv ./jdk1* /usr/local/
		cd /usr/local/jdk*
		JAVA_HOME=`pwd`
		echo "add JAVA_HOME TO  /etc/profile ..."
		cat >>/etc/profile<<EOF
#JAVA_HOME
export JAVA_HOME=${JAVA_HOME}
export PATH='$PATH':$JAVA_HOME/bin
EOF
		source /etc/profile
		java -version
		if [ $? = 0 ]; then
			Echo_Green "====== Jdk install completed ======"
			Echo_Green "Jdk installed successfully, enjoy it!"
		else
			Echo_Red "Jdk install failed!"
		fi
    fi
}

Uninstall_JDK()
{
    echo "You will uninstall JDK..."
    Press_Start
    echo "Delete JDK files..."
    rm -rf /usr/local/jdk*
	echo "Delete JAVA_HOME in /etc/profile ..."
    sed -i '/jdk1/d' /etc/profile
	sed -i '/JAVA_HOME/d' /etc/profile
	source /etc/profile
    Echo_Green "Uninstall JDK completed."
}