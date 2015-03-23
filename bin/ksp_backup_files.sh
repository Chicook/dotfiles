#!/usr/bin/env bash
# ksp_backup_files.sh by Amory Meltzer
# Simply copy pilot and alarm files to a save directory

dateandtime=$(date +%Y.%m.%d_%H%M%S)
folderpath='/Users/Amory/Dropbox/KSP stuff/KSP saves backups/'$dateandtime
ksppath='/Applications/KSP_osx'
kacpath=$ksppath'/GameData/TriggerTech/PluginData/KerbalAlarmClock'

userlist=$(ls -1 $ksppath'/saves' | grep -v scenarios | grep -v training)

mkdir "$folderpath"

for i in $userlist
do
    cp "$ksppath/saves/$i/persistent.sfs" "$folderpath/$i.persistent.sfs"
done

#cp "$kacpath/config.xml" "$folderpath/"
#cp "$kacpath/Alarms-McJohn (CAREER).txt" "$folderpath/"

ls -lFGh "$folderpath/"
