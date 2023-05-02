#!/system/bin/sh
MODDIR=${0%/*}
DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

function read_config(){	#读取配置
	system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
	tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
	optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
}

function run_dex2oat(){	#运行
	log "I" "----------开始第$count次运行！----------"
	if [ "$system_app" != "无" ]; then
		log "D" "----------系统应用编译模式：$system_app----------"
		log "I" "----------开始编译系统应用！----------"
		source $MODDIR/mode/sapp.sh
		log "I" "----------系统应用编译完毕！----------
	fi
	if [ "$tripartite_app" != "无" ]; then
		log "D" "----------三方应用编译模式：$tripartite_app----------"
		log "I" "----------开始编译三方应用！----------"
		source $MODDIR/mode/3app.sh
		log "I" "----------三方应用编译完毕！----------"
	fi
	if [ "$optional_app" != "无" ]; then
		log "D" "----------自选应用编译模式：$optional_app----------"
		log "I" "----------开始编译自选应用！----------"
		source $MODDIR/mode/oapp.sh
		log "I" "----------自选应用编译完毕！----------"
	fi
	if [[ "$system_app" = "无" && "$tripartite_app" = "无" && "$optional_app" = "无" ]]; then
		log "W" "----------未选择应用！----------"
	fi
	log "I" "----------运行完毕！----------"
}

function notification_simulation(){	#通知提醒
	local title="${1}"
	local text="${2}"
	su -lp 2000 -c "cmd notification post -S messaging --conversation '${title}' --message '':'${text}' 'Tag' '$(echo $RANDOM)' "
}

function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") [${1}] : ${2}" >>/data/adb/Dex2oatRUN/日志.log
}

function log_size(){
	find /data/adb/Dex2oatRUN/日志.log -type f -size +1024k -delete
}

function counter(){	#计数
	count=1
	if [ -f $MODDIR/执行次数.txt ];then
		count=$(cat $MODDIR/执行次数.txt)
	fi
}

function counter_increase(){	#计数
	count=$((count+1))
	echo $count >$MODDIR/执行次数.txt
}

log_size
counter
read_config
run_dex2oat
notification_simulation "dex2oat模块" "编译完成！"
counter_increase

