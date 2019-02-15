#!/bin/bash

Install_RabbitMQ()
{
    echo "====== Installing RabbitMQ ======"
    echo "Install ${RabbitMQ_Ver} Version..."
    Press_Start

    cd ${cur_dir}/src
	#安装前检查
	RabbitMQ_Check_Install_Condition
	#安装RabbitMQ
	RabbitMQ_Install
	#把RabbitMQ安装为linux服务TODO
	RabbitMQ_Add_AutoStartup
}

RabbitMQ_Check_Install_Condition()
{
    echo "====== RabbitMQ_Check_Install_Condition ======"
	Echo_Info "Checking Erlang!..."
	erlang=`rpm -qa erlang`
	Download_Files ${YUSP_Download_Mirror}/erlang-20.2.2-1.el7.centos.x86_64.rpm erlang-20.2.2-1.el7.centos.x86_64.rpm
	if [ "x${erlang}" == "x" ]; then
		Echo_Green "OK, Erlang not install, installing Erlang..."
	else
		Echo_Green "OK, Erlang installed version: ${erlang}, uninstalling Erlang and reinstalling Erlang"
		rpm -e --nodeps ${erlang}
	fi
	yum -y install erlang-20.2.2-1.el7.centos.x86_64.rpm
	
	Echo_Info "Checking Socat!..."
	Download_Files ${YUSP_Download_Mirror}/socat-1.7.3.2-2.el7.x86_64.rpm socat-1.7.3.2-2.el7.x86_64.rpm
	if [ "x${socat}" == "x" ]; then
		Echo_Green "OK, socat not install, installing socat..."
	else
		Echo_Green "OK, socat installed version: ${socat}, uninstalling socat and reinstalling socat"
		rpm -e --nodeps ${socat}
	fi
	yum -y install socat-1.7.3.2-2.el7.x86_64.rpm
	
	Echo_Info "Checking rabbitmq-server!..."
	if [ "x${rabbitmq-server}" == "x" ]; then
		Echo_Green "OK, rabbitmq-server not install"
	else
		Echo_Green "OK, socat installed version: ${rabbitmq-server}, uninstalling rabbitmq-server"
		rpm -e --nodeps ${rabbitmq-server}
	fi
	
	if [ $? -eq 0 ]; then
	    Echo_Green "OK, RabbitMQ_Check_Install_Condition success! going on..."
	else
		Echo_Red "Sorry, RabbitMQ_Check_Install_Condition failed! please check your operation!"
		return -1;
	fi
}

RabbitMQ_Install()
{
    echo "====== RabbitMQ_Install ======"
	Download_Files ${YUSP_Download_Mirror}/rabbitmq-server-3.7.3-1.el7.noarch.rpm rabbitmq-server-3.7.3-1.el7.noarch.rpm
	yum -y install rabbitmq-server-3.7.3-1.el7.noarch.rpm
	if [ $? -eq 0 ]; then
        Echo_Green "OK, ====== RabbitMQ_Install Successful!!======"
    else
		Echo_Red "Sorry, RabbitMQ_Install failed! please check you operation and try again!"
		return -1;
	fi
}

RabbitMQ_Add_AutoStartup(){
	#yum 安装的rabbitmq已经实现了服务化
	systemctl enable rabbitmq-server.service 
    #rabbitmq
    systemctl start rabbitmq-server
	systemctl status rabbitmq-server
	if [ $? -eq 0 ]; then
	    Echo_Green "====== Add RabbitMQ Auto Startup Successful! ======"
		Echo_Green "RabbitMQ installed and start successfully, enjoy it!"
    else
        Echo_Red "RabbitMQ install failed!"
    fi
}

Uninstall_RabbitMQ()
{
    echo "You will uninstall RabbitMQ..."
	echo "Shutting down RabbitMQ..."
	systemctl stop rabbitmq-server
	systemctl disable rabbitmq-server.service
    echo "Delete RabbitMQ files..."
	rpm -e --nodeps rabbitmq-server-3.7.3-1.el7.noarch.rpm
    Echo_Green "Uninstall RabbitMQ completed."
}