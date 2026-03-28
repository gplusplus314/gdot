#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script must NOT be run as root!" >&2
	exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $@"
}

addp "dnf-plugins-core" # Needed to add dnf repos

## CLI - System packages
addp "gcc"          # C compiler
addp "wlroots"      # Wayland utils/libs
addp "wl-clipboard" # Wayland copy/paste

## CLI
addp "atuin"            # CLI history in searchable sqlite
addp "bat"              # Better cat
addp "direnv"           # Automatically source .envrc upon dir navigation
addp "fd-find"          # Alternative to find (brew: fd)
addp "figlet"           # ASCII art text generator
addp "fzf"              # TUI/CLI fuzzy finder
addp "gh"               # GitHub CLI
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
addp "yazi"             # File manager

## Programming
addp "ccache"              # Compiler Cache to speed up some compilations
addp "cmake"               # Configurable cross platform make
addp "dotnet-sdk-9.0"      # .Net SDK (brew: dotnet)
addp "golang"              # Go programming language (brew: go)
addp "gopls"               # Go language server
addp "llvm"                # Next-gen compiler backend
addp "lua-language-server" # As the name implies
addp "luarocks"            # Package manager for Lua
addp "ncurses-devel"       # TUI tooling (brew: ncurses)
addp "python3"             # A snake that runs code
addp "rustup"              # Rust toolchain
addp "tio"                 # Serial IO/TTY
addp "uv"                  # Modern Python build and package management
addp "zig"                 # Zig programming language

## ZMK dependencies
addp "dfu-util"            # USB Device Firmware Upgrade
addp "dtc"                 # Device tree compiler
addp "gperf"               # Perfect hash function generator
addp "file-devel"          # File type detection (provides libmagic; brew: libmagic)
addp "ninja-build"         # Build system (brew: ninja)
addp "qemu-system-arm"     # ARM emulator for ZMK

set -x
sudo dnf install -y $PACKAGES
set +x

## Homebrew fallback - packages not available in Fedora repos
PACKAGES=""
addp "resvg"        # SVG rendering tool
addp "fnm"          # Fast Node Version Manager (in Rust)
addp "pyenv"        # Python version manager
addp "marksman"     # Markdown language server
addp "stylua"       # Lua formatter
addp "taplo"        # TOML toolkit
addp "tlrc"         # Short alternative to man-pages (in Rust)
addp "rbenv"        # Ruby environment management
addp "ruby-build"   # Install various Ruby versions and implementations
addp "yarn"         # NPM alternative, ish
addp "devcontainer" # Operate on devcontainer.json without an IDE
addp "west"         # Zephyr meta-tool

set -x
brew install $PACKAGES
set +x

# CONTAINER_ID is set when we're inside a DistroBox session. If installing
# gdot into a devcontainer, we'll short-circuit anything GUI related.
if [[ -v CONTAINER_ID ]]; then
	echo "Detected DistroBox session; skipping GUI packages."
	exit 0
fi

# 1Password is a bit of a special case.
# https://support.1password.com/install-linux/#fedora-or-red-hat-enterprise-linux
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf install -y 1password

## GUI - System packages
PACKAGES=""
addp "firefox" # Browser that actually works correctly on Linux
addp "flatpak" # Universal GUI packages
addp "kitty"   # Terminal emulator

# Brave web browser, buggy, but sometimes a Chromium browser is required.
sudo dnf config-manager addrepo -y \
	--from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo ||
	echo "Brave Browser repo already installed."
addp "brave-browser"

set -x
sudo dnf install -y $PACKAGES
set +x
PACKAGES=""

## GUI - Flatpak, user packages
#addp "com.github.tchx84.Flatseal" # Flatpak permissions management

set -x
#flatpak install -y --noninteractive $PACKAGES
set +x
PACKAGES=""
