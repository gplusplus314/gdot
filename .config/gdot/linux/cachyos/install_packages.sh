#!/bin/sh

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

## GUI
addp "brave-bin" # Web browser

## CLI
addp "direnv"       # Automatically source .envrc upon dir navigation
addp "evtest"       # Input device event monitor and query tool
addp "github-cli"   # GitHub CLI
addp "git"          # Git version control
addp "lolcat"       # The purrfect addition to the CLI
addp "figlet"       # ASCyII art text generator
addp "zsh"          # Ye old faithful interactive shell
addp "tree"         # Show directory structure visually
addp "fzf"          # TUI/CLI fuzzy finder
addp "jq"           # JSON Query tool
addp "tmux"         # Terminal Multiplexer
addp "wl-clipboard" # Wayland clipboard tool

## TUI
addp "neovim" # NeoVim terminal-based text editor

## Yazi (TUI File manager) deps
addp "imagemagick" # Image manipulation
addp "poppler"     # PDF renderer

## Programming
addp "ccache"          # Compiler Cache to speed up some compilations
addp "cmake"           # Configurable cross platform make
addp "gopls"           # Go languago server
addp "llvm"            # Next-gen compiler backend
addp "luarocks"        # Package manager for Lua
addp "ncurses"         # TUI tooling
addp "ninja"           # Small build system similar to Make
addp "rustup"          # Rust toolchain
addp "shfmt"           # Shell script formatter
addp "dotnet-sdk-10.0" # .Net Core (used by some NeoVim extensions)
addp "go"              # Go programming language
addp "python3"         # A snake that runs code
addp "zig"             # Zig Programming language
addp "nodejs"          # NodeJS

set -x
set -e
sudo pacman -Syu --noconfirm $PACKAGES
set +e
set +x
