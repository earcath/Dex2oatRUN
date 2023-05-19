#!/system/bin/sh
MODDIR=${0%/*}

function read_config(){
	DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
	boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
	timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')
	run_time=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时执行时间=" | cut -f2 -d '=')
}


function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") : ${1}" >>/data/adb/Dex2oatRUN/日志.log
}

function boot(){
	log "设备已开机"
	if [ "$boot_operation" = "是" ]; then
		log "开机运行已开启"
		sleep 120
		sh $MODDIR/common.sh
	fi
}

function timing(){
	if [ "$timing_operation" = "是" ]; then
		log "定时运行已开启"
		echo "$run_time * * * sh ../common.sh" >$MODDIR/cron.d/root
		export PATH="/system/bin:/system/xbin:/vendor/bin:$(magisk --path)/.magisk/busybox:$PATH"
		crond -c $MODDIR/cron.d
		log "定时服务已启动"
	fi
}

read_config
boot
timing

