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

cargo install $PACKAGES

# provides the `cargo install-update` command to update the above packages
cargo install cargo-update --force --features vendored-libgit2
