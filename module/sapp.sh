Package=$(pm list packages -s | grep "^package:" | cut -f2 -d ':')

if [ "$system_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
		done
elif [ "$system_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
		done
elif [ "$system_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
		done
elif [ "$system_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
		done
elif [ "$system_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
		done
elif [ "$system_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
		done
elif [ "$system_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
		done
else
	log "E" "配置输入有误！"
fi

