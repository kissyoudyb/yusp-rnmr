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
	#安装adminservice
	Apollo_Install_adminservice
	#安装portal
	Apollo_Install_portal
}

Apollo_Create_Init_db() {
    echo "====== Apollo_Create_Init_db ======"
	Download_Files ${YUSP_Download_Mirror}/apolloconfigdb.sql apolloconfigdb.sql
	Download_Files ${YUSP_Download_Mirror}/apolloportaldb.sql apolloconfigdb.sql
	Apollo_Make_TempMycnf "${Apollo_DB_User}" "${Apollo_DB_Password}"
	echo "show database..."
	Do_Query "show databases;"
	if [ $? -eq 0 ]; then
        Echo_Green "OK, Apollo_DB_User is: ${Apollo_DB_User}, password correct."
    else
		Echo_Red "Sorry, Apollo_DB_User or password notcorrect! install failed!"
		return -1;
	fi
	echo "import apollo init sql..."
	Do_Query "source apolloconfigdb.sql"
	Do_Query "source apolloportaldb.sql"
	echo "show database..."
	Do_Query "show databases;"
	echo "update ApolloConfigDB.ServerConfig Set Apollo_ConfigService_Port=${Apollo_ConfigService_Port}"
	Do_Query "UPDATE ApolloConfigDB.ServerConfig SET \`Value\`='http://localhost:${Apollo_ConfigService_Port}/eureka/' WHERE \`Key\`='eureka.service.url';"
	Do_Query "SELECT * FROM ApolloConfigDB.ServerConfig WHERE \`Key\`='eureka.service.url';"
	echo "update ApolloConfigDB.ServerConfig Successful!"
	Echo_Green "import apollo init sql success..."
}

Apollo_Install_configservice(){
    echo "====== Apollo_Install_configservice ======"
	Download_Files ${YUSP_Download_Mirror}/apollo-configservice-${Apollo_Ver}-github.zip apollo-configservice-${Apollo_Ver}-github.zip
	unzip apollo-configservice-${Apollo_Ver}-github.zip -d apollo-configservice-${Apollo_Ver}
	echo "mv apolloconfig to ${Apollo_Install_Dir} ..." 
	rm -rf /usr/local/apollo-configservice*
	mv apollo-configservice-${Apollo_Ver} ${Apollo_Install_Dir}
	cd ${Apollo_Install_Dir}apollo-configservice-${Apollo_Ver}
	sed -i "s#fill-in-the-correct-server#localhost#" config/application-github.properties
	sed -i "s#FillInCorrectUser#${Apollo_DB_User}#" config/application-github.properties
	sed -i "s#FillInCorrectPassword#${Apollo_DB_Password}#" config/application-github.properties
	sed -i "s#SERVER_PORT=8080#SERVER_PORT=${Apollo_ConfigService_Port}#" scripts/startup.sh
	sh  ${Apollo_Install_Dir}apollo-configservice-${Apollo_Ver}/scripts/startup.sh
	if [ $? -eq 0 ]; then
        Echo_Green "OK, ====== Apollo_Install_configservice Successful!!======"
    else
		Echo_Red "Sorry, Apollo_Install_configservice failed! please check you operation and try again!"
		return -1;
	fi
}

Apollo_Install_adminservice(){
    echo "====== Apollo_Install_adminservice ======"
	Download_Files ${YUSP_Download_Mirror}/apollo-adminservice-${Apollo_Ver}-github.zip apollo-adminservice-${Apollo_Ver}-github.zip
	unzip apollo-adminservice-${Apollo_Ver}-github.zip -d apollo-adminservice-${Apollo_Ver}
	echo "mv apolloadminservice to ${Apollo_Install_Dir} ..." 
	rm -rf ${Apollo_Install_Dir}apollo-adminservice*
	mv apollo-adminservice-${Apollo_Ver} ${Apollo_Install_Dir}
	cd ${Apollo_Install_Dir}apollo-adminservice-${Apollo_Ver}
	sed -i "s#fill-in-the-correct-server#localhost#" config/application-github.properties
	sed -i "s#FillInCorrectUser#${Apollo_DB_User}#" config/application-github.properties
	sed -i "s#FillInCorrectPassword#${Apollo_DB_Password}#" config/application-github.properties
	sed -i "s#SERVER_PORT=8090#SERVER_PORT=${Apollo_AdminService_Port}#" scripts/startup.sh
	sh  ${Apollo_Install_Dir}apollo-adminservice-${Apollo_Ver}/scripts/startup.sh
	if [ $? -eq 0 ]; then
        Echo_Green "OK, ====== Apollo_Install_adminservice Successful!!======"
    else
		Echo_Red "Sorry, Apollo_Install_adminservice failed! please check you operation and try again!"
		return -1;
	fi
}

Apollo_Install_portal(){
    echo "====== Apollo_Install_portal ======"
	Download_Files ${YUSP_Download_Mirror}/apollo-portal-${Apollo_Ver}-github.zip apollo-portal-${Apollo_Ver}-github.zip
	unzip apollo-portal-${Apollo_Ver}-github.zip -d apollo-portal-${Apollo_Ver}
	echo "mv apolloportal to ${Apollo_Install_Dir} ..." 
	rm -rf ${Apollo_Install_Dir}apollo-portal*
	mv apollo-portal-${Apollo_Ver} /usr/local/
	cd ${Apollo_Install_Dir}apollo-portal-${Apollo_Ver}
	sed -i "s#fill-in-the-correct-server#localhost#" config/application-github.properties
	sed -i "s#FillInCorrectUser#${Apollo_DB_User}#" config/application-github.properties
	sed -i "s#FillInCorrectPassword#${Apollo_DB_Password}#" config/application-github.properties
	sed -i "s#SERVER_PORT=8070#SERVER_PORT=${Apollo_Portal_Port}#" scripts/startup.sh
	sed -i "s#fill-in-dev-meta-server:8080#localhost:${Apollo_ConfigService_Port}#" config/apollo-env.properties
	sh  ${Apollo_Install_Dir}apollo-portal-${Apollo_Ver}/scripts/startup.sh
	if [ $? -eq 0 ]; then
        Echo_Green "OK, ====== Apollo_Install_portal Successful!!======"
    else
		Echo_Red "Sorry, Apollo_Install_portal failed! please check you operation and try again!"
		return -1;
	fi
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
	sh  ${Apollo_Install_Dir}apollo-configservice-${Apollo_Ver}/scripts/shutdown.sh
	sh  ${Apollo_Install_Dir}apollo-adminservice-${Apollo_Ver}/scripts/shutdown.sh
	sh  ${Apollo_Install_Dir}apollo-portal-${Apollo_Ver}/scripts/shutdown.sh
	Sleep_Sec 3
    echo "Delete Apollo files..."
    rm -rf ${Apollo_Install_Dir}apollo*
    Echo_Green "Uninstall Apollo completed."
}