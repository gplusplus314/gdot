#!/bin/sh
set -e
if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

cd "$(dirname "$0")"

echo "Executing Homebrew Brewfile..."
if [ -f "$HOME/Brewfile" ]; then
	echo "Using $HOME/Brewfile"
	brew bundle --file="$HOME/Brewfile"
else
	echo "Using gdot's Brewfile"
	brew bundle --file="$GDOT_HOME/macos/Brewfile"
fi
