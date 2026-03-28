#!/bin/sh
set -e
if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

cd "$(dirname "$0")"

brew bundle --file="$GDOT_HOME/Brewfile"
brew bundle --file="$GDOT_HOME/macos/Brewfile"
