#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi
cd "$(dirname "$0")"

dnf install -y --nogpgcheck --repofrompath \
	'terra,https://repos.fyralabs.com/terra$releasever' terra-release
sudo dnf copr enable avengemedia/dms

sudo dnf install -y wlr-randr mangowc dms

if [ ! -f ~/.config/mango/config.conf ]; then
	mkdir -p ~/.config/mango
	cp /etc/mango/config.conf ~/.config/mango/config.conf
fi
mkdir -p ~/.config/mango/dms
touch ~/.config/mango/dms/{colors,layout,outputs}.conf
