Package=$(pm list packages -s | grep "^package:" | cut -f2 -d ':')

if [ "$system_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
elif [ "$system_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
			if [ "${?}" = "0" ]; then
				log "I" "应用$i编译完成！"
			else
				log "E" "应用$i编译失败！"
			fi
		done
else
	log "E" "配置输入有误！"
fi

