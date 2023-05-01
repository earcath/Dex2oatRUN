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
	log "I" "开始编译！"
	log "D" "当前配置信息： 系统应用=$system_app； 三方应用=$tripartite_app； 自选应用=$optional_app"
	if [ "$system_app" != "无" ]; then
		source $MODDIR/mode/sapp.sh
	fi
	if [ "$tripartite_app" != "无" ]; then
		source $MODDIR/mode/3app.sh
	fi
	if [ "$optional_app" != "无" ]; then
		source $MODDIR/mode/oapp.sh
	fi
	if [[ "$system_app" = "无" && "$tripartite_app" = "无" && "$optional_app" = "无" ]]; then
		log "W" "未选择应用！"
	fi
}

function notification_simulation(){	#通知提醒
	local title="${1}"
	local text="${2}"
	su -lp 2000 -c "cmd notification post -S messaging --conversation '${title}' --message '':'${text}' 'Tag' '$(echo $RANDOM)' " >/dev/null 2>&1
}

function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") [${1}] : ${2}" >>/data/adb/Dex2oatRUN/日志.log 2>&1
}

find /data/adb/Dex2oatRUN/日志.log -type f -size +100k -delete
read_config
run_dex2oat
notification_simulation "dex2oat模块" "编译完成！"

