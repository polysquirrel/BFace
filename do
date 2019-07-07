#!/bin/bash

. release
name=bface
targetname="$MOD_NAME-$MOD_VERSION"
moddir=./target/exploded/$MOD_NAME
extension=""
case "$OSTYPE" in
	linux*)	system="lin"
		;;
	darwin*)
		system="mac"
		;;
	*)	system="win"
		extension=".exe"
		;;
esac
if [[ "$PROCESSOR_ARCHITECTURE" == "AMD64" && -f "./main/bin/weidu-$system-amd64$extnesion" ]]; then
	system="$system-amd64"
else
	system="$system-x86"
fi	


case "$#" in
	0)
		eval "$0 package"
		exit $?
		;;
	*)
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

				sed -e "s:BACKUP ~$name/backup~:BACKUP ~$MOD_NAME/backup~:g" \
				    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
				    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
				    ./main/src/$name.tp2 > $moddir/$MOD_NAME.tp2
				if [ ! "$MOD_NAME" == "$name" ]; then
					rm $moddir/$name.tp2
				fi
				
				
				case "$#" in
					1)	
						echo "Packaging $system..."
						cp "./main/bin/weidu-$system$extension" "./target/exploded/setup-$MOD_NAME$extension"
						
						tar -czf "./target/$targetname-$system.tgz" -C "./target/exploded" * 
						;;
					*)
						skip=1
						for arch in $@; do
							if [[ $skip == 0 ]]; then
								rm -f ./target/exploded/setup-*
								case $arch in
									all)
										find ./main/bin -name "weidu-*" -exec basename {} \; | sed -e "s/weidu-\([^.]*\)\(\|\..*\)$/\1/g" | xargs ./do package
										exit $?
										;;
									win*)
																				cp ./main/bin/weidu-$arch.exe "./target/exploded/setup-$MOD_NAME.exe"
																				;;
																			*)
																				cp ./main/bin/weidu-$arch "./target/exploded/setup-$MOD_NAME"
																				;;
																																						esac
																																						echo "Packaging $arch..."
																																						tar -czf "./target/$targetname-$arch.tgz" -C ./target/exploded .
							fi
							skip=0
						done
				esac
				;;

			testinstall)
			        if [ ! -d "target/exploded" ]; then
                                        ./do package
                                        if [ ! $? -eq 0 ]; then
                                                exit $?
                                        fi
                                fi
				
				for GAMEDIR in "test/Baldur's Gate" "test/Baldur's Gate EE" "test/Siege of Dragonspear" "test/Baldur's Gate 2" "test/Baldur's Gate 2 EE" "test/Icewind Dale" "test/Icewind Dale EE"; do
        				if [ -d "$GAMEDIR" ]; then
						echo "Installing in $GAMEDIR"
                				if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                        				rm -rf "$GAMEDIR/$MOD_NAME.bak"
							if [ -f "$GAMEDIR/setup-$MOD_NAME$extension" ]; then
								cd "$GAMEDIR"
								"./setup-$MOD_NAME$extension" --uninstall
								cd -
							fi
                        				mv "$GAMEDIR/$MOD_NAME" "$GAMEDIR/$MOD_NAME.bak"
                				fi
                				cp -a  "$moddir" "$GAMEDIR"
						cp -a "./main/bin/weidu-$system$extension" "$GAMEDIR/setup-$MOD_NAME$xtension"
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
					sed -e "s:BACKUP ~$name/backup~:BACKUP ~$MOD_NAME/backup~:g" \
                                	    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
                                	    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
                                	./main/src/$name.tp2 > "$moddir/$MOD_NAME.tp2"
					cp ./main/src/*tph "$moddir"
					cp ./main/src/*tpa "$moddir"
					cp -a ./main/src/tra "$moddir"
				fi
                                
				for GAMEDIR in "test/Baldur's Gate" "test/Baldur's Gate EE" "test/Siege of Dragonspear" "test/Baldur's Gate 2" "test/Baldur's Gate 2 EE" "test/Icewind Dale" "test/Icewind Dale EE" "test/Icewind Dale 2"; do
				        if [ -d "$GAMEDIR" ]; then
                                                if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                                                	cp "$moddir/"*tph "$GAMEDIR/$MOD_NAME"
							cp "$moddir/"*tpa "$GAMEDIR/$MOD_NAME"
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
esac





