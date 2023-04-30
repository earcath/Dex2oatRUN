Package=$(pm list packages -3 | grep "^package:" | cut -f2 -d ':')

if [ "$tripartite_app" = "verify" ]; then
	for i in $Package
		do
			cmd package compile -m verify $i
		done
elif [ "$tripartite_app" = "quicken" ]; then
	for i in $Package
		do
			cmd package compile -m quicken $i
		done
elif [ "$tripartite_app" = "space-profile" ]; then
	for i in $Package
		do
			cmd package compile -m space-profile $i
		done
elif [ "$tripartite_app" = "space" ]; then
	for i in $Package
		do
			cmd package compile -m space $i
		done
elif [ "$tripartite_app" = "speed-profile" ]; then
	for i in $Package
		do
			cmd package compile -m speed-profile $i
		done
elif [ "$tripartite_app" = "speed" ]; then
	for i in $Package
		do
			cmd package compile -m speed $i
		done
elif [ "$tripartite_app" = "everything" ]; then
	for i in $Package
		do
			cmd package compile -m everything $i
		done
else
	log "E" "配置输入有误！"
fi

