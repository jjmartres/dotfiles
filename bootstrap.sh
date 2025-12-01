#!/bin/sh

OS=$(uname)

case $OS in
'Darwin')
	for s in bootstrap.d/darwin/*.sh; do
		sh "$s"
	done
	;;
'Linux')
	for s in bootstrap.d/linux/*.sh; do
		sh "$s"
	done
	;;
*)
	echo "Sorry. We didn't known how to setup $OS platform"
	exit 1
	;;
esac

stow --dir=$(pwd) --target=$HOME */
