#!/bin/bash

Install_Apollo()
{
    echo "====== Installing Apollo ======"
    echo "Install ${Apollo_Ver} Version..."
    Press_Start

    cd ${cur_dir}/src
	#初始化apollo数据库脚本
	Apollo_Create_Init_db
	#安装configservice
	Apollo_Install_configservice
}

Apollo_Create_Init_db() {
    echo "====== Apollo_Create_Init_db ======"
	Download_Files ${YUSP_Download_Mirror}/apolloconfigdb.sql
	Download_Files ${YUSP_Download_Mirror}/apolloportaldb.sql
	Apollo_Make_TempMycnf "${Apollo_DB_User}" "${Apollo_DB_Password}"
	echo "show database..."
	Do_Query "show databases;"
	if [ $? -eq 0 ]; then
        Echo_Green "OK, Apollo_DB_User is: ${Apollo_DB_User}, password correct."
    fi
	echo "import apollo init sql..."
	Do_Query "source apolloconfigdb.sql"
	Do_Query "source apolloportaldb.sql"
	echo "show database..."
	Do_Query "show databases;"
	Echo_Green "import apollo init sql success..."
}

Apollo_Install_configservice(){
    echo "====== Apollo_Install_configservice ======"
	Download_Files ${YUSP_Download_Mirror}/apollo-configservice-${Apollo_Ver}-github.zip
	unzip apollo-configservice-${Apollo_Ver}-github.zip -d apollo-configservice-${Apollo_Ver}
	echo "mv apolloconfig to /usr/local ..." 
	rm -rf /usr/local/apollo-configservice
	mv apollo-configservice-${Apollo_Ver} /usr/local/
	cd /usr/local/apollo-configservice-${Apollo_Ver}
	sed -i "s#^spring.datasource.url*#spring.datasource.url = jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8#" config/application-github.properties
	sed -i "s#^spring.datasource.username*#spring.datasource.username = ${Apollo_DB_User}#" config/application-github.properties
	sed -i "s#^spring.datasource.password*#spring.datasource.password = ${Apollo_DB_Password}#" config/application-github.properties
	sed -i "s#^SERVER_PORT*#SERVER_PORT=${Apollo_ConfigService_Port}#" scripts/startup.sh
	sh  /usr/local/apollo-configservice-${Apollo_Ver}/scripts/startup.sh
	
}

Apollo_Make_TempMycnf() {
    cat >~/.my.cnf<<EOF
[client]
user='$1'
password='$2'
EOF
    chmod 600 ~/.my.cnf	
}


Uninstall_Apollo()
{
    echo "You will uninstall Apollo..."
	echo "Shutting down Apollo..."
	sh  /usr/local/apollo-configservice-${Apollo_Ver}/scripts/shutdown.sh
	sh  /usr/local/apollo-adminservice-${Apollo_Ver}/scripts/shutdown.sh
	sh  /usr/local/apollo-portal-${Apollo_Ver}/scripts/shutdown.sh
	Sleep_Sec 3
    echo "Delete Apollo files..."
    rm -rf /usr/local/apollo*
    Echo_Green "Uninstall Apollo completed."
}