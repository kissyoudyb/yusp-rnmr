#!/bin/bash

Install_Nexus()
{
    echo "====== Installing Nexus ======"
    echo "Install ${Nexus_Ver} Version..."
    Press_Start

    cd ${cur_dir}/src
	#安装前检查
	Nexus_Check_Install_Condition
	#安装Nexus
	Nexus_Install
	#把Nexus安装为linux服务TODO
	#Nexus_Add_AutoStartup
}

Nexus_Check_Install_Condition()
{
    echo "====== Nexus_Check_Install_Condition ======"
	source /etc/profile
	java -version
	if [ $? -eq 0 ]; then
	    Echo_Green "OK, Nexus install condition check success! going on..."
	else
		Echo_Red "Sorry, Nexus need jdk1.8+! please install jdk1.8+ first!"
		return -1;
	fi
}

Nexus_Install()
{
    echo "====== Nexus_Install ======"
	Download_Files ${YUSP_Download_Mirror}/nexus-${Nexus_Ver}-unix.tar.gz nexus-${Nexus_Ver}-unix.tar.gz
	rm -rf /usr/local/nexus*
	tar -xvf nexus-${Nexus_Ver}-unix.tar.gz -C ${Nexus_Install_Dir}nexus-${Nexus_Ver}	
	${Nexus_Install_Dir}nexus-${Nexus_Ver}/bin/nexus start
	if [ $? -eq 0 ]; then
        Echo_Green "OK, ====== Nexus_Install Successful!!======"
    else
		Echo_Red "Sorry, Nexus_Install failed! please check you operation and try again!"
		return -1;
	fi
}

Nexus_Add_AutoStartup(){
	#TODO 目前如下的实现无法搞
	cp ${Nexus_Install_Dir}nexus-${Nexus_Ver}/bin/nexus /etc/init.d/nexus
    chmod +x /etc/init.d/nexus
    echo "Add Nexus to auto startup..."
    StartUp nexus
    #启动nexus
    /etc/init.d/nexus start
	if [ $? -eq 0 ]; then
	    Echo_Green "====== Add Nexus Auto Startup Successful! ======"
		Echo_Green "Nexus installed successfully, enjoy it!"
    else
        Echo_Red "Nexus install failed!"
    fi
}

Uninstall_Nexus()
{
    echo "You will uninstall Nexus..."
	echo "Shutting down Nexus..."
	${Nexus_Install_Dir}nexus-${Nexus_Ver}/bin/nexus stop
	Remove_StartUp nexus
    echo "Delete Nexus files..."
    rm -rf ${Nexus_Install_Dir}nexus*
	rm -rf /etc/init.d/nexus
    Echo_Green "Uninstall Nexus completed."
}