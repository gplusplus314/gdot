#!/usr/bin/env bash
set -e
set -x

if [[ "$USER" == "root" ]]; then
	echo "Don't run this script as root/sudo. Let it prompt you."
	exit 1
fi

cd $HOME

sudo zypper -n refresh
sudo zypper -n update
sudo zypper -n patch

# "package install"
function paci() {
	sudo zypper -n install "$@"
}

# "package append"
packages=""
function paca() {
	packages="$packages $@"
}

paca bash                   # What you shouldn't do until you try it
paca bat                    # Better cat
paca Bear                   # Generates compile databases for clangd
paca cargo                  # Rust package manager
paca ccache                 # Compiler Cache to speed up some compilations
paca clang                  # Compiler for C-family languages
paca cmake                  # Configurable cross platform make
paca dfu-util               # DFU-mode firmware flashing for keyboard
paca fd                     # Alternative to find
paca figlet                 # ASCII art text generator
paca fzf                    # TUI/CLI fuzzy finder
paca gcc                    # C compiler
paca gh                     # GitHub CLI
paca git                    # Git version control
paca go                     # A gopher who lives on land above C level
paca gopls                  # A very polite languang server for Go
paca jq                     # Manipulate JSON in the CLI
paca kubernetes-client      # Cube cuddle
paca liberation-fonts       # OSS compatible Microsoft fonts
paca llvm                   # Next-gen compiler backend
# paca ruby3.2-rubygem-lolcat # TODO: package dependencies broken
paca lua54                  # As the name implies
paca lua54-luarocks         # Package manager for Lua
paca man-pages              # Manual pages
paca ncurses                # TUI tooling
paca neofetch               # necessary for internet points
paca neovim                 # NeoVim terminal-based text editor
paca nodejs                 # "JavaScript... on a SeRvEr!?!?"
paca npm                    # Defitely not node package manager
paca python3                # A snake that lives on land above C level
paca python3-pipx           # Package manager for python
paca ripgrep                # Fast search tool
paca rust                   # Crabs
paca shfmt                  # Formats shell programs
paca tmux                   # Terminal Multiplexer
paca tree                   # Show directory structure visually
paca wget                   # Gets things from the web
paca which                  # Doesn't show you the way, but shows you a path
paca zip                    # Technologic
paca zsh                    # Interactive shell of choice

paci $packages
packages=""

paca atuin  # CLI history in searchable sqlite
paca stylua # Lua formatter
cargo install $packages
packages=""

sudo npm install --global yarn # Package manager for Node
sudo npm install --global tldr # Short alternative to man-pages

# for ZMK keyboard development
paci dtc          # Device Tree Controller
paci ninja        # Build system for CMake
pipx install west # Build system used by ZMK

# Language-specific packages:
paci lua54-luacheck
go install github.com/go-delve/delve/cmd/dlv@latest
sudo zypper -n install -t pattern devel_C_C++

# Make Zsh look purrdy
pushd ~/.config
if [ ! -d "powerlevel10k" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
fi
popd

# Make bat look purrdy
bat cache --build

# Switch to Zsh
sudo chsh -s $(which zsh) $USER
