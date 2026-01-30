#!/bin/sh
set -e
cd "$(dirname "$0")"
sudo usermod -s "$(which zsh)" "$USER"
sudo cp -r -u -v ./etc/udev /etc
sudo udevadm control --reload
