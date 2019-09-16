#!/bin/sh

#当前工作目录
CURR_DIR=$(cd $(dirname $0); pwd)

#RTE_SDK路径
RTE_SDK_PATH=$(find $CURR_DIR -type d -name "dpdk-stable*" -print)

#RTE_TARGET路径
RTE_TARGET_PATH=$(basename `find $CURR_DIR -type d -name "*native-linuxapp*" -print`)

#当前用户家目录
USER_HOME_DIRECTORY=$(cd ~; pwd)

#~/.bash_profile路径
PROFILE_PATH=$(find $USER_HOME_DIRECTORY -type f -name ".bash_profile" -print)

#设置环境变量RTE_SDK、RTE_TARGET、EXTRA_CFLAGS到配置文件
function set_compile_env()
{
	if [ -z "$RTE_SDK" ]; then
        	echo RTE_SDK="$RTE_SDK_PATH" >> $PROFILE_PATH
		echo "export RTE_SDK" >> $PROFILE_PATH
	fi

	if [ -z "$RTE_TARGET" ]; then
        	echo RTE_TARGET="$RTE_TARGET_PATH" >> $PROFILE_PATH
		echo "export RTE_TARGET" >> $PROFILE_PATH
	fi
	
	if [ -z "$EXTRA_CFLAGS" ]; then
		echo EXTRA_CFLAGS="\"-O0 -g\"" >> $PROFILE_PATH
		echo "export EXTRA_CFLAGS" >> $PROFILE_PATH
	fi
}

#设置环境变量
if [[ -z "$(sed -n '/RTE_*/p' $PROFILE_PATH)" ]] || [[ -z $(sed -n '/EXTRA_CFLAGS/p' $PROFILE_PATH) ]]; then
	set_compile_env
fi

#检测环境变量是否设置成功
if [[ -n "$RTE_SDK" ]] && [[ -n "$RTE_TARGET" ]] && [[ -n $EXTRA_CFLAGS ]]; then
	echo "DPDK compile envirnoment set success"
fi
