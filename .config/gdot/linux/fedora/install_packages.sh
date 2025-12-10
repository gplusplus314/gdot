#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $@"
}

## Flatpak GUI apps
addp "com.brave.Browser"          # Web browser
addp "com.github.tchx84.Flatseal" # Flatpak permissions management

# CONTAINER_ID is set when we're inside a DistroBox session.
if [ -z "$CONTAINER_ID" ]; then
	flatpak install -y --noninteractive $PACKAGES
fi
PACKAGES=""

cd "$(dirname "$0")"
brew bundle --file=../common/Brewfile

## CLI
addp "wlroots"      # Wayland utils/libs
addp "wl-clipboard" # Wayloand copy/paste

## GUI
if [ -z "$CONTAINER_ID" ]; then
	addp "kitty" # Terminal emulator
fi

set -x
sudo dnf install -y $PACKAGES
set +x
