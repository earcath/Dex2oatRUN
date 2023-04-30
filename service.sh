#!/system/bin/sh
MODDIR=${0%/*}
DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')

echo "" > /data/adb/Dex2oatRUN/日志.log

if [ "$boot_operation" = "是" ]; then
nohup /data/adb/modules/Dex2oatRUN/common.sh >/data/adb/Dex2oatRUN/日志.log 2>&1 &
elif [ "$timing_operation" = "是" ]; then
export PATH="/system/bin:/system/xbin:/vendor/bin:$(magisk --path)/.magisk/busybox:$PATH"
crond -c $MODDIR/cron.d
fi

