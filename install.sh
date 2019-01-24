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
    
