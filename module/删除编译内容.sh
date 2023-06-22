done_S_list="/data/adb/module/Dex2oatRUN/done-S.list"
done_3_list="/data/adb/module/Dex2oatRUN/done-3.list"
done_O_list="/data/adb/module/Dex2oatRUN/done-O.list"

PackageS=$(sed '/^#/d' "$done_S_list")
Package3=$(sed '/^#/d' "$done_3_list")
PackageO=$(sed '/^#/d' "$done_O_list")

while IFS= read -r line; do
    cmd package compile --reset "$line"
done <<< "$PackageS"

while IFS= read -r line; do
    cmd package compile --reset "$line"
done <<< "$Package3"

while IFS= read -r line; do
    cmd package compile --reset "$line"
done <<< "$PackageO"

