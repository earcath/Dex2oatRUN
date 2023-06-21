#!/system/bin/sh
MODDIR=${0%/*}

DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"
system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')
newid=$(getprop ro.system.build.id)
touch $MODDIR/new.id
echo $newid > $MODDIR/new.id

if [ !-z $(cmp $MODDIR/old.id $MODDIR/new.id) ]; then
	rm -rf $MODDIR/mode/done-S.list
	rm -rf $MODDIR/mode/done-3.list
	rm -rf $MODDIR/mode/done-O.list
	rm -rf $MODDIR/mode/black.list
	echo $newid > $MODDIR/old.id
fi

# 重建日志
rm -rf /data/adb/Dex2oatRUN/日志.log
touch /data/adb/Dex2oatRUN/日志.log

function log(){
	echo "[ $(date "+%Y-%m-%d %H:%M:%S") ] ${1}" >> /data/adb/Dex2oatRUN/日志.log
}

function dexapp_3(){
	touch $MODDIR/package-3.list
	touch $MODDIR/done-3.list
	touch $MODDIR/black.list
	Package3=$(pm list packages -3 | grep "^package:" | cut -f2 -d ':')
	rm -r $MODDIR/package-3.list
	for i in $Package3
		do
			echo $i >> $MODDIR/package-3.list
		done
	sort done-3.list > done-3_sorted.list
	sort package-3.list > package-3_sorted.list
	sort black.list > black_sorted.list
	comm -23 package-3_sorted.list done-3_sorted.list > result_sorted.list
	comm -23 result_sorted.list black_sorted.list > result.list
	Package3=$(sed '/^#/d' "$MODDIR/result.list")
	if [ "$tripartite_app" = "verify" ]; then
		for i in $Package3
			do
				cmd package compile -m verify $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "quicken" ]; then
		for i in $Package3
			do
				cmd package compile -m quicken $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space-profile" ]; then
		for i in $Package3
			do
				cmd package compile -m space-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space" ]; then
		for i in $Package3
			do
				cmd package compile -m space $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed-profile" ]; then
		for i in $Package3
			do
				cmd package compile -m speed-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed" ]; then
		for i in $Package3
			do
				cmd package compile -m speed $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "everything" ]; then
		for i in $Package3
			do
				cmd package compile -m everything $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-3.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	fi
}

function dexapp_S(){
	touch $MODDIR/package-S.list
	touch $MODDIR/done-S.list
	touch $MODDIR/black.list
	PackageS=$(pm list packages -S | grep "^package:" | cut -f2 -d ':')
	rm -r $MODDIR/package-S.list
	for i in $PackageS
		do
			echo $i >> $MODDIR/package-S.list
		done
	sort done-S.list > done-S_sorted.list
	sort package-S.list > package-S_sorted.list
	sort black.list > black_sorted.list
	comm -23 package-S_sorted.list done-S_sorted.list > 	result_sorted.list
	comm -23 result_sorted.list black_sorted.list > result.list
	PackageS=$(sed '/^#/d' "$MODDIR/result.list")
	if [ "$tripartite_app" = "verify" ]; then
		for i in $PackageS
			do
				cmd package compile -m verify $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "quicken" ]; then
		for i in $PackageS
			do
				cmd package compile -m quicken $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space-profile" ]; then
		for i in $PackageS
			do
				cmd package compile -m space-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space" ]; then
		for i in $PackageS
			do
				cmd package compile -m space $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed-profile" ]; then
		for i in $PackageS
			do
				cmd package compile -m speed-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed" ]; then
		for i in $PackageS
			do
				cmd package compile -m speed $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "everything" ]; then
		for i in $PackageS
			do
				cmd package compile -m everything $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-S.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	fi
}

function dexapp_O(){
	touch $MODDIR/package-O.list
	touch $MODDIR/done-O.list
	touch $MODDIR/black.list
	PackageO=$(sed '/^#/d' "$OPTIONALAPP_CONFIG")
	rm -r $MODDIR/package-O.list
	for i in $PackageO
		do
			echo $i >> $MODDIR/package-O.list
		done
	sort done-O.list > done-O_sorted.list
	sort package-O.list > package-O_sorted.list
	sort black.list > black_sorted.list
	comm -23 package-O_sorted.list done-O_sorted.list > result_sorted.list
	comm -23 result_sorted.list black_sorted.list > result.list
	PackageO=$(sed '/^#/d' "$MODDIR/result.list")
	if [ "$tripartite_app" = "verify" ]; then
		for i in $PackageO
			do
				cmd package compile -m verify $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "quicken" ]; then
		for i in $PackageO
			do
				cmd package compile -m quicken $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space-profile" ]; then
		for i in $PackageO
			do
				cmd package compile -m space-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "space" ]; then
		for i in $PackageO
			do
				cmd package compile -m space $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed-profile" ]; then
		for i in $PackageO
			do
				cmd package compile -m speed-profile $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "speed" ]; then
		for i in $PackageO
			do
				cmd package compile -m speed $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	elif [ "$tripartite_app" = "everything" ]; then
		for i in $PackageO
			do
				cmd package compile -m everything $i
				if [ "${?}" = "0" ]; then
					log "应用$i编译成功！"
					echo $i >> $MODDIR/done-O.list
				else
					log "应用$i编译失败！"
					echo $i >> $MODDIR/black.list
				fi
			done
	fi
}

#开始执行dex2oat
if [ "$system_app" != "无" ]; then
	log "系统应用编译模式：$system_app"
	dexapp_S
fi
if [ "$tripartite_app" != "无" ]; then
	log "三方应用编译模式：$tripartite_app"
	dexapp_3
fi
if [ "$optional_app" != "无" ]; then
	log "自选应用编译模式：$optional_app"
	dexapp_O
fi

#统计结果
ends=$(grep -o '编译成功' /data/adb/Dex2oatRUN/日志.log | wc -l)
endf=$(grep -o '编译失败' /data/adb/Dex2oatRUN/日志.log | wc -l)
log "本次运行结果：成功：$ends；失败：$endf

