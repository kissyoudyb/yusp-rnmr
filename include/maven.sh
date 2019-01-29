#!/bin/bash

Install_Maven()
{
    echo "====== Installing Maven ======"
    echo "Install ${Maven_Ver} Version..."
    Press_Start
    cd ${cur_dir}/src
	mvn -v
    if [ $? = 0 ]; then
        echo "Maven already install. MAVEN_HOME is: ${MAVEN_HOME}"
    else
        Download_Files ${YUSP_Download_Mirror}/${Maven_Ver}-bin.tar.gz ${Maven_Ver}-bin.tar.gz
        Tar_Cd ${Maven_Ver}-bin.tar.gz ${Maven_Ver}
		pwd
		cd ${cur_dir}/src
		echo "mv mavendir to /usr/local ..."
		rm -rf /usr/local/${Maven_Ver}
		mv ./${Maven_Ver} /usr/local/
		cd /usr/local/${Maven_Ver}
		MAVEN_HOME=`pwd`
		echo "add MAVEN_HOME TO  /etc/profile ..."
		cat >>/etc/profile<<EOF
#MAVEN_HOME
export MAVEN_HOME=${MAVEN_HOME}
export PATH=$PATH:$MAVEN_HOME/bin
EOF
		source /etc/profile
		mvn -v
		if [ $? = 0 ]; then
		    #TODO modify setting.xml
			Echo_Green "====== Maven install completed ======"
			Echo_Green "Maven installed successfully, enjoy it!"
		else
			Echo_Red "Maven install failed!"
		fi
    fi
}

Uninstall_Maven()
{
    echo "You will uninstall Maven..."
    Press_Start
    echo "Delete Maven files..."
    rm -rf /usr/local/${Maven_Ver}
	echo "Delete MAVEN_HOME in /etc/profile ..."
    sed -i '/maven/d' /etc/profile
	sed -i '/MAVEN_HOME/d' /etc/profile
	source /etc/profile
    Echo_Green "Uninstall Maven completed."
}