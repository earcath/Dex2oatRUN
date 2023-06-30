#!/system/bin/sh
MODDIR=${0%/*}

DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

log_file="/data/adb/Dex2oatRUN/日志.log"

system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')

newid=$(getprop ro.system.build.id)
newpkg=$(pm list packages | grep "^package:" | cut -f2 -d ':')
tripartiteapp=$(pm list packages -3 | grep "^package:" | cut -f2 -d ':')
systemapp=$(pm list packages -s | grep "^package:" | cut -f2 -d ':')

touch "$MODDIR/old.id"
touch "$MODDIR/old.pkg"
> "$MODDIR/sapp.txt"
> "$MODDIR/3app.txt"
> "$MODDIR/new.id"
> "$MODDIR/new.pkg"
echo "$tripartiteapp" > "$MODDIR/3app.txt"
echo "$systemapp" > "$MODDIR/sapp.txt"
echo "$newid" > "$MODDIR/new.id"
echo "$newpkg" > "$MODDIR/new.pkg"

if [ ! -z "$(cmp "$MODDIR/old.id" "$MODDIR/new.id")" ] || [ ! -z "$(cmp "$MODDIR/old.pkg" "$MODDIR/new.pkg")" ]; then
    > "$MODDIR/updated"
    echo "$newid" > "$MODDIR/old.id"
    echo "$newpkg" > "$MODDIR/old.pkg"
fi

# 重建日志
> "$log_file"

log() {
    printf "[%s] %s\n" "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> "$log_file"
}

compile_package() {
    local mode="$1"
    local pkg="$2"
    cmd package compile -m "$mode" "$pkg"
    if [ "$?" = "0" ]; then
        log "应用$pkg编译成功！"
        echo "$pkg" >> "$done_file"
    else
        log "应用$pkg编译失败！"
    fi
}

compile_applications() {
    local app_type="$1"
    local app_mode="$2"
    local app_config="$3"

    if [ "$app_mode" != "无" ]; then
        log "$app_type应用编译模式：$app_mode"

        while IFS= read -r pkg; do
            compile_package "$app_mode" "$pkg"
        done < "$app_config"
    fi
}

if [ -e "$MODDIR/updated" ]; then
    # 开始执行dex2oat
    compile_applications "系统" "$system_app" "$MODDIR/sapp.txt"
    compile_applications "三方" "$tripartite_app" "$MODDIR/3app.txt"
    compile_applications "自选" "$optional_app" "$OPTIONALAPP_CONFIG"

    # 统计结果
    ends=$(grep -o '编译成功' "$log_file" | wc -l)
    endf=$(grep -o '编译失败' "$log_file" | wc -l)
    log "本次运行结果：成功：$ends；失败：$endf"

    rm -r "$MODDIR/updated"
else
    log "没有更新"
fi
