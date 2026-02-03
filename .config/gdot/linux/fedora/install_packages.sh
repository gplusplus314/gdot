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

addp "dnf-plugins-core" # Needed to add dnf repos

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

# 1Password is a bit of a special case.
# https://support.1password.com/install-linux/#fedora-or-red-hat-enterprise-linux
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf install -y 1password

## GUI - System packages
addp "kitty" # Terminal emulator

# Brave web browser
sudo dnf config-manager addrepo -y \
	--from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
addp "brave-browser"

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
