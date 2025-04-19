#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must NOT be run as root!" >&2
    exit 1
fi

echo "Setting $USER's shell to zsh..."
chsh -s /usr/local/bin/zsh
