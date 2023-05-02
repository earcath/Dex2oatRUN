DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

#创建配置文件
mkdir /data/adb/Dex2oatRUN
if [ ! -f $DEX2OAT_CONFIG ]; then
	touch $DEX2OAT_CONFIG
fi
if [ ! -f $OPTIONALAPP_CONFIG ]; then
	touch $OPTIONALAPP_CONFIG
fi

touch /data/adb/Dex2oatRUN/删除编译内容.sh
cp $MODPATH/删除编译内容.sh /data/adb/Dex2oatRUN/删除编译内容.sh
oldp=$(pm list packages)
oldi=$(getprop ro.system.build.id)
mkdir $MODPATH/compare
touch $MODPATH/compare/old.list
touch $MODPATH/compare/old.id
echo $oldp >$MODPATH/compare/old.list
echo $oldi >$MODPATH/compare/old.id

#读取旧配置
system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
boot_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^开机运行=" | cut -f2 -d '=')
timing_operation=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^定时运行=" | cut -f2 -d '=')
Optionalapp=$(cat $OPTIONALAPP_CONFIG | grep -v '^#')

#写入配置
if [ ! -d /data/adb/modules/Dex2oatRUN ]; then
echo "#基础配置：
#可填：
#无、verify、quicken、space-profile、space、speed-profile、speed、everything
#越往后性能越好，占用空间越大。
系统应用=speed-profile
三方应用=无
自选应用=无
#运行模式：
#填：是、否
开机运行=否
定时运行=是
" >"$DEX2OAT_CONFIG"
echo "#自选应用列表（填包名，一行一个）：
" >"$OPTIONALAPP_CONFIG"
else
echo "#基础配置：
#可填：
#无、verify、quicken、space-profile、space、speed-profile、speed、everything
#越往后性能越好，占用空间越大。
系统应用=$system_app
三方应用=$tripartite_app
自选应用=$optional_app
#运行模式：
#填：是、否
开机运行=$boot_operation
定时运行=$timing_operation
" >"$DEX2OAT_CONFIG"
echo "#自选列表（填包名，一行一个）：
$Optionalapp
" >"$OPTIONALAPP_CONFIG"
fi

ui_print "- 模块会根据配置自动执行dex2oat。"
ui_print "- 配置及日志文件都在此文件夹下：/data/adb/Dex2oatBOOT"

