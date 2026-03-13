#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

## CLI - User packages
cd "$(dirname "$0")"
brew bundle --file=../common/Brewfile

## GUI - System packages
addp "kitty" # Terminal emulator

set -x
set -e
sudo pacman -Syu --noconfirm $PACKAGES
set +e
set +x

## GUI - AUR system packages
addp "1password"  # Password manager
addp "brave-bin"  # Brave web browser
addp "piavpn-bin" # PIA VPN official client

set -x
set -e
paru -Syu --noconfirm $PACKAGES
set +e
set +x
