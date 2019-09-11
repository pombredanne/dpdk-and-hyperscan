#!/bin/sh

#current directory
CURR_DIR=$(cd $(dirname $0); pwd)

#RTE_SDK path
RTE_SDK_PATH=$(find $CURR_DIR -type d -name "dpdk-stable*" -print)

#RTE_TARGET path
#basename去掉路径
RTE_TARGET_PATH=$(basename `find $CURR_DIR -type d -name "*native-linuxapp*" -print`)

#当前用户家目录
USER_HOME_DIRECTORY=$(cd ~; pwd)

#~/.bash_profile路径
PROFILE_PATH=$(find $USER_HOME_DIRECTORY -type f -name ".bash_profile" -print)

#设置环境变量RTE_SDK、RTE_TARGET、EXTRA_CFLAGS到配置文件，需要使用source ~/.bash_profile使之生效
function set_compile_env()
{
	if [ -z $RTE_SDK ]; then
		echo "RTE_SDK is NULL,set it now!"
        	echo RTE_SDK=$RTE_SDK_PATH >> $PROFILE_PATH
		echo "export RTE_SDK" >> $PROFILE_PATH
	else
		echo "RTE_SDK set success!"
	fi

	if [ -z $RTE_TARGET ]; then
		echo RTE_TARGET is NULL,set it now!
        	echo RT_TARGET=$RTE_TARGET_PATH >> $PROFILE_PATH
		echo "export RTE_TARGET" >> $PROFILE_PATH
	else
		echo "RTE_TARGET set success!"
	fi

	if [ -z $EXTRA_CFLAGS ]; then
		echo "EXTRA_CFLAGS is NULL,set it now!"
        	echo EXTRA_CFLAGS="\"-O0 -g\"" >> $PROFILE_PATH
		echo "export EXTRA_CFLAGS" >> $PROFILE_PATH
	else
		echo "EXTRA_CFLAGS set success!"
	fi
}

#设置环境变量
set_compile_env
