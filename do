#!/bin/bash

. version
modname="$MOD_NAME"
targetname="$MOD_NAME-$MOD_VERSION"

case "$#" in
	0)
		eval "$0 package"
		exit $?
		;;
	1)
		case "$1" in
			package)
				mkdir -p ./target/exploded
				cp -a ./main/src/ "./target/exploded/$modname"
				sed "s:BACKUP ~bgfaces/backup~:BACKUP ~$modname/backup~:g" ./main/src/bgfaces.tp2 > ./target/exploded/$modname/$modname.tp2
				rm ./target/exploded/$modname/bgfaces.tp2
				cp ./main/bin/weidu.exe "./target/exploded/setup-$modname.exe"
				tar -czf "./target/$targetname.tgz" -C ./target/exploded .
				;;
			clean)
				rm -rf ./target
				;;
			*)
				echo "Usage: $0 [-h|clean|package]"
		esac
		;;
	*)
		eval "$0 -h"
		exit $?
esac


