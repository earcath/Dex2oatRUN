#!/system/bin/sh
MODDIR=${0%/*}
DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')

rm -rf /data/adb/Dex2oatRUN/日志.log
touch /data/adb/Dex2oatRUN/日志.log

echo "$(date "+%Y-%m-%d %H:%M:%S") [I] : ----------设备已开机----------" >>/data/adb/Dex2oatRUN/日志.log

if [ "$boot_operation" = "是" ]; then
	echo "$(date "+%Y-%m-%d %H:%M:%S") [D] : ----------开机运行已开启----------" >>/data/adb/Dex2oatRUN/日志.log
	sleep 90
	sh $MODDIR/common.sh
fi
if [ "$timing_operation" = "是" ]; then
	echo "$(date "+%Y-%m-%d %H:%M:%S") [D] : ----------定时运行已开启----------" >>/data/adb/Dex2oatRUN/日志.log
	export PATH="/system/bin:/system/xbin:/vendor/bin:$(magisk --path)/.magisk/busybox:$PATH"
	crond -c $MODDIR/cron.d
	echo "$(date "+%Y-%m-%d %H:%M:%S") [I] : ----------定时服务已启动----------" >>/data/adb/Dex2oatRUN/日志.log
fi

