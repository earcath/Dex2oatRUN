#!/system/bin/sh
MODDIR=${0%/*}

function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") [${1}] : ${2}" >>/data/adb/Dex2oatRUN/日志.log
}

function read_config(){
	newp=$(pm list packages)
	newi=$(getprop ro.system.build.id)
}

function write_config(){
	touch $MODDIR/compare/new.list
	touch $MODDIR/compare/new.id
	echo $newp >$MODDIR/compare/new.list
	echo $newi >$MODDIR/compare/new.id
}

function start_compare(){
	if [[ -z $(cmp $MODDIR/compare/old.list $MODDIR/compare/new.list) ]]; then
		log "I" "----------没有安装或卸载应用----------"
	else
		touch $MODDIR/compare/OK
		echo $newp >$MODDIR/compare/old.list
		log "I" "----------安装或卸载了应用----------"
	fi
	if [[ -z $(cmp $MODDIR/compare/old.id $MODDIR/compare/new.id) ]]; then
		log "I" "----------没有更新系统----------"
	else
		touch $MODDIR/compare/OK
		echo $newi >$MODDIR/compare/old.id
		log "I" "----------更新了系统----------"
	fi
	if [ -f $MODDIR/compare/OK ]; then
	log "I" "----------但是刚安装完模块----------"
	fi
}

read_config
write_config
start_compare

