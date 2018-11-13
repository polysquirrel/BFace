#!/bin/bash

modname="bgfaces"
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
				cp ./main/bin/weidu.exe "./target/exploded/setup-$modname.exe"
				tar -czf "./target/$modname.tgz" -C ./target/exploded .
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


