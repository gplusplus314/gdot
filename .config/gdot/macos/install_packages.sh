#!/bin/sh
set -e
cd "$(dirname "$0")"
echo "Executing Homebrew Brewfile..."
if [ -f "$HOME/Brewfile" ]; then
	echo "Using $HOME/Brewfile"
	brew bundle --file="$HOME/Brewfile"
else
	echo "Using gdot's Brewfile"
	brew bundle --file="$GDOT_HOME/macos/Brewfile"
fi
