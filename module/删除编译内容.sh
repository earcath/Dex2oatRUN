Package1=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-S.list")
Package2=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-3.list")
Package3=$(sed '/^#/d' "/data/adb/module/Dex2oatRUN/mode/done-O.list")
for i in $Package1
do
	cmd package compile --reset -i
done
for i in $Package2
do
	cmd package compile --reset -i
done
for i in $Package3
do
	cmd package compile --reset -i
done

