#!/bin/sh

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!" >&2
    exit 1
fi

PACKAGES=""
addp() {
	PACKAGES="$PACKAGES $1"
}

## CLI
addp "shells/atuin"        # CLI history in searchable sqlite
addp "textproc/bat"        # Better cat
addp "sysutils/direnv"     # Automatically source .envrc upon dir navigation
addp "sysutils/fd"         # Alternative to find
addp "misc/figlet"         # ASCyII art text generator
addp "textproc/fzf"        # TUI/CLI fuzzy finder
addp "devel/gh"            # GitHub CLI
addp "devel/git"           # Git version control
addp "textproc/jq"         # JSON Query tool
addp "games/lolcat"        # The purrfect addition to the CLI
addp "sysutils/py-tldr"    # Short alternative to man-pages
addp "textproc/ripgrep"    # Fast search tool
addp "shells/starship"     # Prompt
addp "sysutils/tree"       # Show directory structure visually
addp "sysutils/zoxide"     # Smart `cd` alternative
addp "shells/zsh"          # Ye old faithful interactive shell

## TUI
addp "editors/neovim"      # NeoVim terminal-based text editor
addp "sysutils/py-ranger"  # Terminal file manager

## Ranger (TUI File manager) deps
addp "graphics/py-pillow"  # Image manipulation library
addp "graphics/mupdf"      # PDF rocessing
addp "textproc/hs-pandoc"  # MS/Open Office processing

## Programming
addp "devel/ccache"          # Compiler Cache to speed up some compilations
addp "devel/cmake"           # Configurable cross platform make
addp "lang/dotnet"           # .Net Core (used by some NeoVim extensions)
addp "lang/go"               # Go programming language
addp "devel/gopls"           # Go languago server
addp "devel/llvm"            # Next-gen compiler backend
# addp "lua-language-server" # As the name implies - broken/expired port
addp "devel/lua-luarocks"    # Package manager for Lua
# addp "marksman"            # Markdown language server - no port
addp "devel/ncurses"         # TUI tooling
# addp "nvm"                 # Node Version Manager (Node JS) # not on FreeBSD
addp "www/node"              # NodeJS
addp "www/npm"               # Node Package Manager
addp "devel/py-pipx"         # Python binaries package manager
addp "devel/py-poetry"       # Python dependency manager
addp "devel/pyenv"           # Python version manager
addp "lang/python3"          # A snake that runs code
addp "devel/rbenv"           # Ruby environment management
addp "devel/ruby-build"      # Install various Ruby versions and implementations
addp "devel/rustup-init"     # Rust toolchain
addp "devel/stylua"          # Lua formatter
addp "comms/tio"             # Serial IO/TTY
addp "www/yarn"              # NPM alternative, ish
addp "lang/zig"              # Zig Programming language

## Infrastructure related
addp "sysutils/kubectl"              # Kubernetes client
addp "databases/postgresql17-client" # Postgres client (psql)
addp "sysutils/terraform"            # Infrastructure as Code platform

pkg update
pkg install -y $PACKAGES
