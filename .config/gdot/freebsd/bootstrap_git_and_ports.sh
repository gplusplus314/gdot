#!/bin/sh
# Script to replace the FreeBSD ports tree with the Git version
# This script must be run as root

# Exit on error
set -e

echo "Updating FreeBSD ports tree using Git..."

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!" >&2
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "Git not insalled!" >&2
    exit 1
fi

echo "Removing existing ports tree..."
rm -rf /usr/ports

echo "Cloning fresh ports tree from Git repository..."
git clone --depth 1 https://git.FreeBSD.org/ports.git /usr/ports

echo "Ports tree successfully updated."

