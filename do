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
			reftest)
				./pool -d ./main/src
				./reftest -d ./main/src
				;;
			package)
				echo "Copying files..."
				rm -rf ./target
				mkdir -p ./target/exploded
				cp -a ./main/src/ "$moddir"
				rm -rf "$moddir/charname/pool"

				sed -e "s:BACKUP ~bface/backup~:BACKUP ~$modname/backup~:g" \
				    -e "s:OUTER_TEXT_SPRINT MOD_NAME ~bface~:OUTER_TEXT_SPRINT MOD_NAME ~$modname~:g" \
				    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
				    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
				    ./main/src/bface.tp2 > $moddir/$modname.tp2
				if [ ! "$modname" == "bface" ]; then
					rm $moddir/bface.tp2
				fi
				cp ./main/bin/weidu.exe "./target/exploded/setup-$modname.exe"

				echo "Packaging..."
				tar -czf "./target/$targetname.tgz" -C ./target/exploded .
				;;

			testinstall)
			        if [ ! -d "target/exploded" ]; then
                                        ./do package
                                        if [ ! $? -eq 0 ]; then
                                                exit $?
                                        fi
                                fi
				
				for GAMEDIR in "test/Baldur's Gate" "test/Siege of Dragonspear" "test/Baldur's Gate 2"; do
        				if [ -d "$GAMEDIR" ]; then
						echo "Install to $GAMEDIR"
                				if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                        				rm -rf "$GAMEDIR/$MOD_NAME.bak"
							if [ -f "$GAMEDIR/setup-$MOD_NAME.exe" ]; then
								cd "$GAMEDIR"
								"./setup-$MOD_NAME.exe" --uninstall
								cd -
							elif [ -f "$GAMEDIR/setup-$MOD_NAME" ]; then
								cd "$GAMEDIR"
								"./setup-$MOD_NAME" --uninstall
								cd -
							fi
                        				mv "$GAMEDIR/$MOD_NAME" "$GAMEDIR/$MOD_NAME.bak"
                				fi
                				cp -a  "$moddir" target/exploded/setup-$MOD_NAME.exe "$GAMEDIR"
        				fi
				done
				;;
			
			codeinstall)
				if [ ! -d "target/exploded" ]; then
                                        ./do package
                                        if [ ! $? -eq 0 ]; then
                                                exit $?
                                        fi
				else
					sed -e "s:BACKUP ~bface/backup~:BACKUP ~$modname/backup~:g" \
                                    	    -e "s:OUTER_TEXT_SPRINT MOD_NAME ~bface~:OUTER_TEXT_SPRINT MOD_NAME ~$modname~:g" \
                                	    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
                                	    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
                                	./main/src/bface.tp2 > "$moddir"/$modname.tp2
					cp ./main/src/*tph "$moddir"
					cp -a ./main/src/tra "$moddir"
				fi
                                
				for GAMEDIR in "test/Baldur's Gate" "test/Siege of Dragonspear" "test/Baldur's Gate  2"; do
				        if [ -d "$GAMEDIR" ]; then
                                                if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                                                	cp "$moddir/"*tph "$GAMEDIR/$MOD_NAME"
							cp "$moddir/"*tp2 "$GAMEDIR/$MOD_NAME"
							cp -a "$moddir/tra" "$GAMEDIR/$MOD_NAME"
						fi
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





