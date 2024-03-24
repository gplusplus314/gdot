#!/usr/bin/env bash
set -e
set -x

cd $HOME

sudo pacman -Syu --noconfirm

# "pacman install"
function paci() {
	sudo pacman -S --needed --noconfirm "$@"
	packages=""
}

# "package append"
packages=""
function paca() {
	packages="$packages $@"
}

paca atuin               # CLI history in searchable sqlite
paca base-devel          # Base development packages
paca bash                # What you shouldn't do until you try it
paca bat                 # Better cat
paca bear                # Generates compile databases for clangd
paca cargo               # Rust package manager
paca ccache              # Compiler Cache to speed up some compilations
paca clang               # Compiler for C-family languages
paca cmake               # Configurable cross platform make
paca dfu-util            # DFU-mode firmware flashing for keyboard
paca ddcutil             # Control monitor input programmatically
paca fd                  # Alternative to find
paca figlet              # ASCII art text generator
paca fzf                 # TUI/CLI fuzzy finder
paca gcc                 # C compiler
paca git                 # Git version control
paca github-cli          # GitHub CLI
paca go                  # A gopher who lives on land above C level
paca gopls               # A very polite languang server for Go
paca jq                  # Manipulate JSON in the CLI
paca kitty               # purrfect terminal emulator
paca kubectl             # Some people say "cube cuddle"
paca llvm                # Next-gen compiler backend
paca lolcat              # The purrfect addition to the CLI
paca lua-language-server # As the name implies
paca luarocks            # Package manager for Lua
paca man-db              # Manual pages
paca marksman            # Markdown language server
paca neofetch            # necessary for internet points
paca ncurses             # TUI tooling
paca neovim              # NeoVim terminal-based text editor
paca nodejs              # "JavaScript... on a SeRvEr!?!?"
paca noto-fonts-emoji    # Emoji fonts from Google
paca npm                 # Defitely not node package manager
paca pacman-contrib      # For building AUR related things
paca pipewire            # Audio stack
paca python-pipx         # Install Python packages with automagic virtualenv
paca polkit-kde-agent    # Essentially a "sudo GUI" for gui apps
paca python-pip          # Package manager for Python
paca python3             # A snake that lives on land above C level
paca qt5-wayland         # QT5 lib
paca qt6-wayland         # QT6 lib
paca ripgrep             # Fast search tool
paca rust                # Crabs
paca sddm                # Display/Login/Session manager
paca shfmt               # Formats shell programs
paca stylua              # Lua formatter
paca timeshift           # BTRFS snapshot easymode
paca tldr                # Short alternative to man-pages
paca tmux                # Terminal Multiplexer
paca tree                # Show directory structure visually
paca ttf-liberation      # OSS compatible Microsoft fonts
paca wget                # Gets things from the web
paca which               # Doesn't show you the way, but shows you a path
paca wireplumber         # Audio patching
paca wofi                # Launcher
paca xdg-utils           # Desktop integrations
paca yarn                # Package manager for Node
paca zip                 # Technologic
paca zsh                 # Interactive shell of choice

paci $packages

# for ZMK keyboard development
paci dtc   # Device Tree Controller
paci ninja # Buid system for CMake
pipx install west

# install yay (aur helper) if it isn't already installed
if ! [ -x "$(command -v yay)" ]; then
	pacman -S --needed git base-devel
	pushd ~/
	mkdir -p src/aur.archlinux.org
	cd src/aur.archlinux.org
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	popd
fi

# "aur install"
function auri() {
	yay -S --needed --noconfirm "$@"
}
auri webcord-bin # A better Discord client
auri klassy-git  # kde window decorations with active borders

# Language-specific packages:
sudo luarocks install luacheck
if ! [ -x "$(command -v dlv)" ]; then
	go install github.com/go-delve/delve/cmd/dlv@latest
fi

# KDE settings management
pipx install konsave
konsave -a g

# Fonts for a good terminal experience
sudo mkdir -p /usr/local/share/fonts/nerd
pushd /usr/local/share/fonts/nerd
PREFIX="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFontMono-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFont-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFontMono-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFont-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFontMono-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFont-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFontMono-BoldItalic.ttf"
sudo wget "$PREFIX/SourceCodePro/SauceCodeProNerdFont-BoldItalic.ttf"
sudo fc-cache
popd

# DWM-style tiling for KDE 6
mkdir -p ~/progs
pushd ~/progs
git clone https://github.com/zeroxoneafour/polonium.git
cd polonium
make
popd

# Make Zsh look purrdy
pushd ~/.config
if [ ! -d "powerlevel10k" ]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
fi
popd

# Switch to Zsh
sudo chsh -s $(which zsh) $USER

# Bend both time and space
timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"
