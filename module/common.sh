#!/system/bin/sh
MODDIR=${0%/*}

function read_config(){	#读取配置
	DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"
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
		log "没有更新系统"
	else
		touch $MODDIR/systemupdate
		log "更新了系统"
	fi
	if [[ -z $(cmp $MODDIR/oldapp-S.list $MODDIR/newapp-S.list) ]]; then
		log "没有安装或卸载系统应用"
	else
		touch $MODDIR/appchange-S
		log "安装或卸载了系统应用"
	fi
	if [[ -z $(cmp $MODDIR/oldapp-3.list $MODDIR/newapp-3.list) ]]; then
		log "没有安装或卸载三方应用"
	else
		touch $MODDIR/appchange-3
		log "安装或卸载了三方应用"
	fi
	if [ -e $MODDIR/moduleupdate ]; then
		log "安装或更新了模块"
		log "强制进行编译"
	fi
}

function run_dex2oat(){	#运行
	if [[ "$system_app" != "无" && -e $MODDIR/appchange-S ]] || [[ "$system_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$system_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "系统应用编译模式：$system_app"
		log "开始编译系统应用！"
		source $MODDIR/mode/dexapp-S.sh
		echo $newAPP_S >$MODDIR/oldapp-S.list
		log "系统应用编译完毕！"
	fi
	if [[ "$tripartite_app" != "无" && -e $MODDIR/appchange-3 ]] || [[ "$tripartite_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$tripartite_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "三方应用编译模式：$tripartite_app"
		log "开始编译三方应用！"
		source $MODDIR/mode/dexapp-3.sh
		echo $newAPP_3 >$MODDIR/oldapp-3.list
		log "三方应用编译完毕！"
	fi
	if [[ "$optional_app" != "无" && -e $MODDIR/appchange-3 ]] || [[ "$optional_app" != "无" && -e $MODDIR/appchange-S ]] || [[ "$optional_app" != "无" && -e $MODDIR/moduleupdate ]] || [[ "$optional_app" != "无" && -e $MODDIR/systemupdate ]]; then
		log "自选应用编译模式：$optional_app"
		log "开始编译自选应用！"
		source $MODDIR/mode/dexapp-O.sh
		echo $newAPP_S >$MODDIR/oldapp-S.list
		echo $newAPP_3 >$MODDIR/oldapp-3.list
		log "自选应用编译完毕！"
	fi
	if [[ "$system_app" = "无" && "$tripartite_app" = "无" && "$optional_app" = "无" ]]; then
		log "未选择应用！"
	fi
	log "运行完毕！"
}

function rewrite_log(){
	rm -rf /data/adb/Dex2oatRUN/日志.log
	touch /data/adb/Dex2oatRUN/日志.log
}

function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") : ${1}" >>/data/adb/Dex2oatRUN/日志.log
}

function delete_mup(){
	rm -rf $MODDIR/moduleupdate
}

function end(){
	ends=$(grep -o '编译成功' /data/adb/Dex2oatRUN/日志.log | wc -l)
	endf=$(grep -o '编译失败' /data/adb/Dex2oatRUN/日志.log | wc -l)
	log "本次运行结果：成功：$ends；失败：$endf"
}

rewrite_log
read_config
write_config
start_compare
run_dex2oat
delete_mup
end

