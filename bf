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
		"./$0" package
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
				    ./main/src/$name.tp2 > "$moddir/$MOD_NAME.tp2"
				if [ ! "$MOD_NAME" == "$name" ]; then
					rm "$moddir/$name.tp2"
				fi
				mkdir -p "$moddir/bin"
				
				case "$#" in
					1)	
						echo "Packaging $MOD_NAME for $system..."
						cp -u "./main/bin/gm-$system$extension" "$moddir/bin/gm$extension"
						cp -u "./main/bin/weidu-$system$extension" "./target/exploded/setup-$MOD_NAME$extension"
						
						tar -czf "./target/$targetname-$system.tgz" -C "./target/exploded" "$MOD_NAME" "setup-$MOD_NAME$extension" 
						;;
						
					*)
						skip=1
						for arch in $@; do
							if [[ $skip == 0 ]]; then
								echo "Packaging $MOD_NAME for $arch..."
								rm "$moddir/bin/gm*"
								case $arch in
									all)
										find ./main/bin -name "weidu-*" -exec basename {} \; | sed -e "s/weidu-\([^.]*\)\(\|\..*\)$/\1/g" | xargs "./$0" package
										exit $?
										;;
									win*)
										exe=".exe"
										;;
									*)
										exe=""
										;;
								esac
																		cp -u ./main/bin/weidu-$arch$exe "./target/exploded/setup-$MOD_NAME$exe"
								cp -u ./main/bin/gm-$arch$exe "$moddir/gm$exe"
																		tar -czf "./target/$targetname-$arch.tgz" -C ./target/exploded "$MOD_NAME" "setup-$MOD_NAME$exe" 
								
							fi
							skip=0
						done
				esac
				;;

			testinstall)
			        if [ ! -d "target/exploded" ]; then
                                        "./$0" package
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
								"./setup-$MOD_NAME$extension" --uninstall --language 0
								cd -
							fi
                        				mv "$GAMEDIR/$MOD_NAME" "$GAMEDIR/$MOD_NAME.bak"
                				fi
                				cp -a  "$moddir" "$GAMEDIR"
						cp -u "./main/bin/weidu-$system$extension" "$GAMEDIR/setup-$MOD_NAME$extension"
        				fi
				done
				;;
			
			codeinstall)
				if [ ! -d "target/exploded" ]; then
                                        "./$0" package
                                        if [ ! $? -eq 0 ]; then
                                                exit $?
                                        fi
				else
					sed -e "s:BACKUP ~$name/backup~:BACKUP ~$MOD_NAME/backup~:g" \
                                	    -e "s:VERSION ~SNAPSHOT~:VERSION ~$MOD_VERSION~:g" \
                                	    -e "s?AUTHOR ~polymorphedsquirrel~?AUTHOR ~$MOD_AUTHORS~?g" \
                                	./main/src/$name.tp2 > "$moddir/$MOD_NAME.tp2"
					cp -a ./main/src/*tph "$moddir"
					cp -a ./main/src/*tpa "$moddir"
					cp -a ./main/src/tra "$moddir"
				fi
                                
				for GAMEDIR in "test/Baldur's Gate" "test/Baldur's Gate EE" "test/Siege of Dragonspear" "test/Baldur's Gate 2" "test/Baldur's Gate 2 EE" "test/Icewind Dale" "test/Icewind Dale EE" "test/Icewind Dale 2"; do
				        if [ -d "$GAMEDIR" ]; then
                                                if [ -d "$GAMEDIR/$MOD_NAME" ]; then
                                                	cp -a "$moddir/"*tph "$GAMEDIR/$MOD_NAME"
							cp -a "$moddir/"*tpa "$GAMEDIR/$MOD_NAME"
							cp "$moddir/"*tp2 "$GAMEDIR/$MOD_NAME"
							cp -a "$moddir/tra" "$GAMEDIR/$MOD_NAME"
						fi
					fi
				done
				
				;;
			
			clean)
				rm -rf ./target
				rm -rf ./main/src/charname/pool
				;;
			
			*)
				echo "Usage: $0 [-h | clean | package [<arch>*|all] | testinstall | codeinstall | reftest]"
				echo "  clean:        deletes ./target and ./main/src/charname/pool"
				echo "  package:      packages the module for the specified architectures"
				echo "  testinstall:  copies the recently built module from ./target to game"
				echo "                directories present in ./test, uninstalling the previous"
				echo "                version, if present"
				echo "  codeinstall:  like above, but copies only the weidu scripts"
				echo "                and not the portraits (for faster iteration)"
				echo "  reftest:      runs the ./pool and ./reftest scripts to verify correctness"
				echo "                of all .ref files under the portrait directories"
		
				;;	
		esac
		;;
esac





