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
	if [ "$system_app" != "无" ]; then
		source $MODDIR/mode/sapp.sh
	elif [ "$tripartite_app" != "无" ]; then
		source $MODDIR/mode/3app.sh
	elif [ "$optional_app" != "无" ]; then
		source $MODDIR/mode/oapp.sh
	else
		log "W" "未选择应用！"
	fi
}

function notification_simulation(){	#通知提醒
	local title="${2}"
	local text="${1}"
	su -lp 2000 -c "cmd notification post -S messaging --conversation '${title}' --message 'dex2oat':'${text}' 'Tag' '$(echo $RANDOM)' " >/dev/null 2>&1
}

function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") [${1}] : ${2}"
}

read_config
log "D" "当前配置信息：
系统应用=$system_app
三方应用=$tripartite_app
自选应用=$optional_app"
log "I" "开始编译！"
run_dex2oat
log "I" "编译完成！"
notification_simulation "dex2oat模块" "编译完成！"

