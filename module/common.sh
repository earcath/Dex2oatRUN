#!/system/bin/sh
MODDIR=${0%/*}
DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

function read_config(){	#读取配置
	system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
	tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
	optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
	newAPP_3=$(pm list packages -3)
	newAPP_S=$(pm list packages -s)
	newID=$(getprop ro.system.build.id)
}

function write_config(){
	touch $MODDIR/newapp-3.list
	touch $MODDIR/newapp-S.list
	touch $MODDIR/new.id
	echo $newAPP_3 >$MODDIR/newapp-3.list
	echo $newAPP_S >$MODDIR/newapp-S.list
	echo $newID >$MODDIR/new.id
}

function start_compare(){
	if [[ -z $(cmp $MODDIR/old.id $MODDIR/new.id) ]]; then
		log "D" "*没有更新系统"
	else
		touch $MODDIR/systemupdate
		log "D" "*更新了系统"
	fi
	if [[ -z $(cmp $MODDIR/oldapp-S.list $MODDIR/newapp-S.list) ]]; then
		log "D" "*没有安装或卸载系统应用"
	else
		touch $MODDIR/appchange-S
		log "D" "*安装或卸载了系统应用"
	fi
	if [[ -z $(cmp $MODDIR/oldapp-3.list $MODDIR/newapp-3.list) ]]; then
		log "D" "*没有安装或卸载三方应用"
	else
		touch $MODDIR/appchange-3
		log "D" "*安装或卸载了三方应用"
	fi
	if [ -e $MODDIR/moduleupdate ]; then
		log "D" "*安装或更新了模块"
		log "I" "*强制进行编译"
	fi
}

function run_dex2oat(){	#运行
	log "I" "*开始第$count次运行！"
	if [[ "$system_app" != "无" && -e $MODDIR/appchange-S ]] || [[ "$system_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$system_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "D" "*系统应用编译模式：$system_app"
		log "I" "*开始编译系统应用！"
		source $MODDIR/mode/dexapp-S.sh
		echo $newAPP_S >$MODDIR/oldapp-S.list
		log "I" "*系统应用编译完毕！"
	fi
	if [[ "$tripartite_app" != "无" && -e $MODDIR/appchange-3 ]] || [[ "$tripartite_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$tripartite_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "D" "*三方应用编译模式：$tripartite_app"
		log "I" "*开始编译三方应用！"
		source $MODDIR/mode/dexapp-3.sh
		echo $newAPP_3 >$MODDIR/oldapp-3.list
		log "I" "*三方应用编译完毕！"
	fi
	if [[ "$optional_app" != "无" && -e $MODDIR/appchange-3 ]] || [[ "$optional_app" != "无" && -e $MODDIR/appchange-S ]] || [[ "$optional_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$optional_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "D" "*自选应用编译模式：$optional_app"
		log "I" "*开始编译自选应用！"
		source $MODDIR/mode/dexapp-O.sh
		echo $newAPP_S >$MODDIR/oldapp-S.list
		echo $newAPP_3 >$MODDIR/oldapp-3.list
		log "I" "*自选应用编译完毕！"
	fi
	if [[ "$system_app" = "无" && "$tripartite_app" = "无" && "$optional_app" = "无" ]]; then
		log "W" "*未选择应用！"
	fi
	log "I" "*运行完毕！"
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
	if [ -e $MODDIR/执行次数.txt ];then
		count=$(cat $MODDIR/执行次数.txt)
	fi
}

function counter_increase(){	#计数
	count=$((count+1))
	echo $count >$MODDIR/执行次数.txt
}

function delete_change(){
	rm -rf $MODDIR/moduleupdate
}

function end(){
	ends=$(grep -o '编译成功' /data/adb/Dex2oatRUN/日志.log | wc -l)
	endf=$(grep -o '编译失败' /data/adb/Dex2oatRUN/日志.log | wc -l)
	log "I" "*本次运行结果：成功：$ends；失败：$endf"
}

read_config
write_config
start_compare
log_size
counter
run_dex2oat
notification_simulation "dex2oat模块" "编译完成！"
counter_increase
delete_change
end

