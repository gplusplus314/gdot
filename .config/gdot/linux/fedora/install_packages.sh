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

## CLI - System packages
addp "gcc"          # C compiler
addp "wlroots"      # Wayland utils/libs
addp "wl-clipboard" # Wayloand copy/paste

set -x
sudo dnf install -y $PACKAGES
set +x
PACKAGES=""

## CLI - User packages
cd "$(dirname "$0")"
brew bundle --file=../common/Brewfile

# CONTAINER_ID is set when we're inside a DistroBox session. If installing
# gdot into a devcontainer, we'll short-circuit anything GUI related.
if [ -z "$CONTAINER_ID" ]; then
	exit 0
fi

## GUI - System packages
addp "kitty" # Terminal emulator

set -x
sudo dnf install -y $PACKAGES
set +x
PACKAGES=""

## GUI - Flatpak, user packages
addp "com.github.tchx84.Flatseal" # Flatpak permissions management

set -x
flatpak install -y --noninteractive $PACKAGES
set +x
PACKAGES=""
