#!/bin/bash

. release
modname="$MOD_NAME"
targetname="$MOD_NAME-$MOD_VERSION"
moddir=./target/exploded/$modname
case "$#" in
	0)
		eval "$0 package"
		exit $?
		;;
	1)
		case "$1" in
			package)
				rm -rf ./target
				mkdir -p ./target/exploded
				cp -a ./main/src/ "$moddir"
				
				sed -e "s:BACKUP ~bface/backup~:BACKUP ~$modname/backup~:g" \
				    -e "s:OUTER_TEXT_SPRINT MOD_NAME ~bface~:OUTER_TEXT_SPRINT MOD_NAME ~$modname~:g" \
				    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
				    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
				    ./main/src/bface.tp2 > $moddir/$modname.tp2
				if [ ! "$modname" == "bface" ]; then
					rm $moddir/bface.tp2
				fi
				cp ./main/bin/weidu.exe "./target/exploded/setup-$modname.exe"
				tar -czf "./target/$targetname.tgz" -C ./target/exploded .
				;;

			testinstall)
				if [ ! -d "target/exploded" ]; then
					./do package
					if [ ! $? -eq 0 ]; then
						exit $?
					fi
				fi
				
				for GAMEDIR in "test/Baldur's Gate" "test/Siege of Dragonspear" "test/Baldur's Gate  2"; do
        				if [ -d "$GAMEDIR" ]; then
                				if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                        				rm -rf "$GAMEDIR/$MOD_NAME.bak"
                        				mv "$GAMEDIR/$MOD_NAME" "$GAMEDIR/$MOD_NAME.bak"
                				fi
                				cp -a target/exploded/$MOD_NAME target/exploded/setup-$MOD_NAME.exe "$GAMEDIR"
#               				mv "$GAMEDIR/$MOD_NAME/bface.tp2" "$GAMEDIR/$MOD_NAME/$MOD_NAME.tp2"
#               				cp -a main/src "$GAMEDIR/$MOD_NAME"
#               				cp main/bin/weidu.exe "$GAMEDIR/setup-$MOD_NAME.exe"
        				fi
				done
				;;

			clean)
				rm -rf ./target
				;;
			*)
				echo "Usage: $0 [-h|clean|package|testinstall]"
		esac
		;;
	*)
		eval "$0 -h"
		exit $?
esac





