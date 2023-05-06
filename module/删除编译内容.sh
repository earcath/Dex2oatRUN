DEX2OAT_LOG="/data/adb/Dex2oatRUN/日志.log"
cmd package compile --reset -a &
echo "$(date "+%Y-%m-%d %H:%M:%S") [I] : *已删除全部应用编译内容" >>$DEX2OAT_LOG

