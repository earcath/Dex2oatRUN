function log(){	#日志
	echo "$(date "+%Y-%m-%d %H:%M:%S") [${1}] : ${2}" >>/data/adb/Dex2oatRUN/日志.log
}

Package=$(pm list packages -3 | grep "^package:" | cut -f2 -d ':')

if [ "$tripartite_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$tripartite_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译成功！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
else
	log "E" "*配置输入有误！"
fi

