#!/bin/sh
# Active la collecte sysstats (launchd) une fois le package stowé.
[ "$(uname)" = "Darwin" ] || exit 0
[ -x "$HOME/.local/bin/sysstats" ] || { echo "sysstats: package non stowé, ignoré"; exit 0; }
/usr/bin/python3 "$HOME/.local/bin/sysstats" install
