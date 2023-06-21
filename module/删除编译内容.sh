PackageS=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-S.list")
Package3=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-3.list")
PackageO=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-O.list")

for i in $PackageS
	do
		cmd package compile --reset -i
	done
for i in $Package3
	do
		cmd package compile --reset -i
	done
for i in $PackageO
	do
		cmd package compile --reset -i
	done

