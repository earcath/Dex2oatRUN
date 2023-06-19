function log(){
	echo "[ $(date "+%Y-%m-%d %H:%M:%S") ] ${1}" >> /data/adb/Dex2oatRUN/日志.log
}

touch ./package-O.list
touch ./done-O.list
touch ./black.list
Package=$(pm list packages -O | grep "^package:" | cut -f2 -d ':')
rm -r ./package-O.list
for i in $Package
	do
		echo $i >> ./package-O.list
	done
sort done-O.list > done-O_sorted.list
sort package-O.list > package-O_sorted.list
sort black.list > black_sorted.list
comm -23 package-O_sorted.list done-O_sorted.list > result_sorted.list
comm -23 result_sorted.list black_sorted.list > result.list
Package=$(sed '/^#/d' "./result.list")

if [ "$tripartite_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
			if [ "${?}" = "0" ]; then
				log "应用$i编译成功！"
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
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
				echo $i >> ./done-O.list
			else
				log "应用$i编译失败！"
				echo $i >> ./black.list
			fi
		done
else
	log "配置输入有误！"
fi

