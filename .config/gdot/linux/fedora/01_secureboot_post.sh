#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

cd "$(dirname "$0")"
./02_asus.sh
./03_nvidia.sh

sudo akmods --force && sudo dracut --force

rm "$HOME/gdot_continue.sh" || echo ""

echo ""
echo ""
echo "Reboot and turn Secure Boot on."
