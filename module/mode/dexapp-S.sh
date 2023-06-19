function log(){	#日志
	echo "[ $(date "+%Y-%m-%d %H:%M:%S") ] ${1}" >> /data/adb/Dex2oatRUN/日志.log
}

touch ./package-S.list
touch ./done-S.list
touch ./black.list
Package=$(pm list packages -S | grep "^package:" | cut -f2 -d ':')
for i in $Package
	do
		echo "$i" >> ./package-S.list
	done
sort done-S.list > done-S_sorted.list
sort package-S.list > package-S_sorted.list
comm -23 package-S_sorted.list done-S_sorted.list > re_sult.list
comm -23 re_sult.list black.list > result.list
Package=$(sed '/^#/d' "./result.list")

if [ "$tripartite_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
elif [ "$tripartite_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-S.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
else
	log "配置输入有误！"
fi

