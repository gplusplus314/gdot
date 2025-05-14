#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root!" >&2
	exit 1
fi

pkg update

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

## CLI
addp "devel/gh"         # GitHub CLI
addp "devel/git"        # Git version control
addp "games/lolcat"     # The purrfect addition to the CLI
addp "misc/figlet"      # ASCyII art text generator
addp "shells/atuin"     # CLI history in searchable sqlite
addp "shells/starship"  # Prompt
addp "shells/zsh"       # Ye old faithful interactive shell
addp "sysutils/direnv"  # Automatically source .envrc upon dir navigation
addp "sysutils/fd"      # Alternative to find
addp "sysutils/py-tldr" # Short alternative to man-pages
addp "sysutils/tree"    # Show directory structure visually
addp "sysutils/zoxide"  # Smart `cd` alternative
addp "textproc/bat"     # Better cat
addp "textproc/fzf"     # TUI/CLI fuzzy finder
addp "textproc/jq"      # JSON Query tool
addp "textproc/ripgrep" # Fast search tool

## TUI
addp "editors/neovim"     # NeoVim terminal-based text editor
addp "sysutils/py-ranger" # Terminal file manager

## Ranger (TUI File manager) deps
addp "graphics/mupdf"     # PDF rocessing
addp "graphics/py-pillow" # Image manipulation library
addp "textproc/hs-pandoc" # MS/Open Office processing

## Programming
addp "comms/tio"          # Serial IO/TTY
addp "devel/ccache"       # Compiler Cache to speed up some compilations
addp "devel/cmake"        # Configurable cross platform make
addp "devel/gopls"        # Go languago server
addp "devel/llvm"         # Next-gen compiler backend
addp "devel/lua-luarocks" # Package manager for Lua
addp "devel/ncurses"      # TUI tooling
addp "devel/ninja"        # Small build system similar to Make
addp "devel/py-pipx"      # Python binaries package manager
addp "devel/py-poetry"    # Python dependency manager
addp "devel/pyenv"        # Python version manager
addp "devel/rbenv"        # Ruby environment management
addp "devel/ruby-build"   # Install various Ruby versions and implementations
addp "devel/rustup-init"  # Rust toolchain
addp "devel/shfmt"        # Shell script formatter
addp "devel/stylua"       # Lua formatter
addp "lang/dotnet"        # .Net Core (used by some NeoVim extensions)
addp "lang/go"            # Go programming language
addp "lang/python3"       # A snake that runs code
addp "lang/zig"           # Zig Programming language
addp "www/node"           # NodeJS
addp "www/npm"            # Node Package Manager
addp "www/yarn"           # NPM alternative, ish

## Infrastructure related
addp "databases/postgresql17-client" # Postgres client (psql)
addp "sysutils/kubectl"              # Kubernetes client
addp "sysutils/terraform"            # Infrastructure as Code platform

pkg install -y $PACKAGES
