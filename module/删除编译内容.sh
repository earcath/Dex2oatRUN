log_file="/data/adb/Dex2oatRUN/日志.log"

log() {
    printf "[%s] %s\n" "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> "$log_file"
}

cmd package compile --reset -a

log "编译删除完毕"
