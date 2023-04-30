Package=$(cat $OPTIONALAPP_CONFIG | grep -v '^#')

if [ "$optional_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
		done
elif [ "$optional_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
		done
elif [ "$optional_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
		done
elif [ "$optional_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
		done
elif [ "$optional_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
		done
elif [ "$optional_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
		done
elif [ "$optional_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
		done
else
	log "E" "配置输入有误！"
fi

