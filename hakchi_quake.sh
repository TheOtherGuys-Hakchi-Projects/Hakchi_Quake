#!/bin/sh

source /etc/preinit
script_init

WorkingDir=$(pwd)
GameName=$(echo $WorkingDir | awk -F/ '{print $NF}')
ok=0

if [ -f "/usr/share/games/$GameName/$GameName.desktop" ]; then
	QuakeTrueDir=$(grep /usr/share/games/$GameName/$GameName.desktop -e 'Exec=' | awk '{print $2}' | sed 's/\([/\t]\+[^/\t]*\)\{1\}$//')
	QuakePortableCore="$QuakeTrueDir/etc/libretro/core/tyrquake"
	QuakePortableFiles="$QuakeTrueDir/Quake_1_files"
	ok=1
fi

if [ "$ok" == 1 ]; then
	decodepng "$QuakeTrueDir/Hakchi_Quake_assets/q1splash-min.png" > /dev/fb0;
	[ -f "$rootfs/share/retroarch/assets/RAloading-min.png" ] && mount_bind "$QuakeTrueDir/Hakchi_Quake_assets/q1splash-min.png" "$rootfs/share/retroarch/assets/RAloading-min.png"
	exec retroarch-clover "../../..$QuakePortableCore" "$QuakePortableFiles/PAK0.PAK"
	umount "$rootfs/share/retroarch/assets/RAloading-min.png"
else
	decodepng "$QuakeTrueDir/Hakchi_Quake_assets/q1error_files-min.png" > /dev/fb0;
	sleep 5
fi
