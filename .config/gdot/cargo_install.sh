#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

rustup-init -y || rustup default stable

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

addp atuin      # CLI history in searchable sqlite
addp bat        # Better cat
addp fd-find    # Alternative to find
addp ripgrep    # Fast search tool
addp starship   # Shell prompt
addp stylua     # Lua formatter
addp taplo-cli  # TOML LSP
addp television # General purpose fuzzy finder TUI
addp tlrc       # TLDR manual pages (tldr command)
addp uv         # Python package manager and build tool
addp zoxide     # Smart `cd` alternative

# TUI File manager
addp resvg      # SVG library and CLI tool
addp yazi-build # Installs yazi-fm and yazi-cli TUI file manager

cargo install $PACKAGES
