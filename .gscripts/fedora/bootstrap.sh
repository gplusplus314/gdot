#!/usr/bin/env bash
set -e
set -x

if [[ "$USER" == "root" ]]; then
	echo "Don't run this script as root/sudo. Let it prompt you."
	exit 1
fi

cd $HOME

sudo dnf update
sudo dnf upgrade

# "package install"
function paci() {
	sudo dnf install -y "$@"
}

# "package append"
packages=""
function paca() {
	packages="$packages $@"
}

paca alacritty            # The stubbornly non-sixel terminal emulator
paca bash                 # What you shouldn't do until you try it
paca bat                  # Better cat
paca bear                 # Generates compile databases for clangd
paca cargo                # Rust package manager
paca ccache               # Compiler Cache to speed up some compilations
paca clang                # Compiler for C-family languages
paca cmake                # Configurable cross platform make
paca ddcutil              # Control monitor input programmatically
paca dfu-util             # DFU-mode firmware flashing for keyboard
paca fd-find              # Alternative to find
paca figlet               # ASCII art text generator
paca fzf                  # TUI/CLI fuzzy finder
paca gcc                  # C compiler
paca gh                   # GitHub CLI
paca git                  # Git version control
paca go                   # A gopher who lives on land above C level
paca golang-x-tools-gopls # A very polite languang server for Go
paca jq                   # Manipulate JSON in the CLI
paca kubernetes           # k8s
paca liberation-fonts     # OSS compatible Microsoft fonts
paca llvm                 # Next-gen compiler backend
paca lolcat               # The purrfect addition to the CLI
paca lua                  # As the name implies
paca luarocks             # Package manager for Lua
paca man-db               # Manual pages
paca ncurses              # TUI tooling
paca neofetch             # necessary for internet points
paca neovim               # NeoVim terminal-based text editor
paca nodejs               # "JavaScript... on a SeRvEr!?!?"
paca npm                  # Defitely not node package manager
paca pipewire             # Audio stack
paca polkit-kde           # Essentially a "sudo GUI" for gui apps
paca python3              # A snake that lives on land above C level
paca python3-pip          # Package manager for python
paca qt5-qtwayland        # QT5 lib
paca qt6-qtwayland        # QT6 lib
paca ripgrep              # Fast search tool
paca rust                 # Crabs
paca sddm                 # Display/Login/Session manager
paca shfmt                # Formats shell programs
paca timeshift            # BTRFS snapshot easymode
paca tldr                 # Short alternative to man-pages
paca tmux                 # Terminal Multiplexer
paca tree                 # Show directory structure visually
paca wget                 # Gets things from the web
paca which                # Doesn't show you the way, but shows you a path
paca wireplumber          # Audio patching
paca wofi                 # Launcher
paca xdg-utils            # Desktop integrations
paca zip                  # Technologic
paca zsh                  # Interactive shell of choice
paci $packages
packages=""

paca atuin  # CLI history in searchable sqlite
paca stylua # Lua formatter
cargo install $packages
packages=""

sudo npm install --global yarn # Package manager for Node

# for ZMK keyboard development
paci dtc          # Device Tree Controller
paci ninja-build  # Build system for CMake
pip3 install west # Build system used by ZMK

# for QMK keyboard development:
paci \
	arm-none-eabi-binutils \
	arm-none-eabi-gcc \
	arm-none-eabi-newlib \
	avr-binutils \
	avr-gcc \
	avr-libc \
	dfu-util
pip3 install --user qmk

# for DWL development
paci \
	libinput-devel \
	libudev-devel \
	wayland-devel \
	wayland-protocols-devel \
	wlroots-devel

# Language-specific packages:
sudo luarocks install luacheck
go install github.com/go-delve/delve/cmd/dlv@latest

# Fonts for a good terminal experience
sudo mkdir -p /usr/local/share/fonts/nerd
pushd /usr/local/share/fonts/nerd
PREFIX="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts"
sudo wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFontMono-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold/SauceCodeProNerdFont-Bold.ttf"
sudo wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFontMono-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/Italic/SauceCodeProNerdFont-Italic.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFontMono-BoldItalic.ttf"
sudo wget "$PREFIX/SourceCodePro/Bold-Italic/SauceCodeProNerdFont-BoldItalic.ttf"
sudo fc-cache
popd

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

# Bend both time and space
timedatectl set-timezone "$(curl --fail https://ipapi.co/timezone)"

# Init Alacritty config
pushd ~/.config/alacritty
if [ ! -e "alacritty.yml" ]; then
	cat <<EOF >alacritty.yml
import:
  - ~/.config/alacritty/linux.yml

# Local-machine-specific config after this line
EOF
fi
popd
