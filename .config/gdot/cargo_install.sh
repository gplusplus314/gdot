#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    echo "This script must NOT be run as root!" >&2
    exit 1
fi

. "$HOME/.cargo/env"

# General purpose fuzzy finder TUI
cargo install --locked television
