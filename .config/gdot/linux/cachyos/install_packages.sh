#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

## CLI
addp "atuin"            # CLI history in searchable sqlite
addp "bat"              # Better cat
addp "direnv"           # Automatically source .envrc upon dir navigation
addp "fd"               # Alternative to find
addp "figlet"           # ASCII art text generator
addp "fzf"              # TUI/CLI fuzzy finder
addp "github-cli"       # GitHub CLI (brew: gh)
addp "git"              # Git version control
addp "jq"               # JSON Query tool
addp "lolcat"           # The purrfect addition to the CLI
addp "ripgrep"          # Fast search tool
addp "starship"         # Prompt
addp "tmux"             # Terminal multiplexer
addp "tree"             # Show directory structure visually
addp "uutils-coreutils" # Modern coreutils rewritten in Rust and MIT licensed
addp "wget"             # Gets things from the W
addp "zoxide"           # Smart cd alternative
addp "zsh"              # Ye old faithful interactive shell

## TUI
addp "neovim"           # NeoVim terminal-based text editor
addp "television"       # General purpose fuzzy finder TUI
addp "resvg"            # SVG rendering tool
addp "yazi"             # File manager

## Programming
addp "ccache"              # Compiler Cache to speed up some compilations
addp "cmake"               # Configurable cross platform make
addp "dotnet-sdk"          # .Net SDK (brew: dotnet)
addp "fnm"                 # Fast Node Version Manager (in Rust)
addp "go"                  # Go programming language
addp "gopls"               # Go language server
addp "llvm"                # Next-gen compiler backend
addp "lua-language-server" # As the name implies
addp "luarocks"            # Package manager for Lua
addp "marksman"            # Markdown language server
addp "ncurses"             # TUI tooling
addp "pyenv"               # Python version manager
addp "python"              # A snake that runs code (brew: python3)
addp "rbenv"               # Ruby environment management
addp "ruby-build"          # Install various Ruby versions and implementations
addp "rustup"              # Rust toolchain
addp "stylua"              # Lua formatter
addp "taplo-cli"           # TOML toolkit (brew: taplo)
addp "uv"                  # Modern Python build and package management
addp "yarn"                # NPM alternative, ish
addp "zig"                 # Zig programming language

## ZMK dependencies
addp "dfu-util"            # USB Device Firmware Upgrade
addp "dtc"                 # Device tree compiler
addp "gperf"               # Perfect hash function generator
addp "file"                # File type detection (provides libmagic)
addp "ninja"               # Build system
addp "qemu-system-arm"     # ARM emulator for ZMK

set -x
sudo pacman -Syu --noconfirm $PACKAGES
set +x

## AUR packages (via paru)
PACKAGES=""
addp "tlrc"             # Short alternative to man-pages (in Rust)
addp "devcontainer-cli" # Operate on devcontainer.json without an IDE
addp "tio"              # Serial IO/TTY
addp "python-west"      # Zephyr meta-tool

set -x
paru -S --noconfirm $PACKAGES
set +x

## GUI - System packages
PACKAGES=""
addp "kitty" # Terminal emulator

set -x
set -e
sudo pacman -Syu --noconfirm $PACKAGES
set +e
set +x

## GUI - AUR system packages
PACKAGES=""
addp "1password"  # Password manager
addp "brave-bin"  # Brave web browser
addp "piavpn-bin" # PIA VPN official client

set -x
set -e
paru -Syu --noconfirm $PACKAGES
set +e
set +x
