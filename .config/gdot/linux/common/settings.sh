#!/bin/sh
set -e
cd "$(dirname "$0")"
sudo usermod -s "$(which zsh)" "$USER"
sudo cp -r -u -v ./etc/udev /etc
sudo udevadm control --reload
git config --global alias.jump '!$(which git)/share/git-core/contrib/git-jump/git-jump'
git config --global alias.logf "log --first-parent"
