#!/bin/sh
set -e
cd "$(dirname "$0")"
sudo cp -r -u -v ./etc/udev /etc
sudo udevadm control --reload
