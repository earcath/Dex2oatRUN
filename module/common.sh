#!/system/bin/sh
MODDIR=${0%/*}

function read_config(){	#读取配置
	DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"
	system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
	tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
	optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
	newid=$(getprop ro.system.build.id)
}

function write_config(){
	touch $MODDIR/new.id
	echo $newid > $MODDIR/new.id
}

function start_compare(){
	if [ -z $(cmp $MODDIR/old.id $MODDIR/new.id) ]; then
		log "没有更新系统"
	else
		log "更新了系统"
		rm -rf $MODDIR/mode/done-S.list
		rm -rf $MODDIR/mode/done-3.list
		rm -rf $MODDIR/mode/done-O.list
		rm -rf $MODDIR/mode/black.list
		echo $newid > $MODDIR/old.id
	fi
}

function run_dex2oat(){	#运行
	if [ "$system_app" != "无" ]; then
		log "系统应用编译模式：$system_app"
		source $MODDIR/mode/dexapp-S.sh
	fi
	if [ "$tripartite_app" != "无" ]; then
		log "三方应用编译模式：$tripartite_app"
		source $MODDIR/mode/dexapp-3.sh
	fi
	if [ "$optional_app" != "无" ]; then
		log "自选应用编译模式：$optional_app"
		source $MODDIR/mode/dexapp-O.sh
	fi
	if [ "$system_app" = "无" && "$tripartite_app" = "无" && "$optional_app" = "无" ]; then
		log "未选择应用"
	fi
}

function rewrite_log(){
	rm -rf /data/adb/Dex2oatRUN/日志.log
	touch /data/adb/Dex2oatRUN/日志.log
}

function log(){	#日志
	echo "[ $(date "+%Y-%m-%d %H:%M:%S") ] ${1}" >> /data/adb/Dex2oatRUN/日志.log
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
end

