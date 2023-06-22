
#!/system/bin/sh
MODDIR=${0%/*}

DEX2OAT_CONFIG="/data/adb/Dex2oatRUN/基础配置.prop"
OPTIONALAPP_CONFIG="/data/adb/Dex2oatRUN/自选应用列表.prop"

system_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^系统应用=" | cut -f2 -d '=')
tripartite_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^三方应用=" | cut -f2 -d '=')
optional_app=$(sed '/^#/d' "$DEX2OAT_CONFIG" | grep "^自选应用=" | cut -f2 -d '=')

newid=$(getprop ro.system.build.id)

log_file="/data/adb/Dex2oatRUN/日志.log"
done3_list="$MODDIR/done-3.list"
doneO_list="$MODDIR/done-O.list"
doneS_list="$MODDIR/done-S.list"
package3_list="$MODDIR/package-3.list"
packageS_list="$MODDIR/package-S.list"
packageO_list="$MODDIR/package-O.list"
black_list="$MODDIR/black.list"

touch $MODDIR/new.id
echo $newid > $MODDIR/new.id

if [ !-z $(cmp $MODDIR/old.id $MODDIR/new.id) ]; then
	rm -rf "$doneS_list"
	rm -rf "$done3_list"
	rm -rf "$doneO_list"
	rm -rf "$black_list"
	echo $newid > $MODDIR/old.id
fi

# 重建日志
rm -r "$log_file"
> "$log_file"

function log(){
    printf "[%s] %s\n" "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> "$log_file"
}

function dexapp_3(){
	package3_list="$MODDIR/package-3.list"
	done3_list="$MODDIR/done-3.list"
	black_list="$MODDIR/black.list"
	result_sorted_list="$MODDIR/result_sorted.list"
	result_list="$MODDIR/result.list"

	> "$package3_list"
	> "$done3_list"
	> "$black_list"

	Package3=($(pm list packages -3 | grep "^package:" | cut -f2 -d ':'))

	for pkg in "${Package3[@]}"; do
		echo "$pkg" >> "$package3_list"
	done

	sort "$done3_list" > "$done3_sorted_list"
	sort "$package3_list" > "$package3_sorted_list"
	sort "$black_list" > "$black_sorted_list"

	comm -23 "$package3_sorted_list" "$done3_sorted_list" > "$result_sorted_list"
	comm -23 "$result_sorted_list" "$black_sorted_list" > "$result_list"

	Package3=$(sed '/^#/d' "$result_list")

	compile_package() {
	    local mode="$1"
	    local pkg="$2"
	    cmd package compile -m "$mode" "$pkg"
	    if [ "$?" = "0" ]; then
	        log "应用$pkg编译成功！"
	        echo "$pkg" >> "$done3_list"
	    else
	        log "应用$pkg编译失败！"
	        echo "$pkg" >> "$black_list"
	    fi
	}

	if [ "$tripartite_app" = "verify" ] || [ "$tripartite_app" = "quicken" ] || [ "$tripartite_app" = "space-profile" ] || [ "$tripartite_app" = "space" ] || [ "$tripartite_app" = "speed-profile" ] || [ "$tripartite_app" = "speed" ] || [ "$tripartite_app" = "everything" ]; then
	    for pkg in "${Package3[@]}"; do
	        case "$tripartite_app" in
	            "verify")
	                compile_package "verify" "$pkg"
	                ;;
	            "quicken")
	                compile_package "quicken" "$pkg"
	                ;;
	            "space-profile")
	                compile_package "space-profile" "$pkg"
	                ;;
	            "space")
	                compile_package "space" "$pkg"
	                ;;
	            "speed-profile")
	                compile_package "speed-profile" "$pkg"
	                ;;
	            "speed")
	                compile_package "speed" "$pkg"
	                ;;
	            "everything")
	                compile_package "everything" "$pkg"
	                ;;
	        esac
	    done
	fi
}

function dexapp_S(){
	packageS_list="$MODDIR/package-S.list"
	doneS_list="$MODDIR/done-S.list"
	black_list="$MODDIR/black.list"
	result_sorted_list="$MODDIR/result_sorted.list"
	result_list="$MODDIR/result.list"

	> "$packageS_list"
	> "$doneS_list"
	> "$black_list"

	PackageS=($(pm list packages -S | grep "^package:" | cut -f2 -d ':'))

	for pkg in "${PackageS[@]}"; do
		echo "$pkg" >> "$packageS_list"
	done

	sort "$doneS_list" > "$doneS_sorted_list"
	sort "$packageS_list" > "$packageS_sorted_list"
	sort "$black_list" > "$black_sorted_list"

	comm -23 "$packageS_sorted_list" "$doneS_sorted_list" > "$result_sorted_list"
	comm -23 "$result_sorted_list" "$black_sorted_list" > "$result_list"

	PackageS=$(sed '/^#/d' "$result_list")

	compile_package() {
	    local mode="$1"
	    local pkg="$2"
	    cmd package compile -m "$mode" "$pkg"
	    if [ "$?" = "0" ]; then
	        log "应用$pkg编译成功！"
	        echo "$pkg" >> "$doneS_list"
	    else
	        log "应用$pkg编译失败！"
	        echo "$pkg" >> "$black_list"
	    fi
	}

	if [ "$system_app" = "verify" ] || [ "$system_app" = "quicken" ] || [ "$system_app" = "space-profile" ] || [ "$system_app" = "space" ] || [ "$system_app" = "speed-profile" ] || [ "$system_app" = "speed" ] || [ "$system_app" = "everything" ]; then
	    for pkg in "${PackageS[@]}"; do
	        case "$system_app" in
	            "verify")
	                compile_package "verify" "$pkg"
	                ;;
	            "quicken")
	                compile_package "quicken" "$pkg"
	                ;;
	            "space-profile")
	                compile_package "space-profile" "$pkg"
	                ;;
	            "space")
	                compile_package "space" "$pkg"
	                ;;
	            "speed-profile")
	                compile_package "speed-profile" "$pkg"
	                ;;
	            "speed")
	                compile_package "speed" "$pkg"
	                ;;
	            "everything")
	                compile_package "everything" "$pkg"
	                ;;
	        esac
	    done
	fi
}

function dexapp_O(){
	packageO_list="$MODDIR/package-O.list"
	doneO_list="$MODDIR/done-O.list"
	black_list="$MODDIR/black.list"
	result_sorted_list="$MODDIR/result_sorted.list"
	result_list="$MODDIR/result.list"

	> "$packageO_list"
	> "$doneO_list"
	> "$black_list"

	PackageO=($(sed '/^#/d' "$OPTIONALAPP_CONFIG"))

	for pkg in "${PackageO[@]}"; do
		echo "$pkg" >> "$packageO_list"
	done

	sort "$doneO_list" > "$doneO_sorted_list"
	sort "$packageO_list" > "$packageO_sorted_list"
	sort "$black_list" > "$black_sorted_list"

	comm -23 "$packageO_sorted_list" "$doneO_sorted_list" > "$result_sorted_list"
	comm -23 "$result_sorted_list" "$black_sorted_list" > "$result_list"

	PackageO=$(sed '/^#/d' "$result_list")

	compile_package() {
	    local mode="$1"
	    local pkg="$2"
	    cmd package compile -m "$mode" "$pkg"
	    if [ "$?" = "0" ]; then
	        log "应用$pkg编译成功！"
	        echo "$pkg" >> "$doneO_list"
	    else
	        log "应用$pkg编译失败！"
	        echo "$pkg" >> "$black_list"
	    fi
	}

	if [ "$optional_app" = "verify" ] || [ "$optional_app" = "quicken" ] || [ "$optional_app" = "space-profile" ] || [ "$optional_app" = "space" ] || [ "$optional_app" = "speed-profile" ] || [ "$optional_app" = "speed" ] || [ "$optional_app" = "everything" ]; then
	    for pkg in "${PackageO[@]}"; do
	        case "$optional_app" in
	            "verify")
	                compile_package "verify" "$pkg"
	                ;;
	            "quicken")
	                compile_package "quicken" "$pkg"
	                ;;
	            "space-profile")
	                compile_package "space-profile" "$pkg"
	                ;;
	            "space")
	                compile_package "space" "$pkg"
	                ;;
	            "speed-profile")
	                compile_package "speed-profile" "$pkg"
	                ;;
	            "speed")
	                compile_package "speed" "$pkg"
	                ;;
	            "everything")
	                compile_package "everything" "$pkg"
	                ;;
	        esac
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
ends=$(grep -o '编译成功' "$log_file" | wc -l)
endf=$(grep -o '编译失败' "$log_file" | wc -l)
log "本次运行结果：成功：$ends；失败：$endf

