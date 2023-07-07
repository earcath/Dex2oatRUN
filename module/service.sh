#!/system/bin/sh
MODDIR=${0%/*}

DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"

export PATH="$(magisk --path)/.magisk/busybox:$PATH"

boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')
run_time=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行时间=" | cut -f2 -d '=')

if [ "$boot_operation" = "是" ]; then
    sleep 120

    sh "$MODDIR/common.sh"
fi

if [ "$timing_operation" = "是" ]; then
    echo "$run_time * * * sh $MODDIR/common.sh" > "$MODDIR/cron.d/root"

    crond -c "$MODDIR/cron.d"
fi
