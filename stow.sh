#!/bin/sh
# Deploy every stow package of this repo into $HOME.
# Extra arguments are passed to stow: sh ./stow.sh --simulate -v, sh ./stow.sh -R
#
# Top-level directories that are NOT stow packages (stow's --ignore in .stowrc
# only filters files inside packages, it cannot skip a whole package).
NON_PACKAGES="bootstrap.d nix pixinsight"

cd "$(dirname "$0")" || exit 1

PACKAGES=""
for d in */; do
	d=${d%/}
	case " $NON_PACKAGES " in
	*" $d "*) continue ;;
	esac
	PACKAGES="$PACKAGES $d"
done

# shellcheck disable=SC2086
stow --dir="$(pwd)" --target="$HOME" "$@" $PACKAGES
