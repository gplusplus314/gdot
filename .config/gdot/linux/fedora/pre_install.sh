#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

cd "$(dirname "$0")"

sudo dnf install -y tar git lspci
